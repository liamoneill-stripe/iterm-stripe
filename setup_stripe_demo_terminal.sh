#!/bin/bash

# iTerm2 Live Demo Profile Setup Script
# Creates a professional demo environment with Stripe branding and CLI account indication

# Color codes for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Stripe Demo Terminal Setup ===${NC}"
echo -e "${YELLOW}This script will set up a complete iTerm2 profile for demos${NC}\n"

# Check for inputs and set defaults
read -p "Path to Stripe logo PNG file [~/Downloads/stripe_logo.png]: " LOGO_PATH
LOGO_PATH=${LOGO_PATH:-~/Downloads/stripe_logo.png}

# Expand tilde to full path
LOGO_PATH="${LOGO_PATH/#\~/$HOME}"

if [ ! -f "$LOGO_PATH" ]; then
    echo -e "${RED}Error: Logo file not found at $LOGO_PATH${NC}"
    echo -e "${YELLOW}Please place your Stripe logo PNG in the specified location and try again${NC}"
    exit 1
fi

# Create directories if needed
mkdir -p ~/.iterm2 ~/.iterm2/imgcat
mkdir -p ~/.oh-my-zsh/custom/themes ~/.oh-my-zsh/custom/plugins
mkdir -p ~/.stripe/demo

# Copy logo to a permanent location
cp "$LOGO_PATH" ~/.iterm2/stripe_logo.png
echo -e "${GREEN}✓ Logo copied to ~/.iterm2/stripe_logo.png${NC}"

# Install required packages
echo -e "\n${BLUE}Installing required packages...${NC}"
brew install zsh bat eza fzf neofetch jq wget git stripe/stripe-cli/stripe 2>/dev/null || {
    echo -e "${YELLOW}Some packages may have failed to install. Continuing...${NC}"
}

# Install Oh-My-Zsh if not already installed
if [ ! -d ~/.oh-my-zsh ]; then
    echo -e "\n${BLUE}Installing Oh-My-Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "${GREEN}✓ Oh-My-Zsh installed${NC}"
else
    echo -e "${GREEN}✓ Oh-My-Zsh already installed${NC}"
fi

# Install Powerlevel10k
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k ]; then
    echo -e "\n${BLUE}Installing Powerlevel10k theme...${NC}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
    echo -e "${GREEN}✓ Powerlevel10k installed${NC}"
else
    echo -e "${GREEN}✓ Powerlevel10k already installed${NC}"
fi

# Install required fonts
echo -e "\n${BLUE}Installing fonts...${NC}"
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono font-hack-nerd-font font-fira-code 2>/dev/null || {
    echo -e "${YELLOW}Some fonts may have failed to install. Continuing...${NC}"
}

