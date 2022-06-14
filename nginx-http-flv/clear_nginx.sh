#!/bin/bash
#此脚本用于自动分割Nginx的日志，access.log
#每天00:00执行此脚本 将前一天的access.log重命名为access-xxxx-xx-xx.log格式，并重新打开日志文件
#Nginx日志文件所在目录
LOG_PATH=/usr/local/nginx/logs/
#获取pid文件路径
PID=/usr/local/nginx/logs/nginx.pid
#获取昨天的日期
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
#分割日志
mv ${LOG_PATH}access.log ${LOG_PATH}access-${YESTERDAY}.log
mv ${LOG_PATH}error.log ${LOG_PATH}error-${YESTERDAY}.log
#向Nginx主进程发送USR1信号，重新打开日志文件
kill -USR1 `cat ${PID}`
#定时删除15天前的log
find ${LOG_PATH} -mtime +15 -type f -name "*.log" | xargs rm -f