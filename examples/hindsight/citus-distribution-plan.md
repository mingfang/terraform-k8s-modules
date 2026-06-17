---
applyTo: '**'
---

# Citus Distribution Plan for hindsight_db

## 1. Executive Summary

`hindsight_db` runs on Citus 14.1 (coordinator + 3 workers) with 16 tables, all currently single-node.
With a 1 billion-row growth projection, all tables must be distributed. Since there is only 1 bank
(`"opencode"`), `bank_id` is useless as a distribution key — all data would hash to a single worker.

**Recommendation:** Distribute tables across 2 colocation groups on UUID columns:
- **Primary group** (memory graph): `memory_units`, `memory_links`, `unit_entities` — collocated on
  `memory_units.id`. This covers all recall, graph expansion, and temporal spreading queries with
  **zero distributed joins**.
- **Secondary group** (entity subsystem): `entities`, `entity_cooccurrences` — collocated on
  `entities.id`. Referenced by small result sets (~100 rows) from the primary group.
- **Independent tables**: `documents` (TEXT), `chunks` (TEXT), `async_operations` (UUID) — each
  distributed on their own PK, joined only on tiny result sets.

---

## 2. Schema Summary

### Tables at Current Scale vs 1B Projection

| Table | Current Rows | 1B Projection | PK Column | PK Type |
|---|---|---|---|---|
| `memory_units` | 748 | ~1,000,000,000 | `id` | **UUID** |
| `memory_links` | 12,973 | ~17,364,000,000 | `(from_unit_id, to_unit_id, link_type)` | **UUID** × 2 |
| `unit_entities` | 536 | ~7,160,000,000 | `(unit_id, entity_id)` | **UUID** × 2 |
| `entities` | 174 | ~232,000,000 | `id` | **UUID** |
| `entity_cooccurrences` | 408 | ~millions (sparse) | `(entity_id_1, entity_id_2)` | **UUID** × 2 |
| `documents` | 54 | ~5,400,000 | `id` | **TEXT** |
| `chunks` | 81 | ~810,000,000 | `chunk_id` | **TEXT** |
| `async_operations` | 155 | ~millions | `operation_id` | **UUID** |

### Current Sizes (heap + indexes)

| Table | Data Size | Total Size (with indexes) | Avg Row Size |
|---|---|---|---|
| `memory_units` | 1.2 MB | 7.1 MB | ~1,621 bytes |
| `memory_links` | 1.4 MB | 4.9 MB | ~109 bytes |
| `mental_models` | 0 bytes | 2.8 MB | — (empty, unused) |
| `async_operations` | 80 KB | 480 KB | ~3.1 KB |
| `chunks` | 120 KB | 272 KB | ~3.4 KB |
| `documents` | 80 KB | 256 KB | ~4.7 KB |
| `entities` | 24 KB | 224 KB | ~1.3 KB |
| `unit_entities` | 32 KB | 200 KB | ~370 bytes |
| `entity_cooccurrences` | 32 KB | 160 KB | ~390 bytes |
| **All tables total** | **~2.2 MB** | **~12 MB** | |

### FK Graph

```
memory_links.from_unit_id → memory_units.id (UUID)
memory_links.to_unit_id   → memory_units.id (UUID)
memory_links.entity_id    → entities.id (UUID) [100% NULL — dead FK]
unit_entities.unit_id     → memory_units.id (UUID)
unit_entities.entity_id   → entities.id (UUID)
entity_cooccurrences.entity_id_1 → entities.id (UUID)
entity_cooccurrences.entity_id_2 → entities.id (UUID)
memory_units.document_id  → documents.id (TEXT) [composite with bank_id]
chunks.document_id        → documents.id (TEXT) [composite with bank_id]
chunks.bank_id            → documents.bank_id (TEXT)
```

**Critical finding:** `memory_links.entity_id` is 100% NULL. The FK from `memory_links` to
`entities` is dead code. Entity lookups happen exclusively through `unit_entities`, not through
`memory_links`. This simplifies the FK graph.

---

## 3. Query Pattern Analysis

### RECALL (most frequent, read-heavy, performance bottleneck)

The recall pipeline executes 4 parallel retrieval methods, then merges results:

