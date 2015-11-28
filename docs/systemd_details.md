# Systemd automatic start for tmux

The first time tmux starts when '@continuum-boot' is set to 'on' tmux-continuum will generate a user level systemd unit file which it will save to `${HOME}/.config/systemd/user/tmux.service` and enable it. From then on when that user logs in, either through a GUI session or on the console or via ssh, Systemd will start the tmux server.

The command used to start the tmux server is determined via the '@systemd_tmux_server_start_cmd' option that can be set in .tmux.conf. (Remember to reload your configuration with `tmux source ~/.tmux.conf` afterwards.

The default command to use is `new-session`. If you want more control over what sessions get started then you should set up your sessions in tmux.conf and set @systemd_tmux_server_start_cmd to 'start-server'

