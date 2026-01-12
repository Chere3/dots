# 🌟 Arch Linux Dotfiles

A modern, reproducible, and elegant dotfiles configuration for Arch Linux using GNU Stow.

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![GNU Stow](https://img.shields.io/badge/GNU_Stow-1.0-blue?style=for-the-badge)

## ✨ Features

- 🎨 Clean and organized configuration structure
- 🔧 Fully reproducible system configuration
- 📦 Modular package management with GNU Stow
- 🚀 Easy installation and management
- 📝 Well-documented setup process
- 🎯 Optimized for daily use

## 🛠️ Technologies

### System Configuration

- **OS**: Arch Linux
- **Window Manager**: Hyprland
- **Shell**: Zsh with Starship prompt
- **Terminal**: Kitty
- **File Manager**: Thunar
- **Audio**: Pipewire, PulseAudio

### Included Packages

This dotfiles repository includes configurations for:

- **dconf** - Desktop configuration
- **go** - Go development environment
- **gtk-3-0** - GTK 3.0 theme configuration
- **hypr** - Hyprland window manager
- **kitty** - Kitty terminal emulator
- **pavucontrol** - PulseAudio Volume Control
- **pipewire** - Pipewire audio system
- **pulse** - PulseAudio configuration
- **starship** - Starship prompt configuration
- **systemd** - Systemd user services
- **thunar** - Thunar file manager
- **xfce4** - XFCE4 desktop environment
- **yay** - Yay AUR helper configuration

> **Note:** Browser profiles, cache directories, and sensitive data are excluded from this repository. Only actual configuration files are version controlled.

## 📥 Quick Installation

### Prerequisites

- Arch Linux (or compatible distribution)
- GNU Stow (will be installed automatically if missing)
- Git (for cloning this repository)

### Installation Steps

1. **Clone the repository:**

```bash
git clone <your-repository-url> ~/.dotfiles
cd ~/.dotfiles
```

2. **Run the installation script:**

```bash
./install.sh
```

The script will:
- Check for GNU Stow and install it if missing
- Backup your existing `.config` directory
- Create symlinks for all packages using Stow

3. **Verify installation:**

```bash
ls -la ~/.config
```

You should see your configuration directories linked to the dotfiles repository.

### Dry Run

To see what would be installed without making changes:

```bash
./install.sh --dry-run
```

### Custom Backup Directory

To specify a custom backup directory:

```bash
./install.sh --backup-dir ~/my-backup
```

## 🔧 Usage

### Installing Individual Packages

To install a specific package:

```bash
cd ~/.dotfiles
stow --target="$HOME" <package-name>
```

Example:
```bash
stow --target="$HOME" hypr
```

### Uninstalling Packages

To remove a package (delete symlinks):

```bash
cd ~/.dotfiles
stow -D --target="$HOME" <package-name>
```

Example:
```bash
stow -D --target="$HOME" hypr
```

### Restowing Packages

To update symlinks after making changes:

```bash
cd ~/.dotfiles
stow --restow --target="$HOME" <package-name>
```

Or restow all packages:

```bash
cd ~/.dotfiles
find . -maxdepth 1 -type d ! -path . ! -name ".*" | \
    xargs -I {} stow --restow --target="$HOME" {}
```

## 📁 Structure

```
.dotfiles/
├── .gitignore              # Git ignore rules
├── .stowrc                 # Stow configuration
├── install.sh              # Installation script
├── README.md               # This file
├── <package-name>/         # Individual package directories
│   └── .config/
│       └── <app-name>/     # Application configuration
└── ...
```

Each package follows the structure: `package-name/.config/app-name/` which creates symlinks from `~/.config/app-name/` to the dotfiles repository.

## 🎨 Customization

### Adding New Packages

1. Create a new directory for your package:
```bash
mkdir -p ~/.dotfiles/my-app/.config/my-app
```

2. Add your configuration files:
```bash
cp ~/.config/my-app/* ~/.dotfiles/my-app/.config/my-app/
```

3. Install the package:
```bash
cd ~/.dotfiles
stow --target="$HOME" my-app
```

### Modifying Existing Packages

1. Edit files in the package directory:
```bash
nano ~/.dotfiles/hypr/.config/hypr/hyprland.conf
```

2. Restow the package to update symlinks:
```bash
cd ~/.dotfiles
stow --restow --target="$HOME" hypr
```

## 🔄 Backup and Restore

### Backup

The installation script automatically creates a backup of your existing `.config` directory before installation. Backups are stored in `~/.config-backup-TIMESTAMP`.

### Restore from Backup

To restore your original configuration:

```bash
cp -r ~/.config-backup-TIMESTAMP ~/.config
```

Or restore a specific package:

```bash
cp -r ~/.config-backup-TIMESTAMP/<app-name> ~/.config/
```

## 🐛 Troubleshooting

### Symlinks Not Working

If symlinks are not being created:

1. Check that GNU Stow is installed:
```bash
which stow
```

2. Verify the package structure is correct:
```bash
ls -la ~/.dotfiles/<package-name>/.config/
```

3. Try reinstalling the package:
```bash
cd ~/.dotfiles
stow -D --target="$HOME" <package-name>
stow --target="$HOME" <package-name>
```

### Conflicts with Existing Files

If you have existing files that conflict with dotfiles:

1. Backup the conflicting files:
```bash
mv ~/.config/<app-name> ~/.config/<app-name>.backup
```

2. Install the package:
```bash
cd ~/.dotfiles
stow --target="$HOME" <package-name>
```

3. Compare and merge configurations if needed

### Permission Issues

If you encounter permission issues:

1. Check file permissions:
```bash
ls -la ~/.dotfiles/<package-name>/
```

2. Fix permissions if needed:
```bash
chmod -R u+rw ~/.dotfiles/<package-name>/
```

## 📝 Notes

- Always backup your configuration before installation
- Only actual configuration files are included (browser profiles, cache, and sensitive data are excluded)
- The `.gitignore` file excludes sensitive data and cache directories
- Some packages may require additional system configuration
- Browser configurations are intentionally excluded from version control

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

When contributing:
1. Follow the existing package structure
2. Update this README if adding new packages
3. Test your changes before submitting
4. Ensure sensitive data is excluded via `.gitignore`

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Inspired by modern dotfiles management practices
- Structure adapted from [Chere3/dots-nixos](https://github.com/Chere3/dots-nixos)
- Uses [GNU Stow](https://www.gnu.org/software/stow/) for symlink management

---

Made with ❤️ using Arch Linux
