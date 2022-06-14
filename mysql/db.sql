

DROP TABLE IF EXISTS `config_info`;

CREATE TABLE `config_info` (
  `id` bigint(20) NOT NULL COMMENT 'id',
  `config_name` varchar(100) NOT NULL COMMENT 'configur_name',
  `config_value` text NOT NULL COMMENT 'configur_val d:/data/www/zhihe',
  `remark` varchar(255) DEFAULT NULL COMMENT 'remark',
  `host` varchar(255) DEFAULT NULL COMMENT 'host',
  `port` varchar(255) DEFAULT NULL COMMENT 'port',
  `username` varchar(255) DEFAULT NULL COMMENT 'username',
  `password` varchar(255) DEFAULT NULL COMMENT 'password',
  `school_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='配置表';

/*Data for the table `config_info` */

insert  into `config_info`(`id`,`config_name`,`config_value`,`remark`,`host`,`port`,`username`,`password`,`school_id`) values 
(1,'base_path','D:/zhihe/data','FTP服务器地址','','0','','',NULL),
(2,'lan_base_path','http://175.15.209.1','FTP服务器地址(服务端)','','0','','',NULL),
(3,'ffmpeg_path','D:/zhihe/ffmpeg/bin/ffmpeg','本地ffmpeg路径','','0','','',NULL),
(4,'city','北京市','天气城市',NULL,NULL,NULL,NULL,NULL),
(5,'wechatSync','http://jiaxiao.zhiheiot.cn/app/student/sync','微信（学生同步）',NULL,NULL,NULL,NULL,NULL),
(6,'wechatView','http://jiaxiao.zhiheiot.cn/app/message/view','微信（聊天记录）',NULL,NULL,NULL,NULL,NULL),
(7,'wechatSend','http://jiaxiao.zhiheiot.cn/app/message/teacher_send','微信（老师发送）',NULL,NULL,NULL,NULL,NULL),
(8,'studentView','http://jiaxiao.zhiheiot.cn/app/message/student_view','微信（学生接口）',NULL,NULL,NULL,NULL,NULL),
(10,'homeInfo','{\"title\":\"首页\",\"icon\":\"fa fa-home\",\"href\":\"/page/welcome.html\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(11,'logoInfo','{\"title\":\"<!--智合科技有限公司-->\",\"image\":\"/images/login_logo.png\",\"href\":\"javascript:;\"}',NULL,NULL,NULL,NULL,NULL,NULL),
(12,'weather','{\"data\":{\"yesterday\":{\"date\":\"8日星期六\",\"high\":\"高温 31℃\",\"fx\":\"南风\",\"low\":\"低温 23℃\",\"fl\":\"<![CDATA[2级]]>\",\"type\":\"多云\"},\"city\":\"北京\",\"forecast\":[{\"date\":\"9日星期天\",\"high\":\"高温 33℃\",\"fengli\":\"<![CDATA[2级]]>\",\"low\":\"低温 22℃\",\"fengxiang\":\"南风\",\"type\":\"多云\"},{\"date\":\"10日星期一\",\"high\":\"高温 29℃\",\"fengli\":\"<![CDATA[2级]]>\",\"low\":\"低温 21℃\",\"fengxiang\":\"西北风\",\"type\":\"中雨\"},{\"date\":\"11日星期二\",\"high\":\"高温 32℃\",\"fengli\":\"<![CDATA[2级]]>\",\"low\":\"低温 24℃\",\"fengxiang\":\"南风\",\"type\":\"多云\"},{\"date\":\"12日星期三\",\"high\":\"高温 28℃\",\"fengli\":\"<![CDATA[2级]]>\",\"low\":\"低温 24℃\",\"fengxiang\":\"东南风\",\"type\":\"中雨\"},{\"date\":\"13日星期四\",\"high\":\"高温 33℃\",\"fengli\":\"<![CDATA[2级]]>\",\"low\":\"低温 23℃\",\"fengxiang\":\"西风\",\"type\":\"晴\"}],\"ganmao\":\"感冒易发期，外出请适当调整衣物，注意补充水分。\",\"wendu\":\"29\"},\"status\":1000,\"desc\":\"OK\"}',NULL,NULL,'0',NULL,NULL,NULL),
(13,'face_check','0','是否开启人脸考勤(1是0否)',NULL,NULL,NULL,NULL,NULL),
(14,'ffmpegLocalPath','rtmp://127.0.0.1:1935/live/',NULL,NULL,NULL,NULL,NULL,NULL),
(15,'ffmpegStreamPath','2020',NULL,NULL,NULL,NULL,NULL,NULL),
(16,'nginx_path','D:\\nginx-1.16.0',NULL,NULL,NULL,NULL,NULL,NULL),
(17,'book_config','{\"start_time\":\"22:00:00\",\"gap\":60,\"end_time\":\"23:00:00\"}','预约配置',NULL,'0',NULL,NULL,NULL),
(18,'cron','0 */10 * * * ? ','探测设备轮训任务时长',NULL,NULL,NULL,NULL,NULL),
(19,'internet_ws_url','ws://app.zhiheiot.cn/websocket','面板远程解锁外网地址',NULL,NULL,NULL,NULL,NULL),
(24,'htmlTemplate','<!DOCTYPE html>\r\n<html>\r\n<head>\r\n    <meta charset=\"utf-8\">\r\n    <title>###title###</title>\r\n    <meta name=\"renderer\" content=\"webkit\">\r\n    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1\">\r\n	<style>\r\n		table {\r\n		  border-top: 1px solid #ccc;\r\n		  border-left: 1px solid #ccc;\r\n		}\r\n		table td,\r\n		table th {\r\n		  border-bottom: 1px solid #ccc;\r\n		  border-right: 1px solid #ccc;\r\n		  padding: 3px 5px;\r\n		}\r\n		table th {\r\n		  border-bottom: 2px solid #ccc;\r\n		  text-align: center;\r\n		}\r\n\r\n		/* blockquote 样式 */\r\n		blockquote {\r\n		  display: block;\r\n		  border-left: 8px solid #d0e5f2;\r\n		  padding: 5px 10px;\r\n		  margin: 10px 0;\r\n		  line-height: 1.4;\r\n		  font-size: 100%;\r\n		  background-color: #f1f1f1;\r\n		}\r\n\r\n		/* code 样式 */\r\n		code {\r\n		  display: inline-block;\r\n		  *display: inline;\r\n		  *zoom: 1;\r\n		  background-color: #f1f1f1;\r\n		  border-radius: 3px;\r\n		  padding: 3px 5px;\r\n		  margin: 0 3px;\r\n		}\r\n		pre code {\r\n		  display: block;\r\n		}\r\n\r\n		/* ul ol 样式 */\r\n		ul, ol {\r\n		  margin: 10px 0 10px 20px;\r\n		}\r\n	</style>\r\n</head>\r\n<body>\r\n###value###\r\n</body>\r\n</html>',NULL,NULL,NULL,NULL,NULL,-1),
(25,'projector_use_time','[{\"code\":\"7E14620700BEEF0306002AFD02009E1000002AB5\",\"command_datatype\":\"\",\"command_suffix\":0,\"delay_time\":0,\"ip\":\"\",\"port\":9600,\"protocol\":\"232Command\",\"return_code\":\"\"},{\"code\":\"7E14620700BEEF030600C2FF02009010000086EF\",\"command_datatype\":\"\",\"command_suffix\":0,\"delay_time\":0,\"ip\":\"\",\"port\":9600,\"protocol\":\"232Command\",\"return_code\":\"\"}]','获取投影机使用时长发送码',NULL,NULL,NULL,NULL,NULL),
(26,'cron_send_code','0 */1 * * * ? ','发送指令间隔',NULL,NULL,NULL,NULL,NULL),
(27,'ip_server','192.168.56.102','ip对接服务端',NULL,NULL,NULL,NULL,NULL),
(28,'ip_no_control_room','110002','总控室web端对讲号码',NULL,NULL,NULL,NULL,NULL),
(29,'nginx_http_flv','{\"ip\":\"192.168.1.15\",\"rtmpPort\":\"1935\",\"httpPort\":\"80\"}','http-flv-module地址',NULL,NULL,NULL,NULL,NULL);
