# Hijax Deployment Guide

This guide covers deployment and setup of the Hijax session hijacking framework.

## Quick Start

### Automated Setup (Recommended)

```bash
git clone https://github.com/ctfbindsec/hijax.git
cd hijax
chmod +x setup.sh
./setup.sh
```

The setup script will:
1. Create required directories (`loot/`, `payloads/`)
2. Install system dependencies (chromium-driver, curl, jq, unzip)
3. Install Python dependencies from requirements.txt
4. Set executable permissions on all scripts
5. Verify installation

### Manual Setup

If you prefer manual installation or the automated script fails:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ctfbindsec/hijax.git
   cd hijax
   ```

2. **Create required directories:**
   ```bash
   mkdir -p loot payloads
   ```

3. **Install system dependencies:**
   
   **Debian/Ubuntu:**
   ```bash
   sudo apt update
   sudo apt install -y python3 python3-pip chromium-driver curl jq unzip
   ```
   
   **RedHat/CentOS:**
   ```bash
   sudo yum install -y python3 python3-pip chromium chromedriver curl jq unzip
   ```
   
   **macOS:**
   ```bash
   brew install python3 chromedriver curl jq
   ```

4. **Install Python dependencies:**
   ```bash
   pip3 install -r requirements.txt
   ```
   
   Or with --break-system-packages flag if needed:
   ```bash
   pip3 install -r requirements.txt --break-system-packages
   ```
   
   Or install individually:
   ```bash
   pip3 install selenium requests browser-cookie3 beautifulsoup4 pycryptodome pyperclip
   ```

5. **Set permissions:**
   ```bash
   chmod +x hijax_cli.py token_harvester.py token_injector.py token_replayer.py
   chmod +x hijax_remote_implant.py utils/clipboard_monitor.py
   ```

## Verify Installation

Test that Python modules are available:
```bash
python3 -c "import selenium, requests, browser_cookie3, pyperclip; print('All modules OK')"
```

## Running Hijax

### Main CLI
```bash
python3 hijax_cli.py
```

### Individual Tools

**Token Harvester:**
```bash
python3 token_harvester.py
```

**Token Injector:**
```bash
python3 token_injector.py
```

**Token Replayer:**
```bash
python3 token_replayer.py
```

**Clipboard Monitor:**
```bash
python3 utils/clipboard_monitor.py
```

**Implant Generator:**
```bash
python3 hijax_remote_implant.py
```

## Directory Structure

```
hijax/
├── hijax_cli.py              # Main CLI interface
├── token_harvester.py        # Cookie extraction tool
├── token_injector.py         # Session injection tool
├── token_replayer.py         # API session replay tool
├── hijax_remote_implant.py   # Implant generator
├── hijax_remote_implant.html # Static HTML implant template
├── setup.sh                  # Automated setup script
├── requirements.txt          # Python dependencies
├── .gitignore               # Git ignore rules
├── utils/
│   ├── clipboard_monitor.py # Clipboard token monitor
│   └── browser_parser.py    # Browser parsing utilities
├── loot/                    # Harvested tokens/cookies (gitignored)
│   └── README.md
└── payloads/                # Generated implants (gitignored)
    └── README.md
```

## Deployment for Remote Use

### Serving Implants

Generate an implant payload:
```bash
python3 hijax_remote_implant.py
```

Serve it locally:
```bash
python3 -m http.server 8080
```

Or use Ngrok for remote access:
```bash
ngrok http 8080
```

### Integration with ScamTrack

> **Note:** ScamTrack is a social engineering payload delivery platform. Hijax was designed to work natively with ScamTrack for browser-based payload delivery. See the main README for more details about ScamTrack integration.

1. Copy generated payload to ScamTrack's `payloads/` directory
2. Start ScamTrack server
3. Use the Ngrok URL to deliver the payload
4. Captured data appears in `loot/` directory

## Troubleshooting

### Issue: "No module named 'browser_cookie3'"
**Solution:** Install dependencies:
```bash
pip3 install -r requirements.txt
```

### Issue: "chromium-driver not found"
**Solution:** Install chromium-driver:
```bash
# Debian/Ubuntu
sudo apt install chromium-driver

# macOS
brew install chromedriver
```

### Issue: "Permission denied" when running scripts
**Solution:** Make scripts executable:
```bash
chmod +x *.py utils/*.py setup.sh
```

### Issue: Directory doesn't exist errors
**Solution:** The scripts now auto-create directories, but you can manually create them:
```bash
mkdir -p loot payloads
```

## Security Considerations

⚠️ **IMPORTANT:**
- Use only on systems you own or have explicit permission to test
- Store harvested data securely
- Delete sensitive data after authorized testing
- Never commit `loot/` or `payloads/` content to git
- Follow all applicable laws and regulations (CFAA, GDPR, etc.)

## Updates

To update Hijax:
```bash
git pull origin main
./setup.sh  # Re-run setup if needed
```

## Support

For issues, feature requests, or questions:
- Open an issue on GitHub
- Review the README.md for usage examples
- Check documentation in loot/README.md and payloads/README.md

---

**Remember:** This framework is for educational and authorized security testing only.
