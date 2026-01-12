#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
DRY_RUN=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --backup-dir)
            BACKUP_DIR="$2"
            shift 2
            ;;
        --help|-h)
            cat << EOF
Usage: $0 [OPTIONS]

Install dotfiles using GNU Stow.

OPTIONS:
    -n, --dry-run       Show what would be done without making changes
    --backup-dir DIR    Specify custom backup directory (default: ~/.config-backup-TIMESTAMP)
    -h, --help          Show this help message

EOF
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Print colored message
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for GNU Stow
check_stow() {
    if ! command_exists stow; then
        print_warning "GNU Stow is not installed."
        if [[ "$DRY_RUN" == true ]]; then
            print_info "Would install GNU Stow using pacman"
            return 0
        fi
        
        if [[ "$EUID" -eq 0 ]]; then
            print_info "Installing GNU Stow..."
            pacman -S --noconfirm stow
        else
            print_error "GNU Stow is required but not installed."
            print_info "Please install it with: sudo pacman -S stow"
            print_info "Or run this script with sudo to install it automatically"
            exit 1
        fi
    else
        print_success "GNU Stow is installed ($(stow --version | head -n1))"
    fi
}

# Backup existing .config directory
backup_config() {
    if [[ ! -d "$TARGET_DIR/.config" ]]; then
        print_info "No existing .config directory found, skipping backup"
        return 0
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would backup $TARGET_DIR/.config to $BACKUP_DIR"
        return 0
    fi
    
    print_info "Backing up existing .config directory to $BACKUP_DIR"
    mkdir -p "$(dirname "$BACKUP_DIR")"
    cp -r "$TARGET_DIR/.config" "$BACKUP_DIR"
    print_success "Backup created at $BACKUP_DIR"
    print_warning "You can restore your backup with: cp -r $BACKUP_DIR $TARGET_DIR/.config"
}

# Get list of packages to install
get_packages() {
    find "$DOTFILES_DIR" -maxdepth 1 -type d ! -path "$DOTFILES_DIR" ! -name ".*" ! -name "scripts" | \
        while read -r dir; do
            basename "$dir"
        done | sort
}

# Install packages with Stow
install_packages() {
    local packages
    packages=$(get_packages)
    
    if [[ -z "$packages" ]]; then
        print_error "No packages found in $DOTFILES_DIR"
        exit 1
    fi
    
    print_info "Found $(echo "$packages" | wc -l) package(s) to install"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "Dry-run mode: Would install the following packages:"
        echo "$packages" | while read -r pkg; do
            echo "  - $pkg"
        done
        return 0
    fi
    
    cd "$DOTFILES_DIR"
    
    local failed=0
    
    while read -r pkg; do
        if [[ ! -d "$pkg" ]]; then
            print_warning "Package directory $pkg not found, skipping"
            continue
        fi
        
        print_info "Installing package: $pkg"
        
        # Try normal stow first
        if stow --target="$TARGET_DIR" "$pkg" 2>&1; then
            print_success "Installed $pkg"
        else
            # If it fails due to conflicts, try with --adopt to move existing files
            print_warning "Package $pkg has conflicts, trying --adopt mode..."
            if stow --adopt --target="$TARGET_DIR" "$pkg" 2>&1; then
                print_success "Installed $pkg (with --adopt)"
            else
                print_error "Failed to install $pkg"
                failed=1
            fi
        fi
    done <<< "$packages"
    
    echo ""
    if [[ $failed -eq 0 ]]; then
        print_success "Installation complete!"
    else
        print_warning "Some packages failed to install. Check the output above for details."
        exit 1
    fi
}

# Main installation function
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║   Dotfiles Installation Script        ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "DRY-RUN MODE: No changes will be made"
        echo ""
    fi
    
    print_info "Dotfiles directory: $DOTFILES_DIR"
    print_info "Target directory: $TARGET_DIR"
    echo ""
    
    check_stow
    backup_config
    echo ""
    install_packages
    
    echo ""
    print_success "All done! Your dotfiles are now installed."
    print_info "You can uninstall packages with: stow -D --target=$TARGET_DIR <package-name>"
}

# Run main function
main
