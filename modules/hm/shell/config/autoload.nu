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
# alias ww = viddy --shell /home/ataranchiev/.nix-profile/bin/nu
alias ll = eza -la --git
alias tree = eza --tree
alias cat = bat

def ww [
    --times(-n): int = 2, # time between retries
    command: string, # command to run
] {
    viddy -n $times --shell /home/ataranchiev/.nix-profile/bin/nu $"($command)"
}
