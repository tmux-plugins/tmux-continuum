# Automatic Tmux start

Tmux is automatically started after the computer/server is turned on.

### OS X

To enable this feature:
- put `set -g @continuum-boot 'on'` in `.tmux.conf`
- reload tmux config with this shell command: `$ tmux source-file ~/.tmux.conf`

Next time the computer is started:
- `Terminal.app` window will open and resize to maximum size
- `tmux` command will be executed in the terminal window
- if "auto restore" feature is enabled, tmux will start restoring previous env

Config options:
- `set -g @continuum-boot-options 'fullscreen'` - terminal window
  will go fullscreen
- `set -g @continuum-boot-options 'iterm'` - start [iTerm](https://www.iterm2.com) instead
  of `Terminal.app`
- `set -g @continuum-boot-options 'iterm,fullscreen'` - start `iTerm`
  in fullscreen
- `set -g @continuum-boot-options 'kitty'` - start [kitty](https://sw.kovidgoyal.net/kitty) instead
  of `Terminal.app`
- `set -g @continuum-boot-options 'kitty,fullscreen'` - start `kitty`
  in fullscreen
- `set -g @continuum-boot-options 'alacritty'` - start [alacritty](https://github.com/alacritty/alacritty) instead of `Terminal.app`
- `set -g @continuum-boot-options 'alacritty,fullscreen'` - start `alacritty`
  in fullscreen

Note: The first time you reboot your machine and activate this feature you may be prompted about a script requiring
access to a system program (i.e. - System Events). If this happens tmux will not start automatically and you will need
to go to `System Preferences -> Security & Privacy -> Accessability` and add the script to the list of apps that are
allowed to control your computer.

### Linux

Help with this would be greatly appreciated. Please get in touch.

#### Systemd

##### this will only start the tmux server, it will *not* start any terminal emulator

To enable automatic start with systemd:
- Put `set -g @continuum-boot 'on'` in `.tmux.conf`
- reload tmux config with this shell command: `$ tmux source-file ~/.tmux.conf`
- see [systemd](/docs/systemd_details.md) for more details about how this is implemented
