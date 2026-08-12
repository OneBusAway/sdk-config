{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      forEachSystem = f: nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ] (system: f (import nixpkgs {
        inherit system;
      }));
    in
    {
      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Cross-cutting build deps
            stdenv.cc
            gnumake
            pkg-config

            # TypeScript (node)
            nodejs_24
            (pnpm.override { nodejs = nodejs_24; })
            yarn

            # Python
            python313
            uv
            rye

            # Go
            go
            golangci-lint

            # Ruby
            ruby
            rubocop
            rubyPackages.yard

            # Java / Kotlin
            jdk21
          ];
        };
      });
    };
}
