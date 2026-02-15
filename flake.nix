{
	inputs = {
		nixpkgs.url="nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";			
		};
		mango = {
			url = "github:DreamMaoMao/mango";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};	
	outputs = { self, nixpkgs, home-manager, mango, ...}@inputs:
    let
      # Define your custom package as an overlay
      myOverlay = final: prev: {
        lnreader = prev.stdenv.mkDerivation {
          pname = "lnreader";
          version = "1.0";
          
          src = prev.fetchurl {
            url = "https://github.com/Yujonpradhananga/CLI-PDF-EPUB-reader/releases/download/version/lnreader";
            sha256 = "sha256-IPS1Lk0Tb7ehLXUspya+KbZPmkwZ3Spbl0OXc6VdCGw=";
          };
          
          dontUnpack = true;
          
          nativeBuildInputs = [ prev.patchelf ];
          
          installPhase = ''
            mkdir -p $out/bin
            cp $src $out/bin/lnreader
            chmod +x $out/bin/lnreader
          '';
          
          # Patch AFTER installing, when we have write permissions
          postFixup = ''
            patchelf --set-interpreter ${prev.stdenv.cc.bintools.dynamicLinker} $out/bin/lnreader
          '';
        };
      };
    in
  {
		nixosConfigurations.yujon = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			specialArgs = { inherit inputs; };
			modules = [
				({ config, pkgs, ... }: {
					nixpkgs.overlays = [ myOverlay ];
				})
				./configuration.nix
				./hardware-configuration.nix
				home-manager.nixosModules.home-manager{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.yujon = import ./home.nix;
						extraSpecialArgs = { inherit inputs; };
						backupFileExtension = "backup";
					};
				}
			];
		};
	};
}
