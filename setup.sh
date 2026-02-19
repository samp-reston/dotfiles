#!/usr/bin/env bash

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLAKE_PATH="${REPO_DIR}#sam"

echo "📦 Home Manager Setup Script"
echo "Repository: $REPO_DIR"
echo ""

# Check if flake.nix exists
if [ ! -f "$REPO_DIR/flake.nix" ]; then
    echo "❌ Error: flake.nix not found in $REPO_DIR"
    exit 1
fi

# Check if dotfiles directory exists
if [ ! -d "$REPO_DIR/dotfiles" ]; then
    echo "❌ Error: dotfiles directory not found in $REPO_DIR"
    exit 1
fi

echo "✅ Found flake.nix and dotfiles directory"
echo ""

# Offer to update flake.lock
echo "Do you want to update flake.lock to latest versions? (y/n)"
read -r update_lock
if [[ "$update_lock" == "y" ]]; then
    echo "🔄 Updating flake.lock..."
    nix flake update
    echo "✅ flake.lock updated"
    echo ""
fi

# Offer dry-run
echo "Do you want to do a dry-run first to see what changes will be made? (y/n)"
read -r dry_run
if [[ "$dry_run" == "y" ]]; then
    echo "🔍 Running dry-run..."
    nix run home-manager -- switch --flake "$FLAKE_PATH" --dry-run
    echo ""
    echo "Review the changes above. Continue with actual switch? (y/n)"
    read -r continue
    if [[ "$continue" != "y" ]]; then
        echo "❌ Cancelled"
        exit 0
    fi
fi

# Run home-manager switch
echo "🚀 Activating Home Manager configuration..."
nix run home-manager -- switch --flake "$FLAKE_PATH"

echo ""
echo "✅ Home Manager setup complete!"
echo ""
echo "Next steps:"
echo "1. Review your configuration changes"
echo "2. If something broke, rollback with: home-manager switch --flake $FLAKE_PATH -G <generation>"
echo "3. See available generations with: home-manager generations"
