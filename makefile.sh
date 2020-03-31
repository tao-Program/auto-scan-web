# !/bin/bash

#此脚本为用户创建扫描时数据的存储文件
#运行主程序前先运行此脚本


user_name=$(whoami)

if [ "$user_name" == 'root' ]; then

	touch /root/.auto_scan_nmap
	touch /root/.auto_scan_ports

else

    touch /home/$user_name/.auto_scan_nmap
    touch /home/$user_name/.auto_scan_ports

fi

mv auto_scan_web.sh auto-scan-web
your_pwd=$(pwd)
mv $your_pwd/auto-scan-web /bin