{
  plugins.copilot-chat = {
    enable = true;
    settings.model = "claude-3.7-sonnet-thought";
  };
  keymaps = [{
    mode = "n";
    key = "<leader>c";
    action.__raw = "require('CopilotChat').toggle";
    options.desc = "Toggle Copilot [C]hat";
  }];
}