# Install ZSH plugins
echo -e "\n${BLUE}Installing ZSH plugins...${NC}"
if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if [ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

echo -e "${GREEN}✓ ZSH plugins installed${NC}"

# Create iTerm2 profile - using plists and defaults
echo -e "\n${BLUE}Creating iTerm2 profile...${NC}"

# First check if iTerm2 is installed
if ! [ -d "/Applications/iTerm.app" ] && ! [ -d "$HOME/Applications/iTerm.app" ]; then
    echo -e "${RED}Error: iTerm2 is not installed${NC}"
    echo -e "${YELLOW}Please install iTerm2 first and then run this script again${NC}"
    exit 1
fi

# Download JQ for plist processing if needed
PLIST_BUDDY="/usr/libexec/PlistBuddy"

# Create Dynamic Profile
mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
PROFILE_PATH="$HOME/Library/Application Support/iTerm2/DynamicProfiles/stripe_demo.json"

# Create JSON profile
cat > "$PROFILE_PATH" <<EOL
{
  "Profiles": [
    {
      "Name": "Stripe Demo",
      "Guid": "stripe-demo-profile",
      "Badge Text": "",
      "Dynamic Profile Parent Name": "Default",
      "Normal Font": "JetBrainsMono-Regular 16",
      "Non Ascii Font": "HackNerdFontComplete-Regular 16",
      "Horizontal Spacing": 1,
      "Vertical Spacing": 1.2,
      "Use Non-ASCII Font": true,
      "Use Ligatures": true,
      "ASCII Ligatures": true,
      "Background Color": {
        "Red Component": 0.039,
        "Green Component": 0.145,
        "Blue Component": 0.251,
        "Alpha Component": 0.95
      },
      "Foreground Color": {
        "Red Component": 0.9,
        "Green Component": 0.9,
        "Blue Component": 0.9,
        "Alpha Component": 1
      },
      "Bold Color": {
        "Red Component": 1,
        "Green Component": 1,
        "Blue Component": 0,
        "Alpha Component": 1
      },
      "Selection Color": {
        "Red Component": 0.2,
        "Green Component": 0.47,
        "Blue Component": 1.0,
        "Alpha Component": 1
      },
      "Background Image Location": "$HOME/.iterm2/stripe_logo.png",
      "Background Image Is Tiled": false,
      "Background Image Mode": 1,
      "Background Image Alignment": 9,
      "Background Image X Offset": 20,
      "Background Image Y Offset": 20,
      "Blend": 0.15,
      "Blur": true,
      "Blur Radius": 5.0,
      "Scrollback Lines": 10000,
      "Terminal Type": "xterm-256color",
      "Transparency": 0.1,
      "Initial Use Transparency": true,
      "Unlimited Scrollback": true,
      "Use Bold Font": true,
      "Use Bright Bold": true,
      "Window Type": 0
    }
  ]
}
EOL

echo -e "${GREEN}✓ iTerm2 profile created${NC}"

# Configure .zshrc
echo -e "\n${BLUE}Configuring ZSH...${NC}"

# Backup existing .zshrc
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d%H%M%S)
    echo -e "${YELLOW}Existing .zshrc backed up${NC}"
fi

# Create new .zshrc
cat > ~/.zshrc <<EOL
# Created by Stripe Demo Terminal Setup Script

# Path to your oh-my-zsh installation
export ZSH="\$HOME/.oh-my-zsh"

# Set PowerLevel10k theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting history colored-man-pages)

# Initialize Oh-My-Zsh
source \$ZSH/oh-my-zsh.sh

# Syntax highlighting colors for demos
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=blue,bold'

# Larger history
export HISTSIZE=10000
export SAVEHIST=10000

# Demo-friendly aliases
alias cls="clear"
alias ll="ls -la"
alias cat="bat --style=grid,header 2>/dev/null || cat"
alias ls="eza --icons 2>/dev/null || ls"
alias ll="eza --icons --long --header --git 2>/dev/null || ls -la"
alias demo="cd ~/.stripe/demo"

# Show command execution time if over 3 seconds
REPORTTIME=3

# Demo mode function
demo_mode() {
  function demo_prompt() {
    echo -n "Press ENTER to execute: "
    read
  }
  preexec() { demo_prompt; }
}

undemo_mode() {
  unfunction preexec 2>/dev/null
}

# Demo title function
function demo-title() {
  clear
  echo -e "\n\033[1;36m===== \$1 =====\033[0m\n"
}

# Get Stripe CLI account info and display in terminal
function get_stripe_account() {
  if command -v stripe &> /dev/null; then
    local STRIPE_ACCOUNT=\$(stripe config --list 2>/dev/null | grep "Account ID" | awk '{print \$3}' || echo "Not logged in")
    local STRIPE_ACCOUNT_NAME=\$(stripe config --list 2>/dev/null | grep "Account display name" | cut -d ':' -f2- | xargs || echo "")
    
    if [[ "\$STRIPE_ACCOUNT" != "Not logged in" ]]; then
      if [[ -n "\$STRIPE_ACCOUNT_NAME" ]]; then
        echo "\$STRIPE_ACCOUNT (\$STRIPE_ACCOUNT_NAME)"
      else
        echo "\$STRIPE_ACCOUNT"
      fi
    else
      echo "Not logged in"
    fi
  else
    echo "Stripe CLI not installed"
  fi
}

