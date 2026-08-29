# Dots

My personal Hyprland configuration, SDDM theme, Caelestia customization, and collection of tools that streamline my day-to-day workflow.

> [!WARNING]
> You must have the following dependencies installed for the full configuration to work properly:

| Package                   | Minimum Upstream Version | Minimum Arch Package Version | Install From                    |
| ------------------------- | ------------------------ | ---------------------------- | ------------------------------- |
| `quickshell-git`          | `0.3.0`                  | `0.3.0.r3.g7d1c9a9-1`        | AUR                             |
| `caelestia-shell`         | `2.1.0`                  | `2.1.0-1`                    | AUR                             |
| `sddm`                    | `0.21.0`                 | `0.21.0-8`                   | Standard repositories           |
| `hyprquickshot`           | `N/A`                    | `N/A`                        | GitHub                          |
| `hyprland`                | `0.55.4`                 | `0.55.4-1`                   | Standard repositories           |
| `kitty`                   | `0.47.4`                 | `0.47.4-1.1`                 | Standard repositories           |
| `superfile`               | `1.6.0`                  | `1.6.0-1.1`                  | Standard repositories           |
| `fish`                    | `4.8.1`                  | `4.8.1-1`                    | Standard repositories           |
| `playerctl`               | `2.4.1`                  | `2.4.1-5.1`                  | Standard repositories           |
| `lxqt-policykit`          | `2.4.0`                  | `2.4.0-1.1`                  | Standard repositories           |
| `grim`                    | `1.5.0`                  | `1.5.0-2`                    | Standard repositories           |
| `wl-clipboard`            | `2.3.0`                  | `2.3.0-1`                    | Standard repositories           |
| `libnotify`               | `0.8.8`                  | `0.8.8-1`                    | Standard repositories           |
| `hyprshutdown`            | `0.1.1`                  | `0.1.1-6`                    | Standard repositories           |
| `nemo`                    | `6.6.4`                  | `6.6.4-1`                    | Standard repositories           |
| `zsh`                     | `5.9.2`                  | `5.9.2-1.1`                  | CachyOS Extra (`znver4`)        |
| `starship`                | `1.26.0`                 | `1.26.0-1`                   | Standard repositories           |
| `zoxide`                  | `0.10.0`                 | `0.10.0-1.1`                 | CachyOS Extra (`znver4`)        |
| `nvm`                     | `0.40.5`                 | `0.40.5-1`                   | Standard repositories           |
| `zsh-autocomplete`        | `25.03.19`               | `25.03.19-1`                 | Standard repositories           |
| `zsh-autosuggestions`     | `0.7.1`                  | `0.7.1-1`                    | Standard repositories (`extra`) |
| `zsh-syntax-highlighting` | `0.8.0`                  | `0.8.0-2`                    | Standard repositories           |
| `caelestia-cli`           | `1.1.2`                  | `1.1.2-1`                    | AUR                             |

These packages include many dependencies of their own, which are all required in order for this configuration to work properly.

`hyprquickshot`, for example, relies on `grim`, which is used by the fullscreen screenshot script. `wl-clipboard` provides `wl-copy`, and `libnotify` provides `notify-send`, both of which are used by the screenshot and recording scripts.

> [!IMPORTANT]
> Ensure that you have installed `quickshell-git` and **not** `noctalia-qs`. While `noctalia-qs` may satisfy the dependency requirement, it will result in a failed launch of HyprQuickShot due to a pragma error.

### Installing dependencies

Using **yay**:

```bash
yay -S aur/quickshell-git caelestia-shell sddm hyprland kitty caelestia-cli superfile fish playerctl lxqt-policykit grim wl-clipboard libnotify hyprshutdown nemo zsh starship zoxide nvm zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting
```

Using **paru**:

```bash
paru -S aur/quickshell-git caelestia-shell sddm hyprland kitty caelestia-cli superfile fish playerctl lxqt-policykit grim wl-clipboard libnotify hyprshutdown nemo zsh starship zoxide nvm zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting
```

### Oh My Zsh

If you want to use Oh My Zsh alongside the included Zsh configuration:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

---

# Installer

The repository includes an installer for setting up the configuration, initializing submodules, installing dependencies, and creating the required symlinks.

From a clone of this repository, first review the installer:

```bash
./install.sh help
```

