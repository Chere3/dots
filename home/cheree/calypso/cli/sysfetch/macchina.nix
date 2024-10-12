{ pkgs, ... }:
let
  config = ''
    # Specifies the network interface to use for the LocalIP readout
    interface = "wlan0"

    # Lengthen uptime output
    long_uptime = true

    # Lengthen shell output
    long_shell = false

    # Lengthen kernel output
    long_kernel = false

    # Toggle between displaying the current shell or your user's default one.
    current_shell = true

    # Toggle between displaying the number of physical or logical cores of your
    # processor.
    physical_cores = true

    # Themes need to be placed in "$XDG_CONFIG_DIR/macchina/themes" beforehand.
    # e.g.:
    #  if theme path is /home/foo/.config/macchina/themes/Sodium.toml
    #  theme should be uncommented and set to "Sodium"
    #
    theme = "mezora"

    # Displays only the specified readouts.
    # Accepted values (case-sensitive):
    #   - Host
    #   - Machine
    #   - Kernel
    #   - Distribution
    #   - OperatingSystem
    #   - DesktopEnvironment
    #   - WindowManager
    #   - Resolution
    #   - Backlight
    #   - Packages
    #   - LocalIP
    #   - Terminal
    #   - Shell
    #   - Uptime
    #   - Processor
    #   - ProcessorLoad
    #   - Memory
    #   - Battery
    #   - GPU
    #   - DiskSpace
    # Example:
    show = ["Kernel", "Distribution", "Memory", "Processor", "Uptime", "WindowManager"]
  '';
  theme = ''
    separator=""
    separator_color="blue"
    key_color="blue"
    prefer_small_ascii = true
    hide_ascii = true

    [palette]
    type="Dark"
    visible=true
    glyph=" ⬤ "

    [box]
    title=" cheree "
    border="double"
    visible=true

    [bar]
    glyph="▮ "
    hide_delimiters=true
    visible=true

    [randomize]
    key_color=false
    separator_color=false

    [keys]
    host=" host"
    kernel="󱂸 kernel"
    distro=" distro"
    packages=" packages"
    terminal=" terminal"
    shell=" shell"
    cpu=" cpu"
    cpu_load=" cpu"
    memory=" memory"
    battery=" battery"
  '';
in
{
  home.packages = with pkgs; [ macchina ];

  xdg.configFile."macchina/macchina.toml".text = config;
  xdg.configFile."macchina/themes/mezora.toml".text = theme;
}
