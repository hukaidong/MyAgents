{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    cursor-agent.url = "github:hukaidong/cursor-agent-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      cursor-agent,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      packages.x86_64-linux.my-agents = pkgs.stdenv.mkDerivation rec {
        name = "my-agents";
        src = builtins.path { path = ./.; name = "MyAgents"; };

        buildInputs = with pkgs; [
          git
          claude-code
          cursor-agent.packages.x86_64-linux.default
        ];

        installPhase = ''
          mkdir -p $out
          cp -r bin lib $out
        '';
      };

      packages.x86_64-linux.default = self.packages.x86_64-linux.my-agents;
    };
}
