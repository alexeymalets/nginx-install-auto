# Установка/Обновление Nginx

Все чаще и чаще клиенты обращаются с просьбой обновить Nginx до последней версии.

Для минимизации временных затрат, мы решили написать не большой скрипт, который автоматизирует процесс установки/обновления Nginx до последней версии(mainline).

##Поддерживаемые ОС
* Debian 7,8
* Ubuntu 12,14,15,16
* CentOS 5,6,7

##Локализация
* Русский
* Английский

##Логика
* Опеределение дистрибутива
* Обнаружение репозиториев Nginx
* Обнаружение ключей Nginx
* Проверка наличия установленного Nginx
* Презапуск службы и вывод ошибки, если служба не запущена(Alpha)

##Распространение
Лицензия GNU GPL

Автор не несёт ответственность за сбои, которые могут возникнут при использование скрипта. 

Вы используйте его на свой страх и риск.


##Запуск
Скачиваем архив со скриптом с GitHub
```
wget https://github.com/alexeymalets/nginx-install-auto/archive/master.zip
```
Распаковываем архив
```
unzip master.zip
```
Переходим в директорию со скриптом и устанавливаем права 777
```
cd nginx-install-auto-master && chmod 777 nginx_install.sh
```
Запускаем скрипт
```
sh nginx_install.sh
```
###Возможные проблемы при использовании
####1 unzip: command not found
```
#unzip master.zip
-bash: unzip: command not found
```
Для решения установите пакет unzip
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
Для решения установите пакет ca-certificates
```
apt-get install -y ca-certificates
```

##Партнёры
* Платное администрирование 24/7 https://myhosti.pro/
* Бесплатная помощь в администрировании http://svradmin.ru/