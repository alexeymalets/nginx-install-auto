# Установка/Обновление Nginx

Все чаще и чаще клиенты обращаются с просьбой обновить Nginx до последней версии.

Для минимизации временных затрат, мы решили написать не большой скрипт, который автоматизирует процесс установки/обновления Nginx до последней версии(mainline).

##Работает на следующих ОС:
*Debian 7,8
*Ubuntu 14, 15, 16

##Скрипт доступен на следующих языках:
Русский, Английский

##Логика работы:
*Опеределение дистрибутива
*Обнаружение репозиториев Nginx
Если скрипт обнаружил репозитории Nginx, то предложит установить последую версию Nginx. Старые репозитории Nginx заменяются на новые репозитории(mainline).
Если скрипт не обнаружил репозитории Nginx, то выполнит их добавление и добавит ключи.
*Проверка наличия установленного Nginx
Если пакет Nginx уже установлен(из репозитория ОС), то выполняется обновление репозиториев и обновление версии Nginx. 
При отсутствие пакета выполняется его установка.
*Презапуск службы и вывод ошибки если служба не запустилась
