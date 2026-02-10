#!/usr/bin/env bash_pass_keys

zellij_switch() {
	zellij pipe --plugin "file:{{ conf.homeDir }}/.config/zellij/plugins/zellij-switch.wasm" "$@"
}

list_zellij_sessions() {
	local sessions=$(zellij list-sessions --short --no-formatting 2>/dev/null)

	if [[ -n "$ZELLIJ_SESSION_NAME" && -n "$sessions" ]]; then
		# Output current session first if it exists in the list
		echo "$sessions" | grep -Fx "$ZELLIJ_SESSION_NAME"
		# Then output all other sessions
		echo "$sessions" | grep -vFx "$ZELLIJ_SESSION_NAME"
	else
		# Not in a session or no sessions exist, just output as-is
		echo "$sessions"
	fi
}

list_zoxide_dirs() {
	zoxide query -l 2>/dev/null
}

list_combined() {
	list_zellij_sessions
	list_zoxide_dirs
}

export -f list_zellij_sessions
export -f list_zoxide_dirs
export -f list_combined

is_existing_session() {
	local name="$1"
	zellij list-sessions --short --no-formatting 2>/dev/null | grep -qxF "$name"
}

is_directory() {
	local path="$1"
	[[ -e "$path" && -d "$path" ]]
}

derive_session_name() {
	local path="$1"
	local parent_name=$(basename "$(dirname "$path")")
	local base_name=$(basename "$path")
	echo "${parent_name}__${base_name}"
}

SESS=$(list_combined | grep -vE "^(opencode|claude)" | fzf \
	--border-label ' zellij session manager ' --prompt '⚡  ' \
	--header '  ^a all ^t zellij ^x zoxide ^d delete session ^e zoxide erase ^f find' \
	--bind 'tab:down,btab:up' \
	--bind 'ctrl-a:change-prompt(⚡  )+reload(list_combined)' \
	--bind "ctrl-t:change-prompt(🪟  )+reload(list_zellij_sessions)" \
	--bind "ctrl-x:change-prompt(📁  )+reload(list_zoxide_dirs)" \
	--bind 'ctrl-f:change-prompt(🔎  )+reload(fd -L -H -d 5 -t d -E .Trash -E .git -E .cache . ~)' \
	--bind "ctrl-d:execute(zellij kill-session '{}')+change-prompt(⚡  )+reload(list_zellij_sessions)" \
	--bind "ctrl-e:execute(zoxide remove '{}')+change-prompt(⚡  )+reload(list_zoxide_dirs)")

if [[ -n $SESS ]]; then
	SESS="${SESS/#\~/$HOME}"
	if [[ -e "$SESS" ]]; then
		if [[ -L "$SESS" ]]; then
			SESS=$(readlink -f "$SESS")
		else
			SESS=$(realpath "$SESS")
		fi
	fi

	if [[ -n "$ZELLIJ" ]]; then
		if is_existing_session "$SESS"; then
			zellij_switch -- "--session $(printf %q "$SESS") --layout my"
		elif is_directory "$SESS"; then
			session_name=$(derive_session_name "$SESS")
			zellij_switch -- "--session $(printf %q "$session_name") --cwd $(printf %q "$SESS") --layout my"
		else
			zellij_switch -- "--session $(printf %q "$SESS") --layout my"
		fi
	else
		if is_directory "$SESS"; then
			session_name=$(derive_session_name "$SESS")
			cd "$SESS" && zellij attach --create "$session_name" --layout my
		else
			zellij attach --create "$SESS" --layout my
		fi
	fi
fi
