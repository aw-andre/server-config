{ pkgs, ... }: {
  home.packages = with pkgs; [
    (writeShellScriptBin "rebuild" (builtins.readFile ./rebuild.bash))
    (writeShellScriptBin "run" (builtins.readFile ./run.bash))
    (writeShellScriptBin "vimp" (builtins.readFile ./vimp.bash))
    (writeShellScriptBin "vimt" (builtins.readFile ./vimt.bash))
  ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    sessionVariables = {
      PAGER = "vimp";
      MANPAGER = "nvim -c 'Man!'";
    };
    shellAliases = { cdf = "cd ~/files/"; };
    initExtra = builtins.readFile ./zshrc.zsh;
    plugins = [
      {
        name = "nix-shell";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
      {
        name = "you-should-use";
        src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
      }
      {
        name = "zsh-vi-mode";
        src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
      }
      {
        name = "powerlevel10k-config";
        src = ./.;
        file = "p10k.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
    ];
  };
}
