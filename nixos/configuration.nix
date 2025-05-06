{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking = {
    hostName = "personal-instance";
    domain = "";
    firewall.allowedTCPPorts = [ 80 443 ];
  };
  services = {
    openssh.enable = true;
    nginx = {
      enable = true;
      virtualHosts."clausewitzmanifest.com" = {
        locations."/" = { proxyPass = "http://127.0.0.1:8000"; };
      };
    };
    postgresql = {
      enable = true;
      ensureUsers = [{
        name = "andreaw";
        ensureClauses = {
          superuser = true;
          createrole = true;
          createdb = true;
        };
      }];
      ensureDatabases = [ "andreaw" "clausewitzmanifest" ];
    };
  };
  programs.zsh.enable = true;
  environment.etc."inputrc".text = ''
    set editing-mode vi
    set keymap vi-command
  '';

  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      andreaw = {
        initialPassword = "setyourpassword";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEVhGkZNNklfz7zEZJmgbCtwhK4Pl1jL0+b3aeDa7e/n andreaw@nixos-mbp"
        ];
        extraGroups = [
          "wheel"
          "video"
          "audio"
          "networkmanager"
          "lp"
          "scanner"
          "dialout"
          "uucp"
        ];
      };
      root.openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC78cjsLL8hQ7Mhwdw79jLcv1MPIjlE2gtYElev+PpWbh06risKWhWAQNbkoopnaAR6u1vxx75bv0kYr34iwr3G+sOL5SnDBjumbp7PQLkIkD/P1YmCg7pF9Hk5gVCOdY4B3D0MuatVbtmOKSQC+xTN0U9NUgUoFTfC69FC5FxjYBQSa651PCAsqHtsZSdVypy6htFYZReBvgTri1I+8wYQ6n3fWjHoGGfmPNUojLINu2r0igVMkq/29JzeH1FZI+Tk4QHTvHeVLU7TxJUgjo1cMrKZK4q+20ViIxnqRLdb5cOszPq310Qy5aaa5sNRQvGaltjwCcsixa8VCRJ7MNk5 ssh-key-2025-05-04"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMeFQNMERqkSRsD7Dw7OPEt7m/L9I035J/v8yY9+/ZLD andreaw@nixos-mbp"
      ];
    };
  };

  system.stateVersion = "23.11";
}
