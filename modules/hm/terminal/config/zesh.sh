#!/usr/bin/env bash_pass_keys

LAYOUT=my
HISTORY_DIR="$HOME/.local/state/zellij"
HISTORY_FILE="$HISTORY_DIR/session-history"

zellij_switch() {
	zellij pipe --plugin "file:{{ conf.homeDir }}/.config/zellij/plugins/zellij-switch.wasm" "$@"
	zellij pipe --plugin "https://github.com/mostafaqanbaryan/zellij-switch/releases/download/0.2.1/zellij-switch.wasm" "$@"
}

list_zellij_sessions() {
	local sessions=$(zellij list-sessions --short --no-formatting 2>/dev/null)
	[[ -z "$sessions" ]] && return

	local current="$ZELLIJ_SESSION_NAME"
	local result=""

	# Output current session first if we're in one
	if [[ -n "$current" ]] && echo "$sessions" | grep -qFx "$current"; then
		result="$current"
	fi

	# If history file exists, sort remaining sessions by MRU
	if [[ -f "$HISTORY_FILE" ]]; then
		while IFS= read -r hist_session; do
			# Skip current session (already added) and non-existent sessions
			[[ "$hist_session" == "$current" ]] && continue
			echo "$sessions" | grep -qFx "$hist_session" || continue
			if [[ -n "$result" ]]; then
				result="$result"$'\n'"$hist_session"
			else
				result="$hist_session"
			fi
		done <"$HISTORY_FILE"
	fi

	# Add any sessions not in history (new sessions)
	while IFS= read -r session; do
		[[ "$session" == "$current" ]] && continue
		if [[ -n "$result" ]]; then
			echo "$result" | grep -qFx "$session" && continue
		fi
		if [[ -n "$result" ]]; then
			result="$result"$'\n'"$session"
		else
			result="$session"
		fi
	done <<<"$sessions"

	echo "$result"
}

list_zoxide_dirs() {
	zoxide query -l 2>/dev/null
}

list_combined() {
	list_zellij_sessions
	list_zoxide_dirs
}

export HISTORY_DIR HISTORY_FILE
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

record_session_switch() {
	local session_name="$1"
	[[ -z "$session_name" ]] && return

	mkdir -p "$HISTORY_DIR"

	if [[ -f "$HISTORY_FILE" ]]; then
		# Remove existing entry and prepend new one
		local tmp=$(grep -vFx "$session_name" "$HISTORY_FILE")
		echo "$session_name" >"$HISTORY_FILE"
		[[ -n "$tmp" ]] && echo "$tmp" >>"$HISTORY_FILE"
	else
		echo "$session_name" >"$HISTORY_FILE"
	fi
}

if [ "$1" != "" ]; then
	SESS="$1"
else
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
fi

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
			record_session_switch "$SESS"
			zellij_switch -- "--session $(printf %q "$SESS") --layout $LAYOUT"
		elif is_directory "$SESS"; then
			session_name=$(derive_session_name "$SESS")
			record_session_switch "$session_name"
			zoxide add "$(printf %q "$SESS")"
			zellij_switch -- "--session $(printf %q "$session_name") --cwd $(printf %q "$SESS") --layout $LAYOUT"
		else
			record_session_switch "$SESS"
			zellij_switch -- "--session $(printf %q "$SESS") --layout $LAYOUT"
		fi
	else
		if is_directory "$SESS"; then
			session_name=$(derive_session_name "$SESS")
			record_session_switch "$session_name"
			zoxide add "$(printf %q "$SESS")"
			cd "$SESS" && zellij attach --create "$session_name" --layout "$LAYOUT"
		else
			record_session_switch "$SESS"
			zellij attach --create "$SESS" --layout "$LAYOUT"
		fi
	fi
fi
