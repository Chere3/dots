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

# Calculate relative path from source to target
# This is a manual implementation that works even if realpath is not available
calculate_relative_path() {
    local source="$1"
    local target="$2"
    
    # Normalize paths (remove trailing slashes, ensure absolute)
    source="${source%/}"
    target="${target%/}"
    
    # Convert to absolute paths if needed
    [[ "$source" != /* ]] && source="$(cd "$(dirname "$source")" && pwd)/$(basename "$source")"
    [[ "$target" != /* ]] && target="$(cd "$(dirname "$target")" && pwd)/$(basename "$target")"
    
    # Split paths into arrays (skip empty first element from leading /)
    local source_parts=()
    local target_parts=()
    
    IFS='/' read -ra temp_source <<< "$source"
    IFS='/' read -ra temp_target <<< "$target"
    
    # Skip empty first element (from leading /)
    for ((i=1; i<${#temp_source[@]}; i++)); do
        source_parts+=("${temp_source[$i]}")
    done
    
    for ((i=1; i<${#temp_target[@]}; i++)); do
        target_parts+=("${temp_target[$i]}")
    done
    
    # Find common prefix length
    local common_len=0
    while [[ $common_len -lt ${#source_parts[@]} && $common_len -lt ${#target_parts[@]} && "${source_parts[$common_len]}" == "${target_parts[$common_len]}" ]]; do
        ((common_len++))
    done
    
    # Build relative path
    local result=""
    local depth=$(( ${#source_parts[@]} - common_len ))
    
    # Add .. for each directory level to go up
    for ((j=0; j<depth; j++)); do
        result="${result}../"
    done
    
    # Add remaining target path
    for ((j=common_len; j<${#target_parts[@]}; j++)); do
        result="${result}${target_parts[$j]}"
        if [[ $j -lt $((${#target_parts[@]} - 1)) ]]; then
            result="${result}/"
        fi
    done
    
    # If result is empty, it's the same directory
    [[ -z "$result" ]] && result="."
    
    echo "$result"
}

# Fix absolute symlinks in a package (convert to relative)
fix_absolute_symlinks() {
    local pkg_dir="$1"
    local fixed=0
    local symlinks_found=0
    
    if [[ ! -d "$pkg_dir" ]]; then
        return 0
    fi
    
    # Find all symlinks in the package directory with timeout and depth limit
    local temp_file
    temp_file=$(mktemp)
    
    # Use timeout and limit depth to prevent hanging on large directory trees
    # Limit to 10 levels deep which should be more than enough for systemd configs
    if command_exists timeout; then
        timeout 3 find "$pkg_dir" -maxdepth 10 -type l 2>/dev/null > "$temp_file" || true
    else
        find "$pkg_dir" -maxdepth 10 -type l 2>/dev/null > "$temp_file" || true
    fi
    
    # Check if any symlinks were found
    if [[ ! -s "$temp_file" ]]; then
        rm -f "$temp_file"
        print_info "No symlinks found in $(basename "$pkg_dir"), skipping symlink fix"
        return 0
    fi
    
    # Process each symlink
    while IFS= read -r symlink; do
        [[ -z "$symlink" ]] && continue
        ((symlinks_found++))
        
        # Get symlink target (simple readlink, no -f to avoid hanging)
        local target
        target=$(readlink "$symlink" 2>/dev/null || echo "")
        
        # Check if it's an absolute symlink
        if [[ "$target" == /* ]]; then
            # Get symlink directory (use simple dirname, avoid readlink -f)
            local symlink_dir
            symlink_dir=$(cd "$(dirname "$symlink")" 2>/dev/null && pwd || dirname "$symlink")
            local relative_target
            
            # Try realpath first (more accurate), fall back to manual calculation
            if command_exists realpath && [[ -e "$target" ]]; then
                relative_target=$(timeout 2 realpath --relative-to="$symlink_dir" "$target" 2>/dev/null || echo "")
            fi
            
            # If realpath failed or doesn't exist, use manual calculation
            if [[ -z "$relative_target" ]]; then
                relative_target=$(calculate_relative_path "$symlink_dir" "$target")
            fi
            
            if [[ -n "$relative_target" && "$relative_target" != "." ]]; then
                if [[ "$DRY_RUN" == true ]]; then
                    print_info "Would convert absolute symlink: $symlink -> $target (to relative: $relative_target)"
                else
                    rm -f "$symlink"
                    ln -s "$relative_target" "$symlink" 2>/dev/null || true
                    ((fixed++))
                fi
            else
                print_warning "Could not convert absolute symlink: $symlink -> $target"
            fi
        fi
    done < "$temp_file"
    
    rm -f "$temp_file"
    
    if [[ $fixed -gt 0 && "$DRY_RUN" != true ]]; then
        print_info "Fixed $fixed absolute symlink(s) in $(basename "$pkg_dir")"
    elif [[ $symlinks_found -eq 0 ]]; then
        print_info "No symlinks found in $(basename "$pkg_dir")"
    fi
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
        
        # For systemd package, fix absolute symlinks first (before stow tries to process them)
        if [[ "$pkg" == "systemd" ]]; then
            print_info "Pre-fixing absolute symlinks in $pkg..."
            # Run fix with strict timeout to prevent hanging
            if command_exists timeout; then
                timeout 5 bash -c "$(declare -f fix_absolute_symlinks calculate_relative_path command_exists print_info print_warning); fix_absolute_symlinks '$pkg'" 2>/dev/null || {
                    print_warning "Symlink fix timed out or failed, will try stow anyway..."
                }
            else
                # Without timeout, just try quickly and move on
                fix_absolute_symlinks "$pkg" 2>/dev/null || true
            fi
            
            # Remove existing conflicting files/symlinks that aren't owned by stow
            print_info "Cleaning up existing systemd user service files..."
            local systemd_user_dir="$TARGET_DIR/.config/systemd/user"
            if [[ -d "$systemd_user_dir" ]]; then
                # Remove the specific conflicting files mentioned in stow errors
                local conflicts=(
                    "default.target.wants/pipewire-pulse.service"
                    "default.target.wants/pipewire.service"
                    "pipewire-session-manager.service"
                    "pipewire.service.wants/wireplumber.service"
                    "sockets.target.wants/pipewire-pulse.socket"
                    "sockets.target.wants/pipewire.socket"
                )
                
                for conflict in "${conflicts[@]}"; do
                    local conflict_path="$systemd_user_dir/$conflict"
                    if [[ -e "$conflict_path" ]]; then
                        rm -f "$conflict_path" 2>/dev/null || true
                    fi
                done
            fi
        fi
        
        # Try normal stow first (with timeout to prevent hanging)
        local stow_output=""
        local stow_exit=0
        
        if command_exists timeout; then
            # Run stow with timeout - capture output separately to avoid hanging
            set +e  # Don't exit on error
            stow_output=$(timeout 10 stow --target="$TARGET_DIR" "$pkg" 2>&1)
            stow_exit=$?
            set -e  # Re-enable exit on error
            
            # Check if it was a timeout (exit code 124 or 143)
            if [[ $stow_exit -eq 124 ]] || [[ $stow_exit -eq 143 ]]; then
                # 124 = timeout, 143 = SIGTERM from timeout
                print_error "Stow timed out for $pkg (likely due to symlink issues)"
                print_warning "Skipping $pkg - you may need to fix symlinks manually"
                failed=1
                continue
            fi
        else
            # Without timeout, just run stow normally
            set +e  # Don't exit on error
            stow_output=$(stow --target="$TARGET_DIR" "$pkg" 2>&1)
            stow_exit=$?
            set -e  # Re-enable exit on error
        fi
        
        if [[ $stow_exit -eq 0 ]]; then
            print_success "Installed $pkg"
        else
            # Check if the error is due to "not owned by stow" - need to remove conflicting files
            if echo "$stow_output" | grep -q "not owned by stow"; then
                print_warning "Package $pkg has files not owned by stow, removing them..."
                # Extract the conflicting file paths from stow output
                local conflicts
                conflicts=$(echo "$stow_output" | grep "not owned by stow" | sed 's/.*: //' | sed "s|^|$TARGET_DIR/|")
                
                # Remove each conflicting file
                while IFS= read -r conflict; do
                    [[ -z "$conflict" ]] && continue
                    if [[ -e "$conflict" ]]; then
                        rm -f "$conflict" 2>/dev/null || true
                    fi
                done <<< "$conflicts"
                
                # Try stow again after removing conflicts
                if stow --target="$TARGET_DIR" "$pkg" 2>&1; then
                    print_success "Installed $pkg (after removing conflicts)"
                else
                    # If it still fails, try with --adopt
                    print_warning "Still having issues, trying --adopt mode..."
                    if stow --adopt --target="$TARGET_DIR" "$pkg" 2>&1; then
                        print_success "Installed $pkg (with --adopt)"
                    else
                        print_error "Failed to install $pkg"
                        failed=1
                    fi
                fi
            # Check if the error is due to absolute symlinks
            elif echo "$stow_output" | grep -q "absolute symlink"; then
                print_warning "Package $pkg has absolute symlinks, fixing them..."
                fix_absolute_symlinks "$pkg" || {
                    print_warning "Symlink fix had issues, continuing anyway..."
                }
                # Try stow again after fixing
                if stow --target="$TARGET_DIR" "$pkg" 2>&1; then
                    print_success "Installed $pkg (after fixing symlinks)"
                else
                    # If it still fails, try with --adopt
                    print_warning "Still having issues, trying --adopt mode..."
                    if stow --adopt --target="$TARGET_DIR" "$pkg" 2>&1; then
                        print_success "Installed $pkg (with --adopt)"
                    else
                        print_error "Failed to install $pkg"
                        failed=1
                    fi
                fi
            else
                # If it fails due to other conflicts, try with --adopt to move existing files
                print_warning "Package $pkg has conflicts, trying --adopt mode..."
                if stow --adopt --target="$TARGET_DIR" "$pkg" 2>&1; then
                    print_success "Installed $pkg (with --adopt)"
                else
                    print_error "Failed to install $pkg"
                    failed=1
                fi
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
