{config, pkgs, inputs, ...}:
{
  imports = [
   ./mango
  ];
  home.username = "yujon";
  home.homeDirectory = "/home/yujon";
  home.stateVersion = "25.11";
  home.sessionVariables = {
    EDITOR = "nvim"; 
    QML2_IMPORT_PATH="$HOME/.local/lib/qt6/qml";
    XDG_CURRENT_DESKTOP = "wlroots";
    XCURSOR_THEME = "Bocchi-The-Cursor";
    XCURSOR_SIZE = "24";
  };
home.file.".local/share/fonts/".source = ./Fonts;
 systemd.user.sessionVariables = {
   WAYLAND_DISPLAY = "wayland-0";
   XDG_CURRENT_DESKTOP = "wlroots";
 };
 fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font Mono" ];
      sansSerif = [ "JetBrainsMono Nerd Font" ];
    };
  };
  home.pointerCursor = {
    package = pkgs.callPackage ./pkgs/bocchiCursor.nix {};
    name = "Bocchi-The-Cursor";
    size = 24;
    gtk.enable = true;
  };
  programs.zsh = {
      enable = true;
      sessionVariables = {
      EDITOR = "nvim";
      };   
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "sudo" ];
      };
    
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
    ];

initContent = ''
  export EDITOR=nvim
  bindkey '^W' backward-kill-word
  function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "''$@" --cwd-file="''$tmp"
    IFS= read -r -d $'\0' cwd < "''$tmp"
    [ "''$cwd" != "''$PWD" ] && [ -d "''$cwd" ] && builtin cd -- "''$cwd"
    rm -f -- "''$tmp"
  }
'';
profileExtra = ''
          if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
              exec start-hyprland
          fi
        '';
  };
}
