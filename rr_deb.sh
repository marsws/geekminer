#!/bin/bash
################ ����Ӱ��һ���ű� ##################"
#��װ����Ӱ��
function install_rrys(){
	while :; do
		echo -e "����������Ӱ�Ӷ˿� ["$magenta"1-65535"$none"]"
		read -p "$(echo -e "(Ĭ�϶˿�: 3001):")" port
		[[ -z "$port" ]] && port="3001"
		case $port in
			[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-5][0-9][0-9][0-9][0-9] | 6[0-4][0-9][0-9][0-9] | 65[0-4][0-9][0-9] | 655[0-3][0-5])
		echo
		echo -e "�����趨�˿� = $port"
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
#��ѹ
tar -zxvf rrshareweb_centos7.tar.gz
rm -rf rrshareweb_centos7.tar.gz WEB*.png
#�޸�Ĭ�϶˿�
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
#�趨��̨���м���������
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
echo -e "\n$red ��װ������...$none\n" && exit 1
fi

#��ȡIP
osip=$(curl https://api.ip.sb/ip)
echo "------------------------------------------------------"
echo
echo "��ϲ����װ��ɡ�����ʣ�http://${osip}:$port$none"
echo
echo "������ã��޸�����Ŀ¼"
echo
echo "��ͬVPS�뿪����վ��Ӧ�˿�"
echo "------------------------------------------------------"
}
echo "##########��ӭʹ������Ӱ��webһ����װ�ű�##########"
echo "1.��װ����Ӱ��linux"
echo "2.ж������Ӱ��linux"
echo "3.��װ����&BBR"
echo "4.�˳�"
declare -i stype
read -p "������ѡ��:��1.2.3.4��:" stype
if [ "$stype" == 1 ]
then
#���Ŀ¼�Ƿ����
if [ -e "/home/rrshareweb" ]
then
echo "Ŀ¼���ڣ������Ƿ��Ѿ���װ��"
exit
else
#ִ�а�װ����
install_rrys
fi
	elif [ "$stype" == 2 ]
		then
			systemctl disable rr
		systemctl stop rr
			rm -rf /home/rrshareweb
			rm -rf /etc/systemd/system/rr.service 
			echo 'ж�����.'
			exit
	elif [ "$stype" == 3 ]
		then
			exit
	else
		echo "��������"
	fi	