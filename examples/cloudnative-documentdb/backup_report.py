#!/usr/bin/env python3
"""CloudNativePG Backup Status Report.

Prints a formatted report showing cluster health, backup configuration,
WAL archiving status, backup history, and pod status.

Environment variables (set by terraform null_resource):
  NAMESPACE - Kubernetes namespace (default: from variables.tf or 'cloudnative-documentdb-example')
  CLUSTER   - CloudNativePG cluster name (default: from variables.tf or 'cloudnative-documentdb')

Standalone usage:
  NAMESPACE=cloudnative-documentdb-example CLUSTER=cloudnative-documentdb python3 backup_report.py
"""

import subprocess
import json
import os
import re
from datetime import datetime, timezone


# ── Read defaults from variables.tf ──────────────────────────────────────────
def _tf_default(module_dir, var_name):
    """Return the default value for a Terraform variable from variables.tf, or None."""
    tf_file = os.path.join(module_dir, "variables.tf")
    if not os.path.isfile(tf_file):
        return None
    with open(tf_file, encoding="utf-8") as f:
        content = f.read()
    # Match: variable "name" { default = "something" }
    m = re.search(
        rf'variable\s+"{var_name}"\s*{{\s*default\s*=\s*"([^"]*)"',
        content,
    )
    if m:
        return m.group(1)
    return None


TERRAFORM_DIR = os.path.dirname(os.path.abspath(__file__))

# Prefer env vars, fall back to variables.tf defaults, then legacy hard-coded fallbacks
NAMESPACE = (
    os.environ.get("NAMESPACE")
    or _tf_default(TERRAFORM_DIR, "namespace")
    or "cloudnative-documentdb-example"
)
CLUSTER = (
    os.environ.get("CLUSTER")
    or _tf_default(TERRAFORM_DIR, "name")
    or "cloudnative-documentdb"
)

# Box-drawing characters
HEADER = chr(0x2554) + chr(0x2550) * 72 + chr(0x2557)
HEADER_LB = chr(0x2551)
HEADER_RB = chr(0x2551)
SEPARATOR = chr(0x2560) + chr(0x2550) * 72 + chr(0x2563)
FOOTER = chr(0x255A) + chr(0x2550) * 72 + chr(0x255D)


