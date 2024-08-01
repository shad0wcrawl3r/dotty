let
  nixpkgs = fetchTarball "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz";
  pkgs = import nixpkgs {
    config = {};
    overlays = [];
  };
in
  pkgs.mkShell {
    packages = with pkgs; [
      openssl
      pkg-config
      rustup
      cargo 
      udev
      hyperfine
    ];
    GIT_EDITOR = "${pkgs.neovim}/bin/nvim";
    SHELL = "${pkgs.zsh}/bin/zsh";
  }
