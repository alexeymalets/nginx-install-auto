# Install/Upgrade Nginx

Increasingly, customers are requested to upgrade Nginx to the latest version.

To minimize time-consuming, we decided to not write a great script that will simplify the process of install/upgrade Nginx to the latest version(mainline).

##Supported ОS
* Debian 7,8,9,10
* Ubuntu 12,14,15,16,18
* CentOS/CloudLinux 5,6,7,8

##Localization
* Russian
* English

##Logic
* Definition of distribution
* Detect repositories with Nginx
* Detection of key Nginx
* Check installed Nginx
* Restart the service and the error if the service is not running

##Start
Download the archive with the script from GitHub
```
wget https://github.com/alexeymalets/nginx-install-auto/archive/master.zip
```
Unpack the archive
```
unzip master.zip
```
Go to directory with script and set permissions 777
```
cd nginx-install-auto-master && chmod 777 nginx_install.sh
```
Run the script
```
sh nginx_install.sh
```
###Possible problems when using
####1 unzip: command not found
```
#unzip master.zip
-bash: unzip: command not found
```
To resolve install the package unzip
#####Centos
```
yum install -y unzip
```
#####Debian/Ubuntu
```
apt-get install -y unzip
```
####2 ERROR: The certificate of 'github.com' is not trusted.
```
Connecting to github.com (github.com)|192.30.253.112|:443... connected.
ERROR: The certificate of 'github.com' is not trusted.
ERROR: The certificate of 'github.com' hasn't got a known issuer.
```
To resolve install the package ca-certificates
```
apt-get install -y ca-certificates
```

##Distribution
The GNU GPL license

The author is not responsible for failures that may arise during the use of the script. 

You use it at your own risk.

##Partners
* Support your servers 24/7 https://myhosti.pro/