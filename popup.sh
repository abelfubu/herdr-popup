#!/usr/bin/env bash
# Runs the command supplied via HERDR_POPUP_CMD inside a Herdr popup pane.
# Optional HERDR_POPUP_CWD changes directory before running the command.
# Optional HERDR_POPUP_WAIT=1 waits for a keypress after the command exits.

set -euo pipefail

if [[ -n "${HERDR_POPUP_CWD:-}" ]]; then
  cd "$HERDR_POPUP_CWD"
fi

if [[ -z "${HERDR_POPUP_CMD:-}" ]]; then
  echo "No HERDR_POPUP_CMD set." >&2
  exec "$SHELL"
fi

# Run the user command in the foreground so interactive TUIs work.
# shellcheck disable=SC2086
bash -c "$HERDR_POPUP_CMD" bash

if [[ "${HERDR_POPUP_WAIT:-}" == "1" ]]; then
  echo
  read -n 1 -s -r -p "Press any key to close..."
fi
