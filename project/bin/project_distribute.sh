#!/bin/bash
################################################################################
## Copyright:   HZGOSUN Tech. Co, BigData
## Filename:    ftp_distribute.sh
## Description: 一键配置及分发Collect（FTP）模块
## Author:      zhangbaolin
## Created:     2018-07-26
################################################################################
#set -x  ## 用于调试用，不用的时候可以注释掉
set -e

cd `dirname $0`
## 脚本所在目录
BIN_DIR=`pwd`
CONF_DIR=${BIN_DIR}/../conf
CONF_FILE=${CONF_DIR}/project-conf.properties
cd ..
## 安装包根目录
ROOT_HOME=`pwd`   ##ClusterBuildScripts
## 集群配置文件目录
CLUSTER_CONF_DIR=${ROOT_HOME}/conf
## 集群配置文件
CLUSTER_CONF_FILE=${CONF_DIR}/cluster_conf.properties
## FTP服务器地址
FTPIP=$(grep 'FTPIP' ${CLUSTER_CONF_FILE} | cut -d '=' -f2)
## 集群节点地址
CLUSTERNODELIST=$(grep 'Cluster_HostName' ${CLUSTER_CONF_FILE} | cut -d '=' -f2)
CLUSTERNODE=(${CLUSTERNODE//;/ })
## 本节点ip
LOCALIP=`hostname -i`
cd ..
## 判断RealTimeFaceCompare目录是否存在
if [[ ! -e RealTimeFaceCompare ]]; then
    echo "RealTimeFaceCompare 目录不存在"
    exit 1
fi
## 判断Collect目录是否存在
if [[ ! -e Collect ]]; then
    echo "Collect 目录不存在"
    exit 1
fi

cd RealTimeFaceCompare
## RealTimeFaceCompare 目录
RTFC_HOME=`pwd`
## common模块目录
COMMON_DIR=${RTFC_HOME}/common
## cluster模块目录
CLUSTER_DIR=${RTFC_HOME}/cluster
## service模块目录
SERVICE_DIR=${RTFC_HOME}/service

## cluster-spark模块部署目录
SPARK_DIR=${RTFC_HOME}/cluster/spark
## cluster-spark模块配置文件目录
CONF_SPARK_DIR=${SPARK_DIR}/conf
## common log日志目录
COMMON_LOG_DIR=${COMMON_DIR}/logs
## common log日志文件
COMMON_LOG_FILE=${COMMON_LOG_DIR}/config-project.log
## service的log日志目录
SERVICE_LOG_DIR=${SERVICE_DIR}/logs
## Service log日志文件
SERVICE_LOG_FILE=${COMMON_LOG_DIR}/config-service.log
## cluster-spark log日志目录
SPARK_LOG_DIR=${SPARK_DIR}/logs
## cluster-spark log日志文件
SPARK_LOG_FILE=${SPARK_LOG_DIR}/config-cluster.log

## address模块部署目录
ADDRESS_DIR=${SERVICE_DIR}/address
ADDRESS_BIN_DIR=${ADDRESS_DIR}/bin                                ##address模块脚本存放目录
ADDRESS_START_FILE=${ADDRESS_BIN_DIR}/start-address.sh            ##address模块启动脚本
ADDRESS_CONF_DIR=${ADDRESS_DIR}/conf                              ##address模块conf目录
ADDRESS_PRO_FILE=${ADDRESS_CONF_DIR}/application-pro.properties   ##address模块配置文件
## alarm模块部署目录
ALARM_DIR=${SERVICE_DIR}/alarm
ALARM_BIN_DIR=${ALARM_DIR}/bin                           ##alarm模块脚本存放目录
ALARM_START_FILE=${ALARM_BIN_DIR}/start-alarm.sh       ##alarm模块启动脚本
ALARM_CONF_DIR=${ALARM_DIR}/conf                       ##alarm模块conf目录
ALARM_PRO_FILE=${ALARM_CONF_DIR}/application-pro.properties   ##alarm模块配置文件
## clustering模块部署目录
CLUSTERING_DIR=${SERVICE_DIR}/clustering
CLUSTERING_BIN_DIR=${CLUSTERING_DIR}/bin                                ##clustering模块脚本存放目录
CLUSTERING_START_FILE=${CLUSTERING_BIN_DIR}/start-clustering.sh         ##clustering模块启动脚本
CLUSTERING_CONF_DIR=${CLUSTERING_DIR}/conf                              ##clustering模块conf目录
CLUSTERING_PRO_FILE=${CLUSTERING_CONF_DIR}/application-pro.properties   ##clustering模块配置文件
## dispatch模块部署目录
DISPATCH_DIR=${SERVICE_DIR}/dispatch
DISPATCH_BIN_DIR=${DISPATCH_DIR}/bin                           ##dispatch模块脚本存放目录
DISPATCH_START_FILE=${DISPATCH_BIN_DIR}/start-dispatch.sh       ##dispatch模块启动脚本
DISPATCH_CONF_DIR=${DISPATCH_DIR}/conf                         ##dispatch模块conf目录
DISPATCH_PRO_FILE=${DISPATCH_CONF_DIR}/application-pro.properties   ##dispatch模块配置文件
## dynrepo模块部署目录
DYNREPO_DIR=${SERVICE_DIR}/dynRepo
DYNREPO_BIN_DIR=${DYNREPO_DIR}/bin                           ##dynrepo模块脚本存放目录
DYNREPO_START_FILE=${DYNREPO_BIN_DIR}/start-dynrepo.sh       ##dynrepo模块启动脚本
DYNREPO_CONF_DIR=${DYNREPO_DIR}/conf                         ##dynrepo模块conf目录
DYNREPO_PRO_FILE=${DYNREPO_CONF_DIR}/application-pro.properties   ##dynrepo模块配置文件
## face模块部署目录
FACE_DIR=${SERVICE_DIR}/face
FACE_BIN_DIR=${FACE_DIR}/bin                           ##face模块脚本存放目录
FACE_START_FILE=${FACE_BIN_DIR}/start-face.sh       ##face模块启动脚本
FACE_CONF_DIR=${FACE_DIR}/conf                         ##face模块conf目录
FACE_PRO_FILE=${FACE_CONF_DIR}/application-pro.properties   ##face模块配置文件
## starepo模块目录
STAREPO_DIR=${SERVICE_DIR}/staRepo
STAREPO_BIN_DIR=${STAREPO_DIR}/bin                           ##starepo模块脚本存放目录
STAREPO_START_FILE=${STAREPO_BIN_DIR}/start-starepo.sh       ##starepo模块启动脚本
STAREPO_CONF_DIR=${STAREPO_DIR}/conf                         ##starepo模块conf目录
STAREPO_PRO_FILE=${STAREPO_CONF_DIR}/application-pro.properties   ##starepo模块配置文件
## visual模块目录
VISUAL_DIR=${SERVICE_DIR}/visual
VISUAL_BIN_DIR=${VISUAL_DIR}/bin                           ##visual模块脚本存放目录
VISUAL_START_FILE=${VISUAL_BIN_DIR}/start-visual.sh       ##visual模块启动脚本
VISUAL_CONF_DIR=${VISUAL_DIR}/conf                       ##visual模块conf目录
VISUAL_PRO_FILE=${VISUAL_CONF_DIR}/application-pro.properties   ##visual模块配置文件


## 安装的根目录，所有bigdata 相关的根目录
INSTALL_HOME=$(grep install_homedir ${CONF_FILE}|cut -d '=' -f2)

HADOOP_INSTALL_HOME=${INSTALL_HOME}/Hadoop            ### hadoop 安装目录
HADOOP_HOME=${HADOOP_INSTALL_HOME}/hadoop             ### hadoop 根目录
CORE_FILE=${HADOOP_HOME}/etc/hadoop/core-site.xml
HDFS_FILE=${HADOOP_HOME}/etc/hadoop/hdfs-site.xml
HBASE_INSTALL_HOME=${INSTALL_HOME}/HBase              ### hbase 安装目录
HBASE_HOME=${HBASE_INSTALL_HOME}/hbase                ### hbase 根目录
HBASE_FILE=${HBASE_HOME}/hbase/conf/hbase-site.xml
HIVE_INSTALL_HOME=${INSTALL_HOME}/Hive                ### hive 安装目录
HIVE_HOME=${HIVE_INSTALL_HOME}/hive                   ### hive 根目录
SPARK_INSTALL_HOME=${INSTALL_HOME}/Spark              ### spark 安装目录
SPARK_HOME=${SPARK_INSTALL_HOME}/spark                ### spark 根目录


#####################################################################
# 函数名: config_projectconf
# 描述: 配置RealTimeFaceCompare模块
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function config_projectconf()
{
    for node in ${CLUSTERNODE[@]};do
      #  ## 分发RealTimeFaceCompare，若是本节点则不分发
      #  if [[  x"${node}" != x"${LOCALIP}" ]]; then
      #      scp -r ${RTFC_HOME} root@node:${RTFC_HOME}
      #  fi
        ## 修改common模块配置文件
        ## 修改配置文件 zookeeper安装节点
        echo "配置${node}上 project-conf.properties中的zookeeper地址"
        zookeeper=$(grep 'Zookeeper_InstallNode' ${CLUSTER_CONF_FILE} | cut -d '=' -f2)
        ssh root@node "sed -i 's#zookeeper_installnode=.*#zookeeper_installnode=${zookeeper}#g' ${CONF_FILE}"

        ## 修改配置文件 kafka安装节点
        echo "配置${node}上 project-conf.properties中的kafka地址"
        kafka=$(grep 'Kafka_InstallNode' ${CLUSTER_CONF_FILE} | cut -d '=' -f2)
        ssh root@node "sed -i 's#kafka_install_node=.*#kafka_install_node=${kafka}#g' ${CONF_FILE}"

        ## 修改配置文件 rocketmq安装节点
        echo "配置${node}上 project-conf.properties中的rocketmq地址"
        rocketmq=$(grep 'RocketMQ_Namesrv' ${CLUSTER_CONF_FILE} | cut -d '=' -f2)
        ssh root@node "sed -i 's#rocketmq.address=.*#rocketmq.address=${rocketmq}#g' ${CONF_FILE}"

         ## 修改配置文件 es安装节点
        echo "配置${node}上 project-conf.properties中的rocketmq地址"
        rocketmq=$(grep 'ES_InstallNode' ${CLUSTER_CONF_FILE} | cut -d '=' -f2)
        ssh root@node "sed -i 's#es_service_node=.*#es_service_node=${rocketmq}#g' ${CONF_FILE}"

        ## 修改配置文件 jdbc_service节点
         echo "配置${node}上 project-conf.properties中的jdbc_service地址"
        sparknode=$(grep 'Spark_ServiceNode' ${CLUSTER_CONF_FILE} | cut -d '=' -f2)
        sparknamenode=$(grep 'Spark_NameNode' ${CLUSTER_CONF_FILE} | cut -d '=' -f2)
        if [[ "${sparknode}" =~ "${sparknamenode}" ]]; then
            sparknode=(${sparknode#/$sparknamenode})
            ssh root@node "sed -i 's#jdbc_service_node=.*#jdbc_service_node=${sparknode}#g' ${CONF_FILE}"
        else
            ssh root@node "sed -i 's#jdbc_service_node=.*#jdbc_service_node=${sparknode};${sparknamenode}#g' ${CONF_FILE}"
        fi
    done
}


#####################################################################
# 函数名: distribute_service
# 描述:  分发service各个模块
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function distribute_service()
{
    echo "" | tee -a ${SERVICE_LOG_FILE}
    echo "**************************************************" | tee -a ${SERVICE_LOG_FILE}
    echo "" | tee -a ${SERVICE_LOG_FILE}
    echo "分发service的各个组件......" | tee -a ${SERVICE_LOG_FILE}

    ##开始分发address
    ADDRESS_HOST_LISTS=$(grep address_distribution ${CONF_FILE} | cut -d '=' -f2)
    ADDRESS_HOST_ARRAY=(${ADDRESS_HOST_LISTS//;/ })
    for hostname in ${ADDRESS_HOST_ARRAY[@]}
    do
      ssh root@${hostname} "if [ ! -x "${SERVICE_DIR}" ];then mkdir -p "${SERVICE_DIR}"; fi"
      rsync -rvl ${ADDRESS_DIR} root@${hostname}:${SERVICE_DIR} >/dev/null
      ssh root@${hostname} "chmod -R 755 ${ADDRESS_DIR}"
      echo "${hostname}上分发address完毕........" | tee -a ${SERVICE_LOG_FILE}
    done

    ##开始分发alarm
    ALARM_HOST_LISTS=$(grep alarm_distribution ${CONF_FILE} | cut -d '=' -f2)
    ALARM_HOST_ARRAY=(${ALARM_HOST_LISTS//;/ })
    for hostname in ${ALARM_HOST_ARRAY[@]}
    do
      ssh root@${hostname} "if [ ! -x "${SERVICE_DIR}" ];then mkdir -p "${SERVICE_DIR}"; fi"
      rsync -rvl ${ALARM_DIR} root@${hostname}:${SERVICE_DIR} >/dev/null
      ssh root@${hostname} "chmod -R 755 ${ALARM_DIR}"
      echo "${hostname}上分发alarm完毕........" | tee -a ${SERVICE_LOG_FILE}
    done

    ##开始分发clustering
    CLUSTERING_HOST_LISTS=$(grep clustering_distribution ${CONF_FILE} | cut -d '=' -f2)
    CLUSTERING_HOST_ARRAY=(${CLUSTERING_HOST_LISTS//;/ })
    for hostname in ${CLUSTERING_HOST_ARRAY[@]}
    do
      ssh root@${hostname} "if [ ! -x "${SERVICE_DIR}" ];then mkdir -p "${SERVICE_DIR}"; fi"
      rsync -rvl ${CLUSTERING_DIR} root@${hostname}:${SERVICE_DIR} >/dev/null
      ssh root@${hostname} "chmod -R 755 ${CLUSTERING_DIR}"
      echo "${hostname}上分发clustering完毕......." | tee -a ${SERVICE_LOG_FILE}
    done

    ##开始分发dispatch
    DISPATCH_HOST_LISTS=$(grep dispatch_distribution ${CONF_FILE} | cut -d '=' -f2)
    DISPATCH_HOST_ARRAY=(${DISPATCH_HOST_LISTS//;/ })
    for hostname in ${DISPATCH_HOST_ARRAY[@]}
    do
      ssh root@${hostname} "if [ ! -x "${SERVICE_DIR}" ];then mkdir -p "${SERVICE_DIR}";fi"
      rsync -rvl ${DISPATCH_DIR} root@${hostname}:${SERVICE_DIR} >/dev/null
      ssh root@${hostname} "chmod -R 755 ${DISPATCH_DIR}"
      echo "${hostname}上分发dispatch完毕........." | tee -a ${SERVICE_LOG_FILE}
    done

    ##开始分发dynrepo
    DYNREPO_HOST_LISTS=$(grep dynrepo_distribution ${CONF_FILE} | cut -d '=' -f2)
    DYNREPO_HOST_ARRAY=(${DYNREPO_HOST_LISTS//;/ })
    for hostname in ${DYNREPO_HOST_ARRAY[@]}
    do
       ssh root@${hostname} "if [ ! -x "${SERVICE_DIR}" ];then mkdir -p "${SERVICE_DIR}";fi"
       rsync -rvl ${DYNREPO_DIR} root@${hostname}:${SERVICE_DIR} >/dev/null
       ssh root@${hostname} "chmod -R 755 ${DYNREPO_DIR}"
       echo "${hostname}上分发dynrepo完毕........." | tee -a ${SERVICE_LOG_FILE}
    done

     ##开始分发face
     FACE_HOST_LISTS=$(grep face_distribution ${CONF_FILE} | cut -d '=' -f2)
     FACE_HOST_ARRAY=(${FACE_HOST_LISTS//;/ })
     for hostname in ${FACE_HOST_ARRAY[@]}
     do
        ssh root@${hostname} "if [ ! -x "${SERVICE_DIR}" ];then mkdir -p "${SERVICE_DIR}";fi"
        rsync -rvl ${FACE_DIR} root@${hostname}:${SERVICE_DIR} >/dev/null
        ssh root@${hostname} "chmod -R 755 ${FACE_DIR}"
        echo "${hostname}上分发face完毕......." | tee -a ${SERVICE_LOG_FILE}
     done

     ##开始分发starepo
     STAREPO_HOST_LISTS=$(grep starepo_distribution ${CONF_FILE} | cut -d '=' -f2)
     STAREPO_HOST_ARRAY=(${STAREPO_HOST_LISTS//;/ })
     for hostname in ${STAREPO_HOST_ARRAY[@]}
     do
        ssh root@${hostname} "if [ ! -x "${SERVICE_DIR}" ];then mkdir -p "${SERVICE_DIR}";fi"
        rsync -rvl ${STAREPO_DIR} root@${hostname}:${SERVICE_DIR} >/dev/null
        ssh root@${hostname} "chmod -R 755 ${STAREPO_DIR}"
        echo "${hostname}上分发starepo完毕......." | tee -a ${SERVICE_LOG_FILE}
     done

     ##开始分发visual
     VISUAL_HOST_LISTS=$(grep visual_distribution ${CONF_FILE} | cut -d '=' -f2)
     VISUAL_HOST_ARRAY=(${VISUAL_HOST_LISTS//;/ })
     for hostname in ${VISUAL_HOST_ARRAY[@]}
     do
       ssh root@${hostname} "if [ ! -x "${SERVICE_DIR}" ];then mkdir -p "${SERVICE_DIR}";fi"
       rsync -rvl ${VISUAL_DIR} root@${hostname}:${SERVICE_DIR} >/dev/null
       ssh root@${hostname} "chmod -R 755 ${VISUAL_DIR}"
       echo "${hostname}上分发visual完毕........" | tee -a ${SERVICE_LOG_FILE}
     done

    echo "配置完毕......" | tee -a ${SERVICE_LOG_FILE}

}

#####################################################################
# 函数名: copy_xml_to_spark
# 描述: 配置Hbase服务，移动所需文件到cluster/spark/conf下
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function copy_xml_to_spark()
{
    echo ""  | tee -a ${SPARK_LOG_FILE}
    echo "**********************************************" | tee -a ${SPARK_LOG_FILE}
    echo "" | tee -a ${SPARK_LOG_FILE}
    echo "copy 文件 hbase-site.xml core-site.xml hdfs-site.xml hive-site.xml到 cluster/conf......"  | tee  -a  ${SPARK_LOG_FILE}

    cp ${HBASE_HOME}/conf/hbase-site.xml ${CONF_SPARK_DIR}
    cp ${HADOOP_HOME}/etc/hadoop/core-site.xml ${CONF_SPARK_DIR}
    cp ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml ${CONF_SPARK_DIR}
    cp ${HIVE_HOME}/conf/hive-site.xml ${CONF_SPARK_DIR}

    echo "copy完毕......"  | tee  -a  ${SPARK_LOG_FILE}
}



#####################################################################
# 函数名: config_sparkjob
# 描述:  配置cluster模块下的sparkjob.properties文件
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function config_sparkjob()
{
    echo ""  | tee -a ${SPARK_LOG_FILE}
    echo "**********************************************" | tee -a ${SPARK_LOG_FILE}
    echo "" | tee -a ${SPARK_LOG_FILE}
    echo "配置cluster/spark/conf/sparkJob 文件......"  | tee  -a  ${SPARK_LOG_FILE}

    ### 从project-conf.properties读取sparkJob所需配置IP
    # 根据字段kafka，查找配置文件中，Kafka的安装节点所在IP端口号的值，这些值以分号分割
	KAFKA_IP=$(grep kafka_install_node ${CONF_FILE}|cut -d '=' -f2)
    # 将这些分号分割的ip用放入数组
    spark_arr=(${KAFKA_IP//;/ })
    sparkpro=''
    for spark_host in ${spark_arr[@]}
    do
        sparkpro="$sparkpro$spark_host:9092,"
    done
    sparkpro=${sparkpro%?}

    # 替换sparkJob.properties中：key=value（替换key字段的值value）
    sed -i "s#^kafka.metadata.broker.list=.*#kafka.metadata.broker.list=${sparkpro}#g" ${CONF_SPARK_DIR}/sparkJob.properties
    sed -i "s#^job.faceObjectConsumer.broker.list=.*#job.faceObjectConsumer.broker.list=${sparkpro}#g" ${CONF_SPARK_DIR}/sparkJob.properties

    # 根据字段zookeeper_installnode，查找配置文件中，Zk的安装节点所在IP端口号的值，这些值以分号分割
    ZK_IP=$(grep zookeeper_installnode ${CONF_FILE}|cut -d '=' -f2)
    # 将这些分号分割的ip用放入数组
    zk_arr=(${ZK_IP//;/ })
    zkpro=''
    phoenixpro=''
    phoenixpro=$phoenixpro${zk_arr[0]}":2181"
    for zk_ip in ${zk_arr[@]}
    do
        zkpro="$zkpro$zk_ip:2181,"
    done
    zkpro=${zkpro%?}
    # 替换sparkJob.properties中：key=value（替换key字段的值value）
    sed -i "s#^job.zkDirAndPort=.*#job.zkDirAndPort=${zkpro}#g" ${CONF_SPARK_DIR}/sparkJob.properties
    # 替换sparkJob.properties中：key=value(替换key字段的值value)
    sed -i "s#^phoenix.jdbc.url=jdbc:phoenix:.*#phoenix.jdbc.url=jdbc:phoenix:${phoenixpro}#g"  ${CONF_SPARK_DIR}/sparkJob.properties

    #根据字段es_service_node，查找配置文件中，es的安装节点所在ip端口号的值，这些值以分号分割
    ES_IP=$(grep es_service_node ${CONF_FILE} | cut -d '=' -f2)
    #将这些分号分割的ip用于放入数组中
    es_arr=(${ES_IP//;/ })
    espro=''
    espro=$espro${es_arr[0]}
    echo $espro
    echo "++++++++++++++++++++++++++++++++++"
    #替换sparkJob.properties中：key=value(替换key字段的值value)
    sed -i "s#^es.hosts=.*#es.hosts=${espro}#g" ${CONF_SPARK_DIR}/sparkJob.properties

    #根据字段rocketmq_nameserver，查找配置文件中，rocketmq的nameserver安装节点所在IP端口号的值，这些值以分号分割
    ROCK_IP=$(grep rocketmq_nameserver ${CONF_FILE} | cut -d '=' -f2)
    rockpro=''
    rockpro=$rockpro$ROCK_IP":9876"
    #替换sparkJob.properties中：key=value(替换key字段的值value)
    sed -i "s#^rocketmq.nameserver=.*#rocketmq.nameserver=${rockpro}#g"  ${CONF_SPARK_DIR}/sparkJob.properties

    # 根据job_clustering_mysql_url字段设置常驻人口管理告警信息MYSQL数据库地址
    num=$[ $(cat ${CONF_SPARK_DIR}/sparkJob.properties | cat -n | grep job.clustering.mysql.url  | awk '{print $1}') ]
    value=$(grep job_clustering_mysql_url ${CONF_FILE}  |  awk  -F  "url=" '{print $2}')
    value="job.clustering.mysql.url=${value}"
    sed -i "${num}c ${value}"  ${CONF_SPARK_DIR}/sparkJob.properties

    echo "配置完毕......"  | tee  -a  ${SPARK_LOG_FILE}

    echo "开始分发SparkJob文件......"  | tee  -a  ${SPARK_LOG_FILE}
    for spark_hname in ${spark_arr[@]}
    do
        scp -r ${CONF_SPARK_DIR}/sparkJob.properties root@${spark_hname}:${SPARK_HOME}/conf
    done
}


#####################################################################
# 函数名: config_service
# 描述:  配置service模块下的各个子模块的配置文件，启停脚本
# 参数: N/A
# 返回值: N/A
# 其他: N/A
#####################################################################
function config_service()
{
echo "" | tee -a ${SERVICE_LOG_FILE}
    echo "**************************************************" | tee -a ${SERVICE_LOG_FILE}
    echo "" | tee -a ${SERVICE_LOG_FILE}
    echo "开始配置service底下的各个模块......" | tee -a ${SERVICE_LOG_FILE}

    #单独给静态库配置pro配置文件：
    #从project-conf.properties中读取kafka配置IP
    KAFKA_IP=$(grep kafka_install_node $CONF_FILE | cut -d '=' -f2)
    #将这些分号分割的ip用于放入数组中
    kafka_arr=(${KAFKA_IP//;/ })
    kafkapro=''
    for kafka_host in ${kafka_arr[@]}
    do
      kafkapro=$kafkapro$kafka_host":9092,"
    done
    kafkapro=${kafkapro%?}

    #替换pro文件中的值：
    sed -i "s#^kafka.bootstrap.servers=.*#kafka.bootstrap.servers=${kafkapro}#g" ${STAREPO_PRO_FILE}
    sed -i "s#^kafka.bootstrap.servers=.*#kafka.bootstrap.servers=${kafka_arr[0]:9092}#g" ${STAREPO_START_FILE}
    echo "静态库application-pro文件配置完成......"

    #配置es.hosts:
    #从project-conf.properties中读取es所需配置IP
    #根据字段es，查找配置文件，这些值以分号分隔
    ES_IP=$(grep es_service_node $CONF_FILE | cut -d '=' -f2)
    #将这些分号分割的ip用于放入数组中
    es_arr=(${ES_IP//;/ })
    espro=''
    for es_host in ${es_arr[@]}
    do
       espro="$espro$es_host,"
    done
    espro=${espro%?}

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^ES_HOST=.*#ES_HOST=${espro}#g" ${CLUSTERING_START_FILE}
    echo "start-clustering.sh脚本配置es完成......"

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^ES_HOST=.*#ES_HOST=${espro}#g" ${DYNREPO_START_FILE}
    echo "start-dynrepo.sh脚本配置es完成......"

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^ES_HOST=.*#ES_HOST=${espro}#g" ${STAREPO_START_FILE}
    echo "start-starepo.sh脚本配置es完成......"

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^ES_HOST=.*#ES_HOST=${espro}#g" ${VISUAL_START_FILE}
    echo "start-visual.sh脚本配置es完成......"

        #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^ES_HOST=.*#ES_HOST=${espro}#g" ${ALARM_START_FILE}
    echo "start-alarm.sh脚本配置es完成......"


    #配置zookeeper：
    #从project-conf.properties中读取zookeeper所需配置IP
    #根据字段zookeeper，查找配置文件，这些值以分号分隔
    ZK_HOSTS=$(grep zookeeper_installnode $CONF_FILE | cut -d '=' -f2)
    zk_arr=(${ZK_HOSTS//;/ })
    zkpro=''
    zkpro=$zkpro${zk_arr[0]}":2181"

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^ZOOKEEPER_HOST=.*#ZOOKEEPER_HOST=${zkpro}#g" ${ADDRESS_START_FILE}
    echo "start-address.sh脚本配置zookeeper完成......"

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^ZOOKEEPER_HOST=.*#ZOOKEEPER_HOST=${zkpro}#g" ${DYNREPO_START_FILE}
    echo "start-dynrepo.sh脚本配置zookeeper完成......"

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^ZOOKEEPER_HOST=.*#ZOOKEEPER_HOST=${zk_arr[0]}#g" ${STAREPO_START_FILE}
    echo "start-starepo.sh脚本配置zookeeper完成......"

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^ZOOKEEPER_HOST=.*#ZOOKEEPER_HOST=${zkpro}#g" ${VISUAL_START_FILE}
    echo "start-visual.sh脚本配置zookeeper完成......"

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^ZOOKEEPER_HOST=.*#ZOOKEEPER_HOST=${zkpro}#g" ${ALARM_START_FILE}
    echo "start-alarm.sh脚本配置zookeeper完成......"


    #配置eureka_node:
    #从project-conf.properties中读取eureka_node所需配置ip
    #根据字段eureka_node，查找配置文件，这些值以分号分隔
    EUREKA_NODE_HOSTS=$(grep spring_cloud_eureka_node $CONF_FILE | cut -d '=' -f2)
    eureka_node_arr=(${EUREKA_NODE_HOSTS//;/ })
    enpro=''
    for en_host in ${eureka_node_arr[@]}
    do
      enpro=${enpro}${en_host}","
    done
    enpro=${enpro%?}

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_IP=.*#EUREKA_IP=${enpro}#g" ${ADDRESS_START_FILE}
    echo "start-address.sh脚本配置eureka_node完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_IP=.*#EUREKA_IP=${enpro}#g" ${CLUSTERING_START_FILE}
    echo "start-clustering.sh脚本配置eureka_node完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_IP=.*#EUREKA_IP=${enpro}#g" ${DISPATCH_START_FILE}
    echo "start-dispatch.sh脚本配置eureka_node完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_IP=.*#EUREKA_IP=${enpro}#g" ${DYNREPO_START_FILE}
    echo "start-dynrepo.sh脚本配置eureka_node完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_IP=.*#EUREKA_IP=${enpro}#g" ${FACE_START_FILE}
    echo "start-face.sh脚本配置eureka_node完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_IP=.*#EUREKA_IP=${enpro}#g" ${STAREPO_START_FILE}
    echo "start-starepo.sh脚本配置eureka_node完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_IP=.*#EUREKA_IP=${enpro}#g" ${VISUAL_START_FILE}
    echo "start-visual.sh脚本配置eureka_node完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_IP=.*#EUREKA_IP=${enpro}#g" ${ALARM_START_FILE}
    echo "start-alarm.sh脚本配置eureka_node完成......."

    #配置eureka_port:
    #从project-conf.properties中读取eureka_port所需配置port
    #根据字段eureka_port,查找配置文件
    EUREKA_PORT=$(grep spring_cloud_eureka_port $CONF_FILE | cut -d '=' -f2)

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_PORT=.*#EUREKA_PORT=${EUREKA_PORT}#g" ${ADDRESS_START_FILE}
    echo "start-address.sh脚本配置eureka_port完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_PORT=.*#EUREKA_PORT=${EUREKA_PORT}#g" ${CLUSTERING_START_FILE}
    echo "start-clustering.sh脚本配置eureka_port完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_PORT=.*#EUREKA_PORT=${EUREKA_PORT}#g" ${DISPATCH_START_FILE}
    echo "start-dispatch.sh脚本配置eureka_port完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_PORT=.*#EUREKA_PORT=${EUREKA_PORT}#g" ${DYNREPO_START_FILE}
    echo "start-dynrepo.sh脚本配置eureka_port完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_PORT=.*#EUREKA_PORT=${EUREKA_PORT}#g" ${FACE_START_FILE}
    echo "start-face.sh脚本配置eureka_port完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_PORT=.*#EUREKA_PORT=${EUREKA_PORT}#g" ${STAREPO_START_FILE}
    echo "start-starepo.sh脚本配置eureka_port完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_PORT=.*#EUREKA_PORT=${EUREKA_PORT}#g" ${VISUAL_START_FILE}
    echo "start-visual.sh脚本配置eureka_port完成......."

    #替换模块启动脚本中：key=value(替换key字段的值value)
    sed -i "s#^EUREKA_PORT=.*#EUREKA_PORT=${EUREKA_PORT}#g" ${ALARM_START_FILE}
    echo "start-alarm.sh脚本配置eureka_port完成......."

}

################################################################################
# 函数名：copy_xml_to_service
# 描述：将hbase-site、core-site、hdfs-site拷贝至需要的模块conf底下
# 参数：N/A
# 返回值：N/A
# 其他：N/A
################################################################################
function copy_xml_to_service()
{
    echo "" | tee -a ${SERVICE_LOG_FILE}
    echo "**************************************************" | tee -a ${SERVICE_LOG_FILE}
    echo "" | tee -a ${SERVICE_LOG_FILE}
    echo "开始将配置文件拷贝至需要的模块下......" | tee -a ${SERVICE_LOG_FILE}

    scp -r $CORE_FILE $HDFS_FILE $HBASE_FILE $ADDRESS_CONF_DIR
    scp -r $CORE_FILE $HDFS_FILE $HBASE_FILE $DYNREPO_CONF_DIR
    scp -r $CORE_FILE $HDFS_FILE $HBASE_FILE $STAREPO_CONF_DIR
    scp -r $CORE_FILE $HDFS_FILE $HBASE_FILE $CLUSTERING_CONF_DIR
    scp -r $CORE_FILE $HDFS_FILE $HBASE_FILE $VISUAL_CONF_DIR
    scp -r $CORE_FILE $HDFS_FILE $HBASE_FILE $DISPATCH_CONF_DIR
}



##############################################################################
# 函数名： main
# 描述： 脚本主要业务入口
# 参数： N/A
# 返回值： N/A
# 其他： N/A
##############################################################################
function main()
{
  config_projectconf   ##配置project-conf.properties
  ## cluster模块
  copy_xml_to_spark             ##复制集群xml文件到cluster/spark目录下
  config_sparkjob          ##配置sparkjob.properties
  ## service模块
  config_service          ##配置service各个子模块的配置文件及启停脚本
  copy_xml_to_service     ##复制集群xml文件到各个子模块的conf下
  distribute_service  ##分发service模块
}

#--------------------------------------------------------------------------#
#                                  执行流程                                #
#--------------------------------------------------------------------------#
##打印时间
echo ""
echo "=========================================================="
echo "$(date "+%Y-%m-%d  %H:%M:%S")"

main

set +x


