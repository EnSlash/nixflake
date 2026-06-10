{
  description = "My NixOS configuration with flakes and home-manager";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = { nixpkgs-stable, nixpkgs-unstable, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs-stable.legacyPackages.${system};
  in
  {
    # Конфигурация всей системы NixOS
    nixosConfigurations.iershov-nix = nixpkgs-stable.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          # Настройки Home Manager как часть системы
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.iershov = import ./home.nix;
          
          # Опционально: автоматическое переключение home-manager при rebuild
          home-manager.extraSpecialArgs = { inherit pkgs; };
        }
      ];
    };
    
    # Простая программа для проверки (nix run)
    packages.${system}.default = pkgs.writeShellScriptBin "hello" ''
      echo "✅ NixOS configuration with flakes is ready!"
      echo "📦 Run: sudo nixos-rebuild switch --flake .#iershov-nix"
      echo "👤 Home-manager will be applied automatically"
    '';
  };
}
