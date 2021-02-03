{
  description = "Home Manager for Nix";

  outputs = { self, nixpkgs }: rec {
    nixosModules.home-manager = import ./nixos;

    darwinModules.home-manager = import ./nix-darwin;

    lib = {
      hm = import ./modules/lib { lib = nixpkgs.lib; };
      homeManagerConfiguration = { configuration, system, homeDirectory
        , username, extraModules ? [ ], extraSpecialArgs ? { }
        , pkgs ? builtins.getAttr system nixpkgs.outputs.legacyPackages
        , check ? true }@args:
        import ./modules {
          inherit pkgs check extraSpecialArgs;

          configuration = { ... }: {
            imports = [ configuration ] ++ extraModules;
            home = {
              inherit homeDirectory username;
              stateVersion = "20.09";
            };
          };
        };
    };
  };
}
