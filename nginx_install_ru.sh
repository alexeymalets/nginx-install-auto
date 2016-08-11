#!/bin/sh
#Support https://github.com/alexeymalets/nginx-install-auto
#Soft Nginx Install/Upgrade auto
#Install Nginx mainline version 
#Author Alex Malets

loc_none_script='К сожалению, скрипт Nginx Install/Upgrade auto Вашу ОС не поддерживает'
loc_your_os='Ваша ОС';
loc_go_to_dir='Переходим в директорию'
loc_add_rep='Добавляем репозиторий Nginx'
loc_check_key_sys='Выполняем проверку установлен ли ключ'
loc_add_key='Добавляем ключ'
loc_check_nginx='Проверяем установлен ли Nginx'
loc_install_nginx='Устанавливаем Nginx'
loc_nginx_al_in='Nginx уже установлен.'
loc_nginx_upgrade='Выполняем обновление Nginx'
loc_nginx_repo_find='У Вас уже установлен Nginx репозиторий.'
loc_install_last_v_nginx='Выполнить установку последней версии Nginx?'
loc_yes='Да'
loc_no='Нет'
loc_choose='Ваш выбор'
loc_remove_repo='Удаляем текущие репозитории Nginx с системы'
loc_mainline_repo='Добавляем mainline репозиторий'
loc_install_last_ver='Устанавливаем Nginx актуальной версии'
loc_upgrade_last_ver='Обновляем Nginx до актуальной версии'
loc_no_install_last_ver='Вы отказались от установки последней версии'
loc_setup_last_version='У Вас установлена самая последняя версии Nginx'
loc_restart_nginx='Перезапускаем Nginx'
loc_status_nginx='Проверяем статус сервиса'
loc_upgrade_nginx_sf='Nginx успешно обновлён до последней версии'
loc_upgrade_nginx_faild='К сожалению, во время обновления возникли проблемы, поэтому служба незапущена. Для решения проблемы Вы можете написать на:'
loc_srv_admin='Бесплатная помощь с администрирование серверов'
loc_myhosti='В платный отдел администрирования'
loc_error='Ошибка'
loc_thanks_soft='Спасибо за использование данного ПО!'

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
elif [ "$(cat /etc/*-release | grep "CentOS release 5")" ]; then
	dist=centos
	osv=5
#OS Version Centos 6
elif [ "$(cat /etc/*-release | grep "CentOS release 6")" ]; then
	dist=centos
	osv=6
#OS Version Centos 7
elif [ "$(cat /etc/*-release | grep "CentOS")" ] && [ "$(cat /etc/*-release | grep "7")" ]; then
	dist=centos
	osv=7
else
	echo "${BOLD}${loc_none_script}${NORMAL}"
	exit 0
fi

echo "${BOLD}${BGRED}${loc_your_os} ${dist} ${osv}${NORMAL}"

checknginxstatus=0

