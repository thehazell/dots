## Symlinking
If you prefer to keep the shell file in your home directory to work on (which is my preference), you can symlink `shell.json` to the proper location with the following command:
```shell
ln -s ~/Projects/dots/caelestia/shell.json ~/.config/caelestia/shell.json
```

You may have to create `~/.config/caelestia/`, as it usually doesnt not come pre-created with a caelestia install.

For the custom scheme, use the following command:
```shell
ln -s ~/Projects/dots/caelestia/schemes/hazel/default/dark.txt /usr/lib/python3.14/site-packages/caelestia/data/schemes/hazel/default/dark.txt
```

## Move the files
You can also just move the shell file to `~/.config/caelestia/shell.json`, if you want. Make sure the caelestia directory exists, as described above.

For the scheme, just move the file to `/usr/lib/python3.14/site-packages/caelestia/data/schemes/hazel/default`. 