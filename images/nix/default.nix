{ dockerTools
, bashInteractive
, cacert
, coreutils
, curl
, gitReallyMinimal
, gnugrep
, gnutar
, gzip
, iana-etc
, nix
, openssh
, xz
, extraContents ? [ ]
, extraCommands ? ""
, uid ? 0
, user ? "root"
}:
let
  image = dockerTools.buildImageWithNixDb {
    inherit (nix) name;
    inherit uid;

    contents = [
      ./root
      coreutils
      # add /bin/sh
      bashInteractive
      nix

      # runtime dependencies of nix
      cacert
      gitReallyMinimal
      gnugrep
      gnutar
      gzip
      openssh
      xz

      # for haskell binaries
      iana-etc
    ] ++ extraContents;

    extraCommands = ''
      # for /usr/bin/env
      mkdir usr
      ln -s ../bin usr/bin

      # make sure /tmp exists
      mkdir -m 1777 tmp

      # need a HOME
      mkdir -vp root
    '' + extraCommands;

    config = {
      Cmd = [ "/bin/bash" ];
      Env = [
        "ENV=/etc/profile.d/nix.sh"
        "BASH_ENV=/etc/profile.d/nix.sh"
        "NIX_BUILD_SHELL=/bin/bash"
        "PAGER=cat"
        "PATH=/usr/bin:/bin"
        "SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
        "USER=${user}"
      ];
    };
  };
in
image // { meta = nix.meta // image.meta; }
