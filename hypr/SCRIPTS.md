Run the repository installer to symlink the executable scripts into
`~/.local/bin`:

```bash
./install.sh link
```

This avoids hard-coded clone paths. Ensure `~/.local/bin` is on your `PATH`,
then start a new shell or restart Hyprland to pick up the changes.

After that, you can invoke them directly from anywhere:

```shell
fullscreen_screenshot
fullscreen_screenshot -s
```

This also means your Hyprland configuration can simply reference the script by name instead of using an absolute path.
