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
   LD_LIBRARY_PATH = "$HOME/.config/quickshell/modules";
   QML2_IMPORT_PATH = "$HOME/.config/quickshell/modules";
   XDG_CURRENT_DESKTOP = "wlroots";
  };
 systemd.user.sessionVariables = {
   WAYLAND_DISPLAY = "wayland-0";
   XDG_CURRENT_DESKTOP = "wlroots";
 };
 programs.neovim = {
  enable = true;
  viAlias = true;
  vimAlias = true;
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

initExtra = ''
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
              exec hyprland
          fi
        '';
  };


  home.packages = with pkgs; [
    pdf-cli
    ];

}
