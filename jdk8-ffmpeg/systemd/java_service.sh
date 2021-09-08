#!/bin/bash
APP_NAME=app
APP_PATH=/opt/java/
export JAVA_HOME=/opt/jdk8
export JRE_HOME=${JAVA_HOME}/jre

usage(){
  echo "请输入以下内容 [start|stop]"
  exit 1
}

stop(){
	echo "准备关闭当前项目已存在进程"
	tpid=`ps -ef|grep ${APP_NAME}.jar|grep -v grep|grep -v kill|awk '{print $2}'`
	if [ ${tpid} ]; then
	    echo "关闭进程: ${tpid}"
	    kill -9 $tpid
	    echo "关闭完成"
	else
	    echo '项目未运行'
	fi
}

start(){
	stop
	cd ${APP_PATH}
	echo "开始启动"
	rm -f ${APP_PATH}${APP_NAME}.pid
	nohup ${JRE_HOME}/bin/java -jar ${APP_PATH}${APP_NAME}.jar > /dev/null &
	echo $! > ${APP_PATH}${APP_NAME}.pid
}

case $1 in
"start")
	start
	;;
"stop")
	stop
	;;
	*)
	usage
	;;
esac
exit 0
