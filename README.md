# MullvadVPN-Tricks
Making MullvadVPN work better on GNU/Linux

## Install on Fedora Atomic Desktops
This applies for CentOS Bootc, RHEL Image mode and [HeliumOS](https://heliumos.org) too, I tested it on HeliumOS.

First add the repo file manually, then install it, which will result in a reboot.

```
curl --tlsv1.3 -fsS https://repository.mullvad.net/rpm/stable/mullvad.repo | pkexec tee /etc/yum.repos.d/mullvad.repo

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

## Autostart apps only when the VPN is on

If you want to start applications on boot, but it is **really, really bad** if they start with no VPN on (for example a Torrent program, not that we use it for anything illegal), you can use this script instead of launching the app manually:

```
mkdir ~/.local/bin
wget https://github.com/boredsquirrel/MullvadVPN-Tricks/raw/refs/heads/main/mullvad-appstart -O ~/.local/bin/
chmod +x ~/.local/bin/*
```

In KDE, you can already set that script to "autostart". On GNOME with GNOME-Tweaks, you may need a desktop entry, and you can also use that to start the app from the App List.

```
mkdir ~/.local/share/applications
wget https://github.com/boredsquirrel/MullvadVPN-Tricks/raw/refs/heads/main/mullvad-appstart.desktop -O ~/.local/share/applications/
update-desktop-database
```

Now you can select this "App" to autostart, and in the script you can enter the start commands of the apps you want to start, ***if*** the VPN is connected.

## Kill Apps if VPN is off
You may want to use an additional security to kill certain apps if the VPN is not connected or blocking the connection.

Just in case your VPN may crash or whatever, you wouldn't want some traffic leaking from your real IP address.

```
mkdir ~/.local/bin
wget https://github.com/boredsquirrel/MullvadVPN-Tricks/raw/refs/heads/main/nomullvad-autokill -O ~/.local/bin
chmod +x ~/.local/bin/*
```

In the script you can enter what apps you would like to kill if the VPN is off, and what you would like to restart, once it is on again.

Then you can also set this app as "autostart" in KDE, on GNOME with GNOME-Tweaks you may need another desktop entry.

```
mkdir ~/.local/share/applications
wget https://github.com/boredsquirrel/MullvadVPN-Tricks/raw/refs/heads/main/nomullvad-appkill.desktop -O ~/.local/share/applications/
update-desktop-database
```

You can set this to autostart in GNOME Tweaks.

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
