# 配置脚本

1. 修改jar包名称：`mv "你的jar包" app.jar`
3. 复制脚本：`cp ./java_service.sh "你项目的目录"`
3. 修改脚本内容：将脚本中的`APP_PATH`修改为jar包所在的目录,`JAVA_HOME`修改为java环境的根目录
4. 授权：`chmod 777 ./java_service.sh`
5. 测试启动：`sh ./java_service.sh start`

# centos7 安装服务

1. 复制服务文件：`mv ./java.service /usr/lib/systemd/system/app.service`
2. 修改服务的内容：将对应目录调整为你的目录
3. 重载配置：`systemctl daemon-reload`
4. 设置开机启动：`systemctl enable app`
5. 启动服务：`systemctl start app`
6. 定时重启：`echo '0 0 * * * root systemctl restart app' >> /etc/crontab && crontab /etc/crontab`
