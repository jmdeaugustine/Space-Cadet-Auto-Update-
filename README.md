# Space-Cadet-Auto-Update
# A full debian linux update + flatpak update script with a twist.  

# 🚀 Space Commander Auto-Update

A playful but practical auto-update setup for Linux (Pop!_OS / Ubuntu-based systems).

This project adds a little personality to routine system updates using:
- Animated ASCII visuals
- A “Space Commander → Cadet” briefing
- Standard system tools (`apt`, `flatpak`)

It is designed to be **fun, safe, and easy to customize**.

---

## 📁 Repository Contents

```

auto-upgrade.sh
auto-upgrade.desktop

```

- **auto-upgrade.sh**  
  The main update script. This can live in *any* folder you like.

- **auto-upgrade.desktop**  
  A desktop autostart file that runs the script automatically when you log in.

---

## 🛠️ Installation

### 1️⃣ Choose where to store the script

You may place `auto-upgrade.sh` in **any directory you prefer**.

Common choices:

```

~/scripts/
~/.local/bin/
~/bin/

````

Example:

```bash
mkdir -p ~/scripts
cp auto-upgrade.sh ~/scripts/auto-upgrade.sh
chmod +x ~/scripts/auto-upgrade.sh
````

---

### 2️⃣ Edit the autostart file

Open `auto-upgrade.desktop` in a text editor and update the `Exec=` line to point to the script’s location.

⚠️ **Important notes:**

* You must use the **full absolute path**
* `~` will NOT work inside `.desktop` files

Example:

```ini
Exec=/home/yourusername/scripts/auto-upgrade.sh
```

Replace `yourusername` with your actual username.

---

### 3️⃣ Install the autostart entry

Copy the `.desktop` file into your autostart directory:

```bash
mkdir -p ~/.config/autostart
cp auto-upgrade.desktop ~/.config/autostart/
```

The script will now run automatically when you log in.

---

## ▶️ Manual Usage (Optional)

You can also run the script manually at any time:

```bash
~/scripts/auto-upgrade.sh
```

---

## 🔐 Sudo Permissions

This script runs:

* `apt update`
* `apt full-upgrade`
* `apt autoremove`
* `flatpak update`

You may be prompted for your sudo password.

### Optional: passwordless updates (advanced users only)

If you understand the security implications, you can allow passwordless updates:

```bash
sudo visudo
```

Add:

```text
yourusername ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/flatpak
```

⚠️ Use this with care.

---

## 🧪 Compatibility

Tested on:

* Pop!_OS
* Ubuntu-based distributions
* GNOME desktops (autostart compatible)

Animations are **ASCII-safe** and should work in most terminals.

---

## 🧼 Uninstall

To stop the script from running on login:

```bash
rm ~/.config/autostart/auto-upgrade.desktop
```

To remove everything:

```bash
rm ~/scripts/auto-upgrade.sh
```

---

## 📜 License

MIT License — do whatever you want, just don’t blame me if your spaceship explodes.

---

## ✨ Notes

* Animations run *before* update commands to avoid interfering with output
* Script is intentionally readable and easy to modify
* Feel free to fork and customize the dialogue or visuals

---

🚀 **Commander out.**


