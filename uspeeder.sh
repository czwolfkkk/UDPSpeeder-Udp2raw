#!/bin/bash

#    "========================="
#    " 介绍：适用于CentOS7"
#    " 作者：atrandys"
#    " 网站：www.atrandys.com"
#    " Youtube：atrandys"
#    "========================="

#开始
echo
echo "========================="
echo " 介绍：适用于CentOS7"
echo " 作者：atrandys"
echo " 网站：www.atrandys.com"
echo " Youtube：atrandys"
echo "========================="
echo
echo "给即将安装的软件设置一个文件夹名称,新建文件夹的目录在/usr/src/下"
echo "如果多开，文件夹名称不能相同，举例可设置为game1、game2"
read -p "请输入文件夹名称:" yourdir
ifdir="/usr/src/"$yourdir
if [ ! -d "$ifdir" ]; then
#下载几个配置文件
echo "键入本地代理软件监听的端口"
read -p "请输入数字:" port
echo "键入udpspeeder输出端口（代理软件监听端口-1），不要使用已占用端口"
read -p "请输入数字:" udpspeederport
echo "键入udp2raw监听的端口（udpspeeder输出端口-1），不要使用已占用端口"
read -p "请输入数字:" udp2rawport

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

#设置参数
serverip=$(curl icanhazip.com)
sed -i "s/your_server_ip/$serverip/" /usr/src/$yourdir/client/start.bat
sed -i "s/udp2raw_server_port/$udp2rawport/" /usr/src/$yourdir/client/start.bat

#启动服务
nohup ./speederv2_amd64 -s -l127.0.0.1:$udpspeederport -r127.0.0.1:$port -k "wolf05220411" -f2:4 --mode 0 -q1 >speeder.log 2>&1 &
nohup ./udp2raw_amd64 -s -l0.0.0.1:$udp2rawport -r127.0.0.1:$udpspeederport -k "wolf05220411" --raw-mode faketcp -a

#写入开机自启
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
echo "安装完成"
else
echo "文件夹已存在"
fi