# Set the iTerm2 tab title to show Stripe account
function set_stripe_tab_title() {
  local ACCOUNT_INFO=\$(get_stripe_account)
  if [[ "\$ACCOUNT_INFO" != "Not logged in" && "\$ACCOUNT_INFO" != "Stripe CLI not installed" ]]; then
    echo -ne "\033]0;Stripe: \$ACCOUNT_INFO\007"
  else
    echo -ne "\033]0;Stripe Demo\007"
  fi
}

# Update Stripe CLI info in prompt
function update_stripe_info() {
  local ACCOUNT_INFO=\$(get_stripe_account)
  
  # Set terminal badge to show Stripe account
  if [[ "\$ACCOUNT_INFO" != "Not logged in" && "\$ACCOUNT_INFO" != "Stripe CLI not installed" ]]; then
    echo -ne "\033]1337;SetBadgeFormat=\$(echo -n "Stripe: \$ACCOUNT_INFO" | base64)\007"
  else
    echo -ne "\033]1337;SetBadgeFormat=\007"
  fi
  
  # Also update tab title
  set_stripe_tab_title
}

# Run update on startup and create a function to check periodically
update_stripe_info

# Create a preexec hook to update Stripe info when running stripe commands
autoload -U add-zsh-hook
add-zsh-hook preexec _update_stripe_hook
function _update_stripe_hook() {
  if [[ "\$1" == stripe* || "\$1" == *stripe-cli* ]]; then
    # Wait a moment to let the command complete
    (sleep 2 && update_stripe_info &)
  fi
}

# Load FZF if installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Welcome message
function stripe_welcome() {
  clear
  if command -v neofetch &> /dev/null; then
    neofetch
  fi
  echo -e "\033[0;35m"  
  echo "   _____ _        _            _____                      "
  echo "  / ____| |      (_)          |  __ \\                     "
  echo " | (___ | |_ _ __ _ _ __   ___| |  | | ___ _ __ ___   ___ "
  echo "  \\___ \\| __| '__| | '_ \\ / _ \\ |  | |/ _ \\ '_ \` _ \\ / _ \\"
  echo "  ____) | |_| |  | | |_) |  __/ |__| |  __/ | | | | | (_) |"
  echo " |_____/ \\__|_|  |_| .__/ \\___|_____/ \\___|_| |_| |_|\\___/"
  echo "                   | |                                     "
  echo "                   |_|                                     "
  echo -e "\033[0m"
  
  local ACCOUNT_INFO=\$(get_stripe_account)
  if [[ "\$ACCOUNT_INFO" != "Not logged in" && "\$ACCOUNT_INFO" != "Stripe CLI not installed" ]]; then
    echo -e "Terminal profile ready for presentations!"
    echo -e "\033[0;33mConnected to Stripe account: \033[0;32m\$ACCOUNT_INFO\033[0m"
  else
    echo -e "Terminal profile ready for presentations!"
    echo -e "\033[0;33mStripe CLI status: \033[0;31mNot logged in\033[0m"
    echo -e "Run 'stripe login' to connect to your Stripe account"
  fi
  
  echo -e "\nType \033[0;36mdemo\033[0m to access demo files in ~/.stripe/demo/"
  echo ""
  
  # Update terminal badge
  update_stripe_info
}

# Run welcome message
stripe_welcome

# Load Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOL

