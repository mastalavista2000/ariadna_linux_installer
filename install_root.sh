#!bin/bash

#Имя пользователя системы
username='username'

#Монтирование каталогов
ip_mount='192.168.0.0'
username_share='share'
password_share=''
domain='' #Оставить как есть, если сервер вне домена

#Варианты AltLinux8,AltLinux9,RedOS,AstraLinux
distr=''

#Дистрибутив JAVA, можно указать на локальный каталог(Опционально)
url_java='http://klokan.spb.ru/PUB/jre-6u45-linux-i586.bin'

function Mount_ARM(){

cd /home/$username/linux_installer

if [ -d /mnt/ARM ]; then 
	echo 'Каталог /mnt/ARM уже создан' >> /home/$username/linux_installer/install_log.log
		else 
			echo 'Создание каталога /mnt/ARM' >> /home/$username/linux_installer/install_log.log
			mkdir /mnt/ARM
			echo 'Каталог /mnt/ARM создан' >> /home/$username/linux_installer/install_log.log
fi

if [ -d /mnt/ARM/APP ]; then 
	echo 'Каталог /mnt/ARM/APP уже монтирован' >> /home/$username/linux_installer/install_log.log
		else 
		
			if [ $distr = 'AstraLinux' ]; then
				echo 'Монтирование каталога' >> /home/$username/linux_installer/install_log.log
					if [ $domain = '' ]; then
					sudo mount -t cifs //$ip_mount/ARIADNA/ /mnt/ARM -o username=$username_share,rw,password=$password_share
						else
					sudo mount -t cifs //$ip_mount/ARIADNA/ /mnt/ARM -o username=$username_share,rw,password=$password_share,domain=$domain
					fi
					
			else
			

				echo 'Монтирование каталога' >> /home/$username/linux_installer/install_log.log
					if [ $domain = '' ]; then
					mount -t cifs //$ip_mount/ARIADNA/ /mnt/ARM -o username=$username_share,rw,password=$password_share
						else
					mount -t cifs //$ip_mount/ARIADNA/ /mnt/ARM -o username=$username_share,rw,password=$password_share,domain=$domain
					fi
			echo 'Каталог с АРМами монтирован в каталог /mnt/ARM' >> /home/$username/linux_installer/install_log.log
			fi
fi

if [ -f updater.sh ]; then 
	echo 'updates.sh уже создан' >> /home/$username/linux_installer/install_log.log
		else 
			cd /home/$username
			echo 'Создание updates.sh' >> /home/$username/linux_installer/install_log.log
			touch updater.sh
			echo 'Sh скрипт updater.sh создан' >> /home/$username/linux_installer/install_log.log
fi

if [ $distr = 'AltLinux8' ]; then
	{
	echo 'sleep 30'
	echo 'mount -t cifs //'$ip_mount'/ARIADNA/ /mnt/ARM -o username='$username_share',rw,password='$password_share''
	echo 'sleep 10'
	echo 'cp -a -u -f /mnt/ARM/APP/. /home/'$username'/.wine/drive_c/ARIADNA/APP'
	echo 'chown -R '$username':'$username' /home/'$username'/.wine/drive_c/ARIADNA/APP'
	echo 'chmod -R 777 /home/'$username'/.wine/drive_c/ARIADNA/APP'
	echo ''
	} > 'updater.sh'
fi

if [ $distr = 'AltLinux9' ]; then
	{
	echo 'sleep 30'
	echo 'mount -t cifs //'$ip_mount'/ARIADNA/ /mnt/ARM -o username='$username_share',rw,password='$password_share''
	echo 'sleep 10'
	echo 'cp -a -u -f /mnt/ARM/APP/. /home/'$username'/.wine/drive_c/ARIADNA/APP'
    echo 'chown -R '$username':'$username' /home/'$username'/.wine/drive_c/ARIADNA/APP'
	echo 'chmod -R 777 /home/'$username'/.wine/drive_c/ARIADNA/APP'
	echo ''
	} > 'updater.sh'
fi

if [ $distr = 'RedOS' ]; then
	{
	echo 'sleep 30'
	echo 'sudo mount -t cifs //'$ip_mount'/ARIADNA/ /mnt/ARM -o username='$username_share',rw,password='$password_share''
	echo 'sleep 10'
	echo 'sudo cp -a -u -f /mnt/ARM/APP/. /home/'$username'/.wine/drive_c/ARIADNA/APP'
	echo 'chown -R '$username':'$username' /home/'$username'/.wine/drive_c/ARIADNA/APP'
	echo 'chmod -R 777 /home/'$username'/.wine/drive_c/ARIADNA/APP'
	echo ''
	} > 'updater.sh'
fi

if [ $distr = 'AstraLinux' ]; then
	{
	echo 'sleep 30'
	echo 'sudo mount -t cifs //'$ip_mount'/ARIADNA/ /mnt/ARM -o username='$username_share',rw,password='$password_share''
	echo 'sleep 10'
	echo 'sudo cp -a -u -f /mnt/ARM/APP/. /home/'$username'/.wine/drive_c/ARIADNA/APP'
	echo 'chown -R '$username':'$username' /home/'$username'/.wine/drive_c/ARIADNA/APP'
	echo 'chmod -R 777 /home/'$username'/.wine/drive_c/ARIADNA/APP'
	echo ''
	} > 'updater.sh'
fi

if [ $distr = 'AstraLinux' ]; then
	sudo echo '@reboot sh /home/'$username'/updater.sh' > /var/spool/cron/root
	else
	echo '@reboot sh /home/'$username'/updater.sh' > /var/spool/cron/root
	fi

}


