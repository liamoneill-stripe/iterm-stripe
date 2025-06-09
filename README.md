# Stripe Demo Terminal Setup

A script to create a professional iTerm2 profile optimized for Stripe demos and presentations, featuring branded aesthetics, demo-friendly tools, and automatic Stripe CLI account visualization.

![Stripe Demo Terminal Preview](https://example.com/stripe-terminal-preview.png)

## Features

- **Professional Appearance**
  - Custom Stripe logo background (semi-transparent, positioned at bottom left)
  - Optimized color scheme for high readability during presentations
  - Large, clear typography with ligature support
  - Blur effects and semi-transparency for a modern look

- **Stripe CLI Integration**
  - Visual indicator of current Stripe account (in terminal badge and tab title)
  - Auto-updates when switching accounts
  - Includes example CLI commands for demos

- **Presentation Tools**
  - Step-by-step demo mode (confirms before executing each command)
  - Section header generator for structured demos
  - Pre-configured demo content with code examples
  - Welcome banner with Stripe branding

- **Development Environment**
  - Optimized ZSH configuration with Oh-My-Zsh
  - Powerlevel10k theme with demo-friendly prompt
  - Modern command-line tools (bat, eza, fzf, etc.)
  - Syntax highlighting configured for maximum visibility

## Requirements

- macOS
- [iTerm2](https://iterm2.com/downloads.html) installed
- [Homebrew](https://brew.sh/) installed
- Administrator privileges (for installing packages)
- Internet connection (for downloading components)
- A Stripe logo PNG file with transparent background

## Installation

1. **Download the script**
   ```bash
   curl -o setup_stripe_demo_terminal.sh https://example.com/setup_stripe_demo_terminal.sh
   ```

2. **Make it executable**
   ```bash
   chmod +x setup_stripe_demo_terminal.sh
   ```

3. **Run the script**
   ```bash
   ./setup_stripe_demo_terminal.sh
   ```

4. **Follow the prompts**
   - You'll be asked for the path to your Stripe logo PNG file
   - Default: `~/Downloads/stripe_logo.png`

## What Gets Installed

- **Terminal Components**
  - Oh-My-Zsh (shell framework)
  - Powerlevel10k (ZSH theme)
  - ZSH plugins for productivity
  - Developer fonts with ligature support

- **Command-Line Tools**
  - bat (improved cat command)
  - eza (modern ls replacement)
  - fzf (fuzzy finder)
  - neofetch (system info display)
  - Stripe CLI (if not already installed)

- **Configuration Files**
  - Custom iTerm2 profile
  - Optimized ZSH configuration
  - Powerlevel10k settings
  - Demo script examples in `~/.stripe/demo/`

## Usage

### Opening the Demo Profile

- **From iTerm2:**
  - Go to Profiles menu (⌘+O)
  - Select "Stripe Demo" profile
  
- **From command line:**
  ```bash
  open -a iTerm --args -profile "Stripe Demo"
  ```

### Demo Commands

| Command | Description |
|---------|-------------|
| `demo` | Navigate to demo files directory (`~/.stripe/demo/`) |
| `demo-title "Section Name"` | Clear screen and show formatted section header |
| `demo_mode` | Enable step-by-step confirmation before each command |
| `undemo_mode` | Disable step-by-step confirmation |
| `stripe_welcome` | Display the welcome banner again |
| `update_stripe_info` | Manually update the Stripe account display |

### Stripe CLI Integration

The terminal will automatically show which Stripe account you're currently logged into:
- The terminal badge will display: "Stripe: acct_xxxx (Account Name)"
- The tab title will include your account information
- The welcome message displays connection status

To switch accounts, use `stripe login` and the display will update automatically.

## Customization

After installation, you can customize further:
- Edit `~/.zshrc` to modify shell behavior
- Edit `~/.p10k.zsh` to modify the prompt appearance
- Add additional demo files to `~/.stripe/demo/`
- Modify iTerm2 profile settings through iTerm2 Preferences

## Troubleshooting

### Font Issues
If you see boxes or missing icons in your prompt:
```bash
p10k configure
```
Choose a different glyph set or install additional fonts.

### Account Display Not Updating
If your Stripe account information doesn't update:
```bash
update_stripe_info
```

### Reverting Changes
The script creates backups of modified files. To restore:
```bash
# Find your backup .zshrc file
ls -la ~/.zshrc.backup*

# Restore it
cp ~/.zshrc.backup.TIMESTAMP ~/.zshrc
```

## License

MIT License - Feel free to modify and share this script.

## Contributing

Contributions welcome! Please feel free to submit a Pull Request.
