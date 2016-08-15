#!/bin/sh
#Support https://github.com/alexeymalets/nginx-install-auto
#Soft Nginx Install/Upgrade auto
#Install Nginx mainline version 
#Author Alex Malets

loc_none_script='Unfortunately, the script is Nginx Install/Upgrade auto Your OS does not support'
loc_your_os='Your OS';
loc_go_to_dir='Go to the directory'
loc_add_rep='Add the repository Nginx'
loc_check_key_sys='Performs the validation set key'
loc_add_key='Add key'
loc_check_nginx='Check Nginx is installed'
loc_install_nginx='Install Nginx'
loc_nginx_al_in='Nginx already installed.'
loc_nginx_upgrade='Do update Nginx'
loc_nginx_repo_find='You have already installed the Nginx repository.'
loc_install_last_v_nginx='To install the latest version of Nginx?'
loc_yes='Yes'
loc_no='No'
loc_choose='Choose'
loc_remove_repo='Remove the current repository with Nginx system'
loc_mainline_repo='Add mainline repository'
loc_install_last_ver='Install Nginx latest version'
loc_upgrade_last_ver='Upgrade Nginx latest version'
loc_no_install_last_ver='You refused to install the latest version'
loc_setup_last_version='You have the latest version of Nginx'
loc_restart_nginx='Restart Nginx'
loc_status_nginx='Check the status of the service'
loc_upgrade_nginx_sf='Nginx is successfully updated to the latest version'
loc_upgrade_nginx_faild='Unfortunately, during the upgrade had problems, so the service is not running. To solve, You can write to:'
loc_srv_admin='Free help with server administration'
loc_myhosti='Support your servers 24/7'
loc_error='Error'
loc_thanks_soft='Thank You for using this software!'
loc_ver_repo='Which version would You like to install ?'

clear
#OS Version Ubuntu 16
if [ "$(cat /etc/*-release | grep xenial)" ]; then
	dist=ubuntu
	osv=xenial
#OS Version Ubuntu 15
elif [ "$(cat /etc/*-release | grep wily)" ]; then
	dist=ubuntu
	osv=wily
	dist=ubuntu
#OS Version Ubuntu 14
elif [ "$(cat /etc/*-release | grep trusty)" ]; then
	dist=ubuntu
	osv=trusty
#OS Version Ubuntu 12
elif [ "$(cat /etc/*-release | grep precise)" ]; then
	dist=ubuntu
	osv=precise
#OS Version Debian 8
elif [ "$(cat /etc/*-release | grep jessie)" ]; then
	dist=debian
	osv=jessie
#OS Version Debian 7
elif [ "$(cat /etc/*-release | grep wheezy)" ]; then
	dist=debian
	osv=wheezy
#OS Version Centos 5
elif [ "$(cat /etc/*-release | grep 'CentOS release 5')" ] || [ "$(cat /etc/*-release | grep 'CloudLinux release 5')" ]; then
	dist=centos
	osv=5
#OS Version Centos 6
elif [ "$(cat /etc/*-release | grep 'CentOS release 6')" ] || [ "$(cat /etc/*-release | grep 'CloudLinux release 6')" ]; then
	dist=centos
	osv=6
#OS Version Centos 7
elif [ "$(cat /etc/*-release | grep 'CentOS Linux release 7')" ] || [ "$(cat /etc/*-release | grep 'CloudLinux release 7')" ]; then
	dist=centos
	osv=7
else
	echo "${loc_none_script}!"
	exit 0
fi
if [ "${dist}" = "debian" ] || [ "${dist}" = "ubuntu" ]; then
	echo "${loc_your_os} ${dist} ${osv}"
else
	echo "${loc_your_os} ${dist} ${osv}"	
fi
checknginxstatus=0