The installer supports the following commands:

| Command            | Description                                                 |
| ------------------ | ----------------------------------------------------------- |
| `check`            | Verify installer sources and required commands.             |
| `deps`             | Install required packages using `paru` or `yay`.            |
| `submodules`       | Initialize git submodules, including HyprQuickShot.         |
| `link`             | Create user-level configuration and script symlinks.        |
| `zsh`              | Create Zsh and Starship configuration symlinks.             |
| `fluent-icons`     | Clone and install the Fluent icon theme.                    |
| `caelestia-scheme` | Link the Caelestia scheme with `sudo` (opt-in).             |
| `sddm`             | Link the SDDM configuration and theme with `sudo` (opt-in). |
| `all`              | Run submodules and all user-level links.                    |
| `help`             | Show this help text.                                        |

## Recommended installation

Check that the installer sources and required commands are available:

```bash
./install.sh check
```

Install the required packages using `paru` or `yay`:

```bash
./install.sh deps
```

Initialize the repository submodules:

```bash
./install.sh submodules
```

Create the user-level configuration and script symlinks:

```bash
./install.sh link
```

Set up the Zsh and Starship configuration:

```bash
./install.sh zsh
```

Alternatively, `all` performs the submodule initialization and all user-level linking in one step:

```bash
./install.sh all
```

> [!NOTE]
> `all` does **not** install system-level configuration. The `caelestia-scheme` and `sddm` commands are intentionally separate because they require `sudo`.

## Optional components

Install the Fluent icon theme with:

```bash
./install.sh fluent-icons
```

Link the Caelestia color scheme:

```bash
./install.sh caelestia-scheme
```

Link the SDDM configuration and theme:

```bash
./install.sh sddm
```

Both `caelestia-scheme` and `sddm` are privileged operations and require `sudo`.

Before running a privileged phase, the installer will ask for confirmation. Use `--yes` to skip the confirmation:

```bash
./install.sh --yes caelestia-scheme
./install.sh --yes sddm
```

## Installer options

The installer supports the following options:

| Option      | Description                                                         |
| ----------- | ------------------------------------------------------------------- |
| `--dry-run` | Print actions without changing files or running `git`/`sudo`.       |
| `--force`   | Replace existing files or symlinks; directories are never replaced. |
| `--yes`     | Skip confirmation before privileged phases.                         |

### Dry run

Review the planned changes without modifying anything:

```bash
./install.sh --dry-run all
```

You can also preview individual commands:

```bash
./install.sh --dry-run deps
./install.sh --dry-run submodules
./install.sh --dry-run link
./install.sh --dry-run zsh
```

### Force existing files

By default, existing files and symlinks are left untouched.

Use `--force` when you explicitly want existing files or symlinks to be replaced:

```bash
./install.sh --force all
```

Directories are never replaced by `--force`.

Options can be combined:

```bash
./install.sh --dry-run --force all
```

> [!WARNING]
> Only use `--force` when you understand which existing files and symlinks will be replaced.

---

# Main Components

This repository contains my Hyprland configuration, SDDM theme, Caelestia customization, and a collection of tools that streamline my day-to-day workflow.

---

## SDDM

The SDDM theme is **not** my own work. It uses the excellent [Qylock](https://github.com/Darkkal44/qylock) theme, which curates a large collection of beautiful SDDM themes that are well worth checking out.

https://github.com/user-attachments/assets/ca1bc986-a9ef-40d7-8686-429cf7985434

---

## Caelestia

The included Caelestia color scheme is my own. In addition to the custom color palette, it applies transparency overrides throughout Caelestia because, well... transparency looks cool.

<img width="2560" height="1439" alt="Caelestia preview" src="https://github.com/user-attachments/assets/9710997c-0bdf-41d3-ada7-dfe0336abb8e" />

---

## HyprQuickShot

The screenshot tool, HyprQuickShot, is a modified version of [JamDon2's Hyprquickshot](https://github.com/JamDon2/hyprquickshot) with color updates, fixes to silence `qmllint`, and notifications for when screenshots are taken and whether they were saved to disk or just copied to the clipboard.

<img width="1920" height="1080" alt="HyprQuickShot" src="https://github.com/user-attachments/assets/a5b9e999-be31-462a-9e70-fdfe0ddeae33" />
