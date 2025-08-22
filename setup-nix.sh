#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Nix Setup Script${NC}"
echo "=================="
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Nix is installed
echo -e "${YELLOW}Checking Nix installation...${NC}"
if command_exists nix; then
    echo -e "${GREEN}✅ Nix is installed${NC}"
    nix_version=$(nix --version)
    echo "   Version: $nix_version"
else
    echo -e "${RED}❌ Nix is not installed${NC}"
    echo ""
    echo "To install Nix, run one of the following:"
    echo ""
    echo "For macOS/Linux (single-user):"
    echo "  sh <(curl -L https://nixos.org/nix/install) --no-daemon"
    echo ""
    echo "For macOS/Linux (multi-user):"
    echo "  sh <(curl -L https://nixos.org/nix/install) --daemon"
    echo ""
    echo "For Windows (WSL2):"
    echo "  sh <(curl -L https://nixos.org/nix/install) --no-daemon"
    echo ""
    echo "After installation, restart your shell or run:"
    echo "  source ~/.nix-profile/etc/profile.d/nix.sh"
    echo ""
    exit 1
fi

echo ""

# Check if nix.conf exists - prioritize user config
USER_NIX_CONF_DIR="$HOME/.config/nix"
USER_NIX_CONF_FILE="$USER_NIX_CONF_DIR/nix.conf"
SYSTEM_NIX_CONF_FILE="/etc/nix/nix.conf"

echo -e "${YELLOW}Checking Nix configuration...${NC}"

# Check user config first, then system config
if [ -f "$USER_NIX_CONF_FILE" ]; then
    echo -e "${GREEN}✅ User config found at $USER_NIX_CONF_FILE${NC}"
    NIX_CONF_FILE="$USER_NIX_CONF_FILE"
elif [ -f "$SYSTEM_NIX_CONF_FILE" ]; then
    echo -e "${GREEN}✅ System config found at $SYSTEM_NIX_CONF_FILE${NC}"
    NIX_CONF_FILE="$SYSTEM_NIX_CONF_FILE"
else
    echo -e "${YELLOW}⚠️  No Nix config found, creating user config...${NC}"
    mkdir -p "$USER_NIX_CONF_DIR"
    NIX_CONF_FILE="$USER_NIX_CONF_FILE"
fi

# Check for experimental features
echo ""
echo -e "${YELLOW}Checking experimental features...${NC}"

# Function to check if feature is enabled
check_feature() {
    local feature="$1"
    if grep -q "^experimental-features = .*$feature" "$NIX_CONF_FILE" 2>/dev/null; then
        echo -e "${GREEN}✅ $feature is enabled${NC}"
        return 0
    elif grep -q "^experimental-features = .*" "$NIX_CONF_FILE" 2>/dev/null; then
        if grep -q "^experimental-features = .*$feature.*" "$NIX_CONF_FILE" 2>/dev/null; then
            echo -e "${GREEN}✅ $feature is enabled${NC}"
            return 0
        fi
    fi
    echo -e "${RED}❌ $feature is not enabled${NC}"
    return 1
}

nix_command_enabled=false
flakes_enabled=false

check_feature "nix-command" && nix_command_enabled=true
check_feature "flakes" && flakes_enabled=true

# Enable missing features
if [ "$nix_command_enabled" = false ] || [ "$flakes_enabled" = false ]; then
    echo ""
    echo -e "${YELLOW}Enabling required experimental features...${NC}"
    
    # Read existing config
    if [ -f "$NIX_CONF_FILE" ]; then
        # Check if experimental-features line already exists
        if grep -q "^experimental-features" "$NIX_CONF_FILE" 2>/dev/null; then
            # Update existing experimental-features line
            if [ "$nix_command_enabled" = false ] && [ "$flakes_enabled" = false ]; then
                # Add both features
                sed -i.bak 's/^experimental-features = \(.*\)/experimental-features = \1 nix-command flakes/' "$NIX_CONF_FILE"
            elif [ "$nix_command_enabled" = false ]; then
                # Add nix-command
                sed -i.bak 's/^experimental-features = \(.*\)/experimental-features = \1 nix-command/' "$NIX_CONF_FILE"
            elif [ "$flakes_enabled" = false ]; then
                # Add flakes
                sed -i.bak 's/^experimental-features = \(.*\)/experimental-features = \1 flakes/' "$NIX_CONF_FILE"
            fi
        else
            # Add new experimental-features line
            echo "experimental-features = nix-command flakes" >> "$NIX_CONF_FILE"
        fi
    else
        # Create new config file
        echo "experimental-features = nix-command flakes" > "$NIX_CONF_FILE"
    fi
    
    echo -e "${GREEN}✅ Experimental features enabled${NC}"
    echo "   You may need to restart your shell for changes to take effect"
fi

echo ""
echo -e "${YELLOW}Testing Nix flakes...${NC}"
if nix flake --help >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Nix flakes are working${NC}"
else
    echo -e "${RED}❌ Nix flakes are not working${NC}"
    echo "   Please restart your shell and try again"
    echo "   Or run: source ~/.nix-profile/etc/profile.d/nix.sh"
fi

echo ""
echo -e "${GREEN}🎉 Nix setup complete!${NC}"
echo ""

echo ""
echo "Next steps:"
echo "  1. Enter the Nix development environment:"
echo "     • nix develop --command bash    (recommended)"
echo "     • nix develop --command zsh     (alternative)"
echo ""
echo "  2. Start developing with Rust!"
echo "     • rustc --version    (check Rust compiler)"
echo "     • cargo --version    (check Cargo)"
echo "     • cargo clippy       (run linter)"
echo ""
echo "Note: The development environment includes all Rust tools pre-configured."
echo "      No need to install or configure anything else!"
echo ""
