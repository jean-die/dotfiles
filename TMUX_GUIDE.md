# Tmux Configuration Guide

## Overview

This guide covers the tmux configuration setup with automatic deployment for SSH sessions, featuring Catppuccin Frappe theme integration and modern keybindings.

## Installation

### Local Setup

```bash
# Install tmux
make tmux

# Install tmux with plugins
make tmux-plugins

# Or manually install plugins: Prefix + I (Ctrl-b + I)
```

### Remote Server Deployment

```bash
# Deploy to any server
deploy-tmux user@server.com
deploy-tmux vastai-server

# SSH with automatic tmux deployment
ssh-tmux user@server.com
ssh-tmux vastai-server

# Manual deployment
~/.config/tmux/deploy-tmux.sh user@server.com
```

## Key Bindings

### Pane Navigation

| Key Combination | Action |
|----------------|--------|
| `Ctrl-h` | Move to left pane |
| `Ctrl-j` | Move to down pane |
| `Ctrl-k` | Move to up pane |
| `Ctrl-l` | Move to right pane |
| `Arrow Keys` | Alternative pane navigation |

### Pane Management

| Key Combination | Action |
|----------------|--------|
| `\|` (pipe) | Split pane horizontally |
| `-` (minus) | Split pane vertically |
| `Ctrl-Up/Down/Left/Right` | Resize pane |
| `Ctrl-s` | Synchronize panes (broadcast input) |

### Window Management

| Key Combination | Action |
|----------------|--------|
| `Ctrl-t` | New window/tab |
| `Ctrl-w` | Close window/tab |
| `Ctrl-n` | Next window |
| `Ctrl-p` | Previous window |
| `Ctrl-r` | Rename window |

### Copy Mode (Vi-style)

| Key Combination | Action |
|----------------|--------|
| `Prefix + [` | Enter copy mode |
| `Space` | Start selection |
| `Enter` | Copy selection |
| `y` | Copy to system clipboard |
| `q` | Exit copy mode |

### Plugin Management (Local Only)

| Key Combination | Action |
|----------------|--------|
| `Prefix + I` | Install plugins |
| `Prefix + U` | Update plugins |
| `Prefix + Alt + u` | Remove plugins |

## Example Workflows

### Workflow 1: Setting up a new development server

```bash
# Deploy tmux configuration to server
deploy-tmux dev-server.example.com

# SSH to server (tmux auto-starts)
ssh dev-server.example.com

# Inside tmux session:
# - Split terminal vertically for code/logs
Prefix + |

# - Create new window for testing
Ctrl-t

# - Rename window to "tests"
Ctrl-r
# Type: tests

# - Synchronize panes for multi-server commands
Ctrl-s
```

### Workflow 2: Working with VastAI instances

```bash
# Deploy tmux and sync data in one command
ssh-tmux vastai-server

# Inside the VastAI instance tmux session:
# - Split for monitoring GPU usage
Prefix + |

# - Left pane: main work
# - Right pane: monitoring
nvidia-smi -l 1

# - Create new window for experiments
Ctrl-t

# - Copy commands between panes
# Enter copy mode: Prefix + [
# Select text, copy with 'y'
# Paste with: Prefix + ]
```

### Workflow 3: Multi-server management

```bash
# Deploy to multiple servers
deploy-tmux server1.com
deploy-tmux server2.com
deploy-tmux server3.com

# Connect to first server
ssh-tmux server1.com

# Inside tmux, create multiple windows for different servers
Ctrl-t  # New window
# SSH to server2 from within tmux
ssh server2.com

Ctrl-t  # Another new window
# SSH to server3 from within tmux
ssh server3.com

# Navigate between servers using:
Ctrl-n  # Next window (server)
Ctrl-p  # Previous window (server)
```

### Workflow 4: Development session management

```bash
# Connect to development server
ssh-tmux dev.company.com

# Set up development environment:
# Window 1: Editor
nvim project/

# Window 2: Tests (Ctrl-t to create)
Ctrl-t
pytest --watch

# Window 3: Logs (Ctrl-t to create)
Ctrl-t
tail -f /var/log/app.log

# Window 4: Database (Ctrl-t to create)
Ctrl-t
psql mydb

# Split current window for multiple log files
Prefix + |
tail -f /var/log/error.log

# Navigate efficiently:
# Ctrl-n/Ctrl-p between windows
# Ctrl-h/j/k/l between panes within window
```