function Install_Java(){
cd /home/$username/linux_installer

if [ -d /opt/java/jre1.6.0_45 ]; then echo 'Каталог /opt/java/jre1.6.0_45 уже создан, JAVA установлена' >> /home/$username/linux_installer/install_log.log 
	else 
		echo 'Создание каталога /opt/java' >> /home/$username/linux_installer/install_log.log
		mkdir /opt/java

if [ -f jre-6u45-linux-i586.bin ]; then 
	echo 'Дистрибутив JAVA уже скачан' >> /home/$username/linux_installer/install_log.log
		else 
			echo 'Дистрибутива JAVA нет' >> /home/$username/linux_installer/install_log.log
			echo 'Скачивание дистрибутива java' >> /home/$username/linux_installer/install_log.log
			wget $url_java
fi

if [ -d /home/$username/jre1.6.0_45 ]; then 
	echo 'JAVA Распакована'  >> /home/$username/linux_installer/install_log.log
		else
		echo 'Разархивация JAVA'  >> /home/$username/linux_installer/install_log.log
		chmod a+x /home/$username/linux_installer/jre-6u45-linux-i586.bin
		/home/$username/linux_installer/jre-6u45-linux-i586.bin 
		echo 'Удаление jre-6u45-linux-i586.bin' >> /home/$username/linux_installer/install_log.log
		rm -f jre-6u45-linux-i586.bin
fi

if [ -d /opt/java/jre1.6.0_45 ]; then 
	echo 'Найдена JAVA в каталоге /opt/java/jre1.6.0_45' >> /home/$username/linux_installer/install_log.log
		else
		echo 'Перемещение каталога /home/'$username'/linux_installer/jre1.6.0_45 в /opt/java/jre1.6.0_45' >> /home/$username/linux_installer/install_log.log
		mv /home/$username/linux_installer/jre1.6.0_45 /opt/java/jre1.6.0_45
		echo 'Каталог перемещен'  >> /home/$username/linux_installer/install_log.log
		echo 'Регистрация JAVA в PATH' >> /home/$username/linux_installer/install_log.log
		export PATH=$PATH:/opt/java/jre1.6.0_45/bin/
		echo 'PATH зарегистрирован' >> /home/$username/linux_installer/install_log.log
fi

if [ $distr = 'AltLinux8' ]; then 
	apt-get install i586-libXtst.32bit -y
fi

if [ $distr = 'AltLinux9' ]; then 
	apt-get install i586-libXtst.32bit i586-libnsl1.32bit libnsl1 -y
fi

fi
}

function Install_Wine() {

if [ $distr = 'AstraLinux' ]; then
	echo 'Установка wine, конфигурация AstraLinux' >> /home/$username/linux_installer/install_log.log
	apt-get update && apt-get upgrade -y
	apt-get install wine winetricks zenity -y
fi

if [ $distr = 'AltLinux8' ]; then
	echo 'Установка wine, конфигурация AltLinux8' >> /home/$username/linux_installer/install_log.log
	apt-get update && apt-get dist-upgrade -y
	apt-get install i586-wine.32bit wine-gecko wine-mono winetricks -y
fi

if [ $distr = 'AltLinux9' ]; then
	echo 'Установка wine, конфигурация AltLinux9' >> /home/$username/linux_installer/install_log.log
	apt-get update && apt-get dist-upgrade -y
	apt-get install i586-wine.32bit wine-mono winetricks -y
fi

if [ $distr = 'RedOS' ]; then
	echo 'Установка wine, конфигурация RedOS' >> /home/$username/linux_installer/install_log.log
	yum update && yum upgrade -y
	yum install wine winetricks -y
fi
}

function Run_Crontab() {
systemctl enable crond
systemctl start crond
echo 'Служба Crontab включена, автозапуск добавлен' >> /home/$username/linux_installer/install_log.log
}
echo '127.0.0.1	'$HOSTNAME' localhost '> /etc/hosts

#Запуск функций
Mount_ARM
Install_Java
Install_Wine
Run_Crontab