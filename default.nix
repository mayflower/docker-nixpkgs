let
  pkgs = import ./pkgs.nix;
in {
  inherit (pkgs.docker-nixpkgs) nix-flakes nix-user;
}
