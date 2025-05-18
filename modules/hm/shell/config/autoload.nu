# env
# AWS
{{#linux}}
$env.GPG_TTY = (tty)
{{/linux}}

mkdir ($nu.data-dir | path join "vendor/autoload")
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

$env.OPENAI_API_KEY = "{{ openAiToken }}"
alias ww = viddy
alias ll = eza -la --git
alias tree = eza --tree
alias cat = bat
