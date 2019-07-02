#!/bin/bash
cd /etc/yum.repos.d
mv public-yum-ol6.repo public-yum-ol6.repo.bak  
export REGION=`curl http://169.254.169.254/opc/v1/instance/ -s | grep 'Region'| cut -d '-' -f 2`  
#sudo wget http://yum-$REGION.oracle.com/yum-$REGION-ol6.repo
wget http://yum.oracle.com/public-yum-ol6.repo
sudo yum install -y yum-utils
sudo yum-config-manager --enable ol6_developer_EPEL

#sudo rm oracle-linux-ol7.repo

### 1. Install and setup Java
sudo yum install -y java
 
# Set profile for java
echo "export JAVA_HOME=$(readlink -e $(which java)|sed 's:/bin/java::')" >  /etc/profile.d/java.sh
echo "PATH=\$PATH:\$JAVA_HOME/bin"                                       >> /etc/profile.d/java.sh
source /etc/profile.d/java.sh


### 2. Install some packages
sudo yum install -y expect nkf screen

### 3. Install and setup Oracle Client
sudo yum-config-manager --enable ol6_oracle_instantclient
sudo yum install -y oracle-instantclient18.3-basic
sudo yum install -y oracle-instantclient18.3-sqlplus

