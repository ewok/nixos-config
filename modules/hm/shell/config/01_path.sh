for dir in ~/.local/bin ~/bin ~/.bin; do
  case ":$PATH:" in
    *":$dir:"*) :;; # already in PATH
    *) PATH="$dir:$PATH";;
  esac
done
export PATH

export XDG_CONFIG_HOME="{{ homeDirectory }}/.config"
