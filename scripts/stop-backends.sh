#!/usr/bin/env bash
ROOT=$(cd "$(dirname "$0")/.." && pwd)
for s in users orders; do
  [ -f "$ROOT/logs/$s.pid" ] && kill "$(cat "$ROOT/logs/$s.pid")" 2>/dev/null && echo "Zatrzymano $s"
  rm -f "$ROOT/logs/$s.pid"
done
