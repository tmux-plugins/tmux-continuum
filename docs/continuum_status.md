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

### Last saved timestamp

Along with the current status, continuum can also display the last session save
timestamp to indicate when the last automatic session save happened. This can be
enabled by setting the tmux option `set -g @continuum-timestamp 'on'` in your
`tmux.conf`. The format of the timestamp follows UNIX `date` format and can be
set using `continuum-timestamp-option`.

Example usage:

    set -g @continuum-timestamp 'on'  # Enable last save timestamp in status
    set -g @continuum-timestamp-format '%I:%M %p' # Show date as "HH:MM AM"

When running, `#{continuum_status}` will show continuum last-save timestamp:

    Continuum status: 15 <11:54 AM>
