#!/usr/bin/env bash

set -e

echo "=== Starting setup (Arch Linux) ==="

# Update system

sudo pacman -Syu --noconfirm

# Install dependencies

sudo pacman -S --noconfirm 
python python-pip 
curl wget tar xz 
zathura

# Install JupyterLab

pip install --user jupyterlab

echo "=== Installing Pandoc 3.9.0.2 ==="
cd /tmp

curl -LO https://github.com/jgm/pandoc/releases/download/3.9.0.2/pandoc-3.9.0.2-1-amd64.deb

# Extract deb manually (Arch workaround)

ar x pandoc-3.9.0.2-1-amd64.deb
tar -xf data.tar.xz

# Copy files

sudo cp -r usr/* /usr/

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

chmod +x typst

# Add to PATH

if ! grep -q 'typst' ~/.bashrc; then
echo 'export PATH="$HOME/.local/typst:$PATH"' >> ~/.bashrc
fi

echo "=== Cleanup ==="
rm -rf /tmp/pandoc-3.9.0.2-1-amd64.deb /tmp/data.tar.*

echo "=== Setup complete ==="
echo "Restart terminal or run: source ~/.bashrc"
echo "Test with: typst --version"

