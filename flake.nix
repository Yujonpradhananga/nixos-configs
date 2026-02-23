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
        android-nixpkgs = {
          url = "github:tadfisher/android-nixpkgs";
        };
    };
    outputs = { self, nixpkgs, home-manager, mango, ...}@inputs:
    let
myOverlay = final: prev: {
  pdf-cli = prev.callPackage ./pdf-cli.nix { };
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
