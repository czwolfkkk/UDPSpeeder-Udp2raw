@ECHO OFF 
%1 start mshta vbscript:createobject("wscript.shell").run("""%~0"" ::",0)(window.close)&&exit

start /b udp2raw.exe -c -l127.0.0.1:9898 -ryour_server_ip:udp2raw_server_port -k "wolf05220411" --raw-mode faketcp
start /b speederv2.exe -c -l0.0.0.0:9897 -ryour_server_ip:9898 -k "wolf05220411" --mode 0 -f2:4 -q1 
