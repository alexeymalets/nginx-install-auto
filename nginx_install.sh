#!/bin/sh
#Support https://github.com/alexeymalets/nginx-install-auto
#Install Nginx mainline version 
#Author Alex Malets

BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BGRED='\033[41m'
NORMAL='\033[0m'

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
#OS Version Debian 8
elif [ "$(cat /etc/*-release | grep jessie)" ]; then
	dist=debian
	osv=jessie
#OS Version Debian 7
elif [ "$(cat /etc/*-release | grep wheezy)" ]; then
	dist=debian
	osv=wheezy
#OS Version Centos 5
elif [ "$(cat /etc/issue | grep "CentOS release 5")" ]; then
	dist=centos
	osv=5
#OS Version Centos 6
elif [ "$(cat /etc/issue | grep "CentOS release 6")" ]; then
	dist=centos
	osv=6
#OS Version Centos 7
elif [ "$(cat /etc/issue | grep "CentOS release 7")" ]; then
	dist=centos
	osv=7
else
	echo "${BOLD}Your operating system is not supported!${NORMAL}"
	exit 0
fi

echo "${BOLD}${BGRED}Your OS ${dist} ${osv}${NORMAL}"

if [ "${dist}" = "debian" ] || [ "${dist}" = "ubuntu" ]; then
	if [ -z "$(grep -rn "nginx.org" /etc/apt/)" ]; then
		echo "${GREEN}Go to the directory /etc/apt/sources.list.d/${NORMAL}"
		cd /etc/apt/sources.list.d/

		echo "${GREEN}Adding repository Nginx${NORMAL}"
		touch nginx.list
		echo "deb http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
		echo "deb-src http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
		
		cd
		echo "${GREEN}Check installed key${NORMAL}"
		if [ -z "apt-key list | grep nginx" ]; then
			echo "${GREEN}Adding key${NORMAL}"
			wget http://nginx.org/keys/nginx_signing.key
			apt-key add nginx_signing.key
		fi
		echo "${GREEN}Check installed Nginx${NORMAL}"

		if [ -z "$(dpkg -l|grep nginx)" ]; then
			echo "${BOLD}${GREEN}Install nginx${NORMAL}"
			apt-get update && apt-get -y install nginx
			echo "${GREEN}Restart Nginx${NORMAL}"
			service nginx restart
			echo "${GREEN}Check the operation of the service${NORMAL}"
			if [ -z $(service nginx status | grep "inactive") ]; then
				echo "Nginx is successfully updated to the latest version!"				
			else
				echo "${RED}${BOLD}Unfortunately, during the upgrade package error! To solve the problem, write on the forum:${NORMAL}"
				echo "${BOLD}https://github.com/alexeymalets/nginx-install-auto/issues${NORMAL}"
				echo "Error:$(tail -n 10 /var/log/nginxerror.log)"
			fi
		else
			echo "${BOLD}${GREEN}Nginx is already installed.${NORMAL}"
			echo "${GREEN}We perform a complete upgrade of the Nginx?${NORMAL}"
			echo "1) Yes"
			echo "2) No"
			read -p "Choose: " upradesystem
			if [ $upradesystem -eq 1 ]; then
				echo "${GREEN}Getting update Nginx${NORMAL}"
				apt-get update && apt-get -y upgrade nginx
				echo "${GREEN}Restart Nginx${NORMAL}"
				service nginx restart
				echo "${GREEN}Check the operation of the service${NORMAL}"
				if [ -z $(service nginx status | grep "inactive") ]; then
					echo "Nginx is successfully updated to the latest version!"				
				else
					echo "${RED}${BOLD}Unfortunately, during the upgrade package error! To solve the problem, write on the forum:${NORMAL}"
					echo "${BOLD}https://github.com/alexeymalets/nginx-install-auto/issues${NORMAL}"
					echo "Error:$(tail -n 10 /var/log/nginxerror.log)"
				fi
			else
				echo "${BOLD}${RED}You refused to update.${NORMAL}"
			fi
		fi
	else
		echo "${BOLD}${RED}You already have installed Nginx repository.${NORMAL}"
		echo "${BOLD}${GREEN}To install latest version Nginx?${NORMAL}"
		echo "1) Yes"
		echo "2) No"
		read -p "Choose: " installnginx
		if [ $installnginx -eq 1 ]; then
			echo "${GREEN}Go to the directory /etc/apt/sources.list.d/${NORMAL}"
			cd /etc/apt/sources.list.d/
			echo "${GREEN}Remove repositories with Nginx${NORMAL}"
			for listnginx in $(grep -rl "nginx.org" /etc/apt/)
			do
				sed -i '/nginx.org/d' $listnginx
			done
			touch nginx.list
			echo "deb http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
			echo "deb-src http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
			apt-get update && apt-get -y upgrade nginx
			echo "${BOLD}${GREEN}Nginx has been successfully updated${NORMAL}"
			service nginx restart
			echo "${GREEN}Check the operation of the service${NORMAL}"
			if [ -z $(service nginx status | grep "inactive") ]; then
				echo "Nginx is successfully updated to the latest version!"				
			else
				echo "${RED}${BOLD}Unfortunately, during the upgrade package error! To solve the problem, write on the forum:${NORMAL}"
				echo "${BOLD}http://svradmin.ru/threads/ustanovka-poslednej-versii-nginx.40/#post-164${NORMAL}"
				echo "Error:$(tail -n 10 /var/log/nginxerror.log)"
			fi
		else
			echo "${BOLD}${RED}You refused to update.${NORMAL}"
		fi
	fi
