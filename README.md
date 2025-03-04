# Linux/MacOS 开发环境配置工具集

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

1. **下载并解压 Xray 安装包到 ~/Xray 目录**
   ```bash
   sftp root@vps_ip地址
   
   输入密码
   
   put C:\Users\Administrator\Downloads\Xray-linux-64.zip  /root/
   unzip -d ./Xray Xray-linux-64.zip  

2. **将脚本保存到本地并设置权限**
   ```bash
   code install_xray.sh
   chmod +x install_xray.sh

3. **运行安装脚本**
   ```bash
   ./install_xray.sh

4. **配置节点信息**
   - 将节点信息写入 config.json 文件
   - code /usr/local/etc/xray/config.json

5. **配置全局代理**

   在 `~/.profile` 中添加：
   ```bash
   code ~/.profile
   
   # SOCKS5 代理配置
   export all_proxy="socks5://127.0.0.1:1080"
   
   # HTTP/HTTPS 代理配置
   export http_proxy="http://127.0.0.1:8080"
   export https_proxy="http://127.0.0.1:8080"

6. **应用配置并测试代理**
   ```bash
   source ~/.profile
   systemctl restart xray
   
   curl -I www.google.com
  
### 开发工具安装

1. **将脚本保存到本地并设置权限**
   ```bash
   code install_packages.sh
   chmod +x install_packages.sh

2. **运行安装脚本**
   ```bash
   ./install_packages.sh

3. **验证安装**
   ```bash
   # 检查各个工具是否正确安装
   zsh --version
   git --version
   vim --version

### Zsh 环境配置

1. **将配置文件保存到本地**
   ```bash
   code ~/.zshrc

2. **应用配置**
   ```bash
   source ~/.zshrc


## ⚠️ 注意事项

- 运行 `install_xray.sh` 需要 root 权限
- 确保系统为 Debian 12 或 MacOS
- 安装前请确保网络连接正常
- 建议在安装完成后测试各个工具的功能
- 如遇问题，请查看相关日志文件

## 🔧 常见问题

1\. **Xray 无法启动**
   - 检查配置文件格式是否正确
   - 查看系统日志: `journalctl -u xray`
   - 确认端口未被占用

2\. **插件加载失败**
   - 确保 zinit 正确安装
   - 检查网络连接
   - 尝试重新加载 zsh 配置

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！在提交之前，请：

- 确保代码符合项目规范
- 添加必要的测试和文档
- 更新 README 相关内容

## 📄 许可证

MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
