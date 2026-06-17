CREATE EXTENSION IF NOT EXISTS ltree;
CREATE EXTENSION IF NOT EXISTS plv8;


-- Table: public.section

DROP TABLE IF EXISTS public.section;
CREATE TABLE IF NOT EXISTS public.section
(
    id       SERIAL PRIMARY KEY,
    pid      INTEGER,
    path     LTREE,
    position INTEGER,
    label    TEXT
);

CREATE INDEX IF NOT EXISTS path_gist_idx ON public.section USING GIST (path);
CREATE INDEX IF NOT EXISTS pid_idx ON public.section (pid);


-- Trigger: update_section_path

CREATE OR REPLACE FUNCTION public.update_section_path()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS
$BODY$
DECLARE
    new_path ltree;
BEGIN
    IF NEW.pid IS NULL THEN
        NEW.path = NEW.id::text::ltree;
    ELSEIF TG_OP = 'INSERT' OR OLD.pid IS NULL OR OLD.pid != NEW.pid THEN
        SELECT path || id::text FROM section WHERE id = NEW.pid INTO new_path;
        IF new_path IS NULL THEN
            RAISE EXCEPTION 'Invalid pid %', NEW.pid;
        END IF;
        NEW.path = new_path;
    END IF;
    RETURN NEW;
END;
$BODY$;

DROP TRIGGER IF EXISTS update_section_path ON section;
CREATE TRIGGER update_section_path
    BEFORE INSERT OR UPDATE
    ON public.section
    FOR EACH ROW
EXECUTE PROCEDURE public.update_section_path();


-- Function: json_tree

DROP FUNCTION json_tree(text);
CREATE OR REPLACE FUNCTION public.json_tree(
    start_path text)
    RETURNS json
    LANGUAGE 'plv8'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS
$BODY$
    var rows = plv8.execute('SELECT * FROM section WHERE path <@ $1 ORDER BY nlevel(path),position', [start_path]);
    var all = {},
        out = [],
        top,r,i;
    for(i=0; i<rows.length; i++){
        r = rows[i];
        r.children = [];
        all[r.id] = r;
        if(r.path == start_path){
            out.push(r);
        }
    }
    for(i=0; i<rows.length; i++){
        r = rows[i];
        if(all[ r.pid ]){
            all[ r.pid ].children.push(r);
        }
    }
    return JSON.stringify(out,null,4);
$BODY$;

-- Sample data
insert into public.section (label) values ('root') returning *;
insert into public.section (label, pid) values ('root.a', 1) returning *;
insert into public.section (label, pid) values ('root.b', 1) returning *;
insert into public.section (label, pid) values ('root.b.c', 3) returning *;