#
#  Terminal Configuration
#

{ pkgs, vars, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      alacritty
    ];
  };

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  home-manager.users.${vars.user} = {
    home.file = {
      ".config/alacritty/alacritty.toml" = {
        text = ''
          [env]
          TERM = "xterm-256color"

          [window]
          padding.x = 10
          padding.y = 10

          decorations = "Buttonless"

          opacity = 0.85
          blur = true

          option_as_alt = "Both"

          [font]
          normal.family = "JetBrainsMono Nerd Font"

          size=13

          # Default colors
          [colors.primary]
          background = '#15191e'
          foreground = '#fffbf6'

          dim_foreground    = '#dbdbdb'
          bright_foreground = '#d9d9d9'

          # Cursor colors
          [colors.cursor]
          text   = '#2c2c2c'
          cursor = '#d9d9d9'

          # Normal colors
          [colors.normal]
          black   = '#2e2e2e'
          red     = '#eb4129'
          green   = '#abe047'
          yellow  = '#f6c744'
          blue    = '#47a0f3'
          magenta = '#7b5cb0'
          cyan    = '#64dbed'
          white   = '#e5e9f0'

          # Bright colors
          [colors.bright]
          black   = '#565656'
          red     = '#ec5357'
          green   = '#c0e17d'
          yellow  = '#f9da6a'
          blue    = '#49a4f8'
          magenta = '#a47de9'
          cyan    = '#99faf2'
          white   = '#ffffff'

          # Dim colors
          [colors.dim]
          black   = '#232323'
          red     = '#74423f'
          green   = '#5e6547'
          yellow  = '#8b7653'
          blue    = '#556b79'
          magenta = '#6e4962'
          cyan    = '#5c8482'
          white   = '#828282'
        '';
      };
    };
  };
}