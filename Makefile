build:
	nixos-rebuild build --flake ".$(host)"

switch:
	sudo nixos-rebuild switch --flake ".$(host)"