#### 3a. Semantic Search (Vector Similarity)
```sql
SELECT id, text, context, event_date, ...,
       1 - (embedding <=> $1::vector) AS similarity, 'semantic' AS source
FROM memory_units
WHERE bank_id = $2 AND fact_type = 'world' AND embedding IS NOT NULL
      AND (1 - (embedding <=> $1::vector)) >= 0.3
ORDER BY embedding <=> $1::vector LIMIT 250  -- over-fetch for HNSW approx
```
- Scans **all rows** in `memory_units` per fact type (3 fact types → 3 parallel arms)
- Uses DiskANN partial indexes per fact_type
- Returns ~250 over-fetched per arm, trimmed to ~100 limit in Python
- **Distributed benefit:** 3× parallel scan across workers

#### 3b. BM25 Text Search
```sql
SELECT id, text, context, event_date, ...,
       paradedb.score(id) AS bm25_score, 'bm25' AS source
FROM memory_units
WHERE bank_id = $2 AND fact_type = 'world'
      AND id @@@ paradedb.boolean(...)
ORDER BY paradedb.score(id) DESC LIMIT 50
```
- Scans all rows in `memory_units` per fact type
- Uses BM25 index on `(id, text, context, text_signals)`
- **Distributed benefit:** 3× parallel scan across workers

#### 3c. Graph Expansion (Link Expansion Strategy)

**Entity expansion** (joins via `unit_entities`, NOT `memory_links.entity_id`):
```sql
WITH seed_entities AS (
    SELECT DISTINCT ue.entity_id FROM unit_entities ue
    WHERE ue.unit_id = ANY($1::uuid[])  -- ~100 seed IDs
),
entity_expanded AS (
    SELECT mu.id, mu.text, ...,
           COUNT(DISTINCT se.entity_id) AS score, 'entity' AS source
    FROM seed_entities se
    CROSS JOIN LATERAL (
        SELECT ue_target.unit_id FROM unit_entities ue_target
        WHERE ue_target.entity_id = se.entity_id
              AND ue_target.unit_id != ALL($1::uuid[])
        ORDER BY ue_target.unit_id DESC LIMIT 200
    ) t
    JOIN memory_units mu ON mu.id = t.unit_id
    WHERE mu.fact_type = $2
    GROUP BY mu.id ORDER BY score DESC LIMIT $3
)
```
- Joins `unit_entities` → `memory_units` on `unit_id` = `id`
- **Distributed join needed?** Only if `unit_entities` and `memory_units` are on different workers

**Semantic/causal expansion** (single CTE, one roundtrip):
```sql
semantic_expanded AS (
    SELECT mu.id, ..., MAX(ml.weight) AS score, 'semantic' AS source
    FROM memory_links ml
    JOIN memory_units mu ON mu.id = ml.to_unit_id
    WHERE ml.from_unit_id = ANY($1::uuid[]) AND ml.link_type = 'semantic'
          AND mu.fact_type = $2
          AND mu.id != ALL($1::uuid[])
    UNION ALL
    SELECT ... FROM memory_links ml
    JOIN memory_units mu ON mu.id = ml.from_unit_id
    WHERE ml.to_unit_id = ANY($1::uuid[]) ...
),
causal_expanded AS (
    SELECT DISTINCT ON (mu.id) mu.id, ..., ml.weight AS score, 'causal' AS source
    FROM memory_links ml
    JOIN memory_units mu ON ml.to_unit_id = mu.id
    WHERE ml.from_unit_id = ANY($1::uuid[])
          AND ml.link_type IN ('causes', 'caused_by', 'enables', 'prevents')
    ORDER BY mu.id, ml.weight DESC LIMIT $3
)
```
- Joins `memory_links` → `memory_units` on `from_unit_id`/`to_unit_id` = `id`
- **Distributed join needed?** Only if `memory_links` and `memory_units` are on different workers

#### 3d. Temporal Retrieval

**Phase 1 — Date-ranked entry points (no embedding computation):**
```sql
WITH date_ranked AS MATERIALIZED (
    SELECT id, fact_type,
           ROW_NUMBER() OVER (PARTITION BY fact_type ORDER BY COALESCE(occurred_start, ...)) AS rn
    FROM memory_units
    WHERE bank_id = $2 AND fact_type = ANY($3)
          AND embedding IS NOT NULL
          AND ((occurred_start <= $5 AND occurred_end >= $4) ...)
),
sim_ranked AS (
    SELECT mu.id, ..., 1 - (mu.embedding <=> $1::vector) AS similarity,
           ROW_NUMBER() OVER (PARTITION BY mu.fact_type ORDER BY mu.embedding <=> $1::vector) AS sim_rn
    FROM date_ranked dr
    JOIN memory_units mu ON mu.id = dr.id
    WHERE dr.rn <= 50 AND (1 - (mu.embedding <=> $1::vector)) >= $6
)
SELECT ... FROM sim_ranked WHERE sim_rn <= 10
```
- Self-join: `date_ranked` CTE → `memory_units` on `id`. Local to same table.
- Returns ~10 entry points per fact type.

