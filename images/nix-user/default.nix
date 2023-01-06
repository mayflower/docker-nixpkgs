{ docker-nixpkgs
, nixFlakes
, runCommand
, writeTextFile
, extraContents ? [ ]
}:
docker-nixpkgs.nix.override {
  nix = nixFlakes;
  extraContents = [
    (writeTextFile {
      name = "nix.conf";
      destination = "/etc/nix/nix.conf";
      text = ''
        accept-flake-config = true
        experimental-features = nix-command flakes
        sandbox = false
      '';
    })
    (runCommand "passwd" {} ''
      mkdir -p $out/etc
      cp ${../nix/root/etc/passwd} $out/etc/passwd
      chmod +w $out/etc/passwd
      echo alice:x:999:0:alice:/home/alice:/bin/bash >> $out/etc/passwd
    '')
  ];
  extraCommands = ''
    mkdir -vp home/alice
  '';

  uid = 999;
  user = "alice";
}
