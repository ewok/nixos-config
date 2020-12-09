build:
	nixos-rebuild build --flake ".$(m)"

switch:
	sudo nixos-rebuild switch --flake ".$(m)"
