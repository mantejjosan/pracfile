#!/usr/bin/env bash

set -e

echo "=== Starting setup (Ubuntu/Debian) ==="

# Update package lists (no upgrade for metered users)
sudo apt update

# Install base dependencies
sudo apt install -y \
python3 python3-pip python3-venv \
curl wget tar xz-utils \
zathura git

# Install JupyterLab
pip3 install --user jupyterlab

# Ensure pip binaries are available
export PATH="$HOME/.local/bin:$PATH"

echo "=== Installing Pandoc 3.9.0.2 ==="
cd /tmp

curl -LO https://github.com/jgm/pandoc/releases/download/3.9.0.2/pandoc-3.9.0.2-1-amd64.deb

sudo dpkg -i pandoc-3.9.0.2-1-amd64.deb || sudo apt -f install -y

echo "=== Installing Typst ==="

# Create directory
mkdir -p "$HOME/.local/typst"
cd "$HOME/.local/typst"

# Download Typst
curl -LO https://github.com/typst/typst/releases/download/v0.14.2/typst-x86_64-unknown-linux-musl.tar.xz

# Extract
tar -xf typst-x86_64-unknown-linux-musl.tar.xz

# Move binary
TYPST_DIR=$(find . -type d -name "typst-*")
mv "$TYPST_DIR/typst" .

# Make executable
chmod +x typst

# Add Typst to PATH (universal)
RC_FILE="$HOME/.profile"
if ! grep -q 'typst' "$RC_FILE"; then
    echo 'export PATH="$HOME/.local/typst:$PATH"' >> "$RC_FILE"
fi

# Make available immediately
export PATH="$HOME/.local/typst:$PATH"

echo "=== Cleaning up ==="
rm -f /tmp/pandoc-3.9.0.2-1-amd64.deb

echo "=== Setup complete ==="
echo "Restart terminal or run: source ~/.profile"
echo "Test with: typst --version"

# Source appropriate shell config (best-effort)
SHELL_NAME=$(basename "$SHELL")
if [ "$SHELL_NAME" = "bash" ]; then
    source "$HOME/.bashrc" 2>/dev/null || true
elif [ "$SHELL_NAME" = "zsh" ]; then
    source "$HOME/.zshrc" 2>/dev/null || true
fi

# Clone repository
echo "=== Cloning repository ==="

cd "$HOME"

if [ ! -d "$HOME/pracfile" ]; then
    git clone https://github.com/mantejjosan/pracfile
fi

cd "$HOME/pracfile/notebooks"

# Launch Jupyter Lab
echo ""
echo "======================================"
echo "   LAUNCHING JUPYTER LAB IN 3...2...1"
echo "======================================"
echo ""

sleep 3

jupyter lab
