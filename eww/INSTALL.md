# Eww Bar Dependencies

## Required Packages

To make the eww bar work, you need to install the following packages:

```bash
sudo pacman -S jq socat
```

### Package Descriptions

1. **jq** - Command-line JSON processor
   - Used by `get-workspaces` and `get-window-title` scripts to parse Hyprland JSON output
   - Required for workspace management and window title display

2. **socat** - Multipurpose relay (SOcket CAT)
   - Used by `get-workspaces` and `get-window-title` scripts to listen to Hyprland socket events
   - Required for real-time updates when workspaces change or windows are focused

### Already Installed (if you have Hyprland and NetworkManager)

- **eww** - The bar/widget system itself
- **hyprctl** - Comes with Hyprland (used by all scripts)
- **nmcli** - Comes with NetworkManager (used by `get-wifi` script)

### Quick Install Command

```bash
sudo pacman -S jq socat
```

After installation, restart eww:

```bash
eww reload
```

Or if needed:

```bash
eww kill
eww daemon
eww open bar
```
