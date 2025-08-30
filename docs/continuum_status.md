## Continuum status in tmux status line

There is an option to display current status of tmux continuum in tmux status
line. This is done via `#{continuum_status}` interpolation and it works with
both `status-right` and `status-left` tmux native options.

Example usage:

    set -g status-right 'Continuum status: #{continuum_status}'

When running, `#{continuum_status}` will show continuum save interval:

    Continuum status: 15

or if continuous saving is disabled:

    Continuum status: off


### tmux-powerline
If you use the [tmux-powerline](https://github.com/erikw/tmux-powerline) statusbar, you can use the two [adapter segments](https://github.com/search?q=repo%3Aerikw%2Ftmux-powerline+path%3Asegments%2Ftmux_continuum&type=code) to get tmux-continuum support (auto-save of tmux environment + status in the statusbar).
