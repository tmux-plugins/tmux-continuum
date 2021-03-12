### FAQ

> Will a previous save be overwritten immediately after I start tmux?

No, first automatic save starts 15 minutes after tmux is started. If automatic
restore is not enabled, that gives you enough time to manually restore from a
previous save.

> I want to make a restore to a previous point in time, but it seems that save
is now overwritten?

Read how to [restore a previously saved environment](https://github.com/tmux-plugins/tmux-resurrect/blob/master/docs/restoring_previously_saved_environment.md)

> Will this plugin fill my hard disk?

Most likely no. A regular save file is in the range of 5Kb. And `tmux-resurrect` already has a `remove_old_backups()` routine that will ["remove resurrect files older than 30 days, but keep at least 5 copies of backup."](https://github.com/tmux-plugins/tmux-resurrect/blob/da1a7558024b8552f7262b39ed22e3d679304f99/scripts/save.sh#L271-L277)

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

