-- -------------------------------- The script used when storeMode is 'db' --------------------------------

DROP DATABASE IF EXISTS `nacos`;

CREATE DATABASE `nacos` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

SET NAMES utf8mb4;

USE `nacos`;

/******************************************/
/*   表名称 = config_info                  */
/******************************************/
CREATE TABLE `config_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) DEFAULT NULL COMMENT 'group_id',
  `content` longtext NOT NULL COMMENT 'content',
  `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COMMENT 'source user',
  `src_ip` varchar(50) DEFAULT NULL COMMENT 'source ip',
  `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
  `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
  `c_desc` varchar(256) DEFAULT NULL COMMENT 'configuration description',
  `c_use` varchar(64) DEFAULT NULL COMMENT 'configuration usage',
  `effect` varchar(64) DEFAULT NULL COMMENT '配置生效的描述',
  `type` varchar(64) DEFAULT NULL COMMENT '配置的类型',
  `c_schema` text COMMENT '配置的模式',
  `encrypted_data_key` varchar(1024) NOT NULL DEFAULT '' COMMENT '密钥',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfo_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info';

/******************************************/
/*   表名称 = config_info_aggr             */
/******************************************/
CREATE TABLE `config_info_aggr` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) NOT NULL COMMENT 'group_id',
  `datum_id` varchar(255) NOT NULL COMMENT 'datum_id',
  `content` longtext NOT NULL COMMENT '内容',
  `gmt_modified` datetime NOT NULL COMMENT '修改时间',
  `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
  `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfoaggr_datagrouptenantdatum` (`data_id`,`group_id`,`tenant_id`,`datum_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='增加租户字段';


/******************************************/
/*   表名称 = config_info_beta             */
/******************************************/
CREATE TABLE `config_info_beta` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) NOT NULL COMMENT 'group_id',
  `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
  `content` longtext NOT NULL COMMENT 'content',
  `beta_ips` varchar(1024) DEFAULT NULL COMMENT 'betaIps',
  `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COMMENT 'source user',
  `src_ip` varchar(50) DEFAULT NULL COMMENT 'source ip',
  `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
  `encrypted_data_key` varchar(1024) NOT NULL DEFAULT '' COMMENT '密钥',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfobeta_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_beta';

/******************************************/
/*   表名称 = config_info_tag              */
/******************************************/
CREATE TABLE `config_info_tag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `data_id` varchar(255) NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) DEFAULT '' COMMENT 'tenant_id',
  `tag_id` varchar(128) NOT NULL COMMENT 'tag_id',
  `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
  `content` longtext NOT NULL COMMENT 'content',
  `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COMMENT 'source user',
  `src_ip` varchar(50) DEFAULT NULL COMMENT 'source ip',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_configinfotag_datagrouptenanttag` (`data_id`,`group_id`,`tenant_id`,`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info_tag';

/******************************************/
/*   表名称 = config_tags_relation         */
/******************************************/
CREATE TABLE `config_tags_relation` (
  `id` bigint(20) NOT NULL COMMENT 'id',
  `tag_name` varchar(128) NOT NULL COMMENT 'tag_name',
  `tag_type` varchar(64) DEFAULT NULL COMMENT 'tag_type',
  `data_id` varchar(255) NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) NOT NULL COMMENT 'group_id',
  `tenant_id` varchar(128) DEFAULT '' COMMENT 'tenant_id',
  `nid` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'nid, 自增长标识',
  PRIMARY KEY (`nid`),
  UNIQUE KEY `uk_configtagrelation_configidtag` (`id`,`tag_name`,`tag_type`),
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_tag_relation';

/******************************************/
/*   表名称 = group_capacity               */
/******************************************/
CREATE TABLE `group_capacity` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
  `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数，，0表示使用默认值',
  `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='集群、各Group容量信息表';

