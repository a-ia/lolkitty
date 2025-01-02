# lolkitty: Rainbow Text Renderer 🌈 🐱

**lolkitty** is a lightweight Bash script that outputs text into a rainbow gradient color. 
It is a script I made for personal use, inspired by lolcat! :3 
I will be revisiting this project therefore modifications and additions will be applied to the script in the future.

---

## Features
- Supports animated or static rainbow gradients
- Permanent or temporary animation toggles.
- Works with text from stdin or files.
- Cross-shell compatibility (e.g., Bash, Zsh, Fish).
- Automatically installs itself to `~/bin` for easy access across sessions.
- Detects terminal width and wraps text gracefully.
- Persistent configuration system

---

## Installation

### Automatic Setup
Simply execute the script. It automatically sets itself up:
```bash
./lolkitty
```
The setup process will:
1. Copy the script to `~/bin`.
2. Make the script executable.
3. Add `~/bin` to your `PATH` in `~/.bashrc`, `~/.zshrc`, or equivalent Fish shell configuration if needed.

---

## Usage

#### Basic Usage:
*Print text directly.*
```bash
lolkitty "Meow"
```

#### From standard input "stdin":
*Pipe text into the script.*
```bash
echo "Hello, meow world! >:3 " | lolkitty
```

#### From a file:
*Run the script and pass the file containing the text.*
```bash
lolkitty input.txt
```

### Skip Animation
To display the gradient without animation, use:
```bash
lolkitty --skip "dismanteling ur interwebz so u haz to play with me meow"
```
```bash
echo "in ur cpuz playing gamez with ur threadz meow" | lolkiity --skip
```
```bash
lolkitty input.txt --skip
```

---

## Configuration System

### Configuration File
lolkitty stores its settings in `~/.config/lolkitty/config`

### Default Configuration
```bash
# lolkitty configuration
ANIMATION_ENABLED=true    # Set to false to disable animation globally
ANIMATION_DELAY=0.03     # Animation speed (higher = slower)
COLOR_STEP=10           # Color transition speed (higher = faster)
```

### Managing Configuration
- Use `lolkitty --config` to edit settings in your default editor
- Use `lolkitty --toggle-animation` to quickly toggle animation on/off
- Changes take effect immediately for new lolkitty commands

---

## Customization Options

### Animation Settings
- `ANIMATION_DELAY`: Controls animation speed
  ```bash
  # In ~/.config/lolkitty/config
  ANIMATION_DELAY=0.1    # Slower animation
  ANIMATION_DELAY=0.01   # Faster animation
  ```

### Color Settings
- `COLOR_STEP`: Controls color transition speed
  ```bash
  # In ~/.config/lolkitty/config
  COLOR_STEP=5    # Smoother transitions
  COLOR_STEP=20   # Faster transitions
  ```

### Initial Colors
Modify starting colors in the script:
```bash
R=255  # Red component (0-255)
G=0    # Green component (0-255)
B=0    # Blue component (0-255)
```

### Text Formatting
Override terminal width:
```bash
TERMINAL_WIDTH=80  # Force specific width
```

### Advanced Customizations

#### Custom Color Patterns
Modify the gradient pattern by editing the `next_color` function:
```bash
next_color() {
    if (( R == 255 && B < 255 )); then
        B=$(( B + COLOR_STEP < 255 ? B + COLOR_STEP : 255 ))
    elif (( B == 255 && R > 0 )); then
        R=$(( R - COLOR_STEP > 0 ? R - COLOR_STEP : 0 ))
    # ... add your own color transition rules
    fi
}
```

#### Installation Directory
Change the default installation location:
```bash
local target_dir="/usr/local/bin"  # Alternative location
```

---

## Shell Compatibility

### Bash
- The script automatically modifies your `~/.bashrc` to include `~/bin` in your `PATH` if it is not already set.
- Changes take effect after restarting the terminal or running `source ~/.bashrc`.

### Zsh
- If Zsh is detected, the script adds `~/bin` to your `PATH` in `~/.zshrc` using:
  ```bash
  export PATH="$HOME/bin:$PATH"
  ```
- Changes take effect after restarting the terminal or running `source ~/.zshrc`.

### Fish
- If Fish is detected, the script adds `~/bin` to `fish_user_paths` using:
  ```fish
  set --universal fish_user_paths ~/bin $fish_user_paths
  ```
- Changes take effect immediately.

---

## Troubleshooting

### Command Not Found
- Ensure `~/bin` is in your PATH
- Restart terminal or source config file
- Check installation with `which lolkitty`

### Configuration Issues
- Verify config file exists: `cat ~/.config/lolkitty/config`
- Try recreating config file with default values
- Check file permissions

### Display Issues
- Verify 24-bit color support: `echo $COLORTERM`
- Check terminal compatibility
- Try different color settings

---

## Troubleshooting
**PATH Issues**
- If the command lolkitty is not found, ensure ~/bin is in your PATH.
- Restart your terminal after installation.

**Incorrect Colors**
- Ensure your terminal supports 24-bit color.


---

## Contributing
Anyone interested in contributing can submit pull requests for new features, optimizations, or bug fixes. Contributions are always welcome.

---