# Create minimal p10k configuration
cat > ~/.p10k.zsh <<EOL
# Generated by Powerlevel10k configuration wizard on 2023-05-01 at 12:00
# Based on romkatv/powerlevel10k/config/p10k-rainbow.zsh.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'
  
  # Prompt colors
  local grey='
  # Prompt colors
  local grey='242'
  local red='1'
  local yellow='3'
  local blue='4'
  local magenta='5'
  local cyan='6'
  local white='7'
  local green='2'
  
  # Left prompt segments
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    context                 # user@hostname
    dir                     # current directory
    vcs                     # git status
    command_execution_time  # duration of the last command
    newline                 # move to a new line
    prompt_char             # prompt symbol
  )
  
  # Right prompt segments - we'll keep minimal for demo clarity
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
  
  # Basic style options
  typeset -g POWERLEVEL9K_BACKGROUND=                            # transparent background
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true                # add a newline
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
  
  # Context (username@host)
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE="%n@%m"
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=cyan
  
  # Current Directory
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=blue
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=4
  
  # VCS colors
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=yellow
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=red
  
  # Prompt symbol
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=green
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=red
  
  # Command execution time
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=2
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=yellow
  
  # Transient prompt
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=same-dir
  
  # Instant prompt mode
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
}

(( \${#p10k_config_opts} )) && setopt \${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
EOL

echo -e "${GREEN}✓ ZSH configuration complete${NC}"

# Create demo content
echo -e "\n${BLUE}Creating demo content in ~/.stripe/demo/...${NC}"
mkdir -p ~/.stripe/demo

cat > ~/.stripe/demo/example.js <<EOL
/**
 * Stripe Payment Example
 */
const stripe = require('stripe')('sk_test_example');

async function createPaymentIntent() {
  const paymentIntent = await stripe.paymentIntents.create({
    amount: 2000,
    currency: 'usd',
    payment_method_types: ['card'],
    description: 'Demo payment',
    metadata: {
      order_id: 'demo-12345'
    }
  });
  
  console.log('Payment Intent created:');
  console.log(\`ID: \${paymentIntent.id}\`);
  console.log(\`Status: \${paymentIntent.status}\`);
  console.log(\`Client Secret: \${paymentIntent.client_secret}\`);
  
  return paymentIntent;
}

// Execute function
createPaymentIntent()
  .then(result => console.log('Success!'))
  .catch(error => console.error(\`Error: \${error.message}\`));
EOL

# Create a sample API request file
cat > ~/.stripe/demo/api-request.sh <<EOL
#!/bin/bash

# Example Stripe API Request
echo "Sending request to Stripe API..."
curl -X POST https://api.stripe.com/v1/customers \
  -u sk_test_example: \
  -d name="Demo Customer" \
  -d email="demo@example.com" \
  -d description="Created during live demo"

echo -e "\n\nCreating a payment intent..."
curl -X POST https://api.stripe.com/v1/payment_intents \
  -u sk_test_example: \
  -d amount=1999 \
  -d currency=usd \
  -d "payment_method_types[]"=card \
  -d description="Demo payment intent"
EOL
chmod +x ~/.stripe/demo/api-request.sh

# Create Stripe CLI examples
cat > ~/.stripe/demo/cli-examples.sh <<EOL
#!/bin/bash

# Stripe CLI Examples
# These commands can be copied into your terminal during demos

# Show current account
stripe config --list

# Create a customer
stripe customers create \
  --name="Demo Customer" \
  --email="demo@example.com" \
  --description="Created during live demo"

# List recent payments
stripe payment_intents list --limit 5

# Create a payment intent
stripe payment_intents create \
  --amount=1999 \
  --currency=usd \
  --payment-method-types=card \
  --description="Demo payment intent"

# Start webhook listener
# stripe listen --forward-to http://localhost:3000/webhook

# Trigger webhook event
# stripe trigger payment_intent.succeeded
EOL
chmod +x ~/.stripe/demo/cli-examples.sh

# Create a README for the demo folder
cat > ~/.stripe/demo/README.md <<EOL
# Stripe Demo Files

This folder contains examples for live demonstrations.

## Files:
- **example.js**: Node.js example of creating a PaymentIntent
- **api-request.sh**: Shell script showing API requests to Stripe
- **cli-examples.sh**: Examples of Stripe CLI commands for demos
- **README.md**: This file

## Quick Tips:
1. Use \`demo-title "SECTION NAME"\` to create section headers
2. Use \`demo_mode\` to enable step-by-step command execution
3. Use \`undemo_mode\` to disable step-by-step execution
4. Your current Stripe account is shown in the terminal badge

## Changing Stripe Accounts:
1. \`stripe login\` to authenticate with a different account
2. The terminal badge and title will update automatically
3. Use \`update_stripe_info\` to manually update the display
EOL

echo -e "${GREEN}✓ Demo content created in ~/.stripe/demo/${NC}"

# Create a script to check for Stripe CLI updates
cat > ~/.stripe/check_stripe_cli_updates.sh <<EOL
#!/bin/bash

# Script to check for Stripe CLI updates
CURRENT_VERSION=\$(stripe --version 2>/dev/null | awk '{print \$3}' || echo "")
if [ -z "\$CURRENT_VERSION" ]; then
    echo "Stripe CLI not installed or not in PATH"
    exit 1
fi

LATEST_VERSION=\$(curl -s https://api.github.com/repos/stripe/stripe-cli/releases/latest | grep -Po '"tag_name": "\K.*?(?=")' | sed 's/^v//')
if [ -z "\$LATEST_VERSION" ]; then
    echo "Could not fetch latest version"
    exit 1
fi

if [ "\$CURRENT_VERSION" != "\$LATEST_VERSION" ]; then
    echo "Update available: \$CURRENT_VERSION → \$LATEST_VERSION"
    echo "To update, run: 'brew upgrade stripe'"
else
    echo "Stripe CLI is up to date (\$CURRENT_VERSION)"
fi
EOL
chmod +x ~/.stripe/check_stripe_cli_updates.sh

# Final instructions
echo -e "\n${BLUE}=== Setup Complete ===${NC}"
echo -e "${GREEN}Your Stripe demo terminal profile has been set up successfully!${NC}\n"

echo -e "${YELLOW}To use your new profile:${NC}"
echo -e "1. Launch iTerm2"
echo -e "2. Go to Profiles menu (or press ⌘+O)"
echo -e "3. Select 'Stripe Demo' profile"
echo -e "\n${YELLOW}OR${NC} restart iTerm2 and use this command:\n"
echo -e "${BLUE}open -a iTerm --args -profile \"Stripe Demo\"${NC}\n"

echo -e "${YELLOW}Useful commands:${NC}"
echo -e "- ${BLUE}demo-title \"Section Name\"${NC} - Clear screen and show section header"
echo -e "- ${BLUE}demo_mode${NC} - Enable step-by-step command execution (press Enter between commands)"
echo -e "- ${BLUE}undemo_mode${NC} - Disable step-by-step mode"
echo -e "- ${BLUE}stripe_welcome${NC} - Display the welcome banner again"
echo -e "- ${BLUE}update_stripe_info${NC} - Manually update Stripe account display\n"

echo -e "Demo content is in ${BLUE}~/.stripe/demo/${NC} directory\n"

echo -e "${YELLOW}Note:${NC} When you log in with the Stripe CLI using 'stripe login',"
echo -e "the terminal badge and title will automatically update to show your account.\n"

# Offer to launch iTerm now
read -p "Would you like to launch iTerm with the new profile now? [Y/n]: " LAUNCH_ITERM
LAUNCH_ITERM=${LAUNCH_ITERM:-Y}

if [[ $LAUNCH_ITERM =~ ^[Yy]$ ]]; then
    echo -e "\n${BLUE}Launching iTerm2 with new profile...${NC}"
    open -a iTerm --args -profile "Stripe Demo"
fi

echo -e "\n${GREEN}All done! Happy presenting!${NC}"