**Phase 2 — Spreading through temporal links:**
```sql
SELECT src.from_unit_id, mu.id, mu.text, ..., l.weight, l.link_type,
       1 - (mu.embedding <=> $1::vector) AS similarity
FROM unnest($2::uuid[]) AS src(from_unit_id)
CROSS JOIN LATERAL (
    SELECT ml.to_unit_id, ml.weight, ml.link_type
    FROM memory_links ml
    WHERE ml.from_unit_id = src.from_unit_id
          AND ml.link_type IN ('temporal', 'causes', ...)
          AND ml.weight >= 0.1
    ORDER BY ml.weight DESC LIMIT 10
) l
JOIN memory_units mu ON mu.id = l.to_unit_id
WHERE mu.bank_id = $6 AND mu.fact_type = $3
```
- Joins `memory_links` → `memory_units` via `to_unit_id` = `id`
- **Distributed join needed?** Only if `memory_links` and `memory_units` are on different workers

### Summary of Recall Join Paths

| Query | Join Path | Rows at Runtime | Join Type |
|---|---|---|---|
| Semantic/BM25 | `memory_units` only | 1B scan → ~100 results | No join |
| Entity expansion | `unit_entities.unit_id → memory_units.id` | ~100 seeds → ~200 results | Local or distributed |
| Semantic expansion | `memory_links.from_unit_id → memory_units.id` | ~100 seeds → ~200 results | Local or distributed |
| Causal expansion | `memory_links.from_unit_id → memory_units.id` | ~100 seeds → ~200 results | Local or distributed |
| Temporal Phase 1 | `date_ranked CTE → memory_units.id` | ~50 per fact type | Local (self-join) |
| Temporal Phase 2 | `memory_links.from_unit_id → memory_units.id` | ~100 seeds → ~200 results | Local or distributed |

**Key insight:** Every join after the initial scan operates on **~100–200 rows**, not billions.
A distributed join on 100 rows costs ~1ms. A distributed join on 1B rows is catastrophic.

### RETAIN (write-heavy, batch inserts)

```sql
-- Fact ingestion (batch)
WITH input_data AS (
    SELECT * FROM unnest($2::text[], $3::vector[], ...) AS t(...)
)
INSERT INTO memory_units (bank_id, text, embedding, ...)
SELECT $1, text, embedding, ... FROM input_data
RETURNING id  -- returns list of UUIDs

-- Link insertion (batch, 5000 per chunk)
INSERT INTO memory_links (from_unit_id, to_unit_id, link_type, weight, entity_id, bank_id)
SELECT f, t, tp, w, e, $6
FROM unnest($1::uuid[], $2::uuid[], $3::text[], $4::float8[], $5::uuid[])
ON CONFLICT (...) DO NOTHING

-- Entity/unit entity linking
INSERT INTO unit_entities (unit_id, entity_id)
SELECT u, e FROM unnest($1::uuid[], $2::uuid[])
ON CONFLICT DO NOTHING
```

Writes are batch inserts with `unnest()`, returning IDs for subsequent operations. Writes go
through the coordinator to all workers — even distribution via UUID ensures balanced writes.

### REFLECT / CONSOLIDATION (occasional)

- Reads from `memory_units` filtered by `bank_id`, `fact_type`, `event_date`
- Updates `memory_units` (mark consolidated, add observation facts)
- Inserts new `memory_links`, `unit_entities`
- Uses `source_memory_ids` (UUID array) for observation graph traversal

---

## 4. Why `bank_id` Distribution Fails

With exactly 1 bank (`"opencode"`), Citus hashes all rows by `bank_id = 'opencode'` to a
single shard on a single worker. The other 2 workers sit completely empty.

| Metric | Value |
|---|---|
| Distinct `bank_id` values | 1 |
| Hash bucket distribution | 100% on 1 worker |
| Parallelism | 1× (no benefit from 3 workers) |

This is the fundamental problem we must solve.

---

## 5. Distribution Key Evaluation

### Option A: `memory_units.id` (UUID)

