#!/bin/bash
################################################################################
## Copyright:   HZGOSUN Tech. Co, BigData
## Filename:    hadoopStart.sh
## Description: 启动集群扩展节点nodemanager服务的脚本.
## Version:     2.0
## Author:      zhangbaolin
## Created:     2018-7-12
################################################################################

#set -x

cd `dirname $0`
## 脚本所在目录
BIN_DIR=`pwd`
cd ..
## 安装包根目录
ROOT_HOME=`pwd`
## 配置文件目录
CONF_DIR=${ROOT_HOME}/conf
## 安装日记目录
LOG_DIR=${ROOT_HOME}/logs
## 安装日记目录
LOG_FILE=${LOG_DIR}/hadoopStart.log
## 最终安装的根目录，所有bigdata 相关的根目录
INSTALL_HOME=$(grep Install_HomeDir ${CONF_DIR}/cluster_conf.properties|cut -d '=' -f2)
Hadoop_Masters=$(grep Hadoop_NameNode ${CONF_DIR}/cluster_conf.properties|cut -d '=' -f2)
namenode_arr=(${Hadoop_Masters//;/ })
MASTER1=${namenode_arr[0]}
MASTER2=${namenode_arr[1]}
## 集群扩展节点
EXPEND_NODE=$(grep Node_HostName ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
EXPEND_NODE_ARRY=(${EXPEND_NODE//;/ })

echo -e '启动Hadoop'

for node in ${EXPEND_NODE_ARRY[@]}
do
    ssh root@node "sh ${INSTALL_HOME}/Hadoop/hadoop/sbin/hadoop-daemon.sh start nodemanager"
	if [ $? -eq 0 ];then
	    echo -e 'hdfs success \n'
	else
	    echo -e 'hdfs failed \n'
	fi
done

# 等待三秒后再验证Hadoop是否启动成功
echo -e "********************验证NodeManager是否启动成功*********************"
sleep 3s
source $(grep Source_File ${CONF_DIR}/cluster_conf.properties|cut -d '=' -f2)
xcall jps | grep -E 'NodeManager|jps show as bellow'