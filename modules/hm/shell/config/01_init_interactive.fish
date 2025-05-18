if status is-interactive

  bind \cw backward-kill-word
  bind \e\cB backward-bigword
  bind \e\cF forward-bigword
  bind \e\[109\;5u execute

  if command -vq -- viddy
    alias watch viddy
    alias ww viddy
  end

    if command -vq -- eza
      alias ll "eza -la --git"
      alias ls "eza -a --git"
      alias tree "eza --tree"
    end

  if command -vq -- bat
    alias cat "bat"
  end

  alias ...="cd ../../"
  alias ....="cd ../../../"
  alias .....="cd ../../../../"
  alias ......="cd ../../../../../"
  alias .......="cd ../../../../../../"

end
