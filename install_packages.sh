#!/bin/bash

# 检测操作系统类型

OS_TYPE="unknown"

if [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macos"
    echo "检测到 macOS 系统"
    
    # 确保 Homebrew 已安装
    if ! command -v brew &>/dev/null; then
        echo "正在安装 Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
elif command -v apt &>/dev/null; then
    OS_TYPE="debian"
    echo "检测到 Debian/Ubuntu 系统"
    
    # 更新软件包列表
    sudo apt update -y
    
else
    echo "不支持的操作系统类型，无法安装软件。"
    exit 1
fi

# 检查并安装必要的软件包
function ensure_package() {
    if ! command -v $1 &> /dev/null; then
        echo "正在安装 $1..."
        if [[ "$OS_TYPE" == "macos" ]]; then
            brew install $1
        elif [[ "$OS_TYPE" == "debian" ]]; then
            sudo apt install -y $1
        fi
    fi
}

# 检查基础软件包
ensure_package vim
ensure_package git
ensure_package tmux
ensure_package fzf
ensure_package zsh

# 询问是否将 zsh 设置为默认 shell
read -p "是否将 zsh 设置为默认 shell? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    chsh -s $(which zsh)
    echo "已将 zsh 设置为默认 shell，请重新登录以生效"
fi

# 安装 trash-cli (macOS 使用 trash 命令，Debian 使用 trash-cli)
if ! command -v trash &> /dev/null; then
    echo "正在安装 trash 工具..."
    if [[ "$OS_TYPE" == "macos" ]]; then
        brew install trash-cli
    elif [[ "$OS_TYPE" == "debian" ]]; then
        sudo apt install -y trash-cli
    fi
fi

# 安装 lazygit
if ! command -v lazygit &> /dev/null; then
    echo "正在安装 lazygit..."
    if [[ "$OS_TYPE" == "macos" ]]; then
        brew install lazygit
    elif [[ "$OS_TYPE" == "debian" ]]; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit.tar.gz lazygit
    fi
fi

# 安装 zoxide
if ! command -v zoxide &> /dev/null; then
    echo "正在安装 zoxide..."
    if [[ "$OS_TYPE" == "macos" ]]; then
        brew install zoxide
    elif [[ "$OS_TYPE" == "debian" ]]; then
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    fi
fi

# 安装 zinit
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    echo "正在安装 zinit..."
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

# 打印安装结果
echo "安装完成！以下软件已成功安装："
for package in vim git tmux fzf zsh trash lazygit zoxide zinit; do
    if command -v $package &> /dev/null || [[ -f $HOME/.local/share/zinit/zinit.git/zinit.zsh && $package == "zinit" ]]; then
        echo "✓ $package"
    else
        echo "✗ $package (安装失败)"
    fi
done