if [ "${dist}" = "debian" ] || [ "${dist}" = "ubuntu" ]; then
	BOLD='\033[1m'
	RED='\033[0;31m'
	GREEN='\033[0;32m'
	BGRED='\033[41m'
	NORMAL='\033[0m'
	if [ -z "$(grep -rn "nginx.org" /etc/apt/)" ]; then
		echo "${GREEN}${loc_go_to_dir} /etc/apt/sources.list.d/${NORMAL}"
		cd /etc/apt/sources.list.d/

		echo "${GREEN}${loc_add_rep}${NORMAL}"
		touch nginx.list
		echo "deb http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
		echo "deb-src http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
		
		cd
		echo "${GREEN}${loc_check_key_sys}${NORMAL}"
		if [ -z "$(apt-key list | grep nginx)" ]; then
			echo "${GREEN}${loc_add_key}${NORMAL}"
			wget http://nginx.org/keys/nginx_signing.key
			apt-key add nginx_signing.key
		fi
		echo "${GREEN}${loc_check_nginx}${NORMAL}"

		if [ -z "$(dpkg -l|grep nginx)" ]; then
			echo "${BOLD}${GREEN}${loc_install_nginx}${NORMAL}"
			apt-get update && apt-get -y install nginx
		else
			echo "${BOLD}${GREEN}${loc_nginx_al_in}${NORMAL}"
			echo "${GREEN}${loc_nginx_upgrade}${NORMAL}"
			apt-get update && apt-get -y upgrade nginx
		fi
	else
		if [ -z "$(grep -rn "nginx.org/packages/mainline" /etc/apt/)" ]; then
			echo "${BOLD}${RED}${loc_nginx_repo_find}${NORMAL}"
			echo "${BOLD}${GREEN}${loc_install_last_v_nginx}${NORMAL}"
			echo "1) ${loc_yes}"
			echo "2) ${loc_no}"
			read -p "${loc_choose}: " installnginx
			if [ $installnginx -eq 1 ]; then
				echo "${GREEN}${loc_go_to_dir} /etc/apt/sources.list.d/${NORMAL}"
				cd /etc/apt/sources.list.d/
				echo "${GREEN}${loc_remove_repo}${NORMAL}"
				for listnginx in $(grep -rl "nginx.org" /etc/apt/)
				do
					sed -i '/nginx.org/d' $listnginx
				done
				echo "${GREEN}${loc_mainline_repo}${NORMAL}"
				touch nginx.list
				echo "deb http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
				echo "deb-src http://nginx.org/packages/mainline/${dist}/ ${osv} nginx" | tee -a /etc/apt/sources.list.d/nginx.list
				if [ -z "$(dpkg -l|grep nginx)" ]; then
					echo "${GREEN}${loc_install_last_ver}${NORMAL}"
					apt-get update && apt-get -y install nginx
				else
					echo "${GREEN}${loc_upgrade_last_ver}${NORMAL}"
					apt-get update && apt-get -y upgrade nginx
				fi
			else
				echo "${BOLD}${RED}${loc_no_install_last_ver}${NORMAL}"
				exit 0
			fi
		else
			echo "${BOLD}${RED}${loc_setup_last_version}${NORMAL}"
			if [ -z "$(dpkg -l|grep nginx)" ]; then
				echo "${GREEN}${loc_install_last_ver}${NORMAL}"
				apt-get update && apt-get -y install nginx
			else
				echo "${GREEN}${loc_upgrade_last_ver}${NORMAL}"
				apt-get update && apt-get -y upgrade nginx
			fi
		fi
	fi
	checknginxstatus=1
