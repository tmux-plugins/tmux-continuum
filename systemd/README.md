# Systemd Timer for tmux-resurrect Auto-Save

An alternative to the default `status-right` based auto-save that uses a systemd user timer instead.

## Why?

The default auto-save mechanism uses `#()` command substitution in tmux's `status-right`. This command runs on every status bar refresh for every attached client. With many sessions and clients, this can cause significant CPU overhead.

A systemd timer runs the save script once per interval, regardless of the number of sessions or clients.

## Setup

Copy the unit files to your systemd user directory:

```bash
cp systemd/tmux-resurrect-save.service ~/.config/systemd/user/
cp systemd/tmux-resurrect-save.timer ~/.config/systemd/user/
```

Adjust the path in the service file if your tmux-resurrect is installed somewhere other than `~/.tmux/plugins/tmux-resurrect/`.

Enable and start the timer:

```bash
systemctl --user daemon-reload
systemctl --user enable --now tmux-resurrect-save.timer
```

Then disable the status-right based auto-save in your `tmux.conf`:

```tmux
set -g @continuum-save-interval '0'
```

## Verify

Check the timer status:

```bash
systemctl --user list-timers | grep tmux
```

Manually trigger a save:

```bash
systemctl --user start tmux-resurrect-save.service
```
