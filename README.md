# Rust Nix Development Environment

A cross-platform Rust development environment using Nix flakes for reproducible builds and consistent tooling across different systems.

## 🚀 Quick Start

### Prerequisites
- [Nix Package Manager](https://nixos.org/download.html) installed
- Git (for version control)

### Setup (Automatic)
```bash
# Clone this repository
git clone <your-repo-url>
cd rust-nix

# Run the setup script to configure Nix
./setup-nix.sh

# Enter the development environment
nix develop --command bash
```

### Setup (Manual)
If you prefer to set up manually:

1. **Install Nix** (if not already installed):
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --no-daemon
   ```

2. **Enable experimental features** in `~/.config/nix/nix.conf`:
   ```nix
   experimental-features = nix-command flakes
   ```

3. **Enter the development environment**:
   ```bash
   nix develop --command bash
   ```

## 🛠️ Development Environment

### Available Tools
The Nix development environment includes:

- **Rust Compiler** (`rustc`) - Latest stable version
- **Cargo** - Rust package manager
- **Clippy** - Rust linter (`cargo clippy`)
- **rustfmt** - Code formatter
- **rust-analyzer** - Language server for IDEs

### Shell Support
Works with any shell:
- **PowerShell**: `nix develop --command bash`
- **Bash**: `nix develop --command bash`
- **Zsh**: `nix develop --command zsh`
- **Fish**: `nix develop --command fish`

### Cross-Platform Compatibility
- ✅ **macOS** (Intel & Apple Silicon)
- ✅ **Linux** (x86_64, aarch64)
- ✅ **Windows** (WSL2, native with Nix)

## 📁 Project Structure

```
rust-nix/
├── flake.nix          # Nix flake configuration
├── flake.lock         # Locked dependencies
├── setup-nix.sh       # Nix setup script
├── Cargo.toml         # Rust project configuration
├── src/               # Rust source code
│   └── main.rs        # Main application entry point
└── README.md          # This file
```

## 🔧 Development Workflow

### 1. Start Development
```bash
# Enter the Nix development environment
nix develop --command bash

# You'll see a welcome message and custom prompt: [NIX-DEV]
```

### 2. Build and Run
```bash
# Build the project
cargo build

# Run the project
cargo run

# Run tests
cargo test

# Check code with Clippy
cargo clippy

# Format code
cargo fmt
```

### 3. Add Dependencies
```bash
# Add a dependency to Cargo.toml
cargo add serde

# Add development dependency
cargo add --dev tokio-test
```

## 🎯 Key Features

### Reproducible Environment
- **Same Rust version** across all machines
- **Consistent tooling** (clippy, rustfmt, rust-analyzer)
- **No system pollution** - everything is isolated in Nix

### Cross-Platform
- **Automatic architecture detection** (x86_64, aarch64)
- **Shell-agnostic** - works with PowerShell, Bash, Zsh, etc.
- **No manual configuration** - everything works out of the box

### Developer Experience
- **Custom prompt** showing you're in the Nix environment
- **Welcome message** with Rust version information
- **All tools pre-configured** and ready to use

## 🔍 Troubleshooting

### "command not found" errors
- Make sure you're using `nix develop --command bash` (not just `nix develop`)
- The `--command` flag ensures you get the right shell environment

### Nix flakes not working
- Run `./setup-nix.sh` to check and fix Nix configuration
- Ensure experimental features are enabled: `nix-command` and `flakes`

### Permission errors
- The setup script uses user-level config (`~/.config/nix/nix.conf`)
- No sudo required for normal operation

### PowerShell issues
- Use `nix develop --command bash` directly
- No need to source profile scripts in PowerShell

## 📚 Additional Resources

- [Nix Flakes Documentation](https://nixos.wiki/wiki/Flakes)
- [Rust Documentation](https://doc.rust-lang.org/)
- [Cargo Book](https://doc.rust-lang.org/cargo/)
- [Nix Package Manager](https://nixos.org/guides/nix-pills/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `cargo test` and `cargo clippy`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Happy coding with Rust and Nix! 🦀❄️**