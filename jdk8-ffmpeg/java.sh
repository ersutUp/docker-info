#!/bin/bash
#↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓可修改部分↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
#数据库端口
port=8080
#持久化目录
data=/data/zhiheiot/java/app
#持久化目录
static_file=/data/zhiheiot/java/file
#容器名称
CONTAINER_NAME=zhihe-app
#↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑可修改部分↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
#镜像
image="ersut/centos7-jdk8-ffmpeg:v1"

mkdir -p ${data}
mkdir -p ${static_file}

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
	docker run -d --restart=always --name ${CONTAINER_NAME} -p ${port}:8080 -v ${data}:/data -v ${static_file}:/data/file -v /etc/localtime:/etc/localtime ${image}
else
	#重启数据库
	docker restart ${CONTAINER_NAME}
fi