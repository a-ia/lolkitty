#!/bin/bash
# Config file setup
CONFIG_DIR="$HOME/.config/lolkitty"
CONFIG_FILE="$CONFIG_DIR/config"

# Create default config if it doesn't exist
create_default_config() {
    mkdir -p "$CONFIG_DIR"
    if [[ ! -f "$CONFIG_FILE" ]]; then
        cat > "$CONFIG_FILE" << EOF
# lolkitty configuration
ANIMATION_ENABLED=true    # Set to false to disable animation globally
ANIMATION_DELAY=0.03     # Animation speed (higher = slower)
COLOR_STEP=10           # Color transition speed (higher = faster)
EOF
    fi
}

# Load config
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    fi
}

# Auto-configuration function
auto_setup() {
    local target_dir="$HOME/bin"
    local target_path="$target_dir/lolkitty"
    if [[ "$0" == "$target_path" ]]; then
        return 0
    fi
    if command -v lolkitty >/dev/null 2>&1; then
        return 0
    fi
    echo "Setting up lolkitty in $target_dir..."
    mkdir -p "$target_dir"
    cp "$0" "$target_path"
    chmod +x "$target_path"
    local shell_config=""
    case "$SHELL" in
        */bash)
            shell_config="$HOME/.bashrc"
            ;;
        */zsh)
            shell_config="$HOME/.zshrc"
            ;;
        */fish)
            shell_config="$HOME/.config/fish/config.fish"
            ;;
        *)
            echo "Unsupported shell. Add '$target_dir' to your PATH manually."
            return 0
            ;;
    esac
    if ! echo "$PATH" | grep -q "$HOME/bin"; then
        if [[ "$SHELL" == */fish ]]; then
            echo "set -U fish_user_paths $target_dir \$fish_user_paths" >> "$shell_config"
        else
            echo 'export PATH="$HOME/bin:$PATH"' >> "$shell_config"
        fi
        echo "Added ~/bin to PATH in $shell_config. Please restart your terminal or source your config file."
    fi
    
    # Create default config during setup
    create_default_config
    
    echo "lolkitty has been set up! You can now use it by typing 'lolkitty'."
    echo "Configuration file created at: $CONFIG_FILE"
}

# Command line options handling
handle_options() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --skip)
                SKIP_ANIMATION=true
                shift
                ;;
            --config)
                # Try editors in order of preference
                if command -v nano >/dev/null 2>&1; then
                    nano "$CONFIG_FILE"
                elif command -v vim >/dev/null 2>&1; then
                    vim "$CONFIG_FILE"
                elif command -v vi >/dev/null 2>&1; then
                    vi "$CONFIG_FILE"
                else
                    echo "No text editor found. Please install nano, vim, or vi."
                    echo "Alternatively, you can edit $CONFIG_FILE directly with your preferred editor."
                    exit 1
                fi
                exit 0
                ;;
            --toggle-animation)
                if grep -q "ANIMATION_ENABLED=true" "$CONFIG_FILE"; then
                    sed -i 's/ANIMATION_ENABLED=true/ANIMATION_ENABLED=false/' "$CONFIG_FILE"
                    echo "Animation disabled"
                else
                    sed -i 's/ANIMATION_ENABLED=false/ANIMATION_ENABLED=true/' "$CONFIG_FILE"
                    echo "Animation enabled"
                fi
                exit 0
                ;;
            *)
                break
                ;;
        esac
    done
}

# Initialize script
auto_setup
create_default_config
load_config

# Gradient animation variables
R=255
G=0
B=0
RESET="\e[0m"
ANIMATION_DELAY=${ANIMATION_DELAY:-0.03}
SKIP_ANIMATION=${SKIP_ANIMATION:-false}

# Initialize animation state from config
if [[ "$ANIMATION_ENABLED" == "false" ]]; then
    SKIP_ANIMATION=true
fi

# Handle command line options
handle_options "$@"

# Read input
if [[ -n "$1" ]]; then
    if [[ -f "$1" ]]; then
        input=$(<"$1")
    else
        input="$1"
    fi
else
    input=$(cat)
fi

# Terminal settings
COLOR_STEP=${COLOR_STEP:-10}
TERMINAL_WIDTH=$(tput cols)

# Gradient color calculation
next_color() {
    if (( R == 255 && G < 255 && B == 0 )); then
        G=$(( G + COLOR_STEP < 255 ? G + COLOR_STEP : 255 ))
    elif (( G == 255 && R > 0 )); then
        R=$(( R - COLOR_STEP > 0 ? R - COLOR_STEP : 0 ))
    elif (( G == 255 && B < 255 )); then
        B=$(( B + COLOR_STEP < 255 ? B + COLOR_STEP : 255 ))
    elif (( B == 255 && G > 0 )); then
        G=$(( G - COLOR_STEP > 0 ? G - COLOR_STEP : 0 ))
    elif (( B == 255 && R < 255 )); then
        R=$(( R + COLOR_STEP < 255 ? R + COLOR_STEP : 255 ))
    elif (( R == 255 && B > 0 )); then
        B=$(( B - COLOR_STEP > 0 ? B - COLOR_STEP : 0 ))
    fi
}

# Print character with gradient
print_char() {
    local char="$1"
    echo -ne "\e[38;2;${R};${G};${B}m${char}${RESET}"
    if ! $SKIP_ANIMATION && [[ "$ANIMATION_ENABLED" != "false" ]]; then
        sleep $ANIMATION_DELAY
    fi
}

# Output processing
current_col=0
for word in $input; do
    word_length=$((${#word} + 1))
    if (( current_col + word_length > TERMINAL_WIDTH )); then
        echo
        current_col=0
    fi
    for (( i=0; i<${#word}; i++ )); do
        char="${word:$i:1}"
        print_char "$char"
        next_color
        current_col=$((current_col + 1))
    done
    if (( current_col + 1 < TERMINAL_WIDTH )); then
        print_char " "
        next_color
        current_col=$((current_col + 1))
    fi
done
echo -e "${RESET}"
