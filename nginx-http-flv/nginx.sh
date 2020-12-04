#!/bin/bash
#↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓可修改部分↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
#http端口
http_port=80
#https端口
https_port=443
#flv端口
flv_port=1935
#持久化目录
logs=/data/zhiheiot/nginx/logs
#配置文件目录
conf=/data/zhiheiot/nginx/conf
#静态文件目录
static_file=/data/zhiheiot/java/file
#容器名称
container_name=zhihe-nginx
#↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑可修改部分↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
#镜像
image="ersut/nginx-http-flv:v1.18_1.2.8"

mkdir -p ${logs}
mkdir -p ${conf}


#查询当前镜像是否存在
has=`docker images --format "{{.Repository}}:{{.Tag}}" ${image}`
if [ "${image}" != "${has}" ]; then
	#拉取docker镜像
	docker pull ${image}
fi

#查询当前容器是否存在
is_run=`docker ps -a --filter name=${container_name} --format "{{.Names}}"`
if [ "${container_name}" != "${is_run}" ]; then
	#运行复制文件
	docker run -d --name ${container_name} ${image}
	docker cp ${container_name}:/usr/local/nginx/conf/. ${conf}/
	docker stop ${container_name}
	docker rm ${container_name}
	
	#自定义配置文件
	run_path=`cd $(dirname $0) && pwd`
	cp ${run_path}/nginx.conf ${conf}
	cp ${run_path}/zhiheiot-flv.conf ${conf}
	cp ${run_path}/zhiheiot-http.conf ${conf}
	
	#运行
	docker run -d --restart=always --name ${container_name} -p ${http_port}:80 -p ${https_port}:443  -p ${flv_port}:1935 -v ${logs}:/usr/local/nginx/logs -v ${conf}:/usr/local/nginx/conf -v ${static_file}:/data/file -v /etc/localtime:/etc/localtime ${image}
else
	#重启库
	docker restart ${container_name}
fi