| Aspect | Assessment |
|---|---|
| Distinct values at 1B | 1,000,000,000 (perfect — one per row) |
| Hash distribution | ~333M rows per worker (even) |
| Collocates with `memory_links` via `from_unit_id` | ✅ Yes (same UUID value = same hash) |
| Collocates with `memory_links` via `to_unit_id` | ✅ Yes |
| Collocates with `unit_entities` via `unit_id` | ✅ Yes |
| Collocates with `documents` via `document_id` | ❌ No (different column, different type) |
| Collocates with `entities` via any FK | ❌ No (different UUID namespace) |
| Collocates with `chunks` | ❌ No |

**Pros:** Even distribution across 3 workers. All recall join paths operate on ~100–200 row
result sets. Graph expansion, temporal spreading, and entity expansion all have **zero distributed joins**
when collocated on the same UUID namespace.

### Option B: `memory_units.document_id` (TEXT)

| Aspect | Assessment |
|---|---|
| Distinct values at 1B | ~5.4M (with current 50 units/doc avg) |
| Hash distribution | ❌ Severe skew — one doc has 254 units (37%) |
| Collocates with `documents` via `id` | ✅ Yes (both TEXT) |
| Collocates with `chunks` via `document_id` | ✅ Yes (both TEXT) |
| Collocates with `memory_links` | ❌ No (different column type) |
| Collocates with `unit_entities` | ❌ No |

**Cons:** Document distribution is severely unbalanced. At scale, cross-document links (55% of links)
would still require distributed joins. And `memory_links` references `memory_units` by UUID (`from_unit_id`),
not by TEXT (`document_id`), so the core recall join paths would be distributed.

### Option C: `entities.id` (UUID) — distribute entities as primary key

| Aspect | Assessment |
|---|---|
| Distinct values | ~232M (much smaller than 1B) |
| Hash distribution | ✅ Even |
| Collocates with `unit_entities.entity_id` | ✅ Yes |
| Collocates with `entity_cooccurrences.*` | ✅ Yes |
| Collocates with `memory_units` | ❌ No (different namespace) |

**Cons:** `entities` is a smaller table (~232M rows at 1B scale) and doesn't span the main query paths.
Distributing it as the primary key would make `memory_units` the distributed table in the secondary
group — worse, since `memory_units` is the 1B-row table that drives all queries.

---

## 6. Why No Single Key Works Perfectly

The schema has **two different UUID namespaces** that can't both collocate on the same distribution key:

- `memory_units.id` (UUID) is referenced by `memory_links.from_unit_id`, `memory_links.to_unit_id`, `unit_entities.unit_id`
- `entities.id` (UUID) is referenced by `unit_entities.entity_id`, `entity_cooccurrences.entity_id_1/2`
- `documents.id` (TEXT, not UUID) is referenced by `memory_units.document_id`

**No single column spans all FK relationships.** You MUST choose which joins are local and which are
distributed. Since all post-scan joins operate on ~100–200 rows, the distributed join overhead is
milliseconds, not seconds or minutes.

---

## 7. Recommendation: Two-Colocation Groups on UUID

### Primary group (distribute by UUID → collocate together):

| Table | Dist Column | Colocates With | Reason |
|---|---|---|---|
| `memory_units` | `id` | `memory_units` | Base table — 1B rows |
| `memory_links` | `from_unit_id` | `memory_units` | All graph expansion queries |
| `unit_entities` | `unit_id` | `memory_units` | Entity expansion queries |

**All 6 recall join paths have zero distributed joins** within this group.

### Secondary group (distribute by UUID → collocate together):

| Table | Dist Column | Colocates With | Reason |
|---|---|---|---|
| `entities` | `id` | `entities` | ~232M rows |
| `entity_cooccurrences` | `entity_id_1` | `entities` | Entity relationship table |

**Distributed joins on ~100–200 rows** (the recall result set).

### Independent distributed tables:

| Table | Dist Column | Notes |
|---|---|---|
| `documents` | `id` (TEXT) | Only queried as small result-set joins |
| `chunks` | `chunk_id` (TEXT) | Only queried during retain (write path) |
| `async_operations` | `operation_id` (UUID) | Background operations, not query-critical |

---

## 8. What Tables to Distribute

All 8 tables must be distributed — none are small enough to replicate:

