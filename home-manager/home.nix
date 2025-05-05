{ config, inputs, pkgs, ... }: {
  imports = [ ./nixvim ./ripgrep.nix ./direnv.nix ./git.nix ./shell ./fzf.nix ];

  nixpkgs = {
    overlays = [ ];
    config = { allowUnfree = true; };
  };

  home = {
    username = "andreaw";
    homeDirectory = "/home/andreaw";
    stateVersion = "25.05";
    packages = with pkgs; [ ripgrep-all unzip ];
    file.".psqlrc".source = ./postgresrc.sql;
  };

  programs = {
    bat.enable = true;
    fd.enable = true;
    home-manager.enable = true;
  };
}
