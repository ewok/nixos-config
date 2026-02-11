if command -vq -- starship
  function starship_transient_prompt_func
    starship module character
  end
  starship init fish | source
end

function update --on-event fish_prompt
  if test (tput cols) -gt 80; and test (tput lines) -gt 20
    set -gx STARSHIP_CONFIG "$HOME/.config/starship.toml"
  else
    set -gx STARSHIP_CONFIG "$HOME/.config/starship_short.toml"
  end
end
