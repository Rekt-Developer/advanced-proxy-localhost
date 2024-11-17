# 🚀 Advanced Proxy Localhost Setup

A powerful, fully automated Bash script for setting up advanced proxy and localhost environments in Termux. This tool simplifies the process of configuring Nginx and Apache servers with an intuitive interface and robust error handling.

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-Termux-orange.svg)

## ✨ Features

- 🔧 **Dual Server Support**
  - Nginx configuration with advanced proxy settings
  - Apache setup with virtual hosts
  - Smart server detection and configuration

- 🛠️ **Advanced Configuration Options**
  - Custom domain support
  - Automatic SSL certificate generation
  - Dynamic port configuration
  - Load balancing capabilities

- 🎨 **User Experience**
  - Interactive CLI menu with color coding
  - Progress animations during setup
  - Detailed logging system
  - Error handling with recovery options

- 🔍 **Network Tools**
  - Automatic IP detection and display
  - Port availability checking
  - Network diagnostics
  - DNS configuration helper

## 📋 Prerequisites

- Termux app installed from F-Droid
- At least 100MB free storage
- Active internet connection
- Basic understanding of web servers

## 🚀 Quick Start

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Rekt-Developer/advanced-proxy-localhost.git
   cd advanced-proxy-localhost
   ```

2. **Set Permissions**
   ```bash
   chmod +x setup.sh
   ```

3. **Run Setup**
   ```bash
   ./setup.sh
   ```

## 📖 Detailed Installation

### Method 1: Automated Installation
```bash
curl -sSL https://raw.githubusercontent.com/Rekt-Developer/advanced-proxy-localhost/main/install.sh | bash
```

### Method 2: Manual Installation
1. Update Termux packages:
   ```bash
   pkg update && pkg upgrade -y
   ```

2. Install required packages:
   ```bash
   pkg install git nginx apache2 curl wget -y
   ```

3. Clone and setup:
   ```bash
   git clone https://github.com/Rekt-Developer/advanced-proxy-localhost.git
   cd advanced-proxy-localhost
   chmod +x setup.sh
   ./setup.sh
   ```

## 🛠️ Configuration Options

### Nginx Setup
- Custom domain configuration
- SSL certificate integration
- Reverse proxy settings
- Load balancer configuration
- Custom error pages

### Apache Setup
- Virtual host configuration
- ModSecurity integration
- .htaccess support
- SSL/TLS setup
- Access control

## 📱 Usage Examples

1. **Basic Localhost Setup**
   ```bash
   ./setup.sh --quick-start
   ```

2. **Custom Domain Configuration**
   ```bash
   ./setup.sh --domain example.com
   ```

3. **Advanced Proxy Setup**
   ```bash
   ./setup.sh --proxy --ssl
   ```

## 🔧 Advanced Configuration

### Custom Port Configuration
```bash
./setup.sh --port 8080
```

### SSL Certificate Setup
```bash
./setup.sh --ssl --domain yourdomain.com
```

### Load Balancer Configuration
```bash
./setup.sh --load-balance "server1.com,server2.com"
```

## 🔍 Troubleshooting

### Common Issues

1. **Port Conflicts**
   ```bash
   ./setup.sh --diagnose-ports
   ```

2. **SSL Certificate Problems**
   ```bash
   ./setup.sh --fix-ssl
   ```

3. **Server Not Starting**
   ```bash
   ./setup.sh --repair
   ```

## 📊 Performance Monitoring

Monitor your setup with built-in tools:
```bash
./setup.sh --monitor
```

## 🔒 Security Features

- Automatic firewall configuration
- DDoS protection
- Rate limiting
- IP blocking
- Security headers

## 📝 Logging

Logs are stored in:
```
/data/data/com.termux/files/usr/var/log/proxy-setup/
```

## 🔄 Updates

Update the script:
```bash
./setup.sh --update
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Support

- 📱 Telegram: [@rektdevelopers](https://t.me/rektdevelopers)
- 📧 Email: support@rektdev.com
- 💬 Discord: [Join Server](https://discord.gg/rektdev)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Termux Development Team
- Nginx and Apache communities
- All contributors and testers

---

**Note**: Always ensure you're running the latest version of the script for the best experience and security updates.
