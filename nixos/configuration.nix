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
    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority 0;

            # Accept loopback and established connections
            iif "lo" accept
            ct state established,related accept

            # Allow SSH
            tcp dport 22 accept

            # Allow Cloudflare IPv4 ranges
            ip saddr {
              103.21.244.0/22,
              103.22.200.0/22,
              103.31.4.0/22,
              104.16.0.0/13,
              104.24.0.0/14,
              108.162.192.0/18,
              131.0.72.0/22,
              141.101.64.0/18,
              162.158.0.0/15,
              172.64.0.0/13,
              173.245.48.0/20,
              188.114.96.0/20,
              190.93.240.0/20,
              197.234.240.0/22,
              198.41.128.0/17
            } tcp dport { 80, 443 } accept

            # Allow Cloudflare IPv6 ranges
            ip6 saddr {
              2400:cb00::/32,
              2606:4700::/32,
              2803:f800::/32,
              2405:b500::/32,
              2405:8100::/32,
              2a06:98c0::/29,
              2c0f:f248::/32
            } tcp dport { 80, 443 } accept

            # Drop everything else
            reject with icmp type port-unreachable
          }
        }
      '';
    };
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
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMKUBuOXx8Hua5NxcHmNWe3R4u26GWe5fkvFw65/79BE andreaw@nixos-mbp"
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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3vC8Vi0A0xPxXhffr21Fv8UVhdSSr3TS92tP9z4act andreaw@nixos-mbp"
      ];
    };
  };

  system.stateVersion = "23.11";
}
