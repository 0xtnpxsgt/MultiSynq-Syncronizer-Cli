# Synchronizer One-Click Installer

![event-foundation 3707e01653652767982d](https://github.com/user-attachments/assets/9fc7385a-53d6-4654-bb8b-518309f520dd)
 
🚀 **Complete CLI toolkit for Multisynq Synchronizer**  
Manage your Synchronizer node with ease using this one-click interactive shell installer.

---

## 📦 What This Script Does

- ✅ Installs **Node.js v18**
- ✅ Installs **Docker** (on Linux, auto-configured)
- ✅ Installs `synchronizer` globally via `npm`
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
![image](https://github.com/user-attachments/assets/ef0b64cb-63b2-4afc-bdc0-963eab88bfb8)

---

## 📊 Web Dashboard Features

- Real-time traffic/session/user metrics
- Quality of Service (QoS) scoring
- Live logs with syntax highlighting
- API endpoints documentation
- Dual-server setup (Dashboard + Metrics)

🌐 The web dashboard runs on dual servers:
```bash
Dashboard Server (default port 3000): Main web interface: Visit: localhost:3000
Metrics Server (default port 3001): JSON API endpoints: Visit localhost:3001/metrics
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

```
## 🛠️ Troubleshooting

**Docker not found?**
```bash
synchronize install-docker
```

**Permission issues?**
```bash
synchronize fix-docker
```

---

<p align="center">
  <a href="https://t.me/SelectCircle">
    <img src="https://img.shields.io/badge/Telegram_Channel:-Select_Circle-B22222.svg?&style=for-the-badge&logo=Telegram&logoColor=blue&color=blue" />
  </a>
  <a href="https://discord.gg/Gut4RqF7Bt">
    <img src="https://img.shields.io/badge/Discord_Channel:-Select_Circle-B22222.svg?&style=for-the-badge&logo=Discord&logoColor=blue&color=blue" />
  </a>
</p>

---

### Support My Craft:
<p align="center">
<img src="https://readme-typing-svg.herokuapp.com?font=JetBrains+Mono&color=FFD700&pause=1000&center=true&vCenter=true&width=435&lines=Buy+Me+Coffee&background=00000000" />
</p>
<p align="left">
  <img src="https://img.shields.io/badge/SOL-H6zFVqFtB9JXejSAMwPS7eKKqxPWVQDxpqhRyoi2Xw74-9B59B6.svg?&style=for-the-badge&logo=solana&logoColor=9B59B6" alt="Solana Wallet"/>
</p>
<p align="left">
  <img src="https://img.shields.io/badge/ETH-0x22Ca00129b6e9577Ff195801560A154C92C43554-informational.svg?&style=for-the-badge&color=blue" alt="Ethereum Wallet"/>
</p>
<p align="left">
  <img src="https://img.shields.io/badge/BINANCE_PAY_ID_:_65642518-000033.svg?&style=for-the-badge&logo=GitHub-Sponsors&logoColor=FF8C00&color=gold" alt="Binance Pay ID"/>
</p>

---