def run(cmd, *args, capture=True, stdin_data=None):
    """Run a command and return its stdout, or None on failure."""
    try:
        result = subprocess.run(
            [cmd] + list(args),
            capture_output=capture,
            text=True,
            timeout=15,
            input=stdin_data,
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except (subprocess.TimeoutExpired, FileNotFoundError):
        pass
    return None


def print_section(title):
    print()
    print(HEADER)
    print(f"{HEADER_LB} {title} {HEADER_RB}")
    print(SEPARATOR)


def print_line(text):
    print(f"{HEADER_LB} {text} {HEADER_RB}")


def print_empty():
    print(f"{HEADER_LB}                                                                             {HEADER_RB}")


# ── Cluster Overview ──────────────────────────────────────────────────────────
print_section("📊 CLOUDNATIVEPG BACKUP STATUS REPORT")

cluster_json = run("kubectl", "get", "cluster", CLUSTER, "-n", NAMESPACE, "-o", "json")
if cluster_json:
    cluster = json.loads(cluster_json)
    status = cluster.get("status", {})
    spec = cluster.get("spec", {})

    print()
    print(f"Cluster:  {CLUSTER}")
    print(f"Phase:    {status.get('phase', 'N/A')}")
    print(f"Primary:  {status.get('currentPrimary', 'N/A')}")
    print(f"Instances: {status.get('readyInstances', 'N/A')}")
    print(f"Message:  {status.get('message', '')}")
    print(f"Timeline: {status.get('timelineID', 'N/A')}")
    print(f"Image:    {spec.get('imageName', 'N/A')}")
    print(f"Last Reconcile: {status.get('lastReconcile', 'N/A')}")
else:
    print(f"Cluster {CLUSTER} not found in namespace {NAMESPACE}")

# ── Barman ObjectStore Config ─────────────────────────────────────────────────
print_section("🗄️  BARMAN OBJECTSTORE CONFIGURATION")

objstore_json = run("kubectl", "get", "objectstore", "-n", NAMESPACE, "-o", "json")
if objstore_json:
    objstores = json.loads(objstore_json).get("items", [])
    if objstores:
        obj = objstores[0]
        name = obj["metadata"]["name"]
        spec = obj.get("spec", {})
        config = spec.get("configuration", {})
        creds = config.get("s3Credentials", {})
        access = creds.get("accessKeyId", {})

        print_line(f"ObjectStore: {name}")
        print_line(f"Endpoint:     {config.get('endpointURL', 'N/A')}")
        print_line(f"Destination:  {config.get('destinationPath', 'N/A')}")
        print_line(f"Credentials:  {access.get('name', 'N/A')}")
        print_line(f"WAL Compression: {config.get('wal', {}).get('compression', 'N/A')}")
        print_line(f"Data Compression: {config.get('data', {}).get('compression', 'N/A')}")
        print_line(f"Retention:    {spec.get('retentionPolicy', 'N/A')}")

        # Check S3 endpoint reachability
        endpoint = config.get("endpointURL", "")
        print_empty()
        try:
            import urllib.request
            req = urllib.request.Request(endpoint + "/", method="GET")
            req.add_header("User-Agent", "backup-report/1.0")
            start = datetime.now()
            try:
                resp = urllib.request.urlopen(req, timeout=5)
                http_code = str(resp.getcode())
                duration = (datetime.now() - start).total_seconds()
                if http_code in ("200", "403"):
                    print_line(f"S3 Endpoint:  ✅ REACHABLE (HTTP {http_code}, {duration:.2f}s)")
                else:
                    print_line(f"S3 Endpoint:  ⚠️  UNEXPECTED (HTTP {http_code})")
            except urllib.error.HTTPError as e:
                http_code = str(e.code)
                duration = (datetime.now() - start).total_seconds()
                if http_code in ("200", "403", "405"):
                    print_line(f"S3 Endpoint:  ✅ REACHABLE (HTTP {http_code}, {duration:.2f}s)")
                else:
                    print_line(f"S3 Endpoint:  ❌ UNREACHABLE (HTTP {http_code})")
        except Exception as e:
            print_line(f"S3 Endpoint:  ❌ UNREACHABLE ({e})")
    else:
        print_line("ObjectStore: NOT FOUND — backups may not work")
else:
    print_line("ObjectStore: NOT FOUND — backups may not work")

# ── Scheduled Backup Config ──────────────────────────────────────────────────
print_section("⏰ SCHEDULED BACKUP CONFIGURATION")

sched_json = run("kubectl", "get", "scheduledbackup", "-n", NAMESPACE, "-o", "json")
if sched_json:
    scheds = json.loads(sched_json).get("items", [])
    if scheds:
        s = scheds[0]
        spec = s.get("spec", {})
        status = s.get("status", {})
        print_line(f"Schedule Name: {s['metadata']['name']}")
        print_line(f"Schedule:   {spec.get('schedule', 'N/A')}")
        print_line(f"Method:     {spec.get('method', 'N/A')}")
        print_line(f"Last Check: {status.get('lastCheckTime', 'N/A')}")
        print_line(f"Next Run:   {status.get('nextScheduleTime', 'N/A')}")
        print_line(f"Last Backup: {status.get('lastBackup', 'N/A')}")
    else:
        print_line("Scheduled backup: NOT CONFIGURED")
else:
    print_line("Scheduled backup: NOT CONFIGURED")

# ── WAL Archiving Health ─────────────────────────────────────────────────────
print_section("📝 WAL ARCHIVING HEALTH")

cluster_json2 = run("kubectl", "get", "cluster", CLUSTER, "-n", NAMESPACE, "-o", "json")
primary = None
if cluster_json2:
    primary = json.loads(cluster_json2).get("status", {}).get("currentPrimary")

if primary:
    # Get barman sidecar logs
    barman_logs = run("kubectl", "logs", primary, "-c", "plugin-barman-cloud",
                      "-n", NAMESPACE, "--tail=100")
    if barman_logs:
        lines = barman_logs.split("\n")
        archived_count = sum(1 for l in lines if "Archived WAL file" in l)
        last_archived = ""
        for l in reversed(lines):
            if "Archived WAL file" in l:
                m = re.search(r'"walName":"([^"]*)"', l)
                if m:
                    last_archived = m.group(1)
                break

        if archived_count > 0:
            print_line("✅ WAL archiving is WORKING")
            print_line(f"Successful archives (last 100 logs): {archived_count}")
            print_line(f"Last archived WAL: {last_archived}")
        else:
            print_line("❌ WAL archiving is BROKEN — no successful archives found")

        # Check for errors in recent logs
        recent_logs = run("kubectl", "logs", primary, "-c", "plugin-barman-cloud",
                          "-n", NAMESPACE, "--tail=20")
        if recent_logs:
            error_lines = [l for l in recent_logs.split("\n")
                          if any(kw in l.lower() for kw in ("error", "fail", "not found"))][:5]
            if error_lines:
                print_line("Recent errors:")
                for el in error_lines:
                    # Truncate long lines
                    display = el if len(el) < 180 else el[:177] + "..."
                    print_line(f"  {display}")
    else:
        print_line("Barman sidecar logs: empty or not available")
else:
    print_line("Primary pod: UNKNOWN")

# ── Recent Backup History ───────────────────────────────────────────────────
print_section("📜 RECENT BACKUP HISTORY")

backup_json = run("kubectl", "get", "backup", "-n", NAMESPACE, "-l",
                  f"cnpg.io/cluster={CLUSTER}", "-o", "json")
backups = []
if backup_json:
    backups = json.loads(backup_json).get("items", [])

if backups:
    # Table header
    fmt_header = "{:<39} {:<8} {:<12} {:<8} {}"
    print(fmt_header.format("NAME", "STATUS", "STARTED", "DURATION", "ERROR"))
    print(fmt_header.format("-" * 39, "-" * 8, "-" * 12, "-" * 8, "-" * 60))

    counts = {"done": 0, "failed": 0, "error": 0, "running": 0, "other": 0}
    for item in backups[-10:]:
        meta = item.get("metadata", {})
        stat = item.get("status", {})
        name = meta.get("name", "")
        phase = stat.get("phase", "unknown")
        error = stat.get("error", "")

        start = stat.get("reconciliationStartedAt", "")
        end = stat.get("reconciliationTerminatedAt", "")
        started_fmt = ""
        dur_fmt = "N/A"

        if start:
            try:
                dt = datetime.fromisoformat(start.replace("Z", "+00:00"))
                started_fmt = dt.strftime("%Y-%m-%d %H:%M")
            except ValueError:
                started_fmt = start

        if start and end:
            try:
                st = datetime.fromisoformat(start.replace("Z", "+00:00"))
                et = datetime.fromisoformat(end.replace("Z", "+00:00"))
                dur = (et - st).total_seconds()
                dur_fmt = "%.0fs" % dur if dur < 60 else "%.1fm" % (dur / 60)
            except ValueError:
                dur_fmt = "N/A"

        if phase == "done":
            status_icon = "[OK]"
            counts["done"] += 1
        elif phase in ("failed", "error"):
            status_icon = "[FAIL]"
            counts[phase] = counts.get(phase, 0) + 1
        elif phase == "running":
            status_icon = "[RUN]"
            counts["running"] += 1
        else:
            status_icon = phase
            counts["other"] = counts.get("other", 0) + 1

        error_short = error[:55] + "..." if len(error) > 55 else error
        print(fmt_header.format(name[:39], status_icon, started_fmt, dur_fmt, error_short))

    print_empty()
    print_line(f"Summary: {counts['done']} done, {counts.get('failed', 0) + counts.get('error', 0)} failed, "
               f"{counts.get('running', 0)} running")
else:
    print_line("No backup records found")

# ── Postgres Archive Settings ───────────────────────────────────────────────
print_section("🔧 POSTGRES ARCHIVE SETTINGS")

if primary:
    archive_mode = run("kubectl", "exec", primary, "-c", "postgres", "-n", NAMESPACE,
                       "--", "psql", "-U", "postgres", "-tAc", "SHOW archive_mode;")
    archive_cmd = run("kubectl", "exec", primary, "-c", "postgres", "-n", NAMESPACE,
                      "--", "psql", "-U", "postgres", "-tAc", "SHOW archive_command;")
    archive_timeout = run("kubectl", "exec", primary, "-c", "postgres", "-n", NAMESPACE,
                          "--", "psql", "-U", "postgres", "-tAc", "SHOW archive_timeout;")

    print_line(f"archive_mode:      {archive_mode or 'N/A'}")
    print_line(f"archive_command:   {archive_cmd or 'N/A'}")
    print_line(f"archive_timeout:   {archive_timeout or 'N/A'}")

    if archive_mode == "on":
        print_line("✅ WAL archiving is enabled")
    else:
        print_line("❌ WAL archiving is DISABLED")
else:
    print_line("Primary pod: UNKNOWN")

# ── Pod Health ───────────────────────────────────────────────────────────────
print_section("🐳 POD STATUS")

pods_json = run("kubectl", "get", "pods", "-n", NAMESPACE, "-l",
                f"cnpg.io/cluster={CLUSTER}", "-o", "json")
if pods_json:
    pods = json.loads(pods_json).get("items", [])
    fmt = "{:<30} {:<6} {:<10} {:<10} {:<10} {:<18} {:<8} {}"
    print(fmt.format("NAME", "READY", "STATUS", "RESTARTS", "AGE", "IP", "NODE", ""))
    print(fmt.format("-" * 30, "-" * 6, "-" * 10, "-" * 10, "-" * 10, "-" * 18, "-" * 8, ""))
    for pod in pods:
        meta = pod.get("metadata", {})
        status = pod.get("status", {})
        cstatuses = status.get("containerStatuses", [])
        ready = "/".join(str(1 if c.get("ready") else 0) for c in cstatuses) if cstatuses else "?"
        pod_status = status.get("phase", status.get("conditions", [{}])[0].get("type", "?"))
        restarts = status.get("containerStatuses", [{}])[0].get("restartCount", "?") if cstatuses else "?"
        age = meta.get("creationTimestamp", "?")
        ip = status.get("podIP", "?")
        node = meta.get("labels", {}).get("kubernetes.io/hostname",
                                         status.get("hostIP", "?"))

        # Human-readable age
        if age != "?":
            try:
                created = datetime.fromisoformat(age.replace("Z", "+00:00"))
                diff = datetime.now(timezone.utc) - created
                if diff.days > 0:
                    age_str = f"{diff.days}d" if diff.days < 30 else f"{diff.days // 30}mo"
                else:
                    age_str = f"{diff.seconds // 3600}h"
            except ValueError:
                age_str = age
        else:
            age_str = "?"

        print(fmt.format(meta.get("name", "?"), ready, pod_status, restarts, age_str, ip, node, ""))
else:
    print_line("No pods found")

# ── Footer ────────────────────────────────────────────────────────────────────
print()
print(HEADER)
print(f"{HEADER_LB} Report generated at {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%S UTC')} {HEADER_RB}")
print(FOOTER)
print()
print("=== Report complete ===")
