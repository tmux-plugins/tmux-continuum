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

