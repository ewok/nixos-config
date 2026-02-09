function fish_greeting
  # Early exit if not in a real terminal
  if not isatty stdin
    return
  end

  # Get current tty path, skip if on console tty1 (graphical login)
  set -l current_tty (tty 2>/dev/null)
  if test "$status" -ne 0 -o "$current_tty" = "/dev/tty1"
    return
  end

  # Try tmux if available and not already inside tmux
  if command -vq tmux; and test -z "$TMUX"
    _try_attach_tmux
    and exit
  end

  # Try zellij if available and not already inside zellij
  if command -vq zellij; and test -z "$ZELLIJ"
    _try_attach_zellij
    and exit
  end

  # If we reach here, continue to normal prompt
end

function _try_attach_tmux
  # Determine tmux command based on environment
  set -l TMUX_CMD tmux
  if test -n "$INSIDE_EMACS"
    set TMUX_CMD tmux -L emacs
  end

  # Try to get list of sessions, fail gracefully if no server
  set -l sessions_output ($TMUX_CMD list-sessions 2>/dev/null)
  if test "$status" -ne 0
    # No server running, try to create new session
    $TMUX_CMD new -x- -y- 2>/dev/null
    return "$status"
  end

  # Find first unattached session with numeric name
  set -l SESS (echo $sessions_output | grep -v attached | cut -d: -f1 | grep -E '^[0-9]+$' | head -n 1)

  if test -n "$SESS"
    # Try to attach to existing session
    $TMUX_CMD attach -t $SESS 2>/dev/null
    return "$status"
  else
    # No unattached sessions, create new one
    $TMUX_CMD new -x- -y- 2>/dev/null
    return "$status"
  end
end

function _try_attach_zellij
  # Try to get list of sessions, fail gracefully if zellij not working
  set -l sessions_output (zellij list-sessions 2>/dev/null)
  if test "$status" -ne 0
    # Zellij not working properly, skip to normal prompt
    return 1
  end

  # Parse sessions (exclude EXITED and current, strip ANSI codes)
  set -l SESSIONS (echo $sessions_output | grep -v "EXITED" | grep -v "current" | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')

  set -l FOUND_SESSION ""

  # Find first session without connected clients
  for sess in $SESSIONS
    set -l client_count (zellij --session "$sess" action list-clients 2>/dev/null | wc -l)
    # Only proceed if command succeeded and no clients (header only = 1 line)
    if test "$status" -eq 0 -a "$client_count" -le 1
      set FOUND_SESSION "$sess"
      break
    end
  end

  if test -n "$FOUND_SESSION"
    # Try to attach to session without clients
    zellij attach "$FOUND_SESSION" 2>/dev/null
    return "$status"
  else
    # No available sessions, create new one
    zellij 2>/dev/null
    return "$status"
  end
end