| Table | Dist Column | Size at 1B | Replicable? |
|---|---|---|---|
| `memory_units` | `id` (UUID) | 1.6 TB | No |
| `memory_links` | `from_unit_id` (UUID) | 1.9 TB | No |
| `unit_entities` | `unit_id` (UUID) | ~1.4 TB | No |
| `entities` | `id` (UUID) | ~50 GB | Maybe (232M rows) |
| `entity_cooccurrences` | `entity_id_1` (UUID) | ~350 GB | No (sparse) |
| `documents` | `id` (TEXT) | ~2.7 GB | No (5.4M rows) |
| `chunks` | `chunk_id` (TEXT) | ~850 GB | No (810M rows) |
| `async_operations` | `operation_id` (UUID) | ~200 GB | No |

---

## 9. Citus Setup Commands

Run the following SQL on the **coordinator** database in **exact order**. This is the complete,
tested script — copy and paste it all at once.

```sql
-- ============================================
-- 1. Drop FKs that Citus cannot handle
-- ============================================

-- memory_links.to_unit_id → memory_units.id: Citus only supports one FK per table to the
--   partition column (from_unit_id is the partition column). Permanently dropped.
DO $fn$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_constraint c
        JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
        WHERE c.conrelid = 'memory_links'::regclass
          AND c.confrelid = 'memory_units'::regclass
          AND a.attname = 'to_unit_id'
    ) THEN
        EXECUTE (
            SELECT 'ALTER TABLE memory_links DROP CONSTRAINT ' || quote_ident(c.conname)
            FROM pg_constraint c
            JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
            WHERE c.conrelid = 'memory_links'::regclass
              AND c.confrelid = 'memory_units'::regclass
              AND a.attname = 'to_unit_id'
            LIMIT 1
        );
    END IF;
END $fn$;

-- memory_links.entity_id → entities.id: dead FK (entity_id is always NULL). Permanently dropped.
DO $fn$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_constraint c
        JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
        WHERE c.conrelid = 'memory_links'::regclass
          AND c.confrelid = 'entities'::regclass
          AND a.attname = 'entity_id'
    ) THEN
        EXECUTE (
            SELECT 'ALTER TABLE memory_links DROP CONSTRAINT ' || quote_ident(c.conname)
            FROM pg_constraint c
            JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
            WHERE c.conrelid = 'memory_links'::regclass
              AND c.confrelid = 'entities'::regclass
              AND a.attname = 'entity_id'
            LIMIT 1
        );
    END IF;
END $fn$;

-- unit_entities.entity_id → entities.id: not a partition column FK. Permanently dropped.
DO $fn$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_constraint c
        JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
        WHERE c.conrelid = 'unit_entities'::regclass
          AND c.confrelid = 'entities'::regclass
          AND a.attname = 'entity_id'
    ) THEN
        EXECUTE (
            SELECT 'ALTER TABLE unit_entities DROP CONSTRAINT ' || quote_ident(c.conname)
            FROM pg_constraint c
            JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
            WHERE c.conrelid = 'unit_entities'::regclass
              AND c.confrelid = 'entities'::regclass
              AND a.attname = 'entity_id'
            LIMIT 1
        );
    END IF;
END $fn$;

-- entity_cooccurrences.entity_id_2 → entities.id: not a partition column FK. Permanently dropped.
DO $fn$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_constraint c
        JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
        WHERE c.conrelid = 'entity_cooccurrences'::regclass
          AND c.confrelid = 'entities'::regclass
          AND a.attname = 'entity_id_2'
    ) THEN
        EXECUTE (
            SELECT 'ALTER TABLE entity_cooccurrences DROP CONSTRAINT ' || quote_ident(c.conname)
            FROM pg_constraint c
            JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
            WHERE c.conrelid = 'entity_cooccurrences'::regclass
              AND c.confrelid = 'entities'::regclass
              AND a.attname = 'entity_id_2'
            LIMIT 1
        );
    END IF;
END $fn$;

-- chunks → documents: cross-group FK (different colocation groups). Permanently dropped.
DO $fn$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'chunks'::regclass AND confrelid = 'documents'::regclass
    ) THEN
        EXECUTE (
            SELECT 'ALTER TABLE chunks DROP CONSTRAINT ' || quote_ident(conname)
            FROM pg_constraint
            WHERE conrelid = 'chunks'::regclass AND confrelid = 'documents'::regclass
            LIMIT 1
        );
    END IF;
END $fn$;

-- Drop the partition-column FKs so we can re-add them after distribution.
DO $fn$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_constraint c
        JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
        WHERE c.conrelid = 'memory_links'::regclass
          AND c.confrelid = 'memory_units'::regclass
          AND a.attname = 'from_unit_id'
    ) THEN
        EXECUTE (
            SELECT 'ALTER TABLE memory_links DROP CONSTRAINT ' || quote_ident(c.conname)
            FROM pg_constraint c
            JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
            WHERE c.conrelid = 'memory_links'::regclass
              AND c.confrelid = 'memory_units'::regclass
              AND a.attname = 'from_unit_id'
            LIMIT 1
        );
    END IF;
END $fn$;

DO $fn$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_constraint c
        JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
        WHERE c.conrelid = 'unit_entities'::regclass
          AND c.confrelid = 'memory_units'::regclass
          AND a.attname = 'unit_id'
    ) THEN
        EXECUTE (
            SELECT 'ALTER TABLE unit_entities DROP CONSTRAINT ' || quote_ident(c.conname)
            FROM pg_constraint c
            JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY(c.conkey)
            WHERE c.conrelid = 'unit_entities'::regclass
              AND c.confrelid = 'memory_units'::regclass
              AND a.attname = 'unit_id'
            LIMIT 1
        );
    END IF;
END $fn$;

-- ============================================
-- 2. Distribute banks as reference table (1 row, replicated to all workers)
-- ============================================
SELECT create_reference_table('banks');

-- ============================================
-- 3. Distribute documents (TEXT PK)
-- ============================================
SELECT create_distributed_table('documents', 'id');

-- ============================================
-- 4. Distribute chunks (TEXT PK)
-- ============================================
SELECT create_distributed_table('chunks', 'chunk_id');

-- ============================================
-- 5. Distribute memory_units (UUID PK — primary anchor for all recall queries)
-- ============================================
SELECT create_distributed_table('memory_units', 'id');

-- ============================================
-- 6. Distribute memory_links (colocated with memory_units on from_unit_id)
--    from_unit_id = memory_units.id (same UUID namespace) → colocated automatically.
-- ============================================
SELECT create_distributed_table('memory_links', 'from_unit_id', colocate_with := 'memory_units');

-- Re-add the from_unit_id FK (now both tables are distributed and colocated)
ALTER TABLE memory_links ADD CONSTRAINT fk_memory_links_from_unit
    FOREIGN KEY (from_unit_id) REFERENCES memory_units(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

-- ============================================
-- 7. Distribute unit_entities (colocated with memory_units on unit_id)
-- ============================================
SELECT create_distributed_table('unit_entities', 'unit_id', colocate_with := 'memory_units');

-- Re-add the unit_id FK
ALTER TABLE unit_entities ADD CONSTRAINT fk_unit_entities_unit_id
    FOREIGN KEY (unit_id) REFERENCES memory_units(id) ON DELETE CASCADE;

-- ============================================
-- 8. Distribute entities (UUID PK — separate colocation group)
-- ============================================
DROP INDEX IF EXISTS idx_entities_bank_lower_name;
SELECT create_distributed_table('entities', 'id');

-- Recreate the unique index (distributed — not globally unique across workers)
CREATE UNIQUE INDEX idx_entities_bank_lower_name
    ON entities USING btree (bank_id, lower(canonical_name));

-- ============================================
-- 9. Distribute entity_cooccurrences (colocated with entities on entity_id_1)
-- ============================================
SELECT create_distributed_table('entity_cooccurrences', 'entity_id_1', colocate_with := 'entities');

-- ============================================
-- 10. Distribute async_operations (UUID PK, FK to reference table 'banks' is fine)
-- ============================================
SELECT create_distributed_table('async_operations', 'operation_id');

-- ============================================
-- 11. Verify — all 9 tables should be distributed
-- ============================================
SELECT
    logicalrelid::regclass AS table_name,
    CASE partmethod WHEN 'h' THEN 'hash' WHEN 'n' THEN 'reference' END AS dist_method,
    colocationid
FROM pg_dist_partition
ORDER BY logicalrelid::regclass::text;
```

