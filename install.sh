#!/bin/bash
# Enhanced Auto-Editor Installer
# Installs all dependencies and sets up the edit command

set -e

echo "═══════════════════════════════════════════════════════════════"
echo "  🎬 Enhanced Auto-Editor Installer"
echo "═══════════════════════════════════════════════════════════════"
echo

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

success() { echo -e "${GREEN}✓ $1${NC}"; }
info() { echo -e "${CYAN}→ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }
error() { echo -e "${RED}✗ $1${NC}"; exit 1; }

# Check for required tools
check_command() {
    if command -v "$1" &> /dev/null; then
        success "$1 found"
        return 0
    else
        return 1
    fi
}

# Create directories
mkdir -p ~/.local/bin

# Check Python
info "Checking Python..."
if check_command python3; then
    PYTHON=python3
elif check_command python; then
    PYTHON=python
else
    error "Python not found! Please install Python 3.10+"
fi

# Check pip
info "Checking pip..."
if ! $PYTHON -m pip --version &> /dev/null; then
    warn "pip not found, installing..."
    $PYTHON -m ensurepip --upgrade 2>/dev/null || error "Failed to install pip"
fi
success "pip available"

# Check FFmpeg
info "Checking FFmpeg..."
if ! check_command ffmpeg; then
    warn "FFmpeg not found!"
    echo "Please install FFmpeg:"
    echo "  Arch: sudo pacman -S ffmpeg"
    echo "  Ubuntu: sudo apt install ffmpeg"
    echo "  macOS: brew install ffmpeg"
    exit 1
fi

# Install Python packages
echo
info "Installing Python packages..."
$PYTHON -m pip install --user --upgrade auto-editor groq faster-whisper 2>&1 | tail -5
success "Python packages installed"

# Install DeepFilterNet
echo
info "Installing DeepFilterNet AI..."
DEEP_FILTER_URL="https://github.com/Rikorose/DeepFilterNet/releases/download/v0.5.6/deep-filter-0.5.6-x86_64-unknown-linux-musl"

if [ -f ~/.local/bin/deep-filter ]; then
    success "DeepFilterNet already installed"
else
    info "Downloading DeepFilterNet (35MB)..."
    if curl -L -o ~/.local/bin/deep-filter "$DEEP_FILTER_URL" 2>/dev/null; then
        chmod +x ~/.local/bin/deep-filter
        success "DeepFilterNet installed"
    else
        warn "Failed to download DeepFilterNet. You can install it manually:"
        echo "  curl -L -o ~/.local/bin/deep-filter '$DEEP_FILTER_URL'"
        echo "  chmod +x ~/.local/bin/deep-filter"
    fi
fi

# Install edit command
echo
info "Installing edit command..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/edit" ~/.local/bin/edit
chmod +x ~/.local/bin/edit
success "edit command installed to ~/.local/bin/edit"

# Check PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    warn "~/.local/bin is not in your PATH"
    echo "Add this to your ~/.bashrc or ~/.zshrc:"
    echo '  export PATH="$HOME/.local/bin:$PATH"'
    echo
fi

# Summary
echo
echo "═══════════════════════════════════════════════════════════════"
echo -e "  ${GREEN}✅ Installation Complete!${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo
echo "  Quick Start:"
echo "    1. Get free Groq API key: https://console.groq.com/keys"
echo "    2. Set your key: edit --set-groq-key YOUR_KEY"
echo "    3. Process a video: edit video.mp4"
echo
echo "  Usage:"
echo "    edit video.mp4           # Interactive mode"
echo "    edit video.mp4 --groq    # Use Groq API (recommended)"
echo "    edit video.mp4 --local   # Use local Whisper"
echo "    edit video.mp4 --render  # Render final video"
echo
echo "═══════════════════════════════════════════════════════════════"