/******************************************/
/*   表名称 = his_config_info              */
/******************************************/
CREATE TABLE `his_config_info` (
  `id` bigint(20) unsigned NOT NULL COMMENT 'id',
  `nid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'nid, 自增标识',
  `data_id` varchar(255) NOT NULL COMMENT 'data_id',
  `group_id` varchar(128) NOT NULL COMMENT 'group_id',
  `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
  `content` longtext NOT NULL COMMENT 'content',
  `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  `src_user` text COMMENT 'source user',
  `src_ip` varchar(50) DEFAULT NULL COMMENT 'source ip',
  `op_type` char(10) DEFAULT NULL COMMENT 'operation type',
  `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
   `encrypted_data_key` varchar(1024) NOT NULL DEFAULT '' COMMENT '密钥',
  PRIMARY KEY (`nid`),
  KEY `idx_gmt_create` (`gmt_create`),
  KEY `idx_gmt_modified` (`gmt_modified`),
  KEY `idx_did` (`data_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='多租户改造';


/******************************************/
/*   表名称 = tenant_capacity              */
/******************************************/
CREATE TABLE `tenant_capacity` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `tenant_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Tenant ID',
  `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
  `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
  `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数',
  `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
  `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='租户容量信息表';


CREATE TABLE `tenant_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `kp` varchar(128) NOT NULL COMMENT 'kp',
  `tenant_id` varchar(128) default '' COMMENT 'tenant_id',
  `tenant_name` varchar(128) default '' COMMENT 'tenant_name',
  `tenant_desc` varchar(256) DEFAULT NULL COMMENT 'tenant_desc',
  `create_source` varchar(32) DEFAULT NULL COMMENT 'create_source',
  `gmt_create` bigint(20) NOT NULL COMMENT '创建时间',
  `gmt_modified` bigint(20) NOT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tenant_info_kptenantid` (`kp`,`tenant_id`),
  KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='tenant_info';

CREATE TABLE `users` (
	`username` varchar(50) NOT NULL PRIMARY KEY COMMENT 'username',
	`password` varchar(500) NOT NULL COMMENT 'password',
	`enabled` boolean NOT NULL COMMENT 'enabled'
);

CREATE TABLE `roles` (
	`username` varchar(50) NOT NULL COMMENT 'username',
	`role` varchar(50) NOT NULL COMMENT 'role',
	UNIQUE INDEX `idx_user_role` (`username` ASC, `role` ASC) USING BTREE
);

CREATE TABLE `permissions` (
    `role` varchar(50) NOT NULL COMMENT 'role',
    `resource` varchar(128) NOT NULL COMMENT 'resource',
    `action` varchar(8) NOT NULL COMMENT 'action',
    UNIQUE INDEX `uk_role_permission` (`role`,`resource`,`action`) USING BTREE
);

INSERT INTO `config_info` (`id`, `data_id`, `group_id`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `app_name`, `tenant_id`, `c_desc`, `c_use`, `effect`, `type`, `c_schema`, `encrypted_data_key`) VALUES (1, 'seata-server.properties', 'DEFAULT_GROUP', 'store.mode=db\n#-----db-----\nstore.db.datasource=druid\nstore.db.dbType=mysql\n# 需要根据mysql的版本调整driverClassName\n# mysql8及以上版本对应的driver：com.mysql.cj.jdbc.Driver\n# mysql8以下版本的driver：com.mysql.jdbc.Driver\nstore.db.driverClassName=com.mysql.cj.jdbc.Driver\nstore.db.url=jdbc:mysql://host.docker.internal:3306/seata-server?useUnicode=true&characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useSSL=false\nstore.db.user=root\nstore.db.password=123456\n# 数据库初始连接数\nstore.db.minConn=1\n# 数据库最大连接数\nstore.db.maxConn=20\n# 获取连接时最大等待时间 默认5000，单位毫秒\nstore.db.maxWait=5000\n# 全局事务表名 默认global_table\nstore.db.globalTable=global_table\n# 分支事务表名 默认branch_table\nstore.db.branchTable=branch_table\n# 全局锁表名 默认lock_table\nstore.db.lockTable=lock_table\n# 查询全局事务一次的最大条数 默认100\nstore.db.queryLimit=100\n\n\n# undo保留天数 默认7天,log_status=1（附录3）和未正常清理的undo\nserver.undo.logSaveDays=7\n# undo清理线程间隔时间 默认86400000，单位毫秒\nserver.undo.logDeletePeriod=86400000\n# 二阶段提交重试超时时长 单位ms,s,m,h,d,对应毫秒,秒,分,小时,天,默认毫秒。默认值-1表示无限重试\n# 公式: timeout>=now-globalTransactionBeginTime,true表示超时则不再重试\n# 注: 达到超时时间后将不会做任何重试,有数据不一致风险,除非业务自行可校准数据,否者慎用\nserver.maxCommitRetryTimeout=-1\n# 二阶段回滚重试超时时长\nserver.maxRollbackRetryTimeout=-1\n# 二阶段提交未完成状态全局事务重试提交线程间隔时间 默认1000，单位毫秒\nserver.recovery.committingRetryPeriod=1000\n# 二阶段异步提交状态重试提交线程间隔时间 默认1000，单位毫秒\nserver.recovery.asynCommittingRetryPeriod=1000\n# 二阶段回滚状态重试回滚线程间隔时间  默认1000，单位毫秒\nserver.recovery.rollbackingRetryPeriod=1000\n# 超时状态检测重试线程间隔时间 默认1000，单位毫秒，检测出超时将全局事务置入回滚会话管理器\nserver.recovery.timeoutRetryPeriod=1000', '6c06cfe093bd42e81e1276037b1f77a0', '2024-10-28 14:47:15', '2024-10-28 14:47:15', NULL, '192.168.65.1', '', '', NULL, NULL, NULL, 'properties', NULL, '');
INSERT INTO `his_config_info` (`id`, `nid`, `data_id`, `group_id`, `app_name`, `content`, `md5`, `gmt_create`, `gmt_modified`, `src_user`, `src_ip`, `op_type`, `tenant_id`, `encrypted_data_key`) VALUES (0, 1, 'seata-server.properties', 'DEFAULT_GROUP', '', 'store.mode=db\n#-----db-----\nstore.db.datasource=druid\nstore.db.dbType=mysql\n# 需要根据mysql的版本调整driverClassName\n# mysql8及以上版本对应的driver：com.mysql.cj.jdbc.Driver\n# mysql8以下版本的driver：com.mysql.jdbc.Driver\nstore.db.driverClassName=com.mysql.cj.jdbc.Driver\nstore.db.url=jdbc:mysql://host.docker.internal:3306/seata-server?useUnicode=true&characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useSSL=false\nstore.db.user=root\nstore.db.password=123456\n# 数据库初始连接数\nstore.db.minConn=1\n# 数据库最大连接数\nstore.db.maxConn=20\n# 获取连接时最大等待时间 默认5000，单位毫秒\nstore.db.maxWait=5000\n# 全局事务表名 默认global_table\nstore.db.globalTable=global_table\n# 分支事务表名 默认branch_table\nstore.db.branchTable=branch_table\n# 全局锁表名 默认lock_table\nstore.db.lockTable=lock_table\n# 查询全局事务一次的最大条数 默认100\nstore.db.queryLimit=100\n\n\n# undo保留天数 默认7天,log_status=1（附录3）和未正常清理的undo\nserver.undo.logSaveDays=7\n# undo清理线程间隔时间 默认86400000，单位毫秒\nserver.undo.logDeletePeriod=86400000\n# 二阶段提交重试超时时长 单位ms,s,m,h,d,对应毫秒,秒,分,小时,天,默认毫秒。默认值-1表示无限重试\n# 公式: timeout>=now-globalTransactionBeginTime,true表示超时则不再重试\n# 注: 达到超时时间后将不会做任何重试,有数据不一致风险,除非业务自行可校准数据,否者慎用\nserver.maxCommitRetryTimeout=-1\n# 二阶段回滚重试超时时长\nserver.maxRollbackRetryTimeout=-1\n# 二阶段提交未完成状态全局事务重试提交线程间隔时间 默认1000，单位毫秒\nserver.recovery.committingRetryPeriod=1000\n# 二阶段异步提交状态重试提交线程间隔时间 默认1000，单位毫秒\nserver.recovery.asynCommittingRetryPeriod=1000\n# 二阶段回滚状态重试回滚线程间隔时间  默认1000，单位毫秒\nserver.recovery.rollbackingRetryPeriod=1000\n# 超时状态检测重试线程间隔时间 默认1000，单位毫秒，检测出超时将全局事务置入回滚会话管理器\nserver.recovery.timeoutRetryPeriod=1000', '6c06cfe093bd42e81e1276037b1f77a0', '2024-10-28 14:47:15', '2024-10-28 14:47:15', NULL, '192.168.65.1', 'I', '', '');
