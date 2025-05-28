# Synqchronizer One-Click Installer

🚀 **Complete CLI toolkit for Multisynq Synchronizer**  
Manage your Synchronizer node with ease using this one-click interactive shell installer.

---

## 📦 What This Script Does

- ✅ Installs **Node.js v18**
- ✅ Installs **Docker** (on Linux, auto-configured)
- ✅ Installs `synqchronizer` globally via `npm`
- ✅ Initializes configuration
- ✅ Generates and enables `systemd` services for CLI and Web dashboard
- ✅ Includes interactive menu, icons, and progress spinners

---

## 🔧 Prerequisites

- Linux OS (Ubuntu/Debian/Fedora/CentOS)
- `curl`, `sudo`, `bash`
- A valid **Synq key** from [Multisynq platform](https://multisynq.io)

---

## 🚀 Quick Start

Then follow the menu prompts to:
1. Install requirements
2. Install & Init synchronizer
3. Setup services
4. Monitor logs

## 🚀 One Click Install Command

```bash
wget https://raw.githubusercontent.com/0xtnpxsgt/MultiSynq-Syncronizer-Cli/refs/heads/main/install_synchronizer.sh
chmod +x install_synchronizer.sh
./install_synchronizer.sh
```

---

## 📊 Web Dashboard Features

- Real-time traffic/session/user metrics
- Quality of Service (QoS) scoring
- Live logs with syntax highlighting
- API endpoints documentation
- Dual-server setup (Dashboard + Metrics)

---

## 📘 Full Command Reference

| Command | Description |
|--------|-------------|
| `synchronize init` | Interactive config setup |
| `synchronize start` | Launch synchronizer Docker |
| `synchronize service` | Generate `systemd` service |
| `synchronize service-web` | Setup web dashboard service |
| `synchronize status` | Check service status |
| `synchronize web` | Launch dashboard |
| `synchronize install-docker` | Auto Docker install |
| `synchronize fix-docker` | Docker permission fix |
| `synchronize test-platform` | Check system compatibility |

---

## 🔒 Security

- Synq keys are masked in config display
- Config stored at: `~/.synchronizer-cli/config.json`
- Services run under local user permissions

---

## 🛠️ Troubleshooting

**Docker not found?**
```bash
synchronize install-docker
```

**Permission issues?**
```bash
synchronize fix-docker
```

**See logs**
```bash
journalctl -u synchronizer-cli -f
```

