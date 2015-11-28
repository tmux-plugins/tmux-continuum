# Automatic Tmux start

Tmux is automatically started after the computer/server is turned on.

### OS X

To enable this feature:
- put `set -g @continuum-boot 'on'` in `tmux.conf`
- reload tmux config with this shell command: `$ tmux source-file ~/.tmux.conf`

Next time the computer is started:
- `Terminal.app` window will open and resize to maximum size
- `tmux` command will be executed in the terminal window
- if "auto restore" feature is enabled, tmux will start restoring previous env

Config options:
- `set -g @continuum-boot-options 'fullscreen'` - terminal window
  will go fullscreen
- `set -g @continuum-boot-options 'iterm'` - start `iTerm` instead
  of `Terminal.app`
- `set -g @continuum-boot-options 'iterm,fullscreen'` - start `iTerm`
  in fullscreen

### Linux

Help with this would be greatly appreciated. Please get in touch.

#### Systemd

##### this will only start the tmux server, it will *not* start any terminal emulator

To enable automatic start with systemd:
- Put `set -g @continuum-boot 'on'` in tmux.conf
- reload tmux config with this shell command: `$ tmux source-file ~/.tmux.conf`
- see [systemd](./systemd_details.md) for more details about how this is implemented
