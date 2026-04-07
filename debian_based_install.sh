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

# Install JupyterLab (only if not installed)
if ! command -v jupyter >/dev/null 2>&1; then
    echo "=== Installing JupyterLab ==="
    pip3 install --user jupyterlab
else
    echo "=== JupyterLab already installed, skipping ==="
fi

# Ensure pip binaries are available
export PATH="$HOME/.local/bin:$PATH"


# ── Pandoc ────────────────────────────────────────────────
if command -v pandoc >/dev/null 2>&1; then
    echo "=== Pandoc already installed ($(pandoc --version | head -n1)) ==="
else
    echo "=== Installing Pandoc 3.9.0.2 ==="
    cd /tmp

    curl -LO https://github.com/jgm/pandoc/releases/download/3.9.0.2/pandoc-3.9.0.2-1-amd64.deb

    sudo dpkg -i pandoc-3.9.0.2-1-amd64.deb || sudo apt -f install -y

    rm -f pandoc-3.9.0.2-1-amd64.deb
fi


# ── Typst ─────────────────────────────────────────────────
if command -v typst >/dev/null 2>&1; then
    echo "=== Typst already installed ($(typst --version)) ==="
else
    echo "=== Installing Typst ==="

    mkdir -p "$HOME/.local/typst"
    cd "$HOME/.local/typst"

    curl -LO https://github.com/typst/typst/releases/download/v0.14.2/typst-x86_64-unknown-linux-musl.tar.xz

    tar -xf typst-x86_64-unknown-linux-musl.tar.xz

    TYPST_DIR=$(find . -type d -name "typst-*")
    mv "$TYPST_DIR/typst" .

    chmod +x typst

    # Add to PATH
    RC_FILE="$HOME/.profile"
    if ! grep -q 'typst' "$RC_FILE"; then
        echo 'export PATH="$HOME/.local/typst:$PATH"' >> "$RC_FILE"
    fi

    export PATH="$HOME/.local/typst:$PATH"
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
echo "   LAUNCHING JUPYTER LAB IN 5...4...3...2...1"
echo "   YOUR PROJECT IS IN ~/pracfile/"
echo "======================================"
echo ""

sleep 5

jupyter lab
