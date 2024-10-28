# Seata部署&运行

> 官方docker-compose部署文档：https://seata.apache.org/zh-cn/docs/ops/deploy-by-docker-compose#nacos-db



## 文件结构

```tex
├─.env # docker-compose 的环境变量
├─docker-compose.yml #docker-compose 文件
├─seata
|   ├─lib
|   |  ├─jdbc
|   |  |  └mysql-connector-j-8.0.33.jar #seata连接mysql所需的jar包
|   ├─conf
|   |  ├─application.yml #seata的配置文件
|   |  └seata-server.properties #seata配置中心文件的示例，该配置应放在配置中心
├─nacos
|   ├─conf
|   |  └application.properties #nacos的配置
├─mysql
|   ├─sql
|   |  ├─nacos.sql #nacos的初始化数据库，其中已经包含了 seata-server.properties
|   |  └seata.sql #seata的初始化数据库
|   ├─conf
|   |  └config-mysql.cnf
```

## docker-compose.yml

```yml
version : '3.8'
services:
  mysql:
    container_name: ${prefix}${MYSQL_CONTAINER_NAME}
    platform: linux/amd64
    image: mysql:5.7
    restart: always
    ports:
      - "3306:3306"
    volumes:
      - ./mysql/conf:/etc/mysql/conf.d
      - ./mysql/logs:/logs
      - ./mysql/data:/var/lib/mysql
      - ./mysql/sql/:/docker-entrypoint-initdb.d/
    environment:
      TZ: "$TZ"
      MYSQL_DATABASE: "${MYSQL_DATABASE}"
      MYSQL_ROOT_PASSWORD: "${MYSQL_ROOT_PASSWORD}"

  nacos:
    container_name: ${prefix}${NACOS_CONTAINER_NAME}
    image: nacos/nacos-server:${NACOS_VERSION}
    restart: always
    environment:
      MODE: "${NACOS_MODE}"
      MYSQL_DATABASE_NUM: "${NACOS_MYSQL_DATABASE_NUM}"
      MYSQL_SERVICE_HOST: "${prefix}${MYSQL_CONTAINER_NAME}"
      MYSQL_SERVICE_DB_NAME: "${NACOS_MYSQL_SERVICE_DB_NAME}"
      MYSQL_SERVICE_DB_PARAM: "${NACOS_MYSQL_SERVICE_DB_PARAM}"
      MYSQL_SERVICE_USER: "${NACOS_MYSQL_SERVICE_USER}"
      MYSQL_SERVICE_PASSWORD: "${MYSQL_ROOT_PASSWORD}"
      TZ: "$TZ"
    volumes:
      - ./nacos/conf/application.properties:/home/nacos/conf/application.properties
    ports:
      - "8848:8848"
      - "9848:9848"
      - "9849:9849"
    depends_on:
      - mysql

  #分布式事务
  seata-server:
    container_name: ${prefix}${SEATA_CONTAINER_NAME}
    image: apache/seata-server:${SEATA_VERSION}
    restart: always
    ports:
      - "7091:7091"
      - "8091:8091"
    volumes:
      - ./seata/conf/application.yml:/seata-server/resources/application.yml
      - ./seata/lib/jdbc/mysql-connector-j-8.0.33.jar:/seata-server/libs/mysql-connector-java.jar
    environment:
      STORE_MODE: "db"
      SEATA_IP: "192.168.50.27" #填宿主机ip
      TZ: "$TZ"
      NACOS_ADDR: "${prefix}${NACOS_CONTAINER_NAME}"
    depends_on:
      - mysql
      - nacos
```

**注意：seata的SEATA_IP环境变量要填写宿主机ip**

官方解释：

- SEATA_IP：可选, 指定seata-server启动的IP, 该IP用于向注册中心注册时使用, 如eureka等



## 访问控制台页面

##### 访问Nacos

- 地址：http://127.0.0.1:8848/nacos/

##### 访问Seata

- 地址：http://127.0.0.1:7091/ 
- 账号：seata
- 密码：seata
