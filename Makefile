build:
	echo nixos-rebuild build --flake ".$(host)"

switch:
	echo sudo nixos-rebuild switch --flake ".$(host)"
