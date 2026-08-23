{ config, pkgs, lib, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = ["nodev"];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.blacklistedKernelModules = ["ideapad_laptop"];
  hardware.enableRedistributableFirmware = true;
  #enable openGL
  hardware.graphics.enable = true;

  #NVIDIA drivers
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
	modesetting.enable = true;
	powerManagement.enable = false;
	open = false;
	nvidiaSettings = true;
	package = config.boot.kernelPackages.nvidiaPackages.stable;
}; 


security.rtkit.enable = true;

# XDG Portal configuration
xdg.portal = {
  enable = true;
  wlr.enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  config.common.default = "*";
};


# Add the Kanata service user to necessary groups
# systemd.services.kanata-internalKeyboard.serviceConfig = {
#   SupplementaryGroups = [
#     "input"
#     "uinput"
#   ];
# };
# services.kanata = {
#   enable = true;
#   keyboards = {
#     myKeyboard = {
#       configFile = ./kanata/config.kbd;
#     };
#   };
# };

services.upower.enable = true;

environment.sessionVariables = {
LIBGL_ALWAYS_SOFTWARE = "0";
__GLX_VENDOR_LIBRARY_NAME = "nvidia";
YAZI_CONFIG_HOME = "/home/yujon/.config/yazi";
  };

  networking.hostName = "nixos";
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

  # Firewall rule
  networking.firewall.allowedTCPPorts = [ 50051 ];

  # Set your time zone.
  time.timeZone = "Asia/Kathmandu";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };


# fonts 
fonts.packages = with pkgs; [
  material-symbols 
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-color-emoji
  font-awesome
  proggyfonts
  dina-font
  fira-code-symbols
  nerd-fonts.jetbrains-mono
];


environment.etc."udev/hwdb.d/70-custom-keyboard.hwdb".text = ''
evdev:input:b0003v1A2Cp9605*
#capslock -> left control
 KEYBOARD_KEY_70039=leftctrl
#left alt -> backspace
 KEYBOARD_KEY_700e2=backspace
#semicolon -> alt
 KEYBOARD_KEY_70033=leftalt
#apostrophe -> esc
 KEYBOARD_KEY_70034=esc
#right alt -> semicolon
 KEYBOARD_KEY_700e6=semicolon
#left ctrl -> apostrophe
 KEYBOARD_KEY_700e0=apostrophe
'';

  services.getty.autologinUser = "yujon";
  programs.hyprland={
	enable=true;
	xwayland.enable=true;
  };
  programs.zsh={
	enable=true;
  };
programs.nix-ld.enable = true;

  programs.yazi = {
    enable = true;
  };


# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yujon = {
    isNormalUser = true;
    description = "yujon";
    home="/home/yujon";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
    evtest
    btop
    wget
    zsh
    foot
    kanata
    kitty
    git
    awww
    (pkgs.callPackage ./quickshell.nix {
            inherit pkgs;
            quickshell = inputs.quickshell;
        })
    waybar
    qutebrowser
    fastfetch
    wl-clipboard
    steam-run
    grim
    slurp
    cmake
    ninja
    brightnessctl
    antigravity
    curl
    gcc
    tree-sitter
    ripgrep
    go
    cargo
    cava
    rustc
    rustfmt
    rust-analyzer
    clippy
    pdf-cli
    mpv
    python3
    meson
    unzip
    qt6.qtshadertools
    qt6.qtdeclarative
    vimPlugins.LazyVim
    (pywal16.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [
          python3Packages.haishoku
          python3Packages.colorthief
        ];
      }))
    obs-studio
  ];

nix.settings.experimental-features = ["nix-command" "flakes" "ca-derivations"];

  system.stateVersion = "25.11";

}
