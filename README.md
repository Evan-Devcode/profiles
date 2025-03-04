# 开发环境配置工具集

一套用于快速配置 Linux/MacOS 开发环境的脚本集合，包含代理工具、常用开发工具的安装和 Shell 环境配置。

## 📋 目录

- [项目简介](#项目简介)
- [安装指南](#安装指南)
  - [Xray 代理配置](#xray-代理配置)
  - [开发工具安装](#开发工具安装)
  - [Zsh 环境配置](#zsh-环境配置)
- [注意事项](#注意事项)
- [许可证](#许可证)

## 🚀 项目简介

本项目包含三个主要组件：

- **install_xray.sh**: 从本地 ~/Xray 目录安装 Xray 原生命令行工具
- **install_package.sh**: 自动安装常用开发工具，适用于 Debian 12 和 MacOS
- **.zshrc**: Zsh 配置文件，包含插件管理等增强功能

### 支持的开发工具

| 工具 | 说明 |
|------|------|
| zsh | 现代化的 shell 环境 |
| git | 版本控制工具 |
| vim | 文本编辑器 |
| tmux | 终端复用工具 |
| fzf | 模糊查找工具 |
| trash | 安全删除工具 |
| lazygit | Git TUI 客户端 |
| zoxide | 智能目录跳转 |
| zinit | Zsh 插件管理器 |

## 📥 安装指南

### Xray 代理配置

1. **准备工作**
   ```bash
   下载并解压 Xray 安装包到 ~/Xray 目录

2. **设置脚本权限**
   ```bash
   chmod +x install_xray.sh

3. **运行安装脚本**
   ```bash
   ./install_xray.sh

4. **配置节点信息**
   - 将节点信息写入 config.json 文件
   - 配置文件位置：/usr/local/etc/xray/config.json

5. **配置全局代理**

   在 `~/.profile` 中添加：
   ```bash
   # SOCKS5 代理配置
   export all_proxy="socks5://127.0.0.1:1080"
   
   # HTTP/HTTPS 代理配置
   export http_proxy="http://127.0.0.1:8080"
   export https_proxy="http://127.0.0.1:8080"

6. **应用配置**
   ```bash
   source ~/.profile
   
### 开发工具安装

1. **设置脚本权限**
   ```bash
   chmod +x install_package.sh

2. **运行安装脚本**
   ```bash
   ./install_package.sh

3. **验证安装**
   ```bash
   # 检查各个工具是否正确安装
   zsh --version
   git --version
   vim --version

### zsh环境配置

1. **部署配置文件**
   ```bash
   将配置文件保存到本地

2. **应用配置**
   ```bash
   source ~/.zshrc


















   
