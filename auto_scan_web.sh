# !/bin/bash

# [WARN]注意运行时要用(This is ruler) user@system$ bash auto_network_scan.sh
# 使用此脚本的前提是安装有，ping，nmap，scapy，等程序
# 作者：Chemistry&Programing,  zhang233Program@gmail.com  or  2331858952@qq.com， 时间 : 2020/3/31

user_name=$(whoami)

if [ "$user_name" == 'root' ]; then

   read -p "请输入目标网站的主机记录[URL]：" net_name

   ip_nmap=$(nmap $net_name | grep "Nmap scan" | cut -d '(' -f 2 | cut -d ')' -f 1)
   #对用户输入的URL进行扫描得到它的IP

   scan_net=$(ping -c 3 $net_name)
   #if是如果上面的命令正确运行，将会运行下面的代码

   if [ "$?" == 0 ]; then

        echo -e "\e[1;31m 目标主机存活！(System survival)\e[0m"
        scan_nmap=$(nmap $net_name | grep open | cut -d '/' -f 1)
        #扫描目标机器，查看其开放端口（look open ports）

        echo $scan_nmap >/root/.auto_scan_nmap
        nums=$(grep -o " " /root/.auto_scan_nmap | wc -l)
        #检查端口号之间的空格有多少进而为以下运算做准备

        addnum=$(($nums + 1))
        #计算共有几个端口

        for (( i=1; i<=$addnum; i++ )) 
        do
            one_port=$(cat /root/.auto_scan_nmap | cut -d ' ' -f $i)
            #依次将端口号赋值到变量one_port中

            echo 'sr1(IP(dst="'$ip_nmap'")/TCP(flags="S",dport='$one_port'),timeout=0.1)' >/root/.auto_scan_ports
            echo -e "\e[1;31m 扫描开放端口(scan open port): "$one_port" \e[0m"
            scapy < /root/.auto_scan_ports 2>&1 | grep flags
       done

       exit

    fi

   echo -e "\e[1;31m 错误的IP或域名！\e[0m"

    else

        read -p "请输入目标网站的主机记录[URL]：" net_name

        ip_nmap=$(nmap $net_name | grep "Nmap scan" | cut -d '(' -f 2 | cut -d ')' -f 1)
        #对用户输入的URL进行扫描得到它的IP

        scan_net=$(ping -c 3 $net_name)

        #if是如果上面的命令正确运行，将会运行下面的代码
        if [ "$?" == 0 ]; then

            echo -e "\e[1;31m 目标主机存活！(System survival)\e[0m"
            scan_nmap=$(nmap $net_name | grep open | cut -d '/' -f 1)
            #扫描目标机器，查看其开放端口（look open ports）

            echo $scan_nmap >/home/$user_name/.auto_scan_nmap
            nums=$(grep -o " " /home/$user_name/.auto_scan_nmap | wc -l)
            #检查端口号之间的空格有多少进而为以下运算做准备

            addnum=$(($nums + 1))
            #计算共有几个端口

            for (( i=1; i<=$addnum; i++ )) 
            do
                one_port=$(cat /home/$user_name/.auto_scan_nmap | cut -d ' ' -f $i)
                #依次将端口号赋值到变量one_port中

                echo 'sr1(IP(dst="'$ip_nmap'")/TCP(flags="S",dport='$one_port'),timeout=0.1)' >/home/$user_name/.auto_scan_ports
                echo -e "\e[1;31m 扫描开放端口(scan open port): "$one_port" \e[0m"
                scapy < /home/$user_name/.auto_scan_ports 2>&1 | grep flags

        done

        exit

    fi

    echo -e "\e[1;31m 错误的IP或域名！\e[0m"

fi