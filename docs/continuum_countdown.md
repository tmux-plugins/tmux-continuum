## Continuum countdown in tmux status line

There is an option to display countdown in tmux status line, to see how many
minutes remain before the next automatic save happens. This is done via
`#{continuum_countdown}` interpolation and it works with both `status-right`
and `status-left` tmux native options.

Example usage:

    set -g status-right 'Continuum save in #{continuum_countdown} min'

When running, `#{continuum_countdown}` will show:

    Continuum save in 8 min
