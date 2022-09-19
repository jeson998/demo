#/bin/bash
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"

ins_file="/usr/bin/ss-server"

install(){
#添加网卡
ifconfig eth0:0 10.0.0.11 broadcast 10.0.255.255  netmask 255.255.0.0
ifconfig eth0:1 10.0.0.12 broadcast 10.0.255.255  netmask 255.255.0.0
ifconfig eth0:2 10.0.0.13 broadcast 10.0.255.255  netmask 255.255.0.0
ifconfig eth0:3 10.0.0.14 broadcast 10.0.255.255  netmask 255.255.0.0
ifconfig eth0:4 10.0.0.15 broadcast 10.0.255.255  netmask 255.255.0.0
ifconfig eth0:5 10.0.0.16 broadcast 10.0.255.255  netmask 255.255.0.0
ifconfig eth0:6 10.0.0.17 broadcast 10.0.255.255  netmask 255.255.0.0
ifconfig eth0:7 10.0.0.18 broadcast 10.0.255.255  netmask 255.255.0.0
ifconfig eth0:8 10.0.0.19 broadcast 10.0.255.255  netmask 255.255.0.0

#获取公网IP
ip10=`curl --interface eth0 ifconfig.me`
ip11=`curl --interface eth0:0 ifconfig.me`
ip12=`curl --interface eth0:1 ifconfig.me`
ip13=`curl --interface eth0:2 ifconfig.me`
ip14=`curl --interface eth0:3 ifconfig.me`
ip15=`curl --interface eth0:4 ifconfig.me`
ip16=`curl --interface eth0:5 ifconfig.me`
ip17=`curl --interface eth0:6 ifconfig.me`
ip18=`curl --interface eth0:7 ifconfig.me`
ip19=`curl --interface eth0:8 ifconfig.me`


#安装shadowsocks-libev
apt update
apt install shadowsocks-libev


#开启BBR
modprobe tcp_bbr  
echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf  
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
sysctl net.ipv4.tcp_congestion_control

wget -O encode.sh https://raw.githubusercontent.com/jeson998/demo/main/encode.sh
chmod +x encode.sh
}

start(){
  nohup ss-server -s 10.0.0.4 -p 30022 -u -b 10.0.0.4 -k 111111 -m chacha20-ietf &
  nohup ss-server -s 10.0.0.11 -p 30022 -u -b 10.0.0.11 -k 111111 -m chacha20-ietf &
  nohup ss-server -s 10.0.0.12 -p 30022 -u -b 10.0.0.12 -k 111111 -m chacha20-ietf &
  nohup ss-server -s 10.0.0.13 -p 30022 -u -b 10.0.0.13 -k 111111 -m chacha20-ietf &
  nohup ss-server -s 10.0.0.14 -p 30022 -u -b 10.0.0.14 -k 111111 -m chacha20-ietf &
  nohup ss-server -s 10.0.0.15 -p 30022 -u -b 10.0.0.15 -k 111111 -m chacha20-ietf &
  nohup ss-server -s 10.0.0.16 -p 30022 -u -b 10.0.0.16 -k 111111 -m chacha20-ietf &
  nohup ss-server -s 10.0.0.17 -p 30022 -u -b 10.0.0.17 -k 111111 -m chacha20-ietf &
  nohup ss-server -s 10.0.0.18 -p 30022 -u -b 10.0.0.18 -k 111111 -m chacha20-ietf &
  nohup ss-server -s 10.0.0.19 -p 30022 -u -b 10.0.0.19 -k 111111 -m chacha20-ietf &
}

stop(){
  pkill ss-server
}

generate(){
	#获取公网IP
ip10=`curl --interface eth0 ifconfig.me`
ip11=`curl --interface eth0:0 ifconfig.me`
ip12=`curl --interface eth0:1 ifconfig.me`
ip13=`curl --interface eth0:2 ifconfig.me`
ip14=`curl --interface eth0:3 ifconfig.me`
ip15=`curl --interface eth0:4 ifconfig.me`
ip16=`curl --interface eth0:5 ifconfig.me`
ip17=`curl --interface eth0:6 ifconfig.me`
ip18=`curl --interface eth0:7 ifconfig.me`
ip19=`curl --interface eth0:8 ifconfig.me`
  for i in {10..19};do
      while true
      do
        nip=ip${i}
        #pass=`echo "111111"|base64`
        mark=`echo "${!nip}"|base64`
        str="${!nip}:30022:auth_sha1_v4:chacha20-ietf:plain:MTExMTEx/?remarks=${mark}"
        #echo $str
	      ./encode.sh $str encode
        #echo "ShadowsocksR链接：ssr://$str" >> link.log      
        break
      done
  done
}

check_pid(){
        PID=`ps -ef| grep "ss-server"| grep -v "grep" | grep -v "init.d" |grep -v "service" |awk '{print $2}'`
}


if [ "$1" ];then
echo && echo -e "  SSR 一键管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  
 ${Green_font_prefix} 1.${Font_color_suffix} 安装 SSR
 ${Green_font_prefix} 2.${Font_color_suffix} 启动 服务
 ${Green_font_prefix} 3.${Font_color_suffix} 关闭 服务
 ${Green_font_prefix} 4.${Font_color_suffix} 生成SSR链接
————————————" && echo
        if [[ -e ${ins_file} ]]; then
                check_pid
                if [[ ! -z "${PID}" ]]; then
                        echo -e " 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} 并 ${Green_font_prefix}已启动${Font_color_suffix}"
                else
                        echo -e " 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} 但 ${Red_font_prefix}未启动${Font_color_suffix}"
                fi
        else
                echo -e " 当前状态: ${Red_font_prefix}未安装${Font_color_suffix}"
        fi
        echo
        read -e -p " 请输入数字 [1-4]:" num
        case "$num" in
                1)
                install
    start
    generate
                ;;
                2)
                start
                ;;
                3)
                stop
                ;;
                4)
                generate
                ;;
                *)
                echo "请输入正确数字 [1-4]"
                ;;
       esac

else
    install
    start
    generate
fi

  
