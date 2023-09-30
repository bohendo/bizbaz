{
  description = "Random phonetic phrase generator";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/4ecab3273592f27479a583fb6d975d4aba3486fe"; # v23.05
    utils.url = "github:numtide/flake-utils/04c1b180862888302ddfb2e3ad9eaa63afc60cf8"; # v1.0.0
  };

  outputs = inputs: with inputs;
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      in
      rec {

        packages = rec {

          default = packages.rphon;

          vscodium = pkgs.vscode-with-extensions.override {
            vscode = pkgs.vscodium;
            vscodeExtensions = with pkgs.vscode-extensions; [
              mads-hartmann.bash-ide-vscode
              naumovs.color-highlight
              mikestead.dotenv
              oderwat.indent-rainbow
              yzhang.markdown-all-in-one
              vscodevim.vim
            ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "hoon-highlighter";
                publisher = "urbit-pilled";
                version = "0.1.3";
                sha256 = "sha256-vMuTbFhAmjyv4KkaIBTHoaQVdqV2K2SJF2VmTzRFfDY=";
              }
            ];
          };
        };

        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              bashInteractive
              just
              packages.vscodium
            ];
          };
        };

      }
    );
}
