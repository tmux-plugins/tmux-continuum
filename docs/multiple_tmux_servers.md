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
