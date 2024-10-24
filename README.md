# MullvadVPN-Tricks
Making MullvadVPN work better on GNU/Linux

## Install on Fedora Atomic Desktops
This applies for CentOS Bootc, RHEL Image mode and [HeliumOS](https://heliumos.org) too, I tested it on HeliumOS.

First add the repo file manually, then install it, which will result in a reboot.

```
wget https://repository.mullvad.net/rpm/stable/mullvad.repo
sudo mv mullvad.repo /etc/yum.repos.d/

# install it
rpm-ostree update --install mullvad-vpn --reboot
```

after reboot, to make it work

```
sudo systemctl enable --now mullvad-daemon.service
sudo systemctl enable --now mullvad-early-boot-blocking.service
```

## Automatic Starting
If you want to setup automatic starting of the VPN without launching the GUI app all the time:

```
wget https://github.com/boredsquirrel/MullvadVPN-Tricks/raw/refs/heads/main/create-autostart-service.sh
bash ./create-autostart-service.sh && rm -f ./create-autostart-service.sh || echo "FAILED!"
```

You can also add a GUI desktop entry to start it, if you want that for whatever reason. You can add this as an autostart program in GNOME Tweaks or the KDE settings too:

```
wget -O ~/.local/share/applications/ https://github.com/boredsquirrel/MullvadVPN-Tricks/raw/refs/heads/main/mullvad-nogui.desktop
```

## Excluding Apps
To exclude an app from the VPN (aka. split tunnel), use `mullvad-exclude`.

This is useful for apps like [Syncthing](https://flathub.org/apps/com.github.zocker_160.SyncThingy) or [LocalSend](https://flathub.org/apps/org.localsend.localsend_app) where you need or benefit from local file sharing.

```
cp /wherever/that/entry/is.desktop ~/.local/share/applications/
sed -i 's/Exec=/Exec=mullvad-exclude /g' ~/.local/share/applications/entry.desktop
```

Example, Localsend:

```
cp /var/lib/flatpak/exports/share/applications/org.localsend.localsend_app.desktop ~/.local/share/applications/
sed -i 's/Exec=/Exec=mullvad-exclude /g' ~/.local/share/applications/org.localsend.localsend_app.desktop
```

The entries in the `~/.local` directory will always be preferred over any others.

All system Flatpak apps have their .desktop Entries linked to `/var/lib/flatpak/exports/share/applications/`.
