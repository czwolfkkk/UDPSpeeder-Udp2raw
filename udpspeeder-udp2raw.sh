#!/bin/bash

#    "========================="
#    " ���ܣ�������CentOS7"
#    " ���ߣ�atrandys"
#    " ��վ��www.atrandys.com"
#    " Youtube��atrandys"
#    "========================="

#��ʼ
echo
echo "========================="
echo " ���ܣ�������CentOS7"
echo " ���ߣ�atrandys"
echo " ��վ��www.atrandys.com"
echo " Youtube��atrandys"
echo "========================="
echo
echo "��������װ���������һ���ļ�������,�½��ļ��е�Ŀ¼��/usr/src/��"
echo "����࿪���ļ������Ʋ�����ͬ������������Ϊgame1��game2"
read -p "�������ļ�������:" yourdir
ifdir="/usr/src/"$yourdir
if [ ! -d "$ifdir" ]; then
#���ؼ��������ļ�
echo "���뱾�ش�����������Ķ˿�"
read -p "����������:" port
echo "����udpspeeder����˿ڣ�������������˿�-1������Ҫʹ����ռ�ö˿�"
read -p "����������:" udpspeederport
echo "����udp2raw�����Ķ˿ڣ�udpspeeder����˿�-1������Ҫʹ����ռ�ö˿�"
read -p "����������:" udp2rawport

mkdir /usr/src/$yourdir
mkdir /usr/src/$yourdir/client
cd /usr/src/$yourdir/client
wget https://github.com/czwolfkkk/UDPSpeeder-Udp2raw/raw/master/client/speederv2.exe
wget https://github.com/czwolfkkk/UDPSpeeder-Udp2raw/raw/master/client/udp2raw.exe
wget https://raw.githubusercontent.com/czwolfkkk/UDPSpeeder-Udp2raw/master/client/start.bat
wget https://raw.githubusercontent.com/czwolfkkk/UDPSpeeder-Udp2raw/master/client/stop.bat
cd /usr/src/$yourdir
wget https://github.com/czwolfkkk/UDPSpeeder-Udp2raw/raw/master/speederv2_amd64
wget https://github.com/czwolfkkk/UDPSpeeder-Udp2raw/raw/master/udp2raw_amd64
chmod +x speederv2_amd64 udp2raw_amd64

#���ò���
serverip=$(curl icanhazip.com)
sed -i "s/your_server_ip/$serverip/" /usr/src/$yourdir/client/start.bat
sed -i "s/udp2raw_server_port/$udp2rawport/" /usr/src/$yourdir/client/start.bat

#��������
nohup ./speederv2_amd64 -s -l127.0.0.1:$udpspeederport -r127.0.0.1:$port -k "wolf05220411" -f2:4 --mode 0 -q1 >speeder.log 2>&1 &
nohup ./udp2raw_amd64 -s -l0.0.0.1:$udp2rawport -r127.0.0.1:$udpspeederport -k "wolf05220411" --raw-mode faketcp -a

#д�뿪������
myfile="/etc/rc.d/init.d/kcpandudp"
if [ ! -f "$myfile" ]; then
cat > /etc/rc.d/init.d/kcpandudp<<-EOF
#!/bin/sh
#chkconfig: 2345 80 90
#description:kcpandudp
cd /usr/src/$yourdir
nohup ./speederv2_amd64 -s -l127.0.0.1:$udpspeederport -r127.0.0.1:$port -k "wolf05220411" -f2:4 --mode 0 -q1 >speeder.log 2>&1 &
nohup ./udp2raw_amd64 -s -l0.0.0.1:$udp2rawport -r127.0.0.1:$udpspeederport -k "wolf05220411" --raw-mode faketcp -a
EOF

chmod +x /etc/rc.d/init.d/kcpandudp
chkconfig --add kcpandudp
chkconfig kcpandudp on
else 
cat >> /etc/rc.d/init.d/kcpandudp<<-EOF
cd /usr/src/$yourdir
nohup ./speederv2_amd64 -s -l127.0.0.1:$udpspeederport -r127.0.0.1:$port -k "wolf05220411" -f2:4 --mode 0 -q1 >speeder.log 2>&1 &
nohup ./udp2raw_amd64 -s -l0.0.0.1:$udp2rawport -r127.0.0.1:$udpspeederport -k "wolf05220411" --raw-mode faketcp -a
EOF

fi
echo "��װ���"
else
echo "�ļ����Ѵ���"
fi
