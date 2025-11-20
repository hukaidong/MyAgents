{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nix-ai-tools.url = "github:numtide/nix-ai-tools";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-ai-tools,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      aitools = nix-ai-tools.packages.x86_64-linux;
    in
    {
      packages.x86_64-linux.my-agents = pkgs.stdenv.mkDerivation rec {
        name = "my-agents";
        src = builtins.path {
          path = ./.;
          name = "MyAgents";
        };

        buildInputs = [
          pkgs.git
          aitools.claude-code
          aitools.cursor-agent
        ];

        installPhase = ''
          mkdir -p $out
          cp -r bin lib $out
        '';
      };

      packages.x86_64-linux.default = self.packages.x86_64-linux.my-agents;
    };
}
