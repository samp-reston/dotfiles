{
  description = "Personal environment with Niri";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-config = {
      url = "github:samp-reston/kickstart.nvim";
      flake = false;
  };
  };
  outputs = { self, nixpkgs, home-manager, neovim-config }:
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
                zellij
                fish
                just
              ];
            };
	    programs.neovim = {
              enable = true;
              defaultEditor = true;
            };

            xdg.configFile."nvim".source = neovim-config;

            programs.alacritty = {
              enable = true;
              settings = builtins.fromTOML (builtins.readFile ./dotfiles/alacritty/alacritty.toml);
            };

            programs.waybar = {
              enable = true;
              settings = builtins.fromJSON (builtins.readFile ./dotfiles/waybar/config);
              style = builtins.readFile ./dotfiles/waybar/style.css;
            };

            programs.fish = {
              enable = true;
              interactiveShellInit = builtins.readFile ./dotfiles/fish/config.fish;
            };

            services.mako = {
              enable = true;
            };

            xdg.configFile."zellij/config.kdl".source = ./dotfiles/zellij/config.kdl;
            xdg.configFile."niri/config.kdl".source = ./dotfiles/niri/config.kdl;
          }
        ];
      };
    };
}

