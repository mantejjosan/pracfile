#!/usr/bin/env bash

set -e

echo "=== Starting setup (Arch Linux) ==="

# Install base dependencies
sudo pacman -S --noconfirm \
python python-pip \
curl wget tar xz \
zathura git jupyterlab

# ── Pandoc ────────────────────────────────────────────────
if command -v pandoc >/dev/null 2>&1; then
    echo "=== Pandoc already installed ($(pandoc --version | head -n1)) ==="
else
    echo "=== Installing Pandoc 3.9.0.2 ==="
    cd /tmp

    # curl -LO https://github.com/jgm/pandoc/releases/download/3.9.0.2/pandoc-3.9.0.2-1-amd64.deb
    # Added by param
    # curl -LO https://github.com/jgm/pandoc/releases/download/3.9.0.2/pandoc-3.9.0.2-linux-amd64.tar.gz

    # This automatically finds the latest .tar.gz and downloads it
    curl -s https://api.github.com/repos/jgm/pandoc/releases/latest | grep "browser_download_url" | grep "linux-amd64.tar.gz" | cut -d '"' -f 4 | xargs curl -L -o pandoc-linux-amd64.tar.gz

    # Extract .deb manually (Arch workaround)
    # ar x pandoc-3.9.0.2-1-amd64.deb
    mkdir -p usr
    tar -xzf pandoc-linux-amd64.tar.gz -C usr --strip-components=1

    # Copy into system
    # sudo cp -r usr/* /usr/
    sudo cp usr/bin/* /usr/bin/; sudo cp -r usr/share/* /usr/share/

    rm -rf pandoc-linux-amd64.tar.gz
fi

# ── Typst ─────────────────────────────────────────────────
if command -v typst >/dev/null 2>&1; then
    echo "=== Typst already installed ($(typst --version)) ==="
else
    echo "=== Installing Typst ==="

    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"

    # Direct "latest" download link for Linux x86_64
    # This URL is a GitHub shortcut that doesn't require the API
    URL="https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz"

    echo "Downloading Typst..."
    if curl -L -o "$HOME/typst.tar.xz" "$URL"; then
        # Extract binary directly to your local bin
        tar -xf "$HOME/typst.tar.xz" --strip-components=1 -C "$INSTALL_DIR"
        rm "$HOME/typst.tar.xz"
        chmod +x "$INSTALL_DIR/typst"

        # Ensure $HOME/.local/bin is in your PATH
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
            export PATH="$HOME/.local/bin:$PATH"
        fi

        echo "=== Installation Complete: $(typst --version) ==="
    else
        echo "Error: Download failed. Check your internet connection."
    fi
fi


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

#------------------------
PROJECT_DIR="$HOME/pracfile"
VARS_FILE="$PROJECT_DIR/workflow/variables.typ"

echo ""
echo "--------------------------------------"
echo "   PERSONALIZE YOUR PRACTICAL FILE"
echo "--------------------------------------"
echo ""

# Defaults
default_name="Mantej Singh Josan"
default_roll="2435087"
default_branch="Computer Science & Engineering"
default_year="Second Year — Div C2"
default_subject="Artificial Intelligence"
default_college="Guru Nanak Dev Engineering College, Ludhiana"
default_prof="Prof. Jasdeep Kaur Joia"

# Inputs
read -p "Student Name [$default_name]: " student_name
student_name=${student_name:-$default_name}

read -p "Roll Number [$default_roll]: " roll_no
roll_no=${roll_no:-$default_roll}

read -p "Branch [$default_branch]: " branch
branch=${branch:-$default_branch}

read -p "Year & Division [$default_year]: " year_div
year_div=${year_div:-$default_year}

read -p "Subject [$default_subject]: " subject
subject=${subject:-$default_subject}

read -p "College [$default_college]: " college
college=${college:-$default_college}

read -p "Professor [$default_prof]: " professor
professor=${professor:-$default_prof}

echo "=== Updating variables.typ ==="

update_var() {
    local key="$1"
    local value="$2"

    if grep -q "^#let $key" "$VARS_FILE"; then
        sed -i "s|^#let $key.*|#let $key = \"$value\"|" "$VARS_FILE"
    else
        echo "#let $key = \"$value\"" >> "$VARS_FILE"
    fi
}

update_var "student_name" "$student_name"
update_var "roll_no" "$roll_no"
update_var "branch" "$branch"
update_var "year_div" "$year_div"
update_var "subject" "$subject"
update_var "college" "$college"
update_var "professor" "$professor"

# Launch Jupyter Lab
echo ""
echo "======================================"
echo "   LAUNCHING JUPYTER LAB IN 4...3...2...1"
echo "   Your Project is in ~/pracfile/"
echo "======================================"
echo ""

sleep 4

jupyter lab