else
	if [ -z "$(grep -rn "nginx.org" /etc/yum.repos.d/)" ]; then
		echo "${GREEN}Go to the directory /etc/yum.repos.d/${NORMAL}"
		cd /etc/yum.repos.d/

		echo "${GREEN}Adding repository Nginx${NORMAL}"
		touch nginx.repo	
		echo "[nginx]" | tee -a /etc/yum.repos.d/nginx.repo
		echo "name=nginx repo" | tee -a /etc/yum.repos.d/nginx.repo
		echo "baseurl=http://nginx.org/packages/mainline/${dist}/${osv}/$basearch/" | tee -a /etc/yum.repos.d/nginx.repo
		echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nginx.repo
		echo "enabled=1" | tee -a /etc/yum.repos.d/nginx.repo
		cd
		echo "${GREEN}Check installed key${NORMAL}"
		if [ -z "rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n' | grep nginx" ]; then
			echo "${GREEN}Adding key${NORMAL}"
			wget http://nginx.org/keys/nginx_signing.key
			rpm --import nginx_signing.key
		fi
		
		echo "${GREEN}Check installed Nginx${NORMAL}"

		if [ -z "$(yum list installed|grep nginx)" ]; then
			echo "${BOLD}${GREEN}Install nginx${NORMAL}"
			yum update && yum -y install nginx
			echo "${GREEN}Restart Nginx${NORMAL}"
			service nginx restart
			echo "${GREEN}Check the operation of the service${NORMAL}"
			if [ -z $(service nginx status | grep "inactive") ]; then
				echo "Nginx is successfully updated to the latest version!"				
			else
				echo "${RED}${BOLD}Unfortunately, during the upgrade package error! To solve the problem, write on the forum:${NORMAL}"
				echo "${BOLD}https://github.com/alexeymalets/nginx-install-auto/issues${NORMAL}"
				echo "Error:$(tail -n 10 /var/log/error.log)"
			fi
		else
			echo "${BOLD}${GREEN}Nginx is already installed.${NORMAL}"
			echo "${GREEN}We perform a complete upgrade of the Nginx?${NORMAL}"
			echo "1) Yes"
			echo "2) No"
			read -p "Choose: " upradesystem
			if [ $upradesystem -eq 1 ]; then
				echo "${GREEN}Getting update Nginx${NORMAL}"
				yum update -y nginx
				echo "${GREEN}Restart Nginx${NORMAL}"
				service nginx restart
				echo "${GREEN}Check the operation of the service${NORMAL}"
				if [ -z $(service nginx status | grep "inactive") ]; then
					echo "Nginx is successfully updated to the latest version!"				
				else
					echo "${RED}${BOLD}Unfortunately, during the upgrade package error! To solve the problem, write on the forum:${NORMAL}"
					echo "${BOLD}https://github.com/alexeymalets/nginx-install-auto/issues${NORMAL}"
					echo "Error:$(tail -n 10 /var/log/nginxerror.log)"
				fi
			else
				echo "${BOLD}${RED}You refused to update.${NORMAL}"
			fi
		fi
	else
		echo "${BOLD}${RED}You already have installed Nginx repository.${NORMAL}"
		echo "${BOLD}${GREEN}To install latest version Nginx?${NORMAL}"
		echo "1) Yes"
		echo "2) No"
		read -p "Choose: " installnginx
		if [ $installnginx -eq 1 ]; then
			echo "${GREEN}Go to the directory /etc/yum.repos.d/${NORMAL}"
			cd /etc/yum.repos.d/
			echo "${GREEN}Remove repositories with Nginx${NORMAL}"
			for listnginx in $(grep -rl "nginx.org" /etc/yum.repos.d/)
			do
				rm -rf $listnginx
			done
			echo "${GREEN}Adding repository Nginx${NORMAL}"
			touch nginx.repo	
			echo "[nginx]" | tee -a /etc/yum.repos.d/nginx.repo
			echo "name=nginx repo" | tee -a /etc/yum.repos.d/nginx.repo
			echo "baseurl=http://nginx.org/packages/mainline/${dist}/${osv}/$basearch/" | tee -a /etc/yum.repos.d/nginx.repo
			echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nginx.repo
			echo "enabled=1" | tee -a /etc/yum.repos.d/nginx.repo
			cd
			echo "${GREEN}Check installed key${NORMAL}"
			if [ -z "rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n' | grep nginx" ]; then
				echo "${GREEN}Adding key${NORMAL}"
				cd
				wget http://nginx.org/keys/nginx_signing.key
				rpm --import nginx_signing.key
			fi
			echo "${GREEN}Getting update Nginx${NORMAL}"			
			yum update -y nginx
			echo "${GREEN}Restart Nginx${NORMAL}"
			service nginx restart
			echo "${GREEN}Check the operation of the service${NORMAL}"
			if [ -z $(service nginx status | grep "inactive") ]; then
				echo "Nginx is successfully updated to the latest version!"				
			else
				echo "${RED}${BOLD}Unfortunately, during the upgrade package error! To solve the problem, write on the forum:${NORMAL}"
				echo "${BOLD}https://github.com/alexeymalets/nginx-install-auto/issues${NORMAL}"
				echo "Error:$(tail -n 10 /var/log/nginxerror.log)"
			fi
		else
			echo "${BOLD}${RED}You refused to update.${NORMAL}"
		fi
	fi
fi
