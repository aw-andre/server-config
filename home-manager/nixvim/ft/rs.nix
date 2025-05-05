{ pkgs, ... }: {
  plugins = {
    rustaceanvim.enable = true;
    neotest.adapters.rust.enable = true;
  };
  extraPackages = with pkgs; [ rustfmt ];
}
