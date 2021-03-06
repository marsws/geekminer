#!/bin/bash
################ 人人影视一键脚本 ##################"
#安装人人影视
function install_rrys(){
	while :; do
		echo -e "请输入人人影视端口 ["$magenta"1-65535"$none"]"
		read -p "$(echo -e "(默认端口: 3001):")" port
		[[ -z "$port" ]] && port="3001"
		case $port in
			[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
		echo
		echo -e "重新设定端口 = $port"
		echo "----------------------------------------------------------------"
			break
			;;
			*)
			error
			;;
		esac
	done
cd /home/
wget https://appdown.rrysapp.com/rrshareweb_centos7.tar.gz
#解压
tar -zxvf rrshareweb_centos7.tar.gz
rm -rf rrshareweb_centos7.tar.gz WEB*.png
#修改默认端口
cat > /home/rrshareweb/conf/rrshare.json <<EOF
      {
      "port" : $port,
      "logpath" : "",
      "logqueit" : false,
      "loglevel" : 1,
      "logpersistday" : 2,
      "defaultsavepath" : "/home"
      }
EOF
#设定后台运行及开机自启
if [[ -f /home/rrshareweb/rrshareweb ]]; then
cat > /etc/systemd/system/renren.service <<EOF
[Unit]
Description=RenRen server
After=network.target
Wants=network.target

[Service]
Type=simple
PIDFile=/var/run/renren.pid
ExecStart=/root/rrshareweb/rrshareweb
RestartPreventExitStatus=23
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl enable renren
systemctl start renren

else
echo -e "\n$red 安装出错啦...$none\n" && exit 1
fi

#获取IP
osip=$(curl https://api.ip.sb/ip)
echo "------------------------------------------------------"
echo
echo "恭喜，安装完成。请访问：http://${osip}:$port$none"
echo
echo "点击设置，修改下载目录"
echo
echo "不同VPS请开启入站相应端口"
echo "------------------------------------------------------"
}
echo "##########欢迎使用人人影视web一键安装脚本##########"
echo "1.安装人人影视linux"
echo "2.卸载人人影视linux"
echo "3.安装锐速&BBR"
echo "4.退出"
declare -i stype
read -p "请输入选项:（1.2.3.4）:" stype
if [ "$stype" == 1 ]
then
#检查目录是否存在
if [ -e "/home/rrshareweb" ]
then
echo "目录存在，请检查是否已经安装。"
exit
else
#执行安装函数
install_rrys
fi
	elif [ "$stype" == 2 ]
		then
			systemctl disable rr
		systemctl stop rr
			rm -rf /home/rrshareweb
			rm -rf /etc/systemd/system/rr.service 
			echo '卸载完成.'
			exit
	elif [ "$stype" == 3 ]
		then
			exit
	else
		echo "参数错误！"
	fi	
