# Systemd automatic start for tmux

The first time tmux starts when `@continuum-boot` is set to 'on' tmux-continuum will generate a user level systemd unit file which it will save to `${HOME}/.config/systemd/user/tmux.service` and enable it. From then on when that user logs in, either through a GUI session or on the console or via ssh, Systemd will start the tmux server.

The command used to start the tmux server is determined via the `@continuum-systemd-start-cmd` option that can be set in .tmux.conf. (Remember to reload your configuration with `tmux source ~/.tmux.conf` afterwards.

The default command to use is `new-session -d`. If you want more control over what sessions get started then you should set up your sessions in tmux.conf and set `@continuum-systemd-start-cmd = 'start-server'`. As this will be executed as part of systemd's ExecStart statement there will be no shell parsing. See [Systemd manual](http://www.freedesktop.org/software/systemd/man/systemd.service.html#Command%20lines) for more details.

To control the tmux service you can use all the standard `systemctl` commands using the `--user` argument. eg to see if the tmux server has started:

  systemctl --user status tmux.service


