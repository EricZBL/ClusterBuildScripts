#!/bin/bash
################################################################################
## Copyright:   HZGOSUN Tech. Co, BigData
## Filename:    zookeeperStop_local.sh
## Description: 停止zookeeper集群的脚本
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
## 安装日志目录
LOG_FILE=${LOG_DIR}/zkStart.log
## 最终安装的根目录，所有bigdata 相关的根目录
INSTALL_HOME=$(grep Install_HomeDir ${CONF_DIR}/local_conf.properties|cut -d '=' -f2)
## zk的安装节点，放入数组中
ZK_HOSTNAME_LISTS=$(grep Zookeeper_InstallNode ${CONF_DIR}/local_conf.properties|cut -d '=' -f2)

source /etc/profile
${INSTALL_HOME}/Zookeeper/zookeeper/bin/zkServer.sh stop

# 验证ZK是否启动成功
echo -e "********************验证ZK是否停止成功*********************"
sleep 3s

jps | grep -E 'QuorumPeerMain|jps show as bellow'
