# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:
let
  android-sdk = inputs.android-nixpkgs.sdk.x86_64-linux (sdkPkgs: with sdkPkgs; [
cmdline-tools-latest
    build-tools-35-0-0
    platform-tools
    platforms-android-36
    ndk-28-2-13676358
    cmake-3-22-1
  ]);
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = ["nodev"];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

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

# XDG Portal configuration
xdg.portal = {
  enable = true;
  wlr.enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  config.common.default = "*";
};
# Add the Kanata service user to necessary groups
systemd.services.kanata-internalKeyboard.serviceConfig = {
  SupplementaryGroups = [
    "input"
    "uinput"
  ];
};
services.kanata = {
  enable = true;
  keyboards = {
    myKeyboard = {
      configFile = ./kanata/config.kbd;
    };
  };
};

services.postgresql = {
  enable = true;
  ensureDatabases = [ "location_sharing" "khana_au"];
  enableTCPIP = true;  # Add this line
  authentication = pkgs.lib.mkOverride 10 ''
    #type database  DBuser  auth-method
    local all       all     trust
    host  all       all     127.0.0.1/32 trust
    host  all       all     ::1/128      trust
  '';
};
environment.sessionVariables = {
LIBGL_ALWAYS_SOFTWARE = "0";
__GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

environment.variables = {
  ANDROID_SDK_ROOT = "${android-sdk}/share/android-sdk";
  ANDROID_HOME = "${android-sdk}/share/android-sdk";
  JAVA_HOME = "${pkgs.jdk17}";
};
  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
  noto-fonts
  noto-fonts-cjk-sans
  noto-fonts-color-emoji
  font-awesome
  proggyfonts
  dina-font
  fira-code-symbols
  jetbrains-mono
  monaspace
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
    settings = {
      yazi = lib.importTOML ./yazi.toml;
    };
  };


# Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yujon = {
    isNormalUser = true;
    description = "yujon";
    home="/home/yujon";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "adbusers" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    evtest
    btop
    wget
    zsh
    foot
    kanata
    kitty
    git
    swww
    android-tools
    quickshell
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
    nodejs
    go
    cargo
    rustc
    rustfmt
    rustlings
    rust-analyzer
    clippy
    flutter
    python3
    meson
    android-sdk
    jdk17
    vimPlugins.LazyVim
    (pywal16.overridePythonAttrs (old: {
        propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [
          python313Packages.haishoku
          python313Packages.colorthief
        ];
      }))
    obs-studio
  ];

nix.settings.experimental-features = ["nix-command" "flakes" "ca-derivations"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
