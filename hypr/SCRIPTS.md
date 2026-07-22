If you prefer to keep the scripts in your dotfiles repository (which is my preference), add the scripts directory to your `PATH` so they can be run from anywhere. We can accomplish this with the following:

```fish
fish_add_path ~/Projects/dots/hypr/scripts
```

You will need to reboot your computer or restart Hyprland for it to pick up the changes.

### Make the scripts executable

If you haven't already, make sure the scripts are executable:

```shell
chmod +x ~/Projects/dots/hypr/scripts/*
```

After that, you can invoke them directly from anywhere:

```shell
fullscreen_screenshot
fullscreen_screenshot -s
```

This also means your Hyprland configuration can simply reference the script by name instead of using an absolute path.
