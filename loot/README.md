# Loot Directory

This directory stores harvested tokens, cookies, and session data.

## Files Generated Here:

- `stolen_tokens.txt` - Cookies and tokens extracted from browsers or clipboard

## Security Note:

⚠️ **This directory contains sensitive data!**

- Never commit this directory to version control
- Keep this data secure and encrypted
- Delete after use in authorized testing
- This directory is excluded via `.gitignore`

## Usage:

This directory is automatically populated by:
- `token_harvester.py` - Extracts cookies from Chrome/Firefox
- `utils/clipboard_monitor.py` - Captures tokens from clipboard
- Other Hijax tools that collect session data

All harvested data includes timestamps and source information for tracking.
