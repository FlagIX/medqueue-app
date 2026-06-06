/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 50622
 Source Host           : localhost:3306
 Source Schema         : medqueue

 Target Server Type    : MySQL
 Target Server Version : 50622
 File Encoding         : 65001

 Date: 06/06/2026 10:00:00
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tb_department
-- ----------------------------
DROP TABLE IF EXISTS `tb_department`;
CREATE TABLE `tb_department`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '科室名称',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标',
  `sort` int(3) UNSIGNED NULL DEFAULT NULL COMMENT '排序',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sort`(`sort`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_department
-- ----------------------------
INSERT INTO `tb_department` VALUES (1, '内科', '/dept/neike.png', 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_department` VALUES (2, '外科', '/dept/waike.png', 2, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_department` VALUES (3, '儿科', '/dept/erke.png', 3, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_department` VALUES (4, '妇产科', '/dept/fuchanke.png', 4, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_department` VALUES (5, '眼科', '/dept/yanke.png', 5, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_department` VALUES (6, '耳鼻喉科', '/dept/erbihou.png', 6, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_department` VALUES (7, '口腔科', '/dept/kouqiang.png', 7, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_department` VALUES (8, '皮肤科', '/dept/pifu.png', 8, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_department` VALUES (9, '骨科', '/dept/guke.png', 9, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_department` VALUES (10, '神经内科', '/dept/shenjing.png', 10, '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- ----------------------------
-- Table structure for tb_user
-- ----------------------------
DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号码',
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '密码，加密存储',
  `nick_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '昵称，默认是用户id',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '人物头像',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uniqe_key_phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_user
-- ----------------------------
INSERT INTO `tb_user` VALUES (1, '13686869696', '', '小鱼同学', '/imgs/blogs/blog1.jpg', '2026-06-01 10:00:00', '2026-06-01 10:00:00');
INSERT INTO `tb_user` VALUES (2, '13838411438', '', '可可今天不吃肉', '/imgs/icons/kkjtbcr.jpg', '2026-06-01 10:00:00', '2026-06-01 10:00:00');
INSERT INTO `tb_user` VALUES (3, '13912345678', '', '健康小助手', '', '2026-06-01 10:00:00', '2026-06-01 10:00:00');

-- ----------------------------
-- Table structure for tb_user_info
-- ----------------------------
DROP TABLE IF EXISTS `tb_user_info`;
CREATE TABLE `tb_user_info`  (
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '主键，用户id',
  `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '城市名称',
  `introduce` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '个人介绍，不要超过128个字符',
  `fans` int(8) UNSIGNED NULL DEFAULT 0 COMMENT '粉丝数量',
  `followee` int(8) UNSIGNED NULL DEFAULT 0 COMMENT '关注的人的数量',
  `gender` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '性别，0：男，1：女',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `credits` int(8) UNSIGNED NULL DEFAULT 0 COMMENT '积分',
  `level` tinyint(1) UNSIGNED NULL DEFAULT 0 COMMENT '会员级别，0~9级,0代表未开通会员',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_user_info
-- ----------------------------

-- ----------------------------
-- Table structure for tb_hospital
-- ----------------------------
DROP TABLE IF EXISTS `tb_hospital`;
CREATE TABLE `tb_hospital`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '医院名称',
  `department_id` bigint(20) UNSIGNED NOT NULL COMMENT '科室分类ID',
  `images` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '医院图片，多个图片以\',\'隔开',
  `area` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '区域',
  `address` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '详细地址',
  `x` double UNSIGNED NOT NULL COMMENT '经度',
  `y` double UNSIGNED NOT NULL COMMENT '纬度',
  `level` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '医院等级（三甲/三乙/二甲/社区医院等）',
  `phone` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `open_hours` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '就诊时间',
  `score` int(2) UNSIGNED ZEROFILL NOT NULL COMMENT '评分，1~50，乘10保存避免小数',
  `review_count` int(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT '评价数',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_department_id`(`department_id`) USING BTREE,
  INDEX `idx_name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_hospital
-- ----------------------------
INSERT INTO `tb_hospital` VALUES (1, '上海市第一人民医院', 1, 'https://qcloud.dpfile.com/pc/jiclIsCKmOI2arxKN1Uf0Hx3PucIJH8q0QSz-Z8llzcN56-_QiKuOvyio1OOxsRtFoXqu0G3iT2T27qat3WhLVEuLYk00OmSS1IdNpm8K8sG4JN9RIm2mTKcbLtc2o2vfCF2ubeXzk49OsGrXt_KYDCngOyCwZK-s3fqawWswzk.jpg', '虹口区', '上海市虹口区武进路85号', 121.4854, 31.2615, '三甲', '021-63240090', '08:00-17:00', 45, 120, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (2, '复旦大学附属华山医院', 2, 'https://qcloud.dpfile.com/pc/IOf6VX3qaBgFXFVgp75w-KKJmWZjFc8GXDU8g9bQC6YGCpAmG00QbfT4vCCBj7njuzFvxlbkWx5uwqY2qcjixFEuLYk00OmSS1IdNpm8K8sG4JN9RIm2mTKcbLtc2o2vmIU_8ZGOT1OjpJmLxG6urQ.jpg', '静安区', '上海市静安区乌鲁木齐中路12号', 121.4489, 31.2208, '三甲', '021-52889999', '08:00-17:00', 48, 200, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (3, '上海市浦东新区人民医院', 1, 'https://p0.meituan.net/bbia/c1870d570e73accbc9fee90b48faca41195272.jpg', '浦东新区', '上海市浦东新区川沙镇川环南路490号', 121.6960, 31.1876, '二甲', '021-58981990', '08:00-17:00', 40, 80, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (4, '上海市徐汇区中心医院', 1, 'https://img.meituan.net/msmerchant/232f8fdf09050838bd33fb24e79f30f9606056.jpg', '徐汇区', '上海市徐汇区淮海中路1174号', 121.4497, 31.2094, '二甲', '021-54037810', '08:00-17:00', 38, 60, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (5, '浦东新区潍坊社区卫生服务中心', 1, 'https://img.meituan.net/msmerchant/e71a2d0d693b3033c15522c43e03f09198239.jpg', '浦东新区', '上海市浦东新区崂山路639号', 121.5236, 31.2325, '社区医院', '021-58201150', '08:00-20:00', 35, 30, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (6, '静安区石门二路社区卫生服务中心', 1, 'https://img.meituan.net/msmerchant/909434939a49b36f340523232924402166854.jpg', '静安区', '上海市静安区石门二路483号', 121.4548, 31.2372, '社区医院', '021-62563921', '08:00-20:00', 32, 15, '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- ----------------------------
-- Table structure for tb_appointment_item
-- ----------------------------
DROP TABLE IF EXISTS `tb_appointment_item`;
CREATE TABLE `tb_appointment_item`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `hospital_id` bigint(20) UNSIGNED NOT NULL COMMENT '医院ID',
  `title` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题（普通号/专家号/特需号）',
  `fee` bigint(10) UNSIGNED NOT NULL COMMENT '费用，单位：分',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '类型（1普通/2专家/3特需）',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态（1启用/0停用）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hospital_id`(`hospital_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_appointment_item
-- ----------------------------
-- 上海市第一人民医院（三甲）
INSERT INTO `tb_appointment_item` VALUES (1, 1, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (2, 1, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (3, 1, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 华山医院（三甲）
INSERT INTO `tb_appointment_item` VALUES (4, 2, '普通号', 3000, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (5, 2, '专家号', 6000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (6, 2, '特需号', 30000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 浦东新区人民医院（二甲）
INSERT INTO `tb_appointment_item` VALUES (7, 3, '普通号', 1500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (8, 3, '专家号', 3000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (9, 3, '特需号', 10000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 徐汇区中心医院（二甲）
INSERT INTO `tb_appointment_item` VALUES (10, 4, '普通号', 1500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (11, 4, '专家号', 3000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (12, 4, '特需号', 10000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 潍坊社区卫生服务中心
INSERT INTO `tb_appointment_item` VALUES (13, 5, '普通号', 500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (14, 5, '专家号', 1000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (15, 5, '特需号', 5000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 石门二路社区卫生服务中心
INSERT INTO `tb_appointment_item` VALUES (16, 6, '普通号', 500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (17, 6, '专家号', 1000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (18, 6, '特需号', 5000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- ----------------------------
-- Table structure for tb_doctor
-- ----------------------------
DROP TABLE IF EXISTS `tb_doctor`;
CREATE TABLE `tb_doctor`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `hospital_id` bigint(20) UNSIGNED NOT NULL COMMENT '所属医院ID',
  `department_id` bigint(20) UNSIGNED NOT NULL COMMENT '所属科室ID',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '医生姓名',
  `title` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '职称',
  `avatar` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '头像URL',
  `introduction` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '医生简介',
  `score` int(2) UNSIGNED ZEROFILL NOT NULL DEFAULT 0 COMMENT '评分',
  `appointment_count` int(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT '累计挂号数',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hospital_id`(`hospital_id`) USING BTREE,
  INDEX `idx_department_id`(`department_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_doctor
-- ----------------------------
-- 上海市第一人民医院
INSERT INTO `tb_doctor` VALUES (1, 1, 1, '张明', '主任医师', '/imgs/avatar/male1.jpg', '从事内科临床工作30余年，擅长心脑血管疾病、糖尿病等慢性病的诊治。', 46, 1200, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (2, 1, 2, '李强', '副主任医师', '/imgs/avatar/male2.jpg', '普外科专家，擅长腹腔镜微创手术，甲状腺、乳腺疾病的外科治疗。', 44, 800, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (3, 1, 5, '王芳', '主任医师', '/imgs/avatar/female1.jpg', '眼科主任，擅长白内障超声乳化手术、青光眼诊治。', 47, 1500, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 华山医院
INSERT INTO `tb_doctor` VALUES (4, 2, 1, '赵建国', '主任医师', '/imgs/avatar/male3.jpg', '心血管内科专家，擅长冠心病介入治疗、高血压病综合管理。', 49, 2000, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (5, 2, 8, '陈丽', '副主任医师', '/imgs/avatar/female2.jpg', '皮肤科专家，擅长湿疹、荨麻疹、痤疮等常见皮肤病的诊疗。', 45, 600, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (6, 2, 10, '刘伟', '副主任医师', '/imgs/avatar/male4.jpg', '神经内科专家，擅长脑血管疾病、头痛、头晕、帕金森病的诊治。', 46, 900, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 浦东新区人民医院
INSERT INTO `tb_doctor` VALUES (7, 3, 1, '孙婷', '主治医师', '/imgs/avatar/female3.jpg', '内科常见病、多发病的诊治，尤其擅长慢性阻塞性肺疾病的管理。', 40, 500, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (8, 3, 9, '周华', '副主任医师', '/imgs/avatar/male5.jpg', '骨科专家，擅长骨折创伤、关节置换及腰腿痛的诊治。', 42, 700, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (9, 3, 4, '吴静', '主治医师', '/imgs/avatar/female4.jpg', '妇产科常见疾病诊治，孕期保健及产后康复指导。', 38, 400, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 徐汇区中心医院
INSERT INTO `tb_doctor` VALUES (10, 4, 1, '郑伟', '副主任医师', '/imgs/avatar/male6.jpg', '消化内科专家，擅长胃镜、肠镜检查及胃肠道疾病的诊治。', 41, 650, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (11, 4, 7, '黄莉', '主治医师', '/imgs/avatar/female5.jpg', '口腔科常见病诊治，牙体牙髓治疗、牙齿修复。', 37, 350, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 潍坊社区卫生服务中心
INSERT INTO `tb_doctor` VALUES (12, 5, 1, '徐伟', '主治医师', '/imgs/avatar/male7.jpg', '社区常见病、多发病诊治，慢性病管理及健康咨询。', 36, 300, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (13, 5, 3, '林小红', '住院医师', '/imgs/avatar/female6.jpg', '儿童常见病诊治，计划免疫及儿童保健。', 34, 200, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 石门二路社区卫生服务中心
INSERT INTO `tb_doctor` VALUES (14, 6, 1, '何鑫', '主治医师', '/imgs/avatar/male8.jpg', '社区常见病诊疗，高血压、糖尿病等慢性病系统管理。', 33, 250, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (15, 6, 6, '杨雪', '住院医师', '/imgs/avatar/female7.jpg', '耳鼻喉科常见病诊治，过敏性鼻炎、慢性咽炎的综合治疗。', 31, 150, '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- ----------------------------
-- Table structure for tb_doctor_schedule
-- ----------------------------
DROP TABLE IF EXISTS `tb_doctor_schedule`;
CREATE TABLE `tb_doctor_schedule`  (
  `schedule_id` bigint(20) UNSIGNED NOT NULL COMMENT '排班ID',
  `doctor_id` bigint(20) UNSIGNED NOT NULL COMMENT '医生ID',
  `date` date NOT NULL COMMENT '出诊日期',
  `time_slot` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '时段（上午/下午/晚班）',
  `total_count` int(8) UNSIGNED NOT NULL COMMENT '总号源数',
  `remain_count` int(8) UNSIGNED NOT NULL COMMENT '剩余号源数',
  `fee_id` bigint(20) UNSIGNED NOT NULL COMMENT '费用标准ID',
  `begin_time` datetime NOT NULL COMMENT '预约开始时间',
  `end_time` datetime NOT NULL COMMENT '预约结束时间',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`schedule_id`) USING BTREE,
  INDEX `idx_doctor_date`(`doctor_id`, `date`) USING BTREE,
  INDEX `idx_fee_id`(`fee_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_doctor_schedule
-- 为每位医生生成未来7天的排班，每个时段30个号源
-- 每位医生固定使用该医院对应职称的费用标准ID
-- ----------------------------
-- Doctor 1（张明，上海市第一人民医院·内科·主任医师 → 专家号fee_id=2）
INSERT INTO `tb_doctor_schedule` VALUES (100001, 1, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100002, 1, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100003, 1, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100004, 1, CURDATE() + INTERVAL 2 DAY, '下午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100005, 1, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100006, 1, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100007, 1, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100008, 1, CURDATE() + INTERVAL 4 DAY, '下午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100009, 1, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100010, 1, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100011, 1, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100012, 1, CURDATE() + INTERVAL 6 DAY, '下午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100013, 1, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100014, 1, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 2（李强，外科·副主任医师 → 专家号fee_id=2）
INSERT INTO `tb_doctor_schedule` VALUES (100101, 2, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100102, 2, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100103, 2, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100104, 2, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100105, 2, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100106, 2, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100107, 2, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100108, 2, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 2, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 3（王芳，眼科·主任医师 → 专家号fee_id=2）
INSERT INTO `tb_doctor_schedule` VALUES (100201, 3, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 2, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100202, 3, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 2, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100203, 3, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 2, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100204, 3, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 2, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100205, 3, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 2, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100206, 3, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 2, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100207, 3, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 2, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 4（赵建国，华山·内科·主任医师 → 专家号fee_id=5）
INSERT INTO `tb_doctor_schedule` VALUES (100301, 4, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100302, 4, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100303, 4, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100304, 4, CURDATE() + INTERVAL 2 DAY, '下午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100305, 4, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100306, 4, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100307, 4, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100308, 4, CURDATE() + INTERVAL 4 DAY, '下午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100309, 4, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100310, 4, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100311, 4, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100312, 4, CURDATE() + INTERVAL 6 DAY, '下午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100313, 4, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100314, 4, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 5, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 5（陈丽，华山·皮肤科·副主任医师 → 专家号fee_id=5）
INSERT INTO `tb_doctor_schedule` VALUES (100401, 5, CURDATE() + INTERVAL 2 DAY, '上午', 20, 20, 5, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100402, 5, CURDATE() + INTERVAL 2 DAY, '下午', 20, 20, 5, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100403, 5, CURDATE() + INTERVAL 4 DAY, '上午', 20, 20, 5, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100404, 5, CURDATE() + INTERVAL 4 DAY, '下午', 20, 20, 5, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100405, 5, CURDATE() + INTERVAL 6 DAY, '上午', 20, 20, 5, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100406, 5, CURDATE() + INTERVAL 6 DAY, '下午', 20, 20, 5, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 6（刘伟，华山·神经内科·副主任医师 → 专家号fee_id=5）
INSERT INTO `tb_doctor_schedule` VALUES (100501, 6, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 5, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100502, 6, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 5, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100503, 6, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 5, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100504, 6, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 5, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 7（孙婷，浦东新区人民医院·内科·主治医师 → 普通号fee_id=7）
INSERT INTO `tb_doctor_schedule` VALUES (100601, 7, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 7, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100602, 7, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 7, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100603, 7, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 7, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100604, 7, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 7, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100605, 7, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 7, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100606, 7, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 7, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100607, 7, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 7, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100608, 7, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 7, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 8（周华，浦东·骨科·副主任医师 → 专家号fee_id=8）
INSERT INTO `tb_doctor_schedule` VALUES (100701, 8, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 8, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100702, 8, CURDATE() + INTERVAL 2 DAY, '下午', 25, 25, 8, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100703, 8, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 8, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100704, 8, CURDATE() + INTERVAL 4 DAY, '下午', 25, 25, 8, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100705, 8, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 8, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100706, 8, CURDATE() + INTERVAL 6 DAY, '下午', 25, 25, 8, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 9（吴静，浦东·妇产科·主治医师 → 普通号fee_id=7）
INSERT INTO `tb_doctor_schedule` VALUES (100801, 9, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 7, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100802, 9, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 7, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100803, 9, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 7, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100804, 9, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 7, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 10（郑伟，徐汇区中心医院·内科·副主任医师 → 专家号fee_id=11）
INSERT INTO `tb_doctor_schedule` VALUES (100901, 10, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 11, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100902, 10, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 11, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100903, 10, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 11, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100904, 10, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 11, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100905, 10, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 11, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100906, 10, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 11, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100907, 10, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 11, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (100908, 10, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 11, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 11（黄莉，徐汇·口腔科·主治医师 → 普通号fee_id=10）
INSERT INTO `tb_doctor_schedule` VALUES (101001, 11, CURDATE() + INTERVAL 2 DAY, '上午', 20, 20, 10, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101002, 11, CURDATE() + INTERVAL 4 DAY, '上午', 20, 20, 10, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101003, 11, CURDATE() + INTERVAL 6 DAY, '上午', 20, 20, 10, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 12（徐伟，潍坊社区·内科·主治医师 → 普通号fee_id=13）
INSERT INTO `tb_doctor_schedule` VALUES (101101, 12, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101102, 12, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101103, 12, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101104, 12, CURDATE() + INTERVAL 2 DAY, '下午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101105, 12, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101106, 12, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101107, 12, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101108, 12, CURDATE() + INTERVAL 4 DAY, '下午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101109, 12, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101110, 12, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101111, 12, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101112, 12, CURDATE() + INTERVAL 6 DAY, '下午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101113, 12, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101114, 12, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 13, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 13（林小红，潍坊社区·儿科·住院医师 → 普通号fee_id=13）
INSERT INTO `tb_doctor_schedule` VALUES (101201, 13, CURDATE() + INTERVAL 1 DAY, '上午', 20, 20, 13, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101202, 13, CURDATE() + INTERVAL 3 DAY, '上午', 20, 20, 13, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101203, 13, CURDATE() + INTERVAL 5 DAY, '上午', 20, 20, 13, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101204, 13, CURDATE() + INTERVAL 7 DAY, '上午', 20, 20, 13, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 14（何鑫，石门二路社区·内科·主治医师 → 普通号fee_id=16）
INSERT INTO `tb_doctor_schedule` VALUES (101301, 14, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101302, 14, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101303, 14, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101304, 14, CURDATE() + INTERVAL 2 DAY, '下午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101305, 14, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101306, 14, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101307, 14, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101308, 14, CURDATE() + INTERVAL 4 DAY, '下午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101309, 14, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101310, 14, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101311, 14, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101312, 14, CURDATE() + INTERVAL 6 DAY, '下午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101313, 14, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101314, 14, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 16, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- Doctor 15（杨雪，石门二路·耳鼻喉科·住院医师 → 普通号fee_id=16）
INSERT INTO `tb_doctor_schedule` VALUES (101401, 15, CURDATE() + INTERVAL 2 DAY, '上午', 20, 20, 16, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101402, 15, CURDATE() + INTERVAL 4 DAY, '上午', 20, 20, 16, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101403, 15, CURDATE() + INTERVAL 6 DAY, '上午', 20, 20, 16, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- ----------------------------
-- Table structure for tb_patient_profile
-- ----------------------------
DROP TABLE IF EXISTS `tb_patient_profile`;
CREATE TABLE `tb_patient_profile`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '就诊人姓名',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '身份证号',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '手机号',
  `relation` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关系（本人/配偶/父母/子女/其他）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  UNIQUE INDEX `uniq_id_card`(`id_card`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_patient_profile
-- ----------------------------
INSERT INTO `tb_patient_profile` VALUES (1, 1, '小鱼同学', '310101199001011234', '13686869696', '本人', '2026-06-01 10:00:00', '2026-06-01 10:00:00');
INSERT INTO `tb_patient_profile` VALUES (2, 1, '张建国', '310101196505052345', '13686869696', '父母', '2026-06-01 10:00:00', '2026-06-01 10:00:00');
INSERT INTO `tb_patient_profile` VALUES (3, 2, '可可', '310101199503153456', '13838411438', '本人', '2026-06-01 10:00:00', '2026-06-01 10:00:00');
INSERT INTO `tb_patient_profile` VALUES (4, 3, '健康小助手', '310101199812014567', '13912345678', '本人', '2026-06-01 10:00:00', '2026-06-01 10:00:00');

-- ----------------------------
-- Table structure for tb_appointment_record
-- ----------------------------
DROP TABLE IF EXISTS `tb_appointment_record`;
CREATE TABLE `tb_appointment_record`  (
  `id` bigint(20) NOT NULL COMMENT '订单号（Redis ID生成器）',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `patient_id` bigint(20) UNSIGNED NOT NULL COMMENT '就诊人ID',
  `doctor_id` bigint(20) UNSIGNED NOT NULL COMMENT '医生ID',
  `schedule_id` bigint(20) UNSIGNED NOT NULL COMMENT '排班ID',
  `hospital_id` bigint(20) UNSIGNED NOT NULL COMMENT '医院ID',
  `fee_id` bigint(20) UNSIGNED NOT NULL COMMENT '费用标准ID',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态（1待就诊/2已就诊/3已取消/4已过期）',
  `appoint_date` date NOT NULL COMMENT '预约日期',
  `time_slot` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '预约时段',
  `pay_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '支付方式（1余额/2支付宝/3微信）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_patient_id`(`patient_id`) USING BTREE,
  INDEX `idx_schedule_id`(`schedule_id`) USING BTREE,
  INDEX `idx_doctor_id`(`doctor_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_appointment_record
-- 使用负ID避免与Redis ID生成器冲突
-- ----------------------------

-- ----------------------------
-- Table structure for tb_medical_review
-- ----------------------------
DROP TABLE IF EXISTS `tb_medical_review`;
CREATE TABLE `tb_medical_review`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `hospital_id` bigint(20) UNSIGNED NOT NULL COMMENT '医院ID',
  `doctor_id` bigint(20) UNSIGNED NOT NULL COMMENT '医生ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `rating` int(2) UNSIGNED NOT NULL COMMENT '评分（1-50）',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '评价内容',
  `liked` int(8) UNSIGNED NOT NULL DEFAULT 0 COMMENT '点赞数',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '状态（1正常/0隐藏）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hospital_id`(`hospital_id`) USING BTREE,
  INDEX `idx_doctor_id`(`doctor_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_medical_review
-- ----------------------------
INSERT INTO `tb_medical_review` VALUES (1, 1, 1, 1, 45, '张医生态度非常好，问诊很仔细，开了药吃了两天就好转了，非常推荐！', 3, 1, '2026-06-02 10:00:00', '2026-06-02 10:00:00');
INSERT INTO `tb_medical_review` VALUES (2, 1, 3, 2, 48, '王主任医术高超，做白内障手术非常顺利，术后恢复很好，感谢！', 5, 1, '2026-06-03 14:00:00', '2026-06-03 14:00:00');
INSERT INTO `tb_medical_review` VALUES (3, 2, 4, 1, 50, '赵主任是国内心血管领域的权威，能挂到他的号很幸运，诊断精准。', 8, 1, '2026-06-04 09:00:00', '2026-06-04 09:00:00');
INSERT INTO `tb_medical_review` VALUES (4, 3, 8, 3, 42, '周医生很专业，我的腰痛问题看了好多地方都没好，周医生治疗后明显改善。', 2, 1, '2026-06-05 11:00:00', '2026-06-05 11:00:00');
INSERT INTO `tb_medical_review` VALUES (5, 5, 12, 3, 36, '社区医院很方便，徐医生态度亲切，小毛病不用跑大医院了。', 1, 1, '2026-06-05 15:00:00', '2026-06-05 15:00:00');

-- ----------------------------
-- Table structure for tb_follow
-- ----------------------------
DROP TABLE IF EXISTS `tb_follow`;
CREATE TABLE `tb_follow`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户id',
  `follow_id` bigint(20) UNSIGNED NOT NULL COMMENT '关注对象ID（医院ID或医生ID）',
  `follow_type` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关注类型（0医院/1医生）',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_follow`(`follow_id`, `follow_type`) USING BTREE,
  UNIQUE INDEX `uniq_user_follow`(`user_id`, `follow_id`, `follow_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_follow
-- ----------------------------
INSERT INTO `tb_follow` VALUES (1, 1, 2, 0, '2026-06-02 10:00:00');
INSERT INTO `tb_follow` VALUES (2, 1, 4, 1, '2026-06-02 10:30:00');
INSERT INTO `tb_follow` VALUES (3, 2, 1, 0, '2026-06-03 09:00:00');
INSERT INTO `tb_follow` VALUES (4, 3, 2, 0, '2026-06-04 14:00:00');

-- ----------------------------
-- Table structure for tb_review_comment
-- ----------------------------
DROP TABLE IF EXISTS `tb_review_comment`;
CREATE TABLE `tb_review_comment`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户id',
  `review_id` bigint(20) UNSIGNED NOT NULL COMMENT '评价id',
  `parent_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '关联的1级评论id，如果是一级评论，则值为0',
  `answer_id` bigint(20) UNSIGNED NOT NULL DEFAULT 0 COMMENT '回复的评论id',
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '回复的内容',
  `liked` int(8) UNSIGNED NULL DEFAULT NULL COMMENT '点赞数',
  `status` tinyint(1) UNSIGNED NULL DEFAULT NULL COMMENT '状态，0：正常，1：被举报，2：禁止查看',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_review_id`(`review_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of tb_review_comment
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
