set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional

if status --is-login
    mkdir -p ~/.config/fish/completions
    carapace --list | awk '{print $1}' | xargs -I{} touch ~/.config/fish/completions/{}.fish # disable auto-loaded completions (#185)
end

if status is-interactive
    carapace _carapace | source
end
