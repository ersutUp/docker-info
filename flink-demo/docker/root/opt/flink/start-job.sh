#!/bin/bash

JAR_PATH=$1
MAIN_CLASS=$2
JOB_ARGS=$3

echo "Job JAR_PATH: $JAR_PATH"
echo "Job JAR_PATH: $MAIN_CLASS"
echo "Job JOB_ARGS: $JOB_ARGS"

while ! nc -z 127.0.0.1 8081;do
  sleep 5;
done

sleep 3

echo "/opt/flink/bin/flink run $JAR_PATH $JOB_ARGS"
# 判断 MAIN_CLASS 是否有值
if [ -n "$MAIN_CLASS" ]; then
  /opt/flink/bin/flink run -c $MAIN_CLASS $JAR_PATH $JOB_ARGS
else
  /opt/flink/bin/flink run $JAR_PATH $JOB_ARGS
fi