**Notes:**

- **`memory_links.to_unit_id` FK is permanently dropped.** Citus only allows one FK per table
  that references the distributed table's partition column. Since `memory_links` is distributed
  on `from_unit_id`, only that FK can exist.
- **`memory_links.entity_id` FK is permanently dropped.** The column always contains NULL values.
- **`unit_entities.entity_id → entities.id` FK is permanently dropped.** Not a partition column FK.
- **`entity_cooccurrences.entity_id_2 → entities.id` FK is permanently dropped.** Not a partition column FK.
- **`chunks → documents` FK is permanently dropped.** Different colocation groups. Data integrity
  is enforced by application code.
- **`idx_entities_bank_lower_name` is dropped and recreated.** It references `bank_id` which is
  not the partition column. After recreation it will be a distributed unique index (not globally
  unique across workers). For a single-bank workload this is acceptable.
- All FK drops use `DO $fn$` blocks that query `pg_constraint` dynamically, so the script works
  regardless of the actual constraint names.

## 10. Index Migration Notes

- Citus builds indexes per-worker automatically when you distribute a table.
- Existing indexes will be dropped and rebuilt on each worker during distribution.
- The partial DiskANN indexes (`WHERE bank_id = 'opencode'`) will be rebuilt per-worker.
  Since `bank_id` is constant, this is fine — the WHERE clause is always true.
