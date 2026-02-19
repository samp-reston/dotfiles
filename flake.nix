{
  description = "Personal environment with Niri";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations.sam = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home = {
              username = "sam";
              homeDirectory = "/home/sam";
              stateVersion = "24.05";
              packages = with pkgs; [
                alacritty
                waybar
                mako
                fuzzel
                niri
                pipewire
              ];
            };

            programs.alacritty = {
              enable = true;
              settings = {
                window.opacity = 0.95;
              };
            };

            programs.waybar = {
              enable = true;
            };

            services.mako = {
              enable = true;
            };
          }
        ];
      };
    };
}

