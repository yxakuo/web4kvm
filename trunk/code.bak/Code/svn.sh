#!/bin/sh
echo "This script will reconfigure subversion to work with certs correctly."
echo "Steps outlined by dcrooke and compiled into this script by Kalosaurusrex"
echo "Please see the ubuntuforums.org thread for more information, questions or help."
echo "http://ubuntuforums.org/showthread.php?p=6057983"
echo ""
echo ""
echo "Please run this script as USER ONLY."
echo ""
echo "Press control-c to quit..else the script will start in 5 seconds."
sleep 5
cd /home/study/temp/
sudo apt-get update
sudo apt-get install build-essential openssl ssh expat libssl-dev
sudo apt-get remove subversion
sudo dpkg --purge subversion
wget http://220.181.29.100/tools/subversion-1.6.6.tar.gz
wget http://220.181.29.100/tools/subversion-deps-1.6.6.tar.gz
tar xvfz subversion-deps-1.6.6.tar.gz
tar xvfz subversion-1.6.6.tar.gz
cd subversion-1.6.6/neon/
./configure --prefix=/usr --with-ssl --with-pic
make -j10
sudo make install
cd ..
rm -rf neon
./configure --prefix=/usr --with-ssl --with-neon=/usr/local
make -j10
sudo make install
cd ..
rm -rf subversion-1.6.6
rm subversion-1.6.6.tar.gz
rm subversion-deps-1.6.6.tar.gz
exit 0