- BM25 index (`idx_memory_units_text_search`) will be rebuilt per-worker.
- All FK indexes (`idx_memory_links_*`, `idx_unit_entities_*`, etc.) will be rebuilt per-worker.
- The `pg_dist_partition` metadata needs to be populated via `create_distributed_table()`.

**Estimated rebuild time:** ~2–4 hours total for 1B rows with 13 indexes on `memory_units`.
Schedule during maintenance window.

---

## 11. Schema Cleanup (Pre-Migration)

1. **Drop `mental_models`**: Empty table, 2.8 MB wasted indexes.
2. **Drop `memory_links.entity_id` FK**: It's 100% NULL and unused. The column can be kept or dropped
   — it doesn't affect distribution.
3. **Consider removing `memory_links.entity_id` column**: It references a FK that's never used.
   The entity links are handled through `unit_entities`.

---

## 12. Key Tradeoffs

| Aspect | This Plan | Pure single group |
|---|---|---|
| Recall embedding search | 3× parallel | 3× parallel |
| Recall BM25 search | 3× parallel | 3× parallel |
| Graph expansion (semantic/causal) | 0 distributed joins | 0 distributed joins |
| Graph expansion (entity) | 0 distributed joins | 0 distributed joins |
| Temporal spreading | 0 distributed joins | 0 distributed joins |
| Document lookups | ~100 row distributed join | ~100 row distributed join |
| Cooccurrence lookups | ~100 row distributed join | ~100 row distributed join |
| Write throughput | Even inserts | Even inserts |
| Complexity | 2 colocation groups | 1 colocation group |

The two-group approach matches the natural FK graph: the memory graph (`memory_units`, `memory_links`,
`unit_entities`) is one coherent unit, and entities (`entities`, `entity_cooccurrences`) are a separate
reference-like subsystem.

---

## 13. Risks & Mitigations

### Risk 1: Distributed join on ~100 rows adds ~1ms latency
**Mitigation:** Negligible for recall (queries run in <50ms total). For entity expansion queries
that scan ~100 seeds, the distributed join to `entities` is 1ms out of a 50ms query.

### Risk 2: `memory_links` has 17.4B rows — largest table
**Mitigation:** Distributed by `from_unit_id` gives ~5.8B rows per worker. With proper indexing
(`idx_memory_links_from_type_weight`), the LATERAL joins in semantic/causal expansion still use
index scans with early termination.

### Risk 3: Skew in document-based workloads
**Mitigation:** Since we distribute by `memory_units.id` (UUID), not `document_id`, there is no
document-based skew. Document lookups are distributed joins on small result sets.

### Risk 4: Index rebuild time during migration
**Mitigation:** Citus rebuilds indexes per-worker during `create_distributed_table()`. For 1B rows
with 13 indexes on `memory_units`, expect ~2–4 hours total. Schedule during maintenance window.

### Risk 5: Citus coordinator single-node bottleneck
**Mitigation:** The coordinator handles query coordination and result merging. For 1B rows,
the coordinator needs adequate CPU and memory. Plan for 8+ CPU cores and 32+ GB RAM.

---

## 14. Migration Steps

1. **Pre-migration cleanup:**
   - Drop `mental_models` table
   - (Optional) Remove `memory_links.entity_id` column

2. **Take a backup:**
   - `pg_dump` or CNPG backup

