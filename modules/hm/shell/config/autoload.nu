# env
# AWS
{{#linux}}
$env.GPG_TTY = (tty)
{{/linux}}

mkdir ($nu.data-dir | path join "vendor/autoload")
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")
sed -i 's/get -i/get -o/gi' ($nu.data-dir | path join "vendor/autoload/carapace.nu")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

$env.OPENAI_API_KEY = "{{ openAiToken }}"
# alias ww = viddy --shell /home/ataranchiev/.nix-profile/bin/nu
alias ll = eza -la --git
alias tree = eza --tree
alias cat = bat

def nix-flake-new [
    template?: string, # command to run
] {
    match $template {
        null =>  {
          print "Choose a template:"
          nix flake show templates
        }
        _ =>  {

      nix flake init --template $"templates#($template)"
        }
    }
}

def nix-flake-dev-new [
    template?: string, # command to run
] {
    match $template {
        null =>  {
          print "Choose a template:"
          nix flake show "https://flakehub.com/f/the-nix-way/dev-templates/*"
        }
        _ =>  {

      nix flake init --template $"https://flakehub.com/f/the-nix-way/dev-templates/*#($template)"
        }
    }
}

def ww [
    --times(-n): int = 2, # time between retries
    ...command: string, # command to run
] {
    ^viddy -n $times --shell ~/.nix-profile/bin/nu ...$command
}
