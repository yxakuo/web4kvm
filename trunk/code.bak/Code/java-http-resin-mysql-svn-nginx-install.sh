#!/bin/sh

user=`whoami`

if [ "$user" != "root" ]; then
	echo "If you want to install software,you must be root!"
	exit 1
fi	

if [ -e /home/download ]; then
	cd /home/download
else
	mkdir -p /home/download
	cd /home/download
fi

if [ -e /etc/debian_version ]; then
	apt-get update
elif [ -e /etc/redhat-release ]; then
	yum update
else
	echo "do not know the OS"
fi

java_install()
{
	apt-get install ant
    wget http://220.181.29.100/tools/jdk-6u1-linux-i586.bin
    echo "you should install the jdk by yourself"
}



echo "-----------------------------------------------------------"
echo "                  1,java"
echo "                  2,apache"
echo "                  3,resin"
echo "                  4,mysql"
echo "                  5,nginx"
echo "                  6,svn"
echo "                  7,nagios"
echo "-----------------------------------------------------------"
echo -n "Please enter the number like(134567/1234):"
read choice

echo -n "Install apache(yes|no):"
read answer
if [ "$answer" == "yes" ]; then
	wget http://labs.renren.com/apache-mirror/httpd/httpd-2.0.63.tar.gz
	tar zxf httpd-2.0.63.tar.gz
	cd httpd-2.0.63
	./configure --prefix=/home/apache --enable-so --enable-rewrite --enable-proxy --enable-expires --enable-header --enable-deflate
	make -j8 && make install
	cd ..
fi

if [ ! -e /home/jdk1.6 ]; then
	echo "you should install java firstly"
	exit 1
fi

echo -n "Install resin(yes|no):"
read answer
if [ "$answer" == "yes" ]; then
	wget http://220.181.29.100/tools/resin-3.0.28-patch.tar.gz
	tar zxf resin-3.0.28-patch.tar.gz
	cd resin-3.0.28
	if [ -e /home/apache ];then
		./configure --prefix=/home/resin --enable-linux-smp --enable-jni --with-apxs=/home/apache/bin/apxs  --with-java-home=/home/jdk1.6
		make && make install
		cd ..
	else
		./configure --prefix=/home/resin --enable-linux-smp --enable-jni --with-java-home=/home/jdk1.6
		make && make install
		cd ..
	fi
fi

echo -n "Install mysql(yes|no):"
read answer
if [ "$answer" == "yes" ]; then
	wget http://220.181.29.100/tools/mysql-5.1.42-linux-i686-glibc23.tar.gz
	tar vxf mysql-5.1.42-linux-i686-glibc23.tar.gz
	mv mysql-5.1.42-linux-i686-glibc23 /home/mysql
	if [ -e /etc/mysql ]; then
		mv /etc/mysql /etc/mysql.bak
	fi
	cd /home/mysql
	groupadd mysql
	useradd -g mysql mysql
	chown -R mysql .
	chgrp -R mysql .
	scripts/mysql_install_db --user=mysql
	chown -R root .
	chown -R mysql data
	bin/mysqld_safe --user=mysql &
fi

echo  "\n"
echo  "\n"
sleep 2

echo -n "Install svn(yes|no):"
read answer 
if [ "$answer" == "yes" ]; then
	wget http://220.181.29.100/sh/svn.sh
	bash svn.sh
fi

echo -n "Install nginx(yes|no):"
read answer
if [ "$answer" == "yes" ]; then

	echo -e "\ninstall compiler tools and dependecy libraries for nginx\n"
	sleep 1
	if [ -f /etc/debian_version ];then
    	    apt-get -y install build-essential openssl libssl-dev libpcre3 libpcre3-dev
	else
    	    yum -y install gcc gcc-c++ make gdb automake autoconf libtool openssl openssl-devel pcre pcre-devel
	fi

	sleep 3
	echo -e "\nswitch into the source code packages\n"
	sleep 1
	if [ -d /home/download ]; then
        	cd /home/download
	else
        	mkdir -p /home/download
			cd /home/download
	fi

	if [ "$(uname -m)" == "x86_64" ]; then
			sleep 3
			echo -e "\nneed libunwind install on x86_64 for google-perftools\n"
			sleep 1
        	wget http://ftp.twaren.net/Unix/NonGNU/libunwind/libunwind-0.99.tar.gz
        	tar zxf libunwind-0.99.tar.gz
        	cd libunwind-0.99
        	./configure --prefix=/usr
        	make && make install
        	cd ../
	fi

	sleep 3
	echo -e "\ninstall google-perftools for nginx\n"
	sleep 1
    wget http://google-perftools.googlecode.com/files/google-perftools-1.5.tar.gz
    tar zxf google-perftools-1.5.tar.gz
    cd google-perftools-1.5
    ./configure --prefix=/usr
    make && make install
    cd ../

	sleep 3
	echo -e "\ninstall nginx with addition module - ngx_cache_purge, nginx_upstream_hash and nginx_upstream_hash  - support\n"
	sleep 1
    wget http://labs.frickle.com/files/ngx_cache_purge-1.2.tar.gz
    tar zxf ngx_cache_purge-1.2.tar.gz
    wget http://wiki.nginx.org/images/1/11/Nginx_upstream_hash-0.3.1.tar.gz
    tar zxf Nginx_upstream_hash-0.3.1.tar.gz
    wget http://download.github.com/gnosek-nginx-upstream-fair-2131c73.tar.gz
    tar zxf gnosek-nginx-upstream-fair-2131c73.tar.gz
    wget http://www.nginx.org/download/nginx-0.7.67.tar.gz
    tar zxf nginx-0.7.67.tar.gz
    cd nginx-0.7.67
    patch -p0 < ../nginx_upstream_hash-0.3.1/nginx.patch
    ./configure --prefix=/home/nginx --with-md5=/usr/lib --with-sha1=/usr/lib --with-cc-opt='-I /usr/include/openssl' --with-http_ssl_module --with-http_realip_module --with-http_stub_status_module --with-http_sub_module --with-http_flv_module --with-google_perftools_module --add-module=../ngx_cache_purge-1.2 --add-module=../nginx_upstream_hash-0.3.1 --add-module=../gnosek-nginx-upstream-fair-2131c73
    make && make install
    cd ../
fi
