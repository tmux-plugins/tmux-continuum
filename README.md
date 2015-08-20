# tmux-continuum

Features:

- continuous saving of tmux environment
- automatic tmux start when computer/server is turned on
- automatic restore when tmux is started

Together these features enable uninterrupted tmux usage. No matter the computer
or server restarts, if the machine is on, tmux will be there how you left it off
the last time it was used.

Note: this plugin was recently renamed from `tmux-resurrect-auto` to
`tmux-continuum`. Option names have changed too, so don't forget to update them
if you're doing an upgrade.

#### Continuous saving

Tmux environment will be saved at the interval of 15 minutes. All the saving
happens in the background without the impact to your workflow.

This action starts automatically when the plugin is installed.

#### Automatic tmux start

Tmux is automatically started after the computer/server is turned on.

See the [instructions](scripts/handle_tmux_automatic_start/README.md) how to
enable this for your system.

#### Automatic restore

Last saved environment is automatically restored when tmux is started.

Put `set -g @continuum-restore 'on'` in `tmux.conf` to enable this.

Note: automatic restore happens **exclusively** on tmux server start. No other
action (e.g. sourcing `tmux.conf`) triggers this.

To kill the default session (named "0") created when tmux server starts,
Put `set -g @continuum-kill-default 'on'` in `tmux.conf` to enable this.

#### Dependencies

`tmux 1.9` or higher, `bash`,
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) plugin.

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Please make sure you have the latest version of
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) installed (as
of Feb 2015).

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @plugin 'tmux-plugins/tmux-resurrect'
    set -g @plugin 'tmux-plugins/tmux-continuum'

Hit `prefix + I` to fetch the plugin and source it. The plugin will
automatically start "working" in the background, no action required.

### Manual Installation

Please make sure you have the latest version of
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) installed (as
of Feb 2015).

Clone the repo:

    $ git clone https://github.com/tmux-plugins/tmux-continuum ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/continuum.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

The plugin will automatically start "working" in the background, no action
required.

### FAQ

> Will a previous save be overwritten immediately after I start tmux?

No, first automatic save starts 15 minutes after tmux is started. If automatic
restore is not enabled, that gives you enough time to manually restore from a
previous save.

> I want to make a restore to a previous point in time, but it seems that save
is now overwritten?

None of the previous saves are deleted (unless you explicitly do that). All save
files are kept in `~/.tmux/resurrect/` directory.<br/>
Here are the steps to restore to a previous point in time:

- make sure you start this with a "fresh" tmux instance
- `$ cd ~/.tmux/resurrect/`
- locate the save file you'd like to use for restore (file names have a timestamp)
- symlink the `last` file to the desired save file: `$ ln -sf <file_name> last`
- do a restore with `tmux-resurrect` key: `prefix + Ctrl-r`

You should now be restored to the time when `<file_name>` save happened.

> Will this plugin fill my hard disk?

Most likely no. A regular save file is in the range of 5Kb. That said, it
would be good to clean out old save files from `~/.tmux/resurrect/` dir from
time to time.

> How do I change the save interval to i.e. 1 hour?

The interval is always measured in minutes. So setting the interval to `60`
(minutes) will do the trick. Put this in `.tmux.conf`:

    set -g @continuum-save-interval '60'

and then source `tmux.conf` by executing this command in the shell
`$ tmux source-file ~/.tmux.conf`.

> How do I stop automatic saving?

Just set the save interval to `0`. Put this in `.tmux.conf`

    set -g @continuum-save-interval '0'

and then source `tmux.conf` by executing this command in the shell
`$ tmux source-file ~/.tmux.conf`.

> I had automatic restore turned on, how do I disable it now?

Just remove `set -g @continuum-restore 'on'` from `tmux.conf`.

To be absolutely sure automatic restore doesn't happen, create a
`tmux_no_auto_restore` file in your home directory (command:
`$ touch ~/tmux_no_auto_restore`). Automatic restore won't happen if this file
exists.

### Behavior when running multiple tmux servers

(This is safe to skip if you're always running a single tmux server.)

If you're an advanced tmux user, you might be running multiple tmux servers at
the same time. Maybe you start the first tmux server with `$ tmux` and then
later another one with e.g. `$ tmux -S/tmp/foo`.

You probably don't want to "auto restore" the same environment in the second
tmux that uses `/tmp/foo` socket. You also probably don't want two tmux
environments both having "auto save" feature on (think about overwrites).

This plugin handles multi-server scenario by giving precedence to the tmux
server that was first started.

In the above example, the server started with `$ tmux` will do "auto
restore" (if enabled) and will start "auto saving".
"Auto restore" or "auto saving" **will not** happen for the second server that
was started later with the `$ tmux -S/tmp/foo` command. The plugin will
detect the presence of another server (`$ tmux`) and give it precedence.

### Other goodies

- [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat) - a plugin for
  regex searches in tmux and fast match selection
- [tmux-yank](https://github.com/tmux-plugins/tmux-yank) - enables copying
  highlighted text to system clipboard
- [tmux-open](https://github.com/tmux-plugins/tmux-open) - a plugin for quickly
  opening highlighted file or a url

You might want to follow [@brunosutic](https://twitter.com/brunosutic) on
twitter if you want to hear about new tmux plugins or feature updates.

### Reporting bugs and contributing

Both contributing and bug reports are welcome. Please check out
[contributing guidelines](CONTRIBUTING.md).

### License
[MIT](LICENSE.md)
