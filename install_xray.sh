#!/bin/bash

# Debian 本地安装 Xray 脚本
# 作者: Trae AI
# 用途: 从本地~/Xray安装包安装 Xray

# 颜色定义
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[36m"
PLAIN="\033[0m"

# 检查是否为 root 用户
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}错误: 请使用 root 权限运行此脚本${PLAIN}"
    exit 1
fi

# 检查本地安装包
XRAY_DIR="$HOME/Xray"
if [[ ! -d "$XRAY_DIR" ]]; then
    echo -e "${RED}错误: $XRAY_DIR 目录不存在${PLAIN}"
    exit 1
fi

echo -e "${BLUE}开始安装 Xray...${PLAIN}"

# 创建必要的目录
echo -e "${YELLOW}创建必要的目录...${PLAIN}"
mkdir -p /usr/local/bin/xray
mkdir -p /usr/local/etc/xray
mkdir -p /var/log/xray

# 安装主程序
echo -e "${YELLOW}安装 Xray 主程序...${PLAIN}"
if [[ -f "$XRAY_DIR/xray" ]]; then
    cp "$XRAY_DIR/xray" /usr/local/bin/xray/
    chmod +x /usr/local/bin/xray/xray
else
    echo -e "${RED}错误: 未找到 Xray 可执行文件${PLAIN}"
    exit 1
fi

# 复制配置文件
echo -e "${YELLOW}安装配置文件...${PLAIN}"
if [[ -f "$XRAY_DIR/config.json" ]]; then
    cp "$XRAY_DIR/config.json" /usr/local/etc/xray/
else
    # 创建默认配置文件
    cat > /usr/local/etc/xray/config.json << EOF
{
  "inbounds": [{
    "port": 10086,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "$(cat /proc/sys/kernel/random/uuid)",
          "alterId": 0
        }
      ]
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}
EOF
    echo -e "${YELLOW}已创建默认配置文件，请根据需要修改 /usr/local/etc/xray/config.json${PLAIN}"
fi

# 复制地理位置数据文件
echo -e "${YELLOW}安装地理位置数据文件...${PLAIN}"
if [[ -d "$XRAY_DIR/geoip" ]]; then
    cp -r "$XRAY_DIR/geoip"/* /usr/local/bin/xray/
fi
if [[ -d "$XRAY_DIR/geosite" ]]; then
    cp -r "$XRAY_DIR/geosite"/* /usr/local/bin/xray/
fi
if [[ -f "$XRAY_DIR/geoip.dat" ]]; then
    cp "$XRAY_DIR/geoip.dat" /usr/local/bin/xray/
fi
if [[ -f "$XRAY_DIR/geosite.dat" ]]; then
    cp "$XRAY_DIR/geosite.dat" /usr/local/bin/xray/
fi

# 创建 systemd 服务
echo -e "${YELLOW}创建 systemd 服务...${PLAIN}"
cat > /etc/systemd/system/xray.service << EOF
[Unit]
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=nobody
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray/xray run -config /usr/local/etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF

# 重新加载 systemd 配置
systemctl daemon-reload

# 设置开机自启
echo -e "${YELLOW}设置开机自启...${PLAIN}"
systemctl enable xray

# 启动服务
echo -e "${YELLOW}启动 Xray 服务...${PLAIN}"
systemctl start xray
sleep 2

# 检查服务状态
if systemctl is-active --quiet xray; then
    echo -e "${GREEN}Xray 服务已成功启动！${PLAIN}"
    echo -e "${GREEN}配置文件位置: /usr/local/etc/xray/config.json${PLAIN}"
    echo -e "${GREEN}可执行文件位置: /usr/local/bin/xray/xray${PLAIN}"
    echo -e "${GREEN}日志文件位置: /var/log/xray/access.log 和 /var/log/xray/error.log${PLAIN}"
    echo -e "${BLUE}使用以下命令管理 Xray 服务:${PLAIN}"
    echo -e "  启动: ${YELLOW}systemctl start xray${PLAIN}"
    echo -e "  停止: ${YELLOW}systemctl stop xray${PLAIN}"
    echo -e "  重启: ${YELLOW}systemctl restart xray${PLAIN}"
    echo -e "  状态: ${YELLOW}systemctl status xray${PLAIN}"
    echo -e "  查看日志: ${YELLOW}journalctl -u xray${PLAIN}"
else
    echo -e "${RED}Xray 服务启动失败，请检查日志获取更多信息${PLAIN}"
    echo -e "${YELLOW}查看日志: journalctl -u xray${PLAIN}"
fi

exit 0