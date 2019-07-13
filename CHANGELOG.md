# Changelog

### master
- bugfix: "auto restore" feature stopped working
- bugfix: prevent race condition when auto-saving with locks (@v9v)

### v3.1.0, 2015-03-14
- properly quote scripts
- bugfix: "auto restore" feature does not work on tmux `1.9a`
- bugfix: do not count `tmux source-file .tmux.conf` as a tmux process (when
  checking if other tmux server is running). Previously, this caused
  interpolation command not to be inserted into `status-right` because `tmux
  source-file` was falsely detected as another tmux server.
- add `#{continuum_status}` status line interpolation

### v3.0.0, 2015-02-20
- rename the plugin from `tmux-resurrect-auto` to `tmux-continuum`

### v2.2.0, 2015-02-20
- document tmux multi-server behavior in the readme
- do not auto-restore tmux environment if another tmux server is already running
  (we don't want to duplicate stuff)
- bugfixes for 'tmux auto start' OS X Terminal.app and iTerm scripts
- prevent saving for the first 15 minutes only when plugin is sourced the first
  time (not on subsequent sources or tmux.conf reloads)
- do not start auto-saving if there's another tmux server running (we don't want
  for save files from various tmux environments to override each other)

### v2.1.0, 2015-02-18
- enable "tmux auto start" for OS X
- enable customizing "tmux auto start" for OS X
- fix errors when creating a launchd plist file for auto-start on OS X

### v2.0.0, 2015-02-15
- enable automatic environment restore when tmux is started

### v1.0.0, 2015-02-12
- first working version
- run the save script in the background
- do not start saving right after tmux is started
- add a check for tmux version to the initializer script
- when interval is set to '0' autosave is disabled
- bugfix: helper files not loaded
- update readme with the instructions how to disable auto saving