if [ "${dist}" = "debian" ] || [ "${dist}" = "ubuntu" ]; then
	if [ -z "$(grep -rn "nginx.org" /etc/apt/)" ]; then
		echo "${loc_ver_repo}"
		echo "1) Mainline"
		echo "2) Stable"
		read -p "${loc_choose}: " ver_repo
		if [ $ver_repo -eq 1 ]; then
			echo "${loc_go_to_dir} /etc/apt/sources.list.d/"
			cd /etc/apt/sources.list.d/
			echo "${loc_add_rep}"
			touch nginx.list
			echo "deb http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
			echo "deb-src http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
		else
			echo "${loc_go_to_dir} /etc/apt/sources.list.d/"
			cd /etc/apt/sources.list.d/
			echo "${loc_add_rep}"
			touch nginx.list
			echo "deb http://nginx.org/packages/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
			echo "deb-src http://nginx.org/packages/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
		fi
		
		cd
		echo "${loc_check_key_sys}"
		if [ -z "$(apt-key list | grep nginx)" ]; then
			echo "${loc_add_key}"
			wget http://nginx.org/keys/nginx_signing.key
			apt-key add nginx_signing.key
		fi
		echo "${loc_check_nginx}"

		if [ -z "$(dpkg -l|grep nginx)" ]; then
			echo "${loc_install_nginx}"
			apt-get update && apt-get -y install nginx
		else
			echo "${loc_nginx_al_in}"
			echo "${loc_nginx_upgrade}"
			apt-get update && apt-get -y upgrade nginx
		fi
	else
		if [ -z "$(grep -rn "nginx.org/packages/mainline" /etc/apt/)" ]; then
			echo "${loc_nginx_repo_find}"
			echo "${loc_install_last_v_nginx}"
			echo "1) ${loc_yes}"
			echo "2) ${loc_no}"
			read -p "${loc_choose}: " installnginx
			if [ $installnginx -eq 1 ]; then
				echo "${loc_go_to_dir} /etc/apt/sources.list.d/"
				cd /etc/apt/sources.list.d/
				echo "${loc_remove_repo}"
				for listnginx in $(grep -rl "nginx.org" /etc/apt/)
				do
					sed -i '/nginx.org/d' $listnginx
				done
				echo "${loc_mainline_repo}"
				touch nginx.list
				echo "deb http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
				echo "deb-src http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
				if [ -z "$(dpkg -l|grep nginx)" ]; then
					echo "${loc_install_last_ver}"
					apt-get update && apt-get -y install nginx
				else
					echo "${loc_upgrade_last_ver}"
					apt-get update && apt-get -y upgrade nginx
				fi
			else
				echo "${loc_no_install_last_ver}"
				exit 0
			fi
		else
			echo "${loc_setup_last_version}"
			if [ -z "$(dpkg -l|grep nginx)" ]; then
				echo "${loc_install_last_ver}"
				apt-get update && apt-get -y install nginx
			else
				echo "${loc_upgrade_last_ver}"
				apt-get update && apt-get -y upgrade nginx
			fi
		fi
	fi
	checknginxstatus=1
