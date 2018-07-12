#!/bin/bash
################################################################################
## Copyright:   HZGOSUN Tech. Co, BigData
## Filename:    expand_conf.properties
## Description: 扩展集群的脚本
## Version:     2.0
## Author:      zhangbaolin && yinhang
## Created:     2018-7-2
################################################################################

#set -x

cd `dirname $0`
## 脚本所在目录
BIN_DIR=`pwd`
cd ..
## 安装包根目录
ROOT_HOME=`pwd`
## 主集群配置文件目录
CLUSTER_CONF_DIR=${ROOT_HOME}/conf
##扩展集群配置文件目录
EXPEND_CONF_DIR=${BIN_DIR}/conf
## 安装日记目录
LOG_DIR=${ROOT_HOME}/logs
## 安装日记目录
LOG_FILE=${LOG_DIR}/synConf.log
## 集群扩展的节点
EXPEND_NODE=$(grep Node_HostName ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)

function main() 
{
    #修改主配置文件Cluster_HostName的值
    CLUSTER_HOST=$(grep Cluster_HostName ${CLUSTER_CONF_DIR}/cluster_conf.properties|cut -d '=' -f2)
    CLUSTER_HOST=${CLUSTER_HOST}\;${EXPEND_NODE}
    sed -i "s#Cluster_HostName=.*#Cluster_HostName=${CLUSTER_HOST}#g"   ${CLUSTER_CONF_DIR}/cluster_conf.properties

     ## 扩展Zookeeper
    Is_Zookeeper=$(grep Is_Zookeeper_InstallNode ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
    if [ "x$Is_Zookeeper" = "xyes" ] ;then
        sh syncConf.sh zookeeper
		sh expand_zookeeper.sh
    fi

    ## 扩展datanode
    IS_DataNode=$(grep Is_Hadoop_DataNode ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
    if [ "x$IS_DataNode" = "xyes" ] ;then
	    sh syncConf.sh datanode
        sh expand_hadoop.sh
    fi

    ## 扩展nodemanager
    IS_NodeManager=$(grep Is_Yarn_NodeManager ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
    if [ "x$IS_NodeManager" = "xyes" ] ;then
        sh syncConf.sh nodemanager
		sh expand_hadoop.sh
    fi

    ## 扩展regionserver
    Is_RegionServer=$(grep Is_HBase_HRegionServer ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
    if [ "x$Is_RegionServer" = "xyes" ] ;then
        sh syncConf.sh regionserver
		sh expand_regionserver.sh
    fi

    ## 扩展hive
    IS_HIVE=$(grep Is_Meta_ThriftServer ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
    if [ "x$IS_HIVE" = "xyes" ] ;then
        sh syncConf.sh hive
		sh expand_hive.sh
    fi

    ## 扩展kafka
    Is_Kafka=$(grep Is_Kafka_InstallNode ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
    if [ "x$Is_Kafka" = "xyes" ] ;then
        sh syncConf.sh kafka
		sh expand_kafka.sh
    fi

    ## 扩展Scala
    Is_Scala=$(grep Is_Scala_InstallNode ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
    if [ "x$Is_Scala" = "xyes" ] ;then
        sh syncConf.sh scala
		sh expand_scala.sh
    fi

	## 扩展Spark
    Is_Spark=$(grep Is_Spark_ServiceNode ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
    if [ "x$Is_Spark" = "xyes" ] ;then
        sh syncConf.sh spark
		sh expand_spark.sh
    fi

    ## 扩展Rocketmq
    Is_Rocketmq=$(grep Is_RocketMQ_Broker ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
    if [ "x$Is_Rocketmq" = "xyes" ] ;then
        sh syncConf.sh rocketmq
		sh expand_rocketmq.sh
    fi

	## 扩展HAproxy
    Is_HAproxy=$(grep Is_HAproxy_ServiceNode ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
    if [ "x$Is_HAproxy" = "xyes" ] ;then
        sh syncConf.sh haproxy
		sh expand_haproxy.sh
    fi

    ## 扩展ES
    Is_ES=$(grep Is_ES_InstallNode ${EXPEND_CONF_DIR}/expand_conf.properties | cut -d '=' -f2)
    if [ "x$Is_ES" = "xyes" ] ;then
        sh syncConf.sh es
		sh expand_es.sh
    fi

}

main

