# tmux-resurrect-auto

Continuous saving of tmux environment.

After this plugin is installed, `tmux-resurrect` will save environment at the
interval of 15 minutes. All the saving happens in the background without the
impact to your workflow.

Requirements / dependencies: `tmux 1.9` or higher, `bash`,
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) plugin.

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Please make sure you have the latest version of
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) installed (as
of Feb 2015).

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @tpm_plugins '                \
      tmux-plugins/tpm                   \
      tmux-plugins/tmux-resurrect        \
      tmux-plugins/tmux-resurrect-auto   \
    '

Hit `prefix + I` to fetch the plugin and source it. The plugin will
automatically start "working" in the background, no action required.

### Manual Installation

Please make sure you have the latest version of
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) installed (as
of Feb 2015).

Clone the repo:

    $ git clone https://github.com/tmux-plugins/tmux-resurrect-auto ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/resurrect_auto.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

The plugin will automatically start "working" in the background, no action
required.

### FAQ

> Will a previous save be overwritten immediately after I start tmux?

No, first automatic save starts 15 minutes after tmux is started. That gives you
enough time to restore from a previous save.

> I want to make a restore to a previous point in time, but it seems that save
is now overwritten?

None of the previous saves are deleted (unless you explicitly do that). All save
files are kept in `~/.tmux/resurrect/` directory.<br/>
Here are the steps to restore to a previous point in time:

- make sure you start this with a "fresh" tmux instance
- `$ cd ~/.tmux/resurrect/`
- locate the save file you'd like to use for restore (file names have a timestamp)
- symlink the `last` file to the desired save file: `$ ln -sf <file_name> last`
- do a restore with `prefix + Ctrl-r`

You should now be restored to the time when `<file_name>` save happened.

> Will this plugin fill my hard disk?

Most likely no. A regular save file is in the range of 5Kb. That said, it
would be good to clean out old save files from `~/.tmux/resurrect/` dir from
time to time.

> How do I change the save interval to i.e. 1 hour?

The interval is always measured in minutes. So setting the interval to `60`
(minutes) will do the trick. Put this in `.tmux.conf`:

    set -g @resurrect-auto-save-interval '60'

and then source `tmux.conf` by executing this command in the shell
`tmux source ~/.tmux.conf`.

> How do I stop automatic saving?

Just set the save interval to `0`. Put this in `.tmux.conf`

    set -g @resurrect-auto-save-interval '0'

and then source `tmux.conf` by executing this command in the shell
`tmux source ~/.tmux.conf`.

### Other goodies

- [tmux-copycat](https://github.com/tmux-plugins/tmux-copycat) - a plugin for
  regex searches in tmux and fast match selection
- [tmux-yank](https://github.com/tmux-plugins/tmux-yank) - enables copying
  highlighted text to system clipboard
- [tmux-open](https://github.com/tmux-plugins/tmux-open) - a plugin for quickly
  opening highlighted file or a url

### Reporting bugs and contributing

Both contributing and bug reports are welcome. Please check out
[contributing guidelines](CONTRIBUTING.md).

### License
[MIT](LICENSE.md)
