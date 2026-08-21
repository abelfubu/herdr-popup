# herdr-popup

Generic popup pane plugin for Herdr. Lets you open any shell command in a
session-modal popup from the CLI, an agent tool, or a keybinding.

## Why

Herdr has `[[keys.command]] type = "popup"` but no built-in CLI/tool for opening
an ad-hoc shell command in a popup. This plugin adds a single `popup` pane
entrypoint that runs whatever command you pass via `HERDR_POPUP_CMD`.

## Install

### From GitHub

```bash
herdr plugin install abelfubu/herdr-popup --yes
```

### From a local checkout

```bash
herdr plugin link /path/to/herdr-popup-plugin --enabled
```

## Usage

The easiest way is the `herdr-popup` wrapper (add `bin/herdr-popup` to your
`PATH`, or let chezmoi install it — see below):

```bash
herdr-popup -- glow README.md
herdr-popup -d /path/to/repo -- nvim -c DiffviewOpen
herdr-popup -k -- ls -la
```

Or invoke the plugin directly:

```bash
# Preview a markdown file with glow
herdr plugin pane open \
  --plugin herdr-popup \
  --entrypoint popup \
  --placement popup \
  --width "80%" \
  --height "80%" \
  --focus \
  --env HERDR_POPUP_CMD="glow README.md" \
  --env HERDR_POPUP_CWD="/path/to/project"

# Open Neovim with Diffview
herdr plugin pane open \
  --plugin herdr-popup \
  --entrypoint popup \
  --placement popup \
  --width "90%" \
  --height "90%" \
  --focus \
  --env HERDR_POPUP_CMD="nvim -c DiffviewOpen" \
  --env HERDR_POPUP_CWD="/path/to/project"

# Run a one-off command and keep the popup open afterwards
herdr plugin pane open \
  --plugin herdr-popup \
  --entrypoint popup \
  --placement popup \
  --width "60%" \
  --height "50%" \
  --env HERDR_POPUP_CMD="ls -la" \
  --env HERDR_POPUP_WAIT="1" \
  --env HERDR_POPUP_CWD="/path/to/project"
```

## Environment variables

| Variable | Required | Description |
|---|---|---|
| `HERDR_POPUP_CMD` | yes | Shell command to execute inside the popup |
| `HERDR_POPUP_CWD` | no | Working directory for the command |
| `HERDR_POPUP_WAIT` | no | Set to `1` to wait for a keypress after the command exits |

## Chezmoi

If you manage dotfiles with chezmoi, add the plugin install to a
`run_onchange_after_herdr-plugins.sh.tmpl` script:

```bash
if ! herdr plugin list --json | grep -q '"plugin_id":"herdr-popup"'; then
  echo "Installing herdr-popup plugin..."
  herdr plugin install abelfubu/herdr-popup --yes
else
  echo "herdr-popup plugin already installed"
fi
```

Then add `bin/herdr-popup` from this repo to your chezmoi source as
`dot_local/bin/executable_herdr-popup` to get the wrapper on `PATH`.

## Notes / caveats

- Popups are not listed in `herdr pane list` or `herdr api snapshot`, and cannot
  be targeted with `send-keys`/`read` (see herdr#2878). They close automatically
  when the command exits.
- Use `--focus` if you want to interact with the popup immediately; use
  `--no-focus` if you want the agent to keep the current pane focused.


- Popups are not listed in `herdr pane list` or `herdr api snapshot`, and cannot
  be targeted with `send-keys`/`read` (see herdr#2878). They close automatically
  when the command exits.
- Use `--focus` if you want to interact with the popup immediately; use
  `--no-focus` if you want the agent to keep the current pane focused.