else
	if [ -z "$(grep -rn "nginx.org" /etc/yum.repos.d/)" ]; then
		echo "${GREEN}${loc_go_to_dir} /etc/yum.repos.d/${NORMAL}"
		cd /etc/yum.repos.d/

		echo "${GREEN}${loc_add_rep}${NORMAL}"
		touch nginx.repo	
		echo "[nginx]" | tee -a /etc/yum.repos.d/nginx.repo
		echo "name=nginx repo" | tee -a /etc/yum.repos.d/nginx.repo
		echo "baseurl=http://nginx.org/packages/mainline/${dist}/${osv}/"'$basearch/' | tee -a /etc/yum.repos.d/nginx.repo
		echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nginx.repo
		echo "enabled=1" | tee -a /etc/yum.repos.d/nginx.repo
		cd
		echo "${GREEN}${loc_check_key_sys}${NORMAL}"
		if [ -z "$(rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n' | grep nginx)" ]; then
			echo "${GREEN}${loc_add_key}${NORMAL}"
			wget http://nginx.org/keys/nginx_signing.key
			rpm --import nginx_signing.key
		fi
		
		echo "${GREEN}${loc_check_nginx}${NORMAL}"

		if [ -z "$(yum list installed|grep nginx)" ]; then
			echo "${BOLD}${GREEN}${loc_install_nginx}${NORMAL}"
			yum -y update && yum -y install nginx
		else
			echo "${BOLD}${GREEN}${loc_nginx_al_in}${NORMAL}"
			echo "${GREEN}${loc_nginx_upgrade}${NORMAL}"
			yum update -y nginx
		fi
	else
		if [ -z "$(grep -rn "nginx.org/packages/mainline" /etc/yum.repos.d/)" ]; then
			echo "${BOLD}${RED}${loc_nginx_repo_find}${NORMAL}"
			echo "${BOLD}${GREEN}${loc_install_last_v_nginx}${NORMAL}"
			echo "1) ${loc_yes}"
			echo "2) ${loc_no}"
			read -p "${loc_choose}: " installnginx
			if [ $installnginx -eq 1 ]; then
				echo "${GREEN}${loc_go_to_dir}  /etc/yum.repos.d/${NORMAL}"
				cd /etc/yum.repos.d/
				echo "${GREEN}${loc_remove_repo}${NORMAL}"
				for listnginx in $(grep -rl "nginx.org" /etc/yum.repos.d/)
				do
					rm -rf $listnginx
				done
				echo "${GREEN}${loc_mainline_repo}${NORMAL}"
				touch nginx.repo	
				echo "[nginx]" | tee -a /etc/yum.repos.d/nginx.repo
				echo "name=nginx repo" | tee -a /etc/yum.repos.d/nginx.repo
				echo "baseurl=http://nginx.org/packages/mainline/${dist}/${osv}/"'$basearch/' | tee -a /etc/yum.repos.d/nginx.repo
				echo "gpgcheck=0" | tee -a /etc/yum.repos.d/nginx.repo
				echo "enabled=1" | tee -a /etc/yum.repos.d/nginx.repo
				echo "${GREEN}${loc_check_key_sys}${NORMAL}"
				if [ -z "$(rpm -q gpg-pubkey --qf '%{name}-%{version}-%{release} --> %{summary}\n' | grep nginx)" ]; then
					echo "${GREEN}${loc_add_key}${NORMAL}"
					wget http://nginx.org/keys/nginx_signing.key
					rpm --import nginx_signing.key
				fi
				echo "${GREEN}${loc_upgrade_last_ver}${NORMAL}"			
				yum update -y nginx
			else
				echo "${BOLD}${RED}${loc_no_install_last_ver}${NORMAL}"
			fi
		else
			echo "${BOLD}${RED}${loc_setup_last_version}${NORMAL}"
			if [ -z "$(yum list installed|grep nginx)" ]; then
				echo "${GREEN}${loc_install_last_ver}${NORMAL}"
				yum -y update && yum -y install nginx
			else
				echo "${GREEN}${loc_upgrade_last_ver}${NORMAL}"
				yum update -y nginx
			fi
		fi
	fi
	checknginxstatus=1
fi
if [ $checknginxstatus -eq 1 ]; then
	echo "${GREEN}${loc_restart_nginx}${NORMAL}"
	service nginx restart
	echo "${GREEN}${loc_status_nginx}${NORMAL}"
	if [ -z "$(service nginx status | grep "stopped")" ] || [ -z "$(service nginx status | grep "inactive")" ] || [ -z "$(service nginx status | grep "failed")" ]; then
		echo "${loc_upgrade_nginx_sf}!"		
	else
		echo "${RED}${BOLD}${loc_upgrade_nginx_faild}${NORMAL}"
		echo "${BOLD}GitHub https://github.com/alexeymalets/nginx-install-auto/issues${NORMAL}"
		echo "${BOLD}${loc_srv_admin} http://svradmin.ru/${NORMAL}"
		echo "${BOLD}${loc_myhosti}(24/7) https://myhosti.pro${NORMAL}"
		echo "${loc_error} :$(tail -n 10 /var/log/nginx/error.log)"
	fi
fi

echo "${GREEN}${loc_thanks_soft}${NORMAL}"