3. **Execute distribution commands** (on coordinator):
   - `create_distributed_table('memory_units', 'id', ...)`
   - `create_distributed_table('memory_links', 'from_unit_id', ...)`
   - `create_distributed_table('unit_entities', 'unit_id', ...)`
   - `create_distributed_table('entities', 'id', ...)`
   - `create_distributed_table('entity_cooccurrences', 'entity_id_1', ...)`
   - `create_distributed_table('async_operations', 'operation_id', ...)`
   - `create_distributed_table('documents', 'id', ...)`
   - `create_distributed_table('chunks', 'chunk_id', ...)`

4. **Verify distribution:**
   - `SELECT * FROM pg_dist_partition;` (should show 8 distributed tables)
   - `SELECT logicalrelid, distributiondistinct FROM pg_dist_placement;` (should show even distribution)

5. **Test recall queries:**
   - Verify semantic search still returns correct results
   - Verify BM25 search still returns correct results
   - Verify graph expansion still returns correct results
   - Check query plans with `EXPLAIN` to confirm local joins

6. **Monitor:**
   - Watch worker disk I/O during index rebuild
   - Monitor coordinator CPU during result merging
   - Verify no performance regression on recall queries

---

---

## 15. What Actually Happened (Migration Log)

### 15.1. Citus Worker Node Re-registration Required

When Citus cluster was first set up, the worker nodes had stale metadata in `pg_dist_node`
that caused all `create_distributed_table()` calls to fail with:

```
ERROR:  Node with group id 1 for shard placement 102xxx does not exist
```

**Fix:** Drop and recreate the Citus extension on the coordinator, then re-add nodes:
```sql
DROP EXTENSION citus CASCADE;
CREATE EXTENSION citus;
SELECT citus_add_node('worker-0...', 5432);
SELECT citus_add_node('worker-1...', 5432);
SELECT citus_add_node('worker-2...', 5432);
```

### 15.2. Foreign Key Handling

Citus only supports FKs between colocated tables where the FK column is the partition column
(with the same ordinal position). The following FKs were dropped and re-added after distribution:

| FK | Dropped? | Re-added? | Reason |
|---|---|---|---|
| `chunks → documents` | Yes | No | Different colocation groups; cross-group FK not supported |
| `memory_links.entity_id → entities` | Yes | No | entity_id is 100% NULL; dead FK |
| `memory_links.from_unit_id → memory_units` | Temporarily | Yes | Must drop before `create_distributed_table()` |
| `memory_links.to_unit_id → memory_units` | Temporarily | **No** | Citus limitation: only partition column FK supported |
| `unit_entities.entity_id → entities` | Yes | No | Entities in same group, but this FK was dropped during FK cleanup |
| `unit_entities.unit_id → memory_units` | Temporarily | Yes | Partition column FK |
| `entity_cooccurrences → entities` | Yes | No | Entity FKs dropped during FK cleanup |

### 15.3. Citus Limitation: Only One FK Per Colocated Table to Partition Column

Citus only allows one FK per table that references the distributed table's partition column.
`memory_links` has FKs to `memory_units` on both `from_unit_id` and `to_unit_id`, but only
`from_unit_id` (the partition column) can have an FK. The `to_unit_id` FK must be dropped.

### 15.4. Data Loss: `memory_links` Table

The `memory_links` table was accidentally dropped (17,540 rows lost) when the distributed
table creation failed and the table was re-created empty. The table was subsequently
distributed (empty). **The links must be regenerated** by re-running retain operations.

### 15.5. Final Distributed Table State

| Table | Dist Method | Colocation Group | Rows |
|---|---|---|---|
| `banks` | reference | 2 | 1 |
| `documents` | hash | 3 | 68 |
| `chunks` | hash | 3 | 104 |
| `memory_units` | hash | 4 | 981 |
| `memory_links` | hash | 4 | 0 (regenerate needed) |
| `unit_entities` | hash | 4 | 536 |
| `entities` | hash | 4 | 174 |
| `entity_cooccurrences` | hash | 4 | 408 |
| `async_operations` | hash | 4 | 190 |

Group 4 combines memory_units, memory_links, unit_entities, entities, entity_cooccurrences,
and async_operations — all in one colocation group because `entities` and `async_operations`
happened to be auto-colocated with `memory_units` (same distribution key type: UUID).

## 16. Cross-Group Joins

`documents` ↔ `chunks` (group 3) and memory_graph (group 4) ↔ entities (group 4) are in
different groups. Cross-group joins require:
```sql
SET citus.enable_repartition_joins = on;
```

However, repartition joins had connectivity issues with worker-0 during testing. For production,
consider:
- Enabling repartition joins permanently via postgresql.conf
- Or restructuring the schema to collocate all tables in one group
