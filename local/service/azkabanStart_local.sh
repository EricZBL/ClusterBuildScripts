#!/bin/bash
################################################################################
## Copyright:   HZGOSUN Tech. Co, BigData
## Filename:    azkabanStart_local.sh
## Description: 启动azkaban集群的脚本
## Version:     1.0
## Author:      yinhang
## Created:     2018-07-28
################################################################################
#set -x

cd `dirname $0`
## 脚本所在目录
BIN_DIR=`pwd`
cd ../..
## 安装包根目录
ROOT_HOME=`pwd`
## 配置文件目录
CONF_DIR=${ROOT_HOME}/local/conf
## 安装日志目录
LOG_DIR=${ROOT_HOME}/logs
## 安装日志
LOG_FILE=${LOG_DIR}/esStart.log
## 最终安装的根目录，所有bigdata 相关的根目录
INSTALL_HOME=$(grep Install_HomeDir ${CONF_DIR}/local_conf.properties|cut -d '=' -f2)
## azkaban的安装节点，放入数组中
AZKABAN_HOST=$(grep ES_InstallNode ${CONF_DIR}/local_conf.properties|cut -d '=' -f2)
## 安装目录
AZKABAN_INSTALL_HOME=${INSTALL_HOME}/Azkaban
## 根目录
AZKABAN_HOME=${AZKABAN_INSTALL_HOME}/azkaban

##mysql安装节点主机名
MYSQL_HOSTNAME=$(grep Mysql_InstallNode ${CONF_DIR}/local_conf.properties|cut -d '=' -f2)

## webserver 日记目录
WEBLOG_DIR=${AZKABAN_HOME}/webserver/logs
## webserver 日记文件
WEBLOG_FILE=${WEBLOG_DIR}/webserver.log
## executor 日记目录
EXELOG_DIR=${AZKABAN_HOME}/executor/logs
## executor 日记文件
EXELOG_FILE=${EXELOG_DIR}/executor.log

source /etc/profile
chmod 755 ${AZKABAN_HOME}/webserver/bin/*
mkdir -p $WEBLOG_DIR
cd ${AZKABAN_HOME}/webserver
nohup bin/azkaban-web-start.sh >> ${WEBLOG_FILE} 2>&1 &
if [ $? -eq 0 ];then
    echo  -e 'webserver start success \n'
else
    echo  -e 'webserver start failed \n'
fi

source /etc/profile
chmod 755 ${AZKABAN_HOME}/executor/bin/*
mkdir -p $EXELOG_DIR
cd ${AZKABAN_HOME}/executor
nohup bin/azkaban-executor-start.sh >> ${EXELOG_FILE} 2>&1 &
if [ $? -eq 0 ];then
    echo  -e 'executor start success \n'
else
    echo  -e 'executor start failed \n'
fi

# 等待三秒后再验证Azkaban是否启动成功
echo -e "********************验证Azkaban是否启动成功*********************"
sleep 3s

jps | grep -E 'AzkabanWebServer|AzkabanExecutorServer|jps show as bellow'