else
	if [ -z "$(grep -rn "nginx.org" /etc/yum.repos.d/)" ]; then
		echo "${loc_ver_repo}"
		echo "1) Mainline"
		echo "2) Stable"
		read -p "${loc_choose}: " ver_repo
		if [ $ver_repo -eq 1 ]; then
			echo "${loc_go_to_dir} /etc/yum.repos.d/"
			cd /etc/yum.repos.d/
			echo "${loc_add_rep}"
			touch nginx.repo			
			echo "[nginx]" | tee -a /etc/yum.repos.d/nginx.repo
			echo "name=nginx repo" | tee -a /etc/yum.repos.d/nginx.repo
			echo "baseurl=http://nginx.org/packages/mainline/${dist}/${osv}/"'$basearch/' | tee -a /etc/yum.repos.d/nginx.repo
			echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nginx.repo
			echo "enabled=1" | tee -a /etc/yum.repos.d/nginx.repo
		else
			echo "${loc_go_to_dir} /etc/yum.repos.d/"
			cd /etc/yum.repos.d/
			echo "${loc_add_rep}"
			touch nginx.repo
			echo "[nginx]" | tee -a /etc/yum.repos.d/nginx.repo
			echo "name=nginx repo" | tee -a /etc/yum.repos.d/nginx.repo
			echo "baseurl=http://nginx.org/packages/${dist}/${osv}/"'$basearch/' | tee -a /etc/yum.repos.d/nginx.repo
			echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nginx.repo
			echo "enabled=1" | tee -a /etc/yum.repos.d/nginx.repo
		fi	
		
		cd
		echo "${loc_check_key_sys}"
		if [ -z "$(rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n' | grep nginx)" ]; then
			echo "${loc_add_key}"
			wget http://nginx.org/keys/nginx_signing.key
			rpm --import nginx_signing.key
		fi
		
		echo "${loc_check_nginx}"

		if [ -z "$(yum list installed|grep nginx)" ]; then
			echo "${loc_install_nginx}"
			yum -y update && yum -y install nginx
		else
			echo "${loc_nginx_al_in}"
			echo "${loc_nginx_upgrade}"
			yum update -y nginx
		fi
	else
		if [ -z "$(grep -rn "nginx.org/packages/mainline" /etc/yum.repos.d/)" ]; then
			echo "${loc_nginx_repo_find}"
			echo "${loc_install_last_v_nginx}"
			echo "1) ${loc_yes}"
			echo "2) ${loc_no}"
			read -p "${loc_choose}: " installnginx
			if [ $installnginx -eq 1 ]; then
				echo "${loc_go_to_dir}  /etc/yum.repos.d/"
				cd /etc/yum.repos.d/
				echo "${loc_remove_repo}"
				for listnginx in $(grep -rl "nginx.org" /etc/yum.repos.d/)
				do
					rm -rf $listnginx
				done
				echo "${loc_mainline_repo}"
				touch nginx.repo	
				echo "[nginx]" | tee -a /etc/yum.repos.d/nginx.repo
				echo "name=nginx repo" | tee -a /etc/yum.repos.d/nginx.repo
				echo "baseurl=http://nginx.org/packages/mainline/${dist}/${osv}/"'$basearch/' | tee -a /etc/yum.repos.d/nginx.repo
				echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nginx.repo
				echo "enabled=1" | tee -a /etc/yum.repos.d/nginx.repo
				echo "${loc_check_key_sys}"
				if [ -z "$(rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n' | grep nginx)" ]; then
					echo "${loc_add_key}"
					wget http://nginx.org/keys/nginx_signing.key
					rpm --import nginx_signing.key
				fi
				echo "${loc_upgrade_last_ver}"			
				yum update -y nginx
			else
				echo "${loc_no_install_last_ver}"
			fi
		else
			echo "${loc_setup_last_version}"
			if [ -z "$(yum list installed|grep nginx)" ]; then
				echo "${loc_install_last_ver}"
				yum -y update && yum -y install nginx
			else
				echo "${loc_upgrade_last_ver}"
				yum update -y nginx
			fi
		fi
	fi
	checknginxstatus=1
fi
if [ $checknginxstatus -eq 1 ]; then
	echo "${loc_restart_nginx}"
	if [ "${dist}" = "debian" ] && [ "${osv}" = "8" ] || [ "${dist}" = "ubuntu" ] && [ "${osv}" = "xenial" ] || [ "${dist}" = "centos" ] && [ "${osv}" = "7" ]; then
		systemctl restart nginx
		echo "${loc_status_nginx}"
		if [ -z "$(systemctl status nginx | grep "inactive")" ] && [ -z "$(systemctl status nginx | grep "failed")" ]; then
			echo "${loc_upgrade_nginx_sf}!"		
		else
			echo "${loc_upgrade_nginx_faild}"
			echo "GitHub https://github.com/alexeymalets/nginx-install-auto/issues"
			echo "${loc_srv_admin} http://svradmin.ru/"
			echo "${loc_myhosti}(24/7) https://myhosti.pro"
			echo "${loc_error} :$(systemctl status nginx.service
			)"
		fi
	else
		service nginx restart
		echo "${loc_status_nginx}"
		if [ -z "$(service nginx status | grep stopped)" ] && [ -z "$(service nginx status | grep failed)" ]; then
			echo "${loc_upgrade_nginx_sf}!"		
		else
			echo "${loc_upgrade_nginx_faild}"
			echo "GitHub https://github.com/alexeymalets/nginx-install-auto/issues"
			echo "${loc_srv_admin} http://svradmin.ru/"
			echo "${loc_myhosti}(24/7) https://myhosti.pro"
			echo "${loc_error} :$(tail -n 10 /var/log/nginx/error.log)"
		fi
	fi
fi

echo "${loc_thanks_soft}"