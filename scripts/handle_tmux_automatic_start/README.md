# Automatic Tmux start

Tmux is automatically started after the computer/server is turned on.

### OS X

To enable this feature:
- put `set -g @resurrect-auto-tmux-start 'on'` in `tmux.conf`
- reload tmux config with this shell command: `$ tmux source-file ~/.tmux.conf`

Next time the computer is started:
- `Terminal.app` window will open and resize to maximum size
- `tmux` command will be executed in the terminal window
- if "auto restore" feature is enabled, tmux will start restoring previous env

Config options:
- `set -g @resurrect-auto-tmux-start-options 'fullscreen'` - terminal window
  will go fullscreen
- `set -g @resurrect-auto-tmux-start-options 'iterm'` - start `iTerm` instead
  of `Terminal.app`
- `set -g @resurrect-auto-tmux-start-options 'iterm,fullscreen'` - start `iTerm`
  in fullscreen

### Linux

Help with this would be greatly appreciated. Please get in touch.
