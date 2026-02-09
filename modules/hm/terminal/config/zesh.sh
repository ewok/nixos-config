#!/usr/bin/env bash

# Note: no popup filtering needed for zellij (that was tmux-specific)

SESS=$(bash -c 'zesh list' | grep -vE "^(opencode|claude) " | fzf \
	--border-label ' zesh ' --prompt '⚡  ' \
	--header '  ^a all ^t zellij ^x zoxide ^d delete session ^e zoxide erase ^f find' \
	--bind 'tab:down,btab:up' \
	--bind 'ctrl-a:change-prompt(⚡  )+reload(zesh list)' \
	--bind 'ctrl-t:change-prompt(🪟  )+reload(zesh list --zesh)' \
	--bind 'ctrl-x:change-prompt(📁  )+reload(zesh list --zoxide)' \
	--bind 'ctrl-f:change-prompt(🔎  )+reload(fd -L -H -d 5 -t d -E .Trash -E .git -E .cache . ~)' \
	--bind 'ctrl-d:execute(zellij delete-session {})+change-prompt(⚡  )+reload(zesh list --zesh)' \
	--bind 'ctrl-e:execute(zoxide-rm {})+change-prompt(⚡  )+reload(zesh list --zoxide)')

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

zesh connect "$SESS"
