#!/usr/bin/env bash

set -e

echo "=== Starting setup (Ubuntu/Debian) ==="

# Update system

sudo apt update && sudo apt upgrade -y

# Install base dependencies

sudo apt install -y 
python3 python3-pip python3-venv 
curl wget tar xz-utils 
zathura

# Install JupyterLab

pip3 install --user jupyterlab

echo "=== Installing Pandoc 3.9.0.2 ==="
cd /tmp

curl -LO https://github.com/jgm/pandoc/releases/download/3.9.0.2/pandoc-3.9.0.2-1-amd64.deb

sudo dpkg -i pandoc-3.9.0.2-1-amd64.deb || sudo apt -f install -y

echo "=== Installing Typst ==="

# Create directory

mkdir -p $HOME/.local/typst
cd $HOME/.local/typst

# Download Typst

curl -LO https://github.com/typst/typst/releases/download/v0.14.2/typst-x86_64-unknown-linux-musl.tar.xz

# Extract

tar -xf typst-x86_64-unknown-linux-musl.tar.xz

# Move binary

TYPST_DIR=$(find . -type d -name "typst-*")
mv "$TYPST_DIR/typst" .

# Make executable

chmod +x typst

# Add to PATH if not already

if ! grep -q 'typst' ~/.bashrc; then
echo 'export PATH="$HOME/.local/typst:$PATH"' >> ~/.bashrc
fi

echo "=== Cleaning up ==="
rm -rf /tmp/pandoc-3.9.0.2-1-amd64.deb

echo "=== Setup complete ==="
echo "Restart terminal or run: source ~/.bashrc"
echo "Test with: typst --version"


