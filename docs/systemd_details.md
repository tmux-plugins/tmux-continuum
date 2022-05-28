# Systemd automatic start for tmux

The first time tmux starts when `@continuum-boot` is set to 'on' tmux-continuum will generate a user level systemd unit file which it will save to `${HOME}/.config/systemd/user/tmux.service` and enable it. From then on when that user logs in, either through a GUI session or on the console or via ssh, Systemd will start the tmux server.

The command used to start the tmux server is determined via the `@continuum-systemd-start-cmd` option that can be set in .tmux.conf. (Remember to reload your configuration with `tmux source ~/.tmux.conf` afterwards.

The default command to use is `new-session -d`. If you want more control over what sessions get started then you should set up your sessions in tmux.conf and set `@continuum-systemd-start-cmd = 'start-server'`. As this will be executed as part of systemd's ExecStart statement there will be no shell parsing. See [Systemd manual](http://www.freedesktop.org/software/systemd/man/systemd.service.html#Command%20lines) for more details.

To control the tmux service you can use all the standard `systemctl` commands using the `--user` argument. eg to see if the tmux server has started:

  systemctl --user status tmux.service

## Setup Example

To be able to configure systemd user services, make sure the following directories exist: `$HOME/.config/systemd/user`. If not, just create them:

```shell
mkdir ~/.config/systemd
mkdir ~/.config/systemd/user
```

Create the systemd user service file:

```shell
touch ~/.config/systemd/user/tmux.service
```

The service file can be created from this template:

```shell
[Unit]
Description=tmux default session (detached)
Documentation=man:tmux(1)
After=graphical.target

[Service]
Type=forking
Environment=DISPLAY=:1
ExecStart=/usr/bin/tmux new-session -d

ExecStop=/home/user/.tmux/plugins/tmux-resurrect/scripts/save.sh
ExecStop=/usr/bin/tmux kill-server
KillMode=mixed

RestartSec=2

[Install]
WantedBy=default.target
```

Now make sure you adapt the service file to your needs:

- `Environment`: Set the value of your $DISPLAY environment variable (i.e. `:1`, to find out run `echo $DISPLAY`)
- `ExecStart`: If you want to configure the tmux start command, you can do it here
- `ExecStop`: Enter the full path to the `save.sh` script of `tmux-resurrect`, usually in `$HOME/.tmux/plugins/tmux-resurrect/scripts/save.sh`
- `After`: Adapt to your needs, waiting for `graphical.target` helps if you want to open gui applications such as `code` directly from your resurrected terminals

Now you are ready to enable and start your system service:

```shell
systemctl --user enable tmux.service
systemctl --user start tmux.service
```

- Reboot your machine.
- To check the current status of your tmux service, run this command:

```shell
systemctl --user status tmux.service
```

You should see something along the lines of:

```shell
Active: active (running) since Fri 2022-05-27 15:28:36 CEST; 23h ago
  Docs: man:tmux(1)
  Process: 6300 ExecStart=/usr/bin/tmux new-session -d (code=exited, status=0/SUCCESS)
  CGroup: /user.slice/user-1000.slice/user@1000.service/app.slice/tmux.service
          ├─   6306 /usr/bin/tmux new-session -d
          ├─   7735 zsh
  ...
```
