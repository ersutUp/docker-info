#!/bin/bash
#↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓可修改部分↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
#数据库端口
port=3306
#数据库密码
pass=zhiheiot
#持久化目录
data=/data/zhiheiot/mysql/data
#配置文件目录
conf=/data/zhiheiot/mysql/conf
#容器名称
CONTAINER_NAME=zhihe-mysql
#↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑可修改部分↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
#镜像
image="mysql:5.7"

mkdir -p ${data}
mkdir -p ${conf}

#自定义mysql配置文件
touch ${conf}/config-mysql.cnf
echo "[client] 
default-character-set=utf8mb4

[mysql]
default-character-set=utf8mb4

[mysqld]
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
init_connect='SET NAMES utf8mb4'
character-set-server=utf8mb4
lower_case_table_names = 1
" > ${conf}/config-mysql.cnf

#查询当前镜像是否存在
has=`docker images --format "{{.Repository}}:{{.Tag}}" ${image}`
if [ "${image}" != "${has}" ]; then
	#拉取docker镜像
	docker pull ${image}
fi

#查询当前容器是否存在
is_run=`docker ps -a --filter name=${CONTAINER_NAME} --format "{{.Names}}"`
if [ "${CONTAINER_NAME}" != "${is_run}" ]; then
	#运行数据库
	docker run -d --restart=always --name ${CONTAINER_NAME} -p ${port}:3306 -v ${data}:/var/lib/mysql -v ${conf}:/etc/mysql/conf.d -v /etc/localtime:/etc/localtime -e MYSQL_ROOT_PASSWORD=${pass} ${image}
else
	#重启数据库
	docker restart ${CONTAINER_NAME}
fi