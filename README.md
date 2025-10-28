# BLUX10K

Professional developer terminal setup for every major platform. BLUX10K delivers a curated Zsh environment powered by Oh My Zsh, Powerlevel10k, and zplug with batteries-included tooling and cross-platform automation.

## Highlights

- **Curated `.zshrc`** with 24 documented sections, platform detection, plugin management, and opinionated aliases.
- **Universal `update` function v2.1** with retry/backoff logic, manager filtering, dry-run support, and activity logging.
- **Cross-platform installer** that bootstraps prerequisites, fonts, and configuration files on Linux, macOS, WSL, and Termux.
- **Modern CLI toolchain** featuring `fzf`, `fd`, `ripgrep`, `bat`, `eza`, `zoxide`, and Neovim along with language runtimes.
- **Custom theming** for Powerlevel10k, Neofetch, and private environment scaffolding.

## Repository Layout

```
configs/
  ├── .p10k.zsh              # Lean Powerlevel10k prompt preset
  ├── .zshrc                 # Primary shell configuration (24 sections)
  ├── env.zsh.example        # Template for private environment variables
  └── neofetch/config.conf   # Custom system dashboard
scripts/
  └── install.sh             # Bootstrap installer
```

## Getting Started

### 1. Run the installer

```bash
bash scripts/install.sh
```

The script detects your platform, installs required packages, deploys configuration files, and initializes plugins. It also ensures MesloLGS NF Nerd Font is available and performs a dry-run of the universal `update` command.

> **Note:** The installer prompts for confirmation before making changes and may require `sudo` access for package installation.

### 2. Set your terminal font

Set **MesloLGS NF** (or another Nerd Font variant) in your terminal emulator for correct Powerlevel10k glyph rendering.

### 3. Customize secrets and prompt

1. Edit `~/.config/private/env.zsh` with your API keys (file is created with `0600` permissions).
2. Run `p10k configure` to personalize the prompt, or keep the lean preset shipped in `configs/.p10k.zsh`.

## `.zshrc` Overview

The configuration is organized into the following numbered sections (0-24):

0. ASCII banner & MOTD
1. Performance tweaks
2. zplug bootstrap & plugin declarations
3. Private environment loading
4. XDG directory enforcement
5. History management (rotated monthly)
6. Shell behavior defaults and key bindings
7. Path curation with cross-platform additions
8. Color initialization
9. Platform detection (WSL, Termux, macOS)
10. Truecolor settings and BAT theming
11. Plugin configuration (autosuggestions, syntax highlighting, etc.)
12. FZF + FD integration
13. Aliases (navigation, safety, tooling, package helpers)
14. Utility functions (extract, killport, git helpers)
15. Keybindings for history search, zoxide, and menu select
16. SSH agent bootstrap with multi-key loading
17. GPG TTY forwarding
18. Docker/Podman environment defaults
19. `update` function and helpers (v2.1)
20. Completion wiring and aliases for `update`
21. Session reload + health checks
22. Local overrides (`~/.zshrc.local`, `~/.zsh_aliases`)
23. Byte-code compilation for faster startup
24. MOTD via Neofetch/Fastfetch

### Universal `update` Function

The `update` function centralizes package maintenance with features such as:

- Manager coverage: `apt`, `snap`, `flatpak`, `pip`, `pipx`, `npm`, `pnpm`, `cargo`, `rustup`, `docker`, `oh-my-zsh`, `fwupdmgr`.
- Flags: `-n/--dry-run`, `-q/--quiet`, `-v/--verbose`, `--only`, `--exclude`, and more.
- Retry logic with exponential backoff, per-manager checks, and log files stored in `${XDG_STATE_HOME:-$HOME/.local/state}/sysupdate/logs`.
- Reboot detection and `systemctl --failed` reporting when available.

Use `update -n` for a safe preview or `update --only apt,pip` to target specific managers.

## Manual Installation

If you prefer to install dependencies manually:

1. Install Zsh, Git, curl, wget, and recommended tools listed in `scripts/install.sh` for your platform.
2. Clone the repository and copy the configs:
   ```bash
   cp configs/.zshrc ~/.zshrc
   cp configs/.p10k.zsh ~/.p10k.zsh
   mkdir -p ~/.config/neofetch ~/.config/private
   cp configs/neofetch/config.conf ~/.config/neofetch/config.conf
   cp configs/env.zsh.example ~/.config/private/env.zsh
   chmod 600 ~/.config/private/env.zsh
   ```
3. Open a new Zsh session to activate the configuration.

## Testing Checklist

After installation verify the environment with:

```bash
which nvim fzf fd rg bat eza zoxide git gpg ssh-agent
zsh --version
update -n
```

Check that Neofetch or Fastfetch displays on shell start and confirm that autosuggestions, syntax highlighting, history substring search, and the `z` jump command behave as expected.

## Troubleshooting

- **Fonts missing icons:** ensure MesloLGS NF is installed and selected in your terminal.
- **Debian `bat`/`fd` names:** the installer symlinks `batcat` and `fdfind` into `~/.local/bin`.
- **Powerlevel10k instant prompt conflicts:** keep custom output before the prompt block or disable instant prompt (default: off).
- **`update` requires sudo:** use `sudo -v` beforehand or configure password caching.

## License

[MIT](LICENSE)
