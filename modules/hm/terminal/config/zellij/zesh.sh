#!/usr/bin/env bash_pass_keys

LAYOUT=default
HISTORY_DIR="$HOME/.local/state/zellij"
HISTORY_FILE="$HISTORY_DIR/session-history"
LAYOUT_PREFS_FILE="$HISTORY_DIR/layout-prefs"

zellij_switch() {
	zellij pipe --plugin "file:{{ conf.homeDir }}/.config/zellij/plugins/zellij-switch.wasm" "$@"
}

format_session_with_layout() {
	local session="$1"
	local layout_map="$2"
	# Extract layout from the map string (format: "session1=layout1 session2=layout2 ...")
	local layout=$(echo "$layout_map" | grep -oE -- "(^|[[:space:]])${session}=([^ ]*)" | cut -d= -f2)
	if [[ -n "$layout" ]]; then
		echo "$session (layout: $layout)"
	else
		echo "$session"
	fi
}

list_zellij_sessions() {
	local sessions=$(zellij list-sessions --short --no-formatting 2>/dev/null)
	[[ -z "$sessions" ]] && return

	local current="$ZELLIJ_SESSION_NAME"
	local result=""

	# Build layout lookup map from preferences file
	local layout_map=""
	if [[ -f "$LAYOUT_PREFS_FILE" ]]; then
		layout_map=$(cat "$LAYOUT_PREFS_FILE")
	fi

	# Output current session first if we're in one
	if [[ -n "$current" ]] && echo "$sessions" | grep -qFx -- "$current"; then
		result="$(format_session_with_layout "$current" "$layout_map")"
	fi

	# If history file exists, sort remaining sessions by MRU
	if [[ -f "$HISTORY_FILE" ]]; then
		while IFS= read -r hist_session; do
			# Skip current session (already added) and non-existent sessions
			[[ "$hist_session" == "$current" ]] && continue
			echo "$sessions" | grep -qFx -- "$hist_session" || continue

			if [[ -n "$result" ]]; then
				result="$result"$'\n'"$(format_session_with_layout "$hist_session" "$layout_map")"
			else
				result="$(format_session_with_layout "$hist_session" "$layout_map")"
			fi
		done <"$HISTORY_FILE"
	fi

	# Add any sessions not in history (new sessions)
	while IFS= read -r session; do
		[[ "$session" == "$current" ]] && continue
		if [[ -n "$result" ]]; then
			# Check if session already in result (may have layout suffix, so extract session name)
			echo "$result" | grep -qE -- "^${session}( \(layout:.*\))?$" && continue
		fi
		if [[ -n "$result" ]]; then
			result="$result"$'\n'"$(format_session_with_layout "$session" "$layout_map")"
		else
			result="$(format_session_with_layout "$session" "$layout_map")"
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

list_available_layouts() {
	local layouts_dir="$HOME/.config/zellij/layouts"
	if [[ -d "$layouts_dir" ]]; then
		find "$layouts_dir" -maxdepth 1 -name "*.kdl" -exec basename {} .kdl \;
	fi
}

get_layout_preference() {
	local session_name="$1"
	[[ -f "$LAYOUT_PREFS_FILE" ]] && grep -- "^${session_name}=" "$LAYOUT_PREFS_FILE" | cut -d= -f2
}

record_layout_preference() {
	local session_name="$1"
	local layout_name="$2"
	[[ -z "$session_name" || -z "$layout_name" ]] && return

	mkdir -p "$HISTORY_DIR"

	if [[ -f "$LAYOUT_PREFS_FILE" ]]; then
		# Remove existing entry and append new one (escape session name for grep)
		local tmp=$(grep -vF -- "${session_name}=" "$LAYOUT_PREFS_FILE")
		echo "${session_name}=${layout_name}" >"$LAYOUT_PREFS_FILE"
		[[ -n "$tmp" ]] && echo "$tmp" >>"$LAYOUT_PREFS_FILE"
	else
		echo "${session_name}=${layout_name}" >"$LAYOUT_PREFS_FILE"
	fi
}

delete_layout_preference() {
	local session_name="$1"
	[[ -z "$session_name" ]] && return

	[[ -f "$LAYOUT_PREFS_FILE" ]] || return

	# Remove the layout preference entry for this session (use -F for literal matching)
	local tmp=$(grep -vF -- "${session_name}=" "$LAYOUT_PREFS_FILE")

	if [[ -n "$tmp" ]]; then
		echo "$tmp" >"$LAYOUT_PREFS_FILE"
	else
		# If no other entries remain, delete the file
		rm -f "$LAYOUT_PREFS_FILE"
	fi
}

delete_layout_preference_from_formatted() {
	local formatted
	if [[ -n "$1" ]]; then
		formatted="$1"
	else
		read -r formatted
	fi
	# Strip layout suffix: "session_name (layout: xxx)" -> "session_name"
	local session_name="${formatted%% (layout:*}"
	delete_layout_preference "$session_name"
}

kill_session_from_formatted() {
	local formatted
	if [[ -n "$1" ]]; then
		formatted="$1"
	else
		read -r formatted
	fi
	# Strip layout suffix: "session_name (layout: xxx)" -> "session_name"
	local session_name="${formatted%% (layout:*}"
	zellij kill-session "$session_name"
}

select_layout_for_session() {
	local available_layouts=$(list_available_layouts)
	[[ -z "$available_layouts" ]] && echo "$LAYOUT" && return

	echo "$available_layouts" | fzf \
		--border-label ' select layout ' --prompt '🎨  ' \
		--header 'Choose a layout for this session' \
		--bind 'tab:down,btab:up' || echo "$LAYOUT"
}

export HISTORY_DIR HISTORY_FILE LAYOUT_PREFS_FILE
export -f list_zellij_sessions
export -f list_zoxide_dirs
export -f list_combined
export -f list_available_layouts
export -f get_layout_preference
export -f record_layout_preference
export -f delete_layout_preference
export -f delete_layout_preference_from_formatted
export -f kill_session_from_formatted
export -f select_layout_for_session
export -f format_session_with_layout

is_existing_session() {
	local name="$1"
	zellij list-sessions --short --no-formatting 2>/dev/null | grep -qxF -- "$name"
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
		local tmp=$(grep -vFx -- "$session_name" "$HISTORY_FILE")
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
		--header '  ^a all ^t zellij ^x zoxide ^d delete session ^e zoxide erase ^r reset layout ^f find' \
		--bind 'tab:down,btab:up' \
		--bind 'ctrl-a:change-prompt(⚡  )+reload(list_combined)' \
		--bind "ctrl-t:change-prompt(🪟  )+reload(list_zellij_sessions)" \
		--bind "ctrl-x:change-prompt(📁  )+reload(list_zoxide_dirs)" \
		--bind 'ctrl-f:change-prompt(🔎  )+reload(fd -L -H -d 5 -t d -E .Trash -E .git -E .cache . ~)' \
		--bind 'ctrl-d:execute(echo {} | kill_session_from_formatted)+change-prompt(⚡  )+reload(list_zellij_sessions)' \
		--bind "ctrl-e:execute(zoxide remove '{}')+change-prompt(⚡  )+reload(list_zoxide_dirs)" \
		--bind 'ctrl-r:execute(echo {} | delete_layout_preference_from_formatted)+change-prompt(⚡  )+reload(list_zellij_sessions)')

	# Extract session name from formatted output (remove layout info if present)
	# Format was: "session_name (layout: xxx)" -> extract "session_name"
	SESS="${SESS%% (layout:*}"
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
			# Check for stored layout preference
			chosen_layout=$(get_layout_preference "$session_name")
			if [[ -z "$chosen_layout" ]]; then
				# No preference stored, prompt user for layout selection
				chosen_layout=$(select_layout_for_session)
				record_layout_preference "$session_name" "$chosen_layout"
			fi
			record_session_switch "$session_name"
			zoxide add "$(printf %q "$SESS")"
 			zellij_switch -- "--session $(printf %q "$session_name") --cwd $(printf %q "$SESS") --layout $(printf %q "$chosen_layout")"
		else
			record_session_switch "$SESS"
			zellij_switch -- "--session $(printf %q "$SESS") --layout $LAYOUT"
		fi
	else
		if is_directory "$SESS"; then
			session_name=$(derive_session_name "$SESS")
			# Check for stored layout preference
			chosen_layout=$(get_layout_preference "$session_name")
			if [[ -z "$chosen_layout" ]]; then
				# No preference stored, prompt user for layout selection
				chosen_layout=$(select_layout_for_session)
				record_layout_preference "$session_name" "$chosen_layout"
			fi
			record_session_switch "$session_name"
			zoxide add "$(printf %q "$SESS")"
			cd "$SESS" && zellij attach --create "$session_name" --layout "$chosen_layout"
		else
			record_session_switch "$SESS"
			zellij attach --create "$SESS" --layout "$LAYOUT"
		fi
	fi
fi
