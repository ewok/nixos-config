# H

$env._git_log_medium_format = '%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
$env._git_log_oneline_format = '%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n'
$env._git_log_brief_format = '%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'
$env._git_log_some = '%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'

# GIT
  alias ga    = git add
  alias gA    = git cherry-pick --no-commit
  alias gAF   = git cherry-pick --ff
  alias gb    = git branch
  alias gba   = git branch --all --verbose
  alias gbc   = git switch -c
  alias gbD   = git branch --delete
  alias gbs   = git switch
  alias gbX   = git branch --delete --force
  alias gc    = git commit --verbose
  alias gcam  = git commit --verbose --amend
  alias gcm   = git commit --message
  alias gco   = git checkout
  alias gdc   = git diff --no-ext-diff --cached
  alias gd    = git diff --no-ext-diff
  alias gfa   = git fetch --all
  alias gf    = git fetch
  alias g     = git
  alias glb   = do { ^git log --topo-order $"--pretty=format:($env._git_log_brief_format)" }
  alias gldiff = do { ^git log --topo-order --stat --patch --full-diff $"--pretty=format:($env._git_log_medium_format)" }
  alias glga  = do { ^git log --topo-order --graph $"--pretty=format:($env._git_log_oneline_format)" --all }
  alias glgas = do { ^git log --topo-order --graph $"--pretty=format:($env._git_log_oneline_format)" --all --stat }
  alias glg   = do { ^git log --topo-order --graph $"--pretty=format:($env._git_log_oneline_format)" }
  alias gl    = do { ^git log --topo-order $"--pretty=format:($env._git_log_medium_format)" }
  alias glgsa = do { ^git log --topo-order --graph $"--pretty=format:($env._git_log_oneline_format)" --stat --all }
  alias glgs  = do { ^git log --topo-order --graph $"--pretty=format:($env._git_log_oneline_format)" --stat }
  alias gloga = do { ^git log --date=short --graph $"--pretty=($env._git_log_some)" --all }
  alias glogat = do { ^git log --graph $"--pretty=($env._git_log_some)" --all }
  alias glog  = do { ^git log --date=short --graph $"--pretty=($env._git_log_some)" }
  alias glo   = do { ^git log --topo-order $"--pretty=format:($env._git_log_oneline_format)" }
  alias glogta = do { ^git log --graph $"--pretty=($env._git_log_some)" --all }
  alias glogt = do { ^git log --graph $"--pretty=($env._git_log_some)" }
  alias gls   = do { ^git log --topo-order --stat $"--pretty=format:($env._git_log_medium_format)" }
  alias glC   = git shortlog --summary --numbered
  alias glS   = git log --show-signature
  alias gma   = git merge --abort
  alias gmC   = git merge --no-commit
  alias gmf   = git merge --ff-only
  alias gmF   = git merge --no-ff
  alias gm    = git merge
  alias gmSf  = git merge -S --ff-only
  alias gmS   = git merge -S
  alias gms   = git merge --squash
  alias gmSs  = git merge -S --squash
  alias gPa   = git push --all
  alias gPF   = git push --force
  alias gPf   = git push --force-with-lease
  alias gP    = git push
  alias gpra  = git pull --rebase --autostash
  alias gpr   = git pull --rebase
  alias gPt   = git push --tags
  alias gp    = git pull
  alias gra   = git rebase --abort
  alias grc   = git rebase --continue
  alias gRf   = git restore --source=
  alias gr    = git rebase
  alias gR    = git restore
  alias gri   = git rebase --interactive
  alias gRp   = git restore --patch
  alias grs   = git rebase --skip
  alias gRs   = git restore --staged
  alias gs    = git status
  alias gt    = git tag
  alias gtl   = git tag -l
  alias gts   = git tag -s
  alias gwa   = git worktree add
  alias gwl   = git worktree list
  alias gwm   = git worktree move
  alias gwp   = git worktree prune
  alias gwx   = git worktree remove
  alias gXC   = git clean -e shell.nix -e .envrc -dxf
  alias gXc   = git clean -e shell.nix -e .envrc -dxn
  alias gX    = git reset
  alias gXh   = git reset --hard
  alias gXH   = git reset "HEAD^"
  alias gXs   = git reset --soft
  alias gXX   = git rm -r --cached
  alias gZa   = git stash apply
  alias gZd   = git stash drop
  alias gZ    = git stash
  alias gZl   = git stash list
  alias gZp   = git stash pop
  alias gZs   = git stash save --include-untracked
  alias gZS   = git stash save --patch --no-keep-index
