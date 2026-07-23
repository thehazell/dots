> [!WARNING]
> You must have the following dependencies installed for the full configuration to work properly:
>
> | Package           | Minimum Upstream Version | Minimum Arch Package Version | Install From                                          |
> | ----------------- | ------------------------ | ---------------------------- | ----------------------------------------------------- |
> | `quickshell-git`  | `0.3.0`                  | `0.3.0.r3.g7d1c9a9-1`        | AUR                                                   |
> | `caelestia-shell` | `2.1.0`                  | `2.1.0-1`                    | AUR                                                   |
> | `obs-studio`      | `32.1.2`                 | `32.1.2-7.1`                 | Standard repositories                                 |
> | `sddm`            | `0.21.0`                 | `0.21.0-8`                   | Standard repositories                                 |
> | `hyprquickshot`   | `N/A`                    | `N/A`                        | [GitHub](https://github.com/thehazell/hyprquickshot/) |
> | `uv`              | `0.11.28`                | `0.11.28`                    | Standard repositories                                 |
> | `obs-cli`         | `0.9.5`                  | `0.9.5`                      | [GitHub](https://github.com/pschmitt/obs-cli)         |
> | `hyprland`        | `0.55.4`                 | `0.55.4-1`                   | Standard repositories                                 |
> | `kitty`           | `0.47.4`                 | `0.47.4-1.1`                 | Standard repositories                                 |
> | `superfile`       | `1.6.0`                  | `1.6.0-1.1`                  | Standard repositories                                 |
> | `fish`            | `4.8.1`                  | `4.8.1-1`                    | Standard repositories                                 |
> | `playerctl`       | `2.4.1`                  | `2.4.1-5.1`                  | Standard repositories
>
> These packages include many dependencies of their own, which are all required in order for this to work properly. Hyprquickshot, for example, relies on grim, which is used by the fullscreen screenshot script.

Using **yay**:

```bash
yay -S quickshell-git caelestia-shell obs-studio sddm uv hyprland kitty superfile fish playerctl
```

Using **paru**:

```bash
paru -S quickshell-git caelestia-shell obs-studio sddm uv hyprland kitty superfile fish playerctl
```

---
## Setup

The following setup guides cover the recommended installation and configuration for each component:

| Component     | Guide                                                                                                         |
| ------------- | ------------------------------------------------------------------------------------------------------------- |
| Caelestia     | [SETUP.md](https://github.com/thehazell/dots/blob/main/caelestia/SETUP.md)                                    |
| Hypr Scripts  | [SCRIPTS.md](https://github.com/thehazell/dots/blob/main/hypr/SCRIPTS.md)                                     |
| SDDM          | [SETUP.md](https://github.com/thehazell/dots/blob/main/sddm/SETUP.md)                                         |
| HyprQuickShot | [SETUP.md](https://github.com/thehazell/hyprquickshot/blob/bd46adce40940503a2ff587ff2c8e26ab7514156/SETUP.md) |

### Installer

From a clone of this repository, use the installer to initialize
the submodule and link the user-level configuration:

```bash
./install.sh all
```

Review planned changes without modifying anything with `./install.sh --dry-run all`.
Existing files and symlinks are left untouched by default; pass `--force` only
when they should be replaced. Privileged system links are intentionally opt-in:

```bash
./install.sh caelestia-scheme
./install.sh sddm
```

---
# Main Components

This repository contains my Hyprland configuration, SDDM theme, Caelestia customization, and a collection of tools that streamline my day-to-day workflow.

## SDDM

The SDDM theme is **not** my own work. It uses an excellent [Qylock](https://github.com/Darkkal44/qylock) theme, which curates a large collection of beautiful SDDM themes that are well worth checking out.

https://github.com/user-attachments/assets/ca1bc986-a9ef-40d7-8686-429cf7985434

---

## Caelestia

The included Caelestia color scheme is my own. In addition to the custom color palette, it applies transparency overrides throughout Caelestia because, well... transparency looks cool.

<img width="2560" height="1439" alt="Caelestia preview" src="https://github.com/user-attachments/assets/9710997c-0bdf-41d3-ada7-dfe0336abb8e" />

---

## Hyprquickshot

The screenshot tool, Hyprquickshot, is a modified version of [JamDon2's Hyprquickshot](https://github.com/JamDon2/hyprquickshot) with color updates, fixes to silence qmllint, and notifications for when screenshots are taken and whether they were saved to the disk, or just to clipboard.

<img width="1920" height="1080" alt="Hyprquickshot" src="https://github.com/user-attachments/assets/a5b9e999-be31-462a-9e70-fdfe0ddeae33" />
