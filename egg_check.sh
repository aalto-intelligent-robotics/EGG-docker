#!/usr/bin/env sh
# Ensure the 'egg' package is installed in the current uv environment.

if ! command -v uv >/dev/null 2>&1; then
  echo "Error: 'uv' is not installed or not on PATH." >&2
fi

# Check if 'egg' is installed in the active uv/venv
if uv run -q python - <<'PYCODE'
import sys
from importlib.metadata import version, PackageNotFoundError
try:
    version("egg")
    sys.exit(0)
except PackageNotFoundError:
    sys.exit(1)
PYCODE
then
  echo "'egg' is already installed."
else
  echo "'egg' is not installed; installing..."
  uv pip install -e ${HOME}/workspace/egg
fi
