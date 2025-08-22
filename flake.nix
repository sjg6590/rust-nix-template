{
  description = "Rust with rust-overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }: let
    forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
  in {
    devShells = forAllSystems (system: let
      overlays = [ rust-overlay.overlays.default ];
      pkgs = import nixpkgs { inherit overlays system; };
    in {
      default = pkgs.mkShell {
        buildInputs = [
          (pkgs.rust-bin.stable.latest.default) # or nightly, or specific version
          pkgs.rust-analyzer
        ];
        shellHook = ''
          echo "🚀 Rust Development Environment"
          echo "=============================="
          echo "Rust version: $(rustc --version)"
          echo "Cargo version: $(cargo --version)"
          echo ""
          echo "✅ You are now in the Nix development environment!"
          echo ""
          
          # Set a custom prompt to show you're in the Nix environment
          # Use different formats for different shells
          if [ -n "$ZSH_VERSION" ]; then
            # Zsh format
            export PS1="%F{cyan}[NIX-DEV]%f %F{green}%~%f %F{yellow}$%f "
          elif [ -n "$BASH_VERSION" ]; then
            # Bash format
            export PS1="\[\033[1;36m\][NIX-DEV]\[\033[0m\] \[\033[1;32m\]\W\[\033[0m\] \[\033[1;33m\]\$\[\033[0m\] "
          elif [ -n "$POWERSHELL_VERSION" ] || [ -n "$PSVersionTable" ]; then
            # PowerShell format (if running in PowerShell)
            export PS1="[NIX-DEV] \W \$ "
          else
            # Fallback for other shells
            export PS1="[NIX-DEV] \W \$ "
          fi
          
          # Set environment variable to indicate Nix environment
          export NIX_DEV_ENV="true"
        '';
      };
    });
  };
}