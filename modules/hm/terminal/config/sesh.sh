#!/usr/bin/env bash

if [[ "$(tmux display-message -p -F '#{session_name}')" == popup* ]];
then
    FILTER="grep ^popup"
else
    FILTER="grep -v ^popup"
fi

SESS=$(bash -c 'sesh list -tz' | $FILTER | fzf-tmux -p 55%,60% \
    --border-label ' sesh ' --prompt '⚡  ' \
    --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^e zoxide erase ^f find' \
    --bind 'tab:down,btab:up' \
    --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list -t ; sesh list -z)' \
    --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
    --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c)' \
    --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z)' \
    --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -L -H -d 5 -t d -E .Trash -E .git -E .cache . ~)' \
    --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡  )+reload(sesh list -t)' \
    --bind 'ctrl-e:execute(zoxide-rm {})+change-prompt(⚡  )+reload(sesh list -z)')

if [[ -n $SESS ]]; then
	SESS="${SESS/#\~/$HOME}"
	if [[ -e "$SESS" ]]; then
		if [[ -L "$SESS" ]]; then
			SESS=$(readlink -f "$SESS")
		else
			SESS=$(realpath "$SESS")
		fi
	fi
fi

sesh connect "$SESS"
