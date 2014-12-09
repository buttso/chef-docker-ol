#!/bin/bash

echo "============================================"
echo " Checking for Oracle Linux 7.0 Docker Image"
echo "==========================x================="
echo  ""

ORACLE_LINUX_NAME="oraclelinux"
ORACLE_LINUX_VERSION="7.0"
ORACLE_LINUX_URL=http://public-yum.oracle.com/docker-images/OracleLinux/OL7/oraclelinux-7.0.tar.xz

if [ "`docker images | grep $ORACLE_LINUX_NAME | grep $ORACLE_LINUX_VERSION `" == "" ]; then 
  echo "Docker image for $ORACLE_LINUX_NAME:$ORACLE_LINUX_VERSION not found"
  echo "Downloading and installing $ORACLE_LINUX_NAME $ORACLE_LINUX_VERSION from the Oracle YUM repository"
  echo ""

  if [ ! -e oraclelinux-7.0.tar.xz ]; then
      wget http://public-yum.oracle.com/docker-images/OracleLinux/OL7/oraclelinux-7.0.tar.xz
  fi;
 
  
  # b9e4f102f8104827a192241a7135a7d1  oraclelinux-7.0.tar.xz
  unamestr=`uname`
  if [[ "$unamestr" == 'Darwin' ]]; then
    MD5="MD5 (oraclelinux-7.0.tar.xz) = b9e4f102f8104827a192241a7135a7d1"
    MD5_CHECK="`md5 oraclelinux-7.0.tar.xz`"
  else
    MD5="b9e4f102f8104827a192241a7135a7d1  oraclelinux-7.0.tar.xz"
    MD5_CHECK="`md5sum oraclelinux-7.0.tar.xz`"
  fi

  if [ "$MD5" != "$MD5_CHECK" ]; then
    echo "MD5 does not match, download failed"
    exit
  fi

  gunzip oraclelinux-7.0.tar.xz
  docker load -i oraclelinux-7.0.tar
  rm oraclelinux-7.0.tar
  docker images | grep oraclelinux
else
  echo "Found $ORACLE_LINUX_NAME:$ORACLE_LINUX_VERSION docker image"
  echo ""
  docker images | grep oraclelinux
fi

echo ""

exit;


#http://public-yum.oracle.com/docker-images/OracleLinux/OL7/oraclelinux-7.0.tar.xz

if [ ! -e wls1213_dev.zip ]
then
  echo "Download the WebLogic 12c ZIP Distribution and"
  echo "drop the file wls1213_dev.zip in this folder before"
  echo "building this WLS Docker container!"
  exit
fi

unamestr=`uname`
if [[ "$unamestr" == 'Darwin' ]]; then
  MD5="MD5 (wls1213_dev.zip) = 0a9152e312997a630ac122ba45581a18"
  MD5_CHECK="`md5 wls1213_dev.zip`"
else
  MD5="0a9152e312997a630ac122ba45581a18  wls1213_dev.zip"
  MD5_CHECK="`md5sum wls1213_dev.zip`"
fi


if [ "$MD5" != "$MD5_CHECK" ]
then
  echo "MD5 does not match! Download again!"
  exit
fi

echo "====================="

docker build -t oracle/weblogic .

echo ""
echo "WebLogic Docker Container is ready to be used. To start, run 'dockWebLogic.sh'"

