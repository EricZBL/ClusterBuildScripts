#!/bin/bash
################################################################################
## Copyright:   HZGOSUN Tech. Co, BigData
## Filename:    expand_zookeeper.sh
## Description: zookeeper扩展安装
## Version:     2.4
## Author:      yinhang
## Created:     2018-07-06
################################################################################
## set -x  ## 用于调试用，不用的时候可以注释掉

#---------------------------------------------------------------------#
#                              定义变量                                #
#---------------------------------------------------------------------#
cd `dirname $0`
## 脚本所在目录
BIN_DIR=`pwd`
cd ..
## ClusterBuildScripts 目录
CLUSTER_BUILD_SCRIPTS_DIR=`pwd`
## expand conf 配置文件目录
CONF_DIR=${CLUSTER_BUILD_SCRIPTS_DIR}/expand/conf
## 安装日志目录
LOG_DIR=${CLUSTER_BUILD_SCRIPTS_DIR}/logs
## 安装日记目录
LOG_FILE=${LOG_DIR}/expand_zookeeper.log
## 最终安装的根目录，所有bigdata 相关的根目录
INSTALL_HOME=$(grep Install_HomeDir ${CLUSTER_BUILD_SCRIPTS_DIR}/conf/cluster_conf.properties|cut -d '=' -f2)
## 集群新增节点主机名，放入数组中
CLUSTER_HOST=$(grep Node_HostName ${CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
echo "读取的新增集群节点IP为："${CLUSTER_HOST} | tee -a $LOG_FILE
HOSTNAMES=(${CLUSTER_HOST//;/ })

## ZOOKEEPER_INSTALL_HOME zookeeper 安装目录
ZOOKEEPER_INSTALL_HOME=${INSTALL_HOME}/Zookeeper
## ZOOKEEPER_HOME  zookeeper 根目录
ZOOKEEPER_HOME=${INSTALL_HOME}/Zookeeper/zookeeper

## zookeeper conf 目录
ZOOKEEPER_CONF=${ZOOKEEPER_HOME}/conf
## zookeeper zoo,cfg 文件
ZOO_CFG_FILE=${ZOOKEEPER_CONF}/zoo.cfg
## zookeeper data 目录
ZOOKEEPER_DATA=${ZOOKEEPER_HOME}/data
## zookeeper myid 文件
ZOOKEEPER_MYID=${ZOOKEEPER_DATA}/myid
##
NUM=$(sed -n '$p' ${ZOO_CFG_FILE} | cut -d '.' -f2 | cut -d '=' -f1)
NUMBER=${NUM}+1

if [ ! -d $LOG_DIR ];then
    mkdir -p $LOG_DIR;
fi

## 打印当前时间
echo "" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE
echo "===================================================" | tee -a $LOG_FILE
echo "$(date "+%Y-%m-%d  %H:%M:%S")"

#####################################################################
# 函数名:zoo_cfg
# 描述: 修改 zoo.cfg 和 myid 文件
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function zoo_cfg ()
{
for insName in ${HOSTNAMES[@]}
do
    value1=$(grep "server.${NUMBER}"  ${ZOO_CFG_FILE})
    if [ -n "${value1}" ];then
        sed -i "s#server.${NUMBER}=.*#server.${NUMBER}=${insName}:2888:3888#g"  ${ZOO_CFG_FILE}
    else
        echo "server.${NUMBER}=${insName}:2888:3888" >> ${ZOO_CFG_FILE}
    fi

    NUMBER=$((${NUMBER}+1))
done
}

#####################################################################
# 函数名:zookeeper_distribution
# 描述: 分发新增节点 zookeeper
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function zookeeper_distribution ()
{
for insName in ${HOSTNAMES[@]}
do
    echo ""  | tee  -a  $LOG_FILE
    echo "************************************************"
    echo "准备将zookeeper分发到节点$insName：" | tee -a $LOG_FILE
    echo "zookeeper 分发中,请稍候......" | tee -a $LOG_FILE
    scp -r ${ZOOKEEPER_INSTALL_HOME} root@${insName}:${INSTALL_HOME} > /dev/null
    echo "zookeeper 分发完毕......" | tee -a $LOG_FILE
done
}

#####################################################################
# 函数名:myid
# 描述: 修改 myid 文件
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################

function myid ()
{
for insName in ${HOSTNAMES[@]}
do
    ## 修改 myid
    ssh root@${insName} "echo ${NUMBER} >> ${ZOOKEEPER_MYID}"

    NUMBER=$((${NUMBER}+1))
done
}

#####################################################################
# 函数名: main
# 描述: 脚本主要业务入口
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function main ()
{
zoo_cfg
zookeeper_distribution
myid
}

#---------------------------------------------------------------------#
#                              执行流程                                #
#---------------------------------------------------------------------#
## 打印时间
echo "" | tee -a $LOG_FILE
echo "$(date "+%Y-%m-%d  %H:%M:%S")" | tee  -a  $LOG_FILE
main



