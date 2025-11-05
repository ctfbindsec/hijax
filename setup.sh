#!/bin/bash
# Hijax Setup Script
# Automated installation and deployment for the Hijax framework

set -e

echo "════════════════════════════════════════════════════════════"
echo "  H I J A X  -  Setup & Installation"
echo "  Session Hijacking Framework"
echo "════════════════════════════════════════════════════════════"
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[i]${NC} $1"
}

# Check if running as root (not recommended but needed for some packages)
if [ "$EUID" -eq 0 ]; then 
    print_info "Running as root. This is not recommended for security reasons."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Create necessary directories
print_info "Creating required directories..."
mkdir -p loot
mkdir -p payloads
print_success "Created loot/ and payloads/ directories"

# Check for Python 3
print_info "Checking for Python 3..."
if ! command -v python3 &> /dev/null; then
    print_error "Python 3 is not installed. Please install Python 3.6+ first."
    exit 1
fi
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
print_success "Python ${PYTHON_VERSION} found"

# Check for pip3
print_info "Checking for pip3..."
if ! command -v pip3 &> /dev/null; then
    print_error "pip3 is not installed. Installing pip3..."
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y python3-pip
    elif command -v yum &> /dev/null; then
        sudo yum install -y python3-pip
    else
        print_error "Could not install pip3 automatically. Please install it manually."
        exit 1
    fi
fi
print_success "pip3 is available"

# Install system dependencies
print_info "Installing system dependencies..."
if command -v apt &> /dev/null; then
    print_info "Detected Debian/Ubuntu system"
    sudo apt update
    sudo apt install -y chromium-driver curl jq unzip || {
        print_error "Failed to install some system packages. Continuing anyway..."
    }
elif command -v yum &> /dev/null; then
    print_info "Detected RedHat/CentOS system"
    sudo yum install -y chromium chromedriver curl jq unzip || {
        print_error "Failed to install some system packages. Continuing anyway..."
    }
elif command -v brew &> /dev/null; then
    print_info "Detected macOS system"
    brew install chromedriver curl jq || {
        print_error "Failed to install some packages via Homebrew. Continuing anyway..."
    }
else
    print_info "Could not detect package manager. Skipping system dependencies."
    print_info "Please manually install: chromium-driver, curl, jq, unzip"
fi

# Install Python dependencies
print_info "Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    # Try to install without --break-system-packages first
    if pip3 install -r requirements.txt 2>/dev/null; then
        print_success "Python dependencies installed successfully"
    else
        # If that fails, try with --break-system-packages for systems that need it
        print_info "Retrying with --break-system-packages flag..."
        pip3 install -r requirements.txt --break-system-packages || {
            print_error "Failed to install Python dependencies"
            print_info "You may need to install packages manually:"
            print_info "  pip3 install selenium requests browser-cookie3 beautifulsoup4 pycryptodome pyperclip"
            exit 1
        }
        print_success "Python dependencies installed successfully"
    fi
else
    print_error "requirements.txt not found. Installing packages manually..."
    pip3 install selenium requests browser-cookie3 beautifulsoup4 pycryptodome pyperclip --break-system-packages || {
        print_error "Failed to install Python dependencies"
        exit 1
    }
    print_success "Python dependencies installed successfully"
fi

# Set proper permissions
print_info "Setting executable permissions..."
chmod +x hijax_cli.py 2>/dev/null || true
chmod +x token_harvester.py 2>/dev/null || true
chmod +x token_injector.py 2>/dev/null || true
chmod +x token_replayer.py 2>/dev/null || true
chmod +x hijax_remote_implant.py 2>/dev/null || true
chmod +x utils/clipboard_monitor.py 2>/dev/null || true
print_success "Permissions set"

# Test imports
print_info "Testing Python imports..."
python3 -c "import selenium; import requests; import browser_cookie3; import pyperclip" 2>/dev/null && {
    print_success "All Python modules imported successfully"
} || {
    print_error "Some Python modules failed to import. Please check installation."
}

# Display completion message
echo ""
echo "════════════════════════════════════════════════════════════"
print_success "Hijax installation completed successfully!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "To get started, run:"
echo "  python3 hijax_cli.py"
echo ""
echo "Available tools:"
echo "  • python3 token_harvester.py    - Extract cookies from browsers"
echo "  • python3 token_injector.py     - Inject cookies into browser"
echo "  • python3 token_replayer.py     - Replay sessions via API"
echo "  • python3 utils/clipboard_monitor.py - Monitor clipboard for tokens"
echo ""
echo "Output directories:"
echo "  • loot/     - Stolen tokens and cookies"
echo "  • payloads/ - Generated implant payloads"
echo ""
print_info "Remember: This tool is for educational and authorized testing only!"
echo ""
