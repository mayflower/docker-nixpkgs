let
  nixpkgs = builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-22.11.tar.gz";
  pkgs = import nixpkgs { config = { }; overlays = [ ]; };
in
with pkgs;
mkShell {
  buildInputs = [
    dive
    jq
    skopeo
  ] ++ lib.optional (pkgs ? mdsh) pkgs.mdsh;

  shellHook = ''
    # try to work aroud build issues
    unset TMPDIR

    export NIX_PATH=nixpkgs=${toString nixpkgs}
  '';
}
