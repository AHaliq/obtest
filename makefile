js:
	nix-build -o docs -A ghcjs.frontend

run:
	ob run