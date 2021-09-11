# tmux-continuum

Features:

- continuous saving of tmux environment
- automatic tmux start when computer/server is turned on
- automatic restore when tmux is started

Together, these features enable uninterrupted tmux usage. No matter the computer
or server restarts, if the machine is on, tmux will be there how you left it off
the last time it was used.

Tested and working on Linux, OSX and Cygwin.

#### Continuous saving

Tmux environment will be saved at an interval of 15 minutes. All the saving
happens in the background without impact to your workflow.

This action starts automatically when the plugin is installed. Note it requires
the status line to be `on` to run (since it uses a hook in status-right to run).

#### Automatic tmux start

Tmux is automatically started after the computer/server is turned on.

See the [instructions](docs/automatic_start.md) on how to enable this for your
system.

#### Automatic restore

Last saved environment is automatically restored when tmux is started.

Put `set -g @continuum-restore 'on'` in `.tmux.conf` to enable this.

Note: automatic restore happens **exclusively** on tmux server start. No other
action (e.g. sourcing `.tmux.conf`) triggers this.

#### Dependencies

`tmux 1.9` or higher, `bash`,
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) plugin.

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Please make sure you have
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) installed.

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'tmux-plugins/tmux-resurrect'
    set -g @plugin 'tmux-plugins/tmux-continuum'

Hit `prefix + I` to fetch the plugin and source it. The plugin will
automatically start "working" in the background, no action required.

### Manual Installation

Please make sure you have
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) installed.

Clone the repo:

    $ git clone https://github.com/tmux-plugins/tmux-continuum ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/continuum.tmux

Reload TMUX environment with: `$ tmux source-file ~/.tmux.conf`

The plugin will automatically start "working" in the background, no action
required.

### Docs

- [frequently asked questions](docs/faq.md)
- [behavior when running multiple tmux servers](docs/multiple_tmux_servers.md) -
  this doc is safe to skip, but you might want to read it if you're using tmux
  with `-L` or `-S` flags
- [automatically start tmux after the computer is turned on](docs/automatic_start.md)
- [continuum status in tmux status line](docs/continuum_status.md)

### Other goodies

- [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat) - a plugin for
  regex searches in tmux and fast match selection
- [tmux-yank](https://github.com/tmux-plugins/tmux-yank) - enables copying
  highlighted text to system clipboard
- [tmux-open](https://github.com/tmux-plugins/tmux-open) - a plugin for quickly
  opening highlighted file or a url

### Known Issues

- In order to be executed periodically, the plugin updates the `status-right` tmux variable. In case some plugin (usually themes) overwrites the `status-right` variable, the autosave feature stops working. To fix this issue, place the plugin last in the TPM plugins list. 

### Reporting bugs and contributing

Both contributing and bug reports are welcome. Please check out
[contributing guidelines](CONTRIBUTING.md).

### License
[MIT](LICENSE.md)
