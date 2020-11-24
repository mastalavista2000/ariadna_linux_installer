#!bin/bash

#Имя пользователя системы
username='username'

#Варианты AltLinux8,AlLinux9,RedOS,AstraLinux
distr=''

#Версия Oracle Client для установки. Варианты 11,12,InstantClient
#12 Для установки рекомендуется 12 версия
#11 Версию устанвливать если невозможна установка 12 или InstantClient
#InstantClient работает с АРМами после обновления от 28.05.20
oracle_version='12'

#Ссылка на Oracle Client 11, можно указать на локальный каталог(Опционально)
url_oracle_client_11='http://klokan.spb.ru/PUB/oraarch/ORACLE%20CLIENT/XP_WIN2003_client_32bit/oracle_client_x32.tar'

#Ссылка на Oracle Client 12, можно указать на локальный каталог(Опционально)
url_oracle_client_12='http://klokan.spb.ru/PUB/oraarch/ORACLE%20CLIENT/win32_12201_client.tar'

#Ссылка на Instant Client, можно указать на локальный каталог(Опционально)
url_instant_client='http://klokan.spb.ru/PUB/oraarch/ORACLE%20CLIENT/instant_client19.tar'

function Install_Winetricks() {

if [ -d /home/$username/.wine ]; then
	winetricks vb6run
	winetricks mdac28
	winetricks vcrun6
	winetricks vcrun2010
		else 
			if [ $distr = 'AstraLinux' ]; then 
				WINEARCH=win32 winecfg 
			fi
			winecfg
			winetricks vb6run
			winetricks mdac28
			winetricks vcrun6
			winetricks vcrun2010
fi

if [ $distr = 'AstraLinux' ]; then
cd /home/$username/linux_installer
if [ -f wine_gecko-2.47-x86.msi ]; then 
	echo 'wine_gecko-2.47-x86.msi уже скачан' >> /home/$username/linux_installer/install_log.log
		else 
		echo 'Загрузка wine_gecko-2.47-x86.msi' >> /home/$username/linux_installer/install_log.log
		wget http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86.msi 
fi
wine msiexec /i wine_gecko-2.47-x86.msi

if [ -f wine_gecko-2.47-x86_64.msi ]; then 
	echo 'wine_gecko-2.47-x86.msi уже скачан' >> /home/$username/linux_installer/install_log.log
		else 
		echo 'Загрузка wine_gecko-2.47-x86.msi' >> /home/$username/linux_installer/install_log.log
		wget http://dl.winehq.org/wine/wine-gecko/2.47/wine_gecko-2.47-x86_64.msi
fi
wine msiexec /i wine_gecko-2.47-x86_64.msi

fi
}

function Install_Oracle_12() {
cd /home/$username/linux_installer

if [ $oracle_version = '12' ]; then

if [ -f win32_12201_client.tar ]; then 
	echo 'Дистрибутив OracleClient уже скачан' >> /home/$username/linux_installer/install_log.log
		else 
			echo 'Дистрибутива OracleClient нет' >> /home/$username/linux_installer/install_log.log
			echo 'Скачивание дистрибутива OracleClient' >> /home/$username/linux_installer/install_log.log
			wget $url_oracle_client_12
fi

if [ -d /home/$username/linux_installer/client32 ]; then 
	cd /home/$username/linux_installer/client32
		else
			echo'Распаковка win32_12201_client.tar' >> /home/$username/linux_installer/install_log.log
			tar -xvf win32_12201_client.tar
			cd /home/$username/linux_installer/client32
fi

if [ -f setup.exe ]; then 
	echo 'Установка OracleClient' >> /home/$username/linux_installer/install_log.log
	wine setup.exe -ignorePrereq -J"-Doracle.install.client.validate.clientSupportedOSCheck=false"
		else
		echo 'ERR: Setup.exe не найден' >> /home/$username/linux_installer/install_log.log
fi

fi

}

function Install_Oracle_11() {
cd /home/$username/linux_installer

if [ $oracle_version = '11' ]; then

if [ -f oracle_client_x32.tar ]; then 
	echo 'Дистрибутив OracleClient уже скачан' >> /home/$username/linux_installer/install_log.log
		else 
			echo 'Дистрибутива OracleClient нет' >> /home/$username/linux_installer/install_log.log
			echo 'Скачивание дистрибутива OracleClient' >> /home/$username/linux_installer/install_log.log
			wget $url_oracle_client_11
fi

if [ -d /home/$username/linux_installer/client ]; then 
	cd /home/$username/linux_installer/client
		else
			echo'Распаковка oracle_client_x32.tar' >> /home/$username/linux_installer/install_log.log
			tar -xvf oracle_client_x32.tar
			cd /home/$username/linux_installer/client
fi

if [ -f setup.exe ]; then 
	echo 'Установка OracleClient' >> /home/$username/linux_installer/install_log.log
	wine setup.exe
		else
		echo 'ERR: Setup.exe не найден' >> /home/$username/linux_installer/install_log.log
fi

fi

}

function Install_Oracle_Instant() {
cd /home/$username/linux_installer

if [ $oracle_version = 'InstantClient' ]; then

if [ -d /home/$username/.wine/drive_c/oracle ]; then
	echo 'Каталог /home/$username/.wine/drive_c/oracle уже создан' >> /home/$username/linux_installer/install_log.log
		else
		mkdir /home/$username/.wine/drive_c/oracle
fi

if [ -f instant_client19 ]; then 
	echo 'Дистрибутив oracle_instantclient19 уже скачан' >> /home/$username/linux_installer/install_log.log
		else 
			echo 'Дистрибутива oracle_instantclient19 нет' >> /home/$username/linux_installer/install_log.log
			echo 'Скачивание дистрибутива oracle_instantclient19' >> /home/$username/linux_installer/install_log.log
			wget $url_instant_client
fi

if [ -d /home/$username/linux_installer/instant_client ]; then 
	echo 'Копирование instant_client в /home/'$username'/.wine/drive_c/oracle' >> /home/$username/linux_installer/install_log.log
	cp -a -u -f /home/$username/linux_installer/instant_client/. /home/$username/.wine/drive_c/oracle
		else
			echo 'Распаковка oracle_instantclient19.tar' >> /home/$username/linux_installer/install_log.log
			tar -xvf instant_client19.tar
			echo 'Копирование instant_client в /home/'$username'/.wine/drive_c/oracle' >> /home/$username/linux_installer/install_log.log
			cp -a -u -f /home/$username/linux_installer/instant_client/. /home/$username/.wine/drive_c/oracle
fi

fi

}

#Запуск функций
Install_Winetricks
Install_Oracle_12
Install_Oracle_11
Install_Oracle_Instant