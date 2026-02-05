#!/usr/bin/env bash

################################################################################
# Git Sync Script - Git Repository Synchronization
#
# Syncs configured branches with git.vps.ewok.email host
# Features: current branch sync, conflict handling, logging, dry-run mode,
#           auto-commit uncommitted changes, branch validation
#
# Only syncs when current branch matches configured branch
################################################################################

set -e # Exit on error (will be handled by traps)
set -o pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/git-sync-config.conf"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/git-sync.log"
MAX_LOG_SIZE=$((10 * 1024 * 1024)) # 10MB

# Default options
DRY_RUN=false
QUIET=false
NO_PUSH=false
NO_PULL=false
SPECIFIC_REPO=""

# Counters for summary
TOTAL_REPOS=0
SUCCESS_REPOS=0
FAILED_REPOS=0
CONFLICT_REPOS=0

# Colors for output (disabled if not a terminal)
if [[ -t 1 ]]; then
	RED='\033[0;31m'
	GREEN='\033[0;32m'
	YELLOW='\033[1;33m'
	BLUE='\033[0;34m'
	NC='\033[0m' # No Color
else
	RED=''
	GREEN=''
	YELLOW=''
	BLUE=''
	NC=''
fi

################################################################################
# Helper Functions
################################################################################

log() {
	local level="$1"
	shift
	local message="$*"
	local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

	# Create log directory if it doesn't exist
	mkdir -p "$LOG_DIR"

	# Log to file
	echo "[$timestamp] [$level] $message" >>"$LOG_FILE"

	# Log to console based on verbosity
	if [[ "$QUIET" == "false" ]]; then
		case "$level" in
		ERROR)
			echo -e "${RED}[ERROR]${NC} $message" >&2
			;;
		WARNING)
			echo -e "${YELLOW}[WARNING]${NC} $message" >&2
			;;
		INFO)
			echo -e "${BLUE}[INFO]${NC} $message"
			;;
		SUCCESS)
			echo -e "${GREEN}[SUCCESS]${NC} $message"
			;;
		*)
			echo "$message"
			;;
		esac
	fi

	# Rotate log if too large
	if [[ -f "$LOG_FILE" ]] && [[ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null) -gt $MAX_LOG_SIZE ]]; then
		mv "$LOG_FILE" "${LOG_FILE}.old"
		log "INFO" "Log file rotated"
	fi
}

print_usage() {
	cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Syncs configured git branches to specified remotes on git.vps.ewok.email

IMPORTANT: This script only syncs when:
  1. Repository is on the configured branch (not detached HEAD)
  2. Current branch matches the branch specified in config

If current branch doesn't match config, a warning is shown and the repository is skipped.

OPTIONS:
    --dry-run           Preview changes without applying them
    --quiet             Minimal output (errors only)
    --repo <name>       Sync only specific repository (by directory name)
    --no-push           Only pull changes, don't push
    --no-pull           Only push changes, don't pull
    -h, --help          Show this help message

CONFIGURATION:
    Edit ${CONFIG_FILE} to configure repositories
    Format: LOCAL_PATH|BRANCH_NAME|REMOTE_NAME|REMOTE_URL

EXAMPLES:
    # Sync all configured repositories (if on correct branches)
    $(basename "$0")

    # Sync only 'learning' repository
    $(basename "$0") --repo learning

    # Workflow: checkout branch then sync
    cd ~/projects/myrepo
    git checkout main
    $(basename "$0")

NOTES:
    - Repository must be on configured branch (not detached HEAD)
    - If on different branch, warning shown and repository skipped
    - Uncommitted changes are auto-committed with timestamp
    - Uses pull with rebase strategy
    - Conflicts abort the sync for that repository
    - Log file: ${LOG_FILE}

EOF
}

parse_arguments() {
	while [[ $# -gt 0 ]]; do
		case "$1" in
		--dry-run)
			DRY_RUN=true
			log "INFO" "Dry-run mode enabled"
			shift
			;;
		--quiet)
			QUIET=true
			shift
			;;
		--no-push)
			NO_PUSH=true
			log "INFO" "Push disabled (pull only)"
			shift
			;;
		--no-pull)
			NO_PULL=true
			log "INFO" "Pull disabled (push only)"
			shift
			;;
		--repo)
			SPECIFIC_REPO="$2"
			log "INFO" "Syncing only repository: $SPECIFIC_REPO"
			shift 2
			;;
		-h | --help)
			print_usage
			exit 0
			;;
		*)
			echo "Unknown option: $1" >&2
			print_usage
			exit 1
			;;
		esac
	done

	# Validate conflicting options
	if [[ "$NO_PUSH" == "true" ]] && [[ "$NO_PULL" == "true" ]]; then
		log "ERROR" "Cannot use --no-push and --no-pull together"
		exit 1
	fi
}

check_dependencies() {
	local deps=("git")
	for dep in "${deps[@]}"; do
		if ! command -v "$dep" &>/dev/null; then
			log "ERROR" "Required dependency not found: $dep"
			exit 1
		fi
	done
}

check_config_file() {
	if [[ ! -f "$CONFIG_FILE" ]]; then
		log "ERROR" "Configuration file not found: $CONFIG_FILE"
		exit 1
	fi
}

validate_config() {
	log "INFO" "Validating configuration..."

	local validation_errors=0
	local repo_count=0

	while IFS='|' read -r repo_path branch_name remote_name remote_url; do
		# Skip comments and empty lines
		[[ "$repo_path" =~ ^#.*$ ]] && continue
		[[ -z "$repo_path" ]] && continue

		repo_count=$((repo_count + 1))

		# Trim whitespace
		repo_path=$(echo "$repo_path" | xargs)
		branch_name=$(echo "$branch_name" | xargs)
		remote_name=$(echo "$remote_name" | xargs)
		remote_url=$(echo "$remote_url" | xargs)

		# Validate required fields
		if [[ -z "$repo_path" ]] || [[ -z "$branch_name" ]] || [[ -z "$remote_name" ]] || [[ -z "$remote_url" ]]; then
			log "ERROR" "Invalid config format (missing required fields): $repo_path|$branch_name|$remote_name|$remote_url"
			validation_errors=$((validation_errors + 1))
			continue
		fi

		# Check if path exists
		if [[ ! -d "$repo_path" ]]; then
			log "ERROR" "Repository path does not exist: $repo_path"
			validation_errors=$((validation_errors + 1))
			continue
		fi

		# Check if it's a git repository
		if [[ ! -d "$repo_path/.git" ]]; then
			log "ERROR" "Not a git repository: $repo_path"
			validation_errors=$((validation_errors + 1))
			continue
		fi

		# Validate branch name format (basic check)
		if [[ ! "$branch_name" =~ ^[a-zA-Z0-9/_-]+$ ]]; then
			log "ERROR" "Invalid branch name format '$branch_name' at $repo_path"
			validation_errors=$((validation_errors + 1))
			continue
		fi

		# Validate remote name format
		if [[ ! "$remote_name" =~ ^[a-zA-Z0-9_-]+$ ]]; then
			log "ERROR" "Invalid remote name format '$remote_name' at $repo_path"
			validation_errors=$((validation_errors + 1))
			continue
		fi

		log "INFO" "  ✓ $(basename "$repo_path"): branch='$branch_name', remote='$remote_name'"

	done <"$CONFIG_FILE"

	if [[ $repo_count -eq 0 ]]; then
		log "ERROR" "No repositories configured in $CONFIG_FILE"
		return 1
	fi

	log "INFO" "Configuration validation complete: $repo_count repositories, $validation_errors errors"

	if [[ $validation_errors -gt 0 ]]; then
		log "ERROR" "Configuration has errors. Please fix them before running sync."
		return 1
	fi

	return 0
}

auto_commit_changes() {
	local repo_path="$1"

	cd "$repo_path"

	# Check if there are uncommitted changes
	if ! git diff-index --quiet HEAD -- 2>/dev/null; then
		local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
		local commit_msg="Auto-commit: $timestamp"

		if [[ "$DRY_RUN" == "true" ]]; then
			log "INFO" "  [DRY-RUN] Would auto-commit uncommitted changes"
			git status --short
		else
			log "INFO" "  Auto-committing uncommitted changes"
			git add -A
			git commit -m "$commit_msg"
			log "SUCCESS" "  Created auto-commit: $commit_msg"
		fi
		return 0
	fi

	return 1
}

sync_repository() {
	local repo_path="$1"
	local branch_name="$2"
	local remote_name="$3"
	local remote_url="$4"
	local repo_name=$(basename "$repo_path")

	log "INFO" "=========================================="
	log "INFO" "Syncing repository: ${RED}$repo_name${NC}"
	log "INFO" "Path: ${GREEN}$repo_path${NC}"
	log "INFO" "Configured branch: ${YELLOW}$branch_name${NC}"
	log "INFO" "Remote: $remote_name (${BLUE}$remote_url${NC})"

	# Validate path exists
	if [[ ! -d "$repo_path" ]]; then
		log "ERROR" "Repository path does not exist: $repo_path"
		return 1
	fi

	# Validate it's a git repository
	if [[ ! -d "$repo_path/.git" ]]; then
		log "ERROR" "Not a git repository: $repo_path"
		return 1
	fi

	cd "$repo_path"

	# Detect current branch - must be on a branch, not detached HEAD
	local current_branch=""
	if git symbolic-ref -q HEAD >/dev/null 2>&1; then
		current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")
		# Strip any ambiguous prefixes
		current_branch=${current_branch#heads/}
		current_branch=${current_branch#refs/heads/}
	else
		log "WARNING" "Repository is in detached HEAD state, skipping sync"
		log "INFO" "  Checkout branch '$branch_name' first, then run sync again"
		return 1
	fi

	log "INFO" "Current branch: $current_branch"

	# Compare current branch with configured branch
	if [[ "$current_branch" != "$branch_name" ]]; then
		log "WARNING" "Current branch '$current_branch' doesn't match configured branch '$branch_name', skipping sync"
		log "INFO" "  To sync this repository, checkout branch '$branch_name' first"
		return 1
	fi

	log "SUCCESS" "Branch matches configuration, proceeding with sync"

	# Verify remote exists
	if ! git remote | grep -q "^${remote_name}$"; then
		log "WARNING" "Remote '$remote_name' does not exist, creating it..."
		if [[ "$DRY_RUN" == "true" ]]; then
			log "INFO" "  [DRY-RUN] Would add remote: $remote_name -> $remote_url"
		else
			git remote add "$remote_name" "$remote_url"
			log "SUCCESS" "  Added remote: $remote_name"
		fi
	else
		# Verify URL matches
		local current_url=$(git remote get-url "$remote_name" 2>/dev/null || echo "")
		if [[ "$current_url" != "$remote_url" ]]; then
			log "WARNING" "Remote URL mismatch. Expected: $remote_url, Got: $current_url"
			return 1
		fi
	fi

	# Auto-commit uncommitted changes
	auto_commit_changes "$repo_path" || true

	# Fetch from remote
	if [[ "$NO_PULL" == "false" ]]; then
		log "INFO" "  Fetching from remote..."
		if [[ "$DRY_RUN" == "true" ]]; then
			log "INFO" "  [DRY-RUN] Would fetch from $remote_name"
		else
			if ! git fetch "$remote_name"; then
				log "ERROR" "Failed to fetch from remote"
				return 1
			fi
		fi
	fi

	# Check if remote branch exists
	local remote_branch_exists=false
	if git rev-parse --verify "${remote_name}/${branch_name}" &>/dev/null; then
		remote_branch_exists=true
	fi

	# Pull changes (rebase) if remote branch exists
	if [[ "$NO_PULL" == "false" ]] && [[ "$remote_branch_exists" == "true" ]]; then
		log "INFO" "  Pulling changes with rebase..."

		if [[ "$DRY_RUN" == "true" ]]; then
			log "INFO" "  [DRY-RUN] Would pull changes from ${remote_name}/${branch_name}"
			local ahead_behind=$(git rev-list --left-right --count "${branch_name}...${remote_name}/${branch_name}" 2>/dev/null || echo "0 0")
			local ahead=$(echo "$ahead_behind" | awk '{print $1}')
			local behind=$(echo "$ahead_behind" | awk '{print $2}')
			log "INFO" "  [DRY-RUN] Local commits ahead: $ahead, Remote commits behind: $behind"
		else
			if ! git pull --rebase "$remote_name" "$branch_name" 2>/dev/null; then
				log "ERROR" "Merge conflict detected during pull"
				log "ERROR" "Aborting rebase..."
				git rebase --abort 2>/dev/null || true
				CONFLICT_REPOS=$((CONFLICT_REPOS + 1))
				return 1
			fi
			log "SUCCESS" "  Successfully pulled changes"
		fi
	elif [[ "$NO_PULL" == "false" ]]; then
		log "INFO" "  Remote branch does not exist yet (will be created on push)"
	fi

	# Push changes
	if [[ "$NO_PUSH" == "false" ]]; then
		local unpushed=0
		if [[ "$remote_branch_exists" == "true" ]]; then
			unpushed=$(git log "${remote_name}/${branch_name}".."$branch_name" --oneline 2>/dev/null | wc -l | xargs)
		else
			# New branch - count all commits
			unpushed=$(git log "$branch_name" --oneline 2>/dev/null | wc -l | xargs)
		fi

		if [[ "$unpushed" -gt 0 ]] || [[ "$DRY_RUN" == "true" ]]; then
			log "INFO" "  Pushing changes to remote..."

			if [[ "$DRY_RUN" == "true" ]]; then
				log "INFO" "  [DRY-RUN] Would push $unpushed commits to ${remote_name}/${branch_name}"
				if [[ "$unpushed" -gt 0 ]]; then
					if [[ "$remote_branch_exists" == "true" ]]; then
						git log "${remote_name}/${branch_name}".."$branch_name" --oneline 2>/dev/null | head -5
					else
						git log "$branch_name" --oneline 2>/dev/null | head -5
					fi
				fi
			else
				# Use -u flag for new branches or if upstream not set
				if [[ "$remote_branch_exists" == "false" ]]; then
					if ! git push -u "$remote_name" "$branch_name"; then
						log "ERROR" "Failed to push to remote"
						return 1
					fi
					log "SUCCESS" "  Successfully pushed $unpushed commits (new branch, upstream set)"
				else
					if ! git push "$remote_name" "$branch_name" 2>/dev/null; then
						log "ERROR" "Failed to push to remote"
						return 1
					fi
					log "SUCCESS" "  Successfully pushed $unpushed commits"
				fi
			fi
		else
			log "INFO" "  No commits to push"
		fi
	fi

	log "SUCCESS" "Repository synced successfully: $repo_name (branch: $branch_name)"
	return 0
}

process_repositories() {
	log "INFO" "Starting git sync process..."
	log "INFO" "Configuration file: $CONFIG_FILE"
	log "INFO" "Log file: $LOG_FILE"

	if [[ "$DRY_RUN" == "true" ]]; then
		echo ""
		echo -e "${YELLOW}========================================${NC}"
		echo -e "${YELLOW}DRY-RUN MODE - No changes will be made${NC}"
		echo -e "${YELLOW}========================================${NC}"
		echo ""
	fi

	# Read configuration file - new format: PATH|BRANCH|REMOTE|URL
	while IFS='|' read -r repo_path branch_name remote_name remote_url; do
		# Skip comments and empty lines
		[[ "$repo_path" =~ ^#.*$ ]] && continue
		[[ -z "$repo_path" ]] && continue

		# Trim whitespace
		repo_path=$(echo "$repo_path" | xargs)
		branch_name=$(echo "$branch_name" | xargs)
		remote_name=$(echo "$remote_name" | xargs)
		remote_url=$(echo "$remote_url" | xargs)

		# Validate required fields
		if [[ -z "$repo_path" ]] || [[ -z "$branch_name" ]] || [[ -z "$remote_name" ]] || [[ -z "$remote_url" ]]; then
			log "ERROR" "Invalid config line: missing required fields (need PATH|BRANCH|REMOTE|URL)"
			continue
		fi

		# Skip if specific repo requested and this doesn't match
		if [[ -n "$SPECIFIC_REPO" ]]; then
			local repo_name=$(basename "$repo_path")
			if [[ "$repo_name" != "$SPECIFIC_REPO" ]]; then
				continue
			fi
		fi

		TOTAL_REPOS=$((TOTAL_REPOS + 1))

		if sync_repository "$repo_path" "$branch_name" "$remote_name" "$remote_url"; then
			SUCCESS_REPOS=$((SUCCESS_REPOS + 1))
		else
			FAILED_REPOS=$((FAILED_REPOS + 1))
		fi

		echo ""
	done <"$CONFIG_FILE"
}

print_summary() {
	log "INFO" "=========================================="
	log "INFO" "Sync Summary"
	log "INFO" "=========================================="
	log "INFO" "Total repositories: $TOTAL_REPOS"
	log "SUCCESS" "Successful: $SUCCESS_REPOS"

	if [[ $FAILED_REPOS -gt 0 ]]; then
		log "ERROR" "Failed: $FAILED_REPOS"
	else
		log "INFO" "Failed: $FAILED_REPOS"
	fi

	if [[ $CONFLICT_REPOS -gt 0 ]]; then
		log "WARNING" "Conflicts: $CONFLICT_REPOS"
	fi

	log "INFO" "=========================================="

	if [[ $FAILED_REPOS -eq 0 ]] && [[ $CONFLICT_REPOS -eq 0 ]]; then
		log "SUCCESS" "All repositories synced successfully!"
		return 0
	else
		log "WARNING" "Some repositories had issues. Check log file: $LOG_FILE"
		return 1
	fi
}

################################################################################
# Main
################################################################################

main() {
	parse_arguments "$@"
	check_dependencies
	check_config_file

	# Validate configuration before processing
	if ! validate_config; then
		exit 1
	fi

	local start_time=$(date '+%Y-%m-%d %H:%M:%S')
	log "INFO" "=========================================="
	log "INFO" "Git Sync Started: $start_time"
	log "INFO" "=========================================="

	process_repositories

	local end_time=$(date '+%Y-%m-%d %H:%M:%S')
	log "INFO" "Git Sync Ended: $end_time"

	print_summary

	return $?
}

# Run main function
main "$@"
