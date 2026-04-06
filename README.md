# Archived
This flake is now archived in favor of [upstream](https://search.nixos.org/packages?type=packages&channel=unstable&query=fladder)

# Fladder
This flake packages [Fladder](https://github.com/DonutWare/Fladder/) for NixOS.

Unfortunately, using `flutter.buildFlutterApplication` fails, because Fladder uses MediaKit, which doesn't build in the Nix build env (see `test` branch).
That's why the appimage was used.

# How to use

```nix
# flake.nix
inputs = {
  ...

  nixpkgs.url = "github:NixOS/nixpkgs/nixos-xxx";
  
  fladder-nix = {
    url = "github:DestinyofYeet/fladder.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

}

outputs = {nixpkgs, fladder-nix, ...}:{
  nixosConfigurations = {
    nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ({pkgs, ...}:{
          environment.systemPackages = [
            fladder-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
          ]
        })
      ];
    }
  };
}
```
