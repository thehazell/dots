## Symlinking
If you prefer to keep this in your home directory to work on (which is my preference), you can symlink this to the proper directories.  You can accomplish this by using the following command:
```shell
sudo ln -s ~/Projects/dots/sddm/theme.conf /etc/sddm.conf.d/theme.conf
```
This will symlink theme.conf, which is declaring the theme, to the SDDM overide directory. If you have another file also declaring the theme in this directory, it would be best to remove it. 

You can also symlink the theme itself, which would use the following command:
```shell
sudo ln -s ~/Projects/dots/sddm/themes/R1999_1 /usr/share/sddm/themes/R1999_1
```

Finally, remember to set permissions. I accomplished this by using `setfacl`,  but there are multiple ways to do this:
```shell
setfacl -m u:sddm:x ~
setfacl -m u:sddm:x ~/Projects
setfacl -m u:sddm:x ~/Projects/dots
setfacl -m u:sddm:rx ~/Projects/dots/sddm
setfacl -R -m u:sddm:rX ~/Projects/dots/sddm
```
Remember to adjust for your directory names.

## Edit your files
You can also just add the theme section in an existing SDDM config file, if you have it. You would simply add the following:
```toml
[Theme]
Current=R1999_1
```

The theme would get copied to `/usr/share/sddm/themes/`.

## Note
The background video will soon not be included in the repo in favor of a small install script that will, in the future, download the background video and icon pack from my CDN. This will be done to avoid an infalted repository size.