## Configuration Files

### Local Configuration (with plugins)
- **Location**: `~/.config/tmux/tmux.conf`
- **Features**: Full plugin support, Catppuccin theme, session persistence
- **Plugins**: TPM, tmux-sensible, tmux-resurrect, tmux-continuum, vim-tmux-navigator

### Server Configuration (portable)
- **Location**: `~/.config/tmux/tmux-server.conf`
- **Features**: Plugin-free, manual Catppuccin styling, maximum compatibility
- **Deployed to**: `~/.config/tmux/tmux.conf` on remote servers

## Troubleshooting

### Common Issues

**Tmux not auto-starting on SSH:**
```bash
# Check if auto-tmux script exists
ls -la ~/.local-auto-tmux.sh

# Manually source the script
source ~/.local-auto-tmux.sh
```

**Key bindings not working:**
```bash
# Reload tmux configuration
tmux source-file ~/.config/tmux/tmux.conf

# Or use prefix command
Prefix + :
source-file ~/.config/tmux/tmux.conf
```

**Clipboard not working on server:**
```bash
# Install xclip (Linux) or ensure pbcopy (macOS) is available
sudo apt install xclip  # Ubuntu/Debian
sudo yum install xclip  # CentOS/RHEL
```

**Colors not displaying correctly:**
```bash
# Check terminal color support
echo $TERM

# Should be: xterm-256color or screen-256color
# Set in your shell profile if needed:
export TERM=xterm-256color
```

### Plugin Issues (Local only)

**Plugins not installing:**
```bash
# Manually clone TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Run installation script
~/.tmux/plugins/tpm/scripts/install_plugins.sh
```

**Theme not loading:**
```bash
# Check if Catppuccin plugin is installed
ls ~/.tmux/plugins/tmux/

# Manually install if missing
git clone https://github.com/catppuccin/tmux.git ~/.tmux/plugins/tmux
```

## Advanced Usage

### Session Management

```bash
# Create named session
tmux new-session -s work

# List sessions
tmux list-sessions

# Attach to specific session
tmux attach-session -t work

# Detach from session
Prefix + d

# Kill session
tmux kill-session -t work
```

### Remote Session Persistence

With `tmux-continuum` plugin (local) or manual session management (server):

```bash
# Sessions automatically save every 15 minutes (local)
# Manual save (server):
Prefix + Ctrl-s

# Restore sessions on next login (automatic on local)
# Manual restore (server):
tmux new-session -s main
```

### Custom Server Deployment

For servers with specific requirements:

```bash
# Edit server config before deployment
nvim ~/.config/tmux/tmux-server.conf

# Deploy custom configuration
deploy-tmux special-server.com
```

## Files Structure

```
dotfiles/
├── .config/tmux/
│   ├── tmux.conf           # Local config (with plugins)
│   ├── tmux-server.conf    # Portable server config
│   └── deploy-tmux.sh      # Deployment script
├── dot-zshrc               # Shell functions
└── Makefile               # Installation targets
```

## Useful Commands Reference

### Tmux Native Commands

```bash
# Session management
tmux new-session -s <name>
tmux list-sessions
tmux attach-session -t <name>
tmux kill-session -t <name>

# Window management
tmux new-window
tmux list-windows
tmux rename-window <name>

# Pane management
tmux split-window -h
tmux split-window -v
tmux list-panes
```

### Custom Aliases

```bash
# Deployment
deploy-tmux <host>          # Deploy config to remote host
ssh-tmux <host>             # Deploy and connect with tmux

# VastAI integration
vastai-sync                 # Sync with VastAI (custom workflow)
```

## Tips and Best Practices

1. **Always deploy config before important sessions** to ensure consistent experience
2. **Use window names** (`Ctrl-r`) to organize long-running sessions
3. **Leverage pane synchronization** (`Ctrl-s`) for multi-server command execution
4. **Copy between panes** using copy mode for efficient command reuse
5. **Detach sessions** (`Prefix + d`) instead of closing to preserve work
6. **Use named sessions** for different projects or contexts
