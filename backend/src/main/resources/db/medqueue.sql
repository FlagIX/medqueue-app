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

-- ----------------------------
-- 新增医院数据 (科室3-10全覆盖 + 内科/外科补充)
-- ----------------------------
INSERT INTO `tb_hospital` VALUES (7, '复旦大学附属儿科医院', 3, '', '闵行区', '上海市闵行区万源路399号', 121.3835, 31.1339, '三甲', '021-64931990', '08:00-17:00', 47, 200, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (8, '上海交通大学医学院附属上海儿童医学中心', 3, '', '浦东新区', '上海市浦东新区东方路1678号', 121.5172, 31.2025, '三甲', '021-38626161', '08:00-17:00', 46, 180, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (9, '复旦大学附属妇产科医院', 4, '', '黄浦区', '上海市黄浦区方斜路419号', 121.4789, 31.2198, '三甲', '021-63770161', '08:00-17:00', 48, 220, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (10, '上海市第一妇婴保健院', 4, '', '浦东新区', '上海市浦东新区高科西路2699号', 121.5306, 31.1788, '三甲', '021-20261111', '08:00-17:00', 45, 190, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (11, '复旦大学附属眼耳鼻喉科医院', 5, '', '徐汇区', '上海市徐汇区汾阳路83号', 121.4499, 31.2162, '三甲', '021-64377134', '08:00-17:00', 49, 250, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (12, '上海爱尔眼科医院', 5, '', '徐汇区', '上海市徐汇区吴中路83号', 121.4028, 31.1928, '二甲', '021-54899900', '08:30-17:30', 42, 150, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (13, '上海交通大学医学院附属新华医院', 6, '', '杨浦区', '上海市杨浦区控江路1665号', 121.5267, 31.2728, '三甲', '021-25078999', '08:00-17:00', 46, 210, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (14, '上海市浦东医院', 6, '', '浦东新区', '上海市浦东新区惠南镇拱为路2800号', 121.7532, 31.0509, '二甲', '021-68035001', '08:00-17:00', 40, 90, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (15, '上海交通大学医学院附属第九人民医院', 7, '', '黄浦区', '上海市黄浦区制造局路639号', 121.4853, 31.2140, '三甲', '021-23271699', '08:00-17:00', 48, 260, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (16, '上海市口腔医院', 7, '', '黄浦区', '上海市黄浦区北京东路356号', 121.4836, 31.2417, '三甲', '021-63601100', '08:00-17:00', 44, 140, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (17, '上海市皮肤病医院', 8, '', '长宁区', '上海市长宁区武夷路238号', 121.4186, 31.2187, '三甲', '021-61833100', '08:00-17:00', 45, 170, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (18, '上海市长宁区中心医院', 8, '', '长宁区', '上海市长宁区仙霞路1111号', 121.3790, 31.2191, '二甲', '021-62909911', '08:00-17:00', 39, 80, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (19, '上海市第六人民医院', 9, '', '徐汇区', '上海市徐汇区宜山路600号', 121.4315, 31.1754, '三甲', '021-64369181', '08:00-17:00', 48, 240, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (20, '上海长征医院', 9, '', '黄浦区', '上海市黄浦区凤阳路415号', 121.4770, 31.2318, '三甲', '021-81886999', '08:00-17:00', 47, 200, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (21, '上海交通大学医学院附属瑞金医院', 10, '', '黄浦区', '上海市黄浦区瑞金二路197号', 121.4640, 31.2104, '三甲', '021-64370045', '08:00-17:00', 49, 280, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (22, '上海市同济医院', 10, '', '普陀区', '上海市普陀区新村路389号', 121.4155, 31.2716, '三甲', '021-56051080', '08:00-17:00', 44, 160, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (23, '复旦大学附属中山医院', 1, '', '徐汇区', '上海市徐汇区医学院路136号', 121.4613, 31.2021, '三甲', '021-64041990', '08:00-17:00', 49, 300, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (24, '上海市第十人民医院', 1, '', '静安区', '上海市静安区延长中路301号', 121.4520, 31.2802, '三甲', '021-66303643', '08:00-17:00', 45, 175, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (25, '海军军医大学第一附属医院（上海长海医院）', 2, '', '杨浦区', '上海市杨浦区长海路168号', 121.5270, 31.3077, '三甲', '021-31166666', '08:00-17:00', 47, 230, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_hospital` VALUES (26, '上海市普陀区中心医院', 2, '', '普陀区', '上海市普陀区兰溪路164号', 121.4010, 31.2604, '二甲', '021-62549931', '08:00-17:00', 40, 100, '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- ----------------------------
-- 新增挂号费用标准
-- ----------------------------
INSERT INTO `tb_appointment_item` VALUES (19, 7, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (20, 7, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (21, 7, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (22, 8, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (23, 8, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (24, 8, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (25, 9, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (26, 9, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (27, 9, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (28, 10, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (29, 10, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (30, 10, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (31, 11, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (32, 11, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (33, 11, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (34, 12, '普通号', 1500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (35, 12, '专家号', 3000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (36, 12, '特需号', 10000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (37, 13, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (38, 13, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (39, 13, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (40, 14, '普通号', 1500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (41, 14, '专家号', 3000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (42, 14, '特需号', 10000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (43, 15, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (44, 15, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (45, 15, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (46, 16, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (47, 16, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (48, 16, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (49, 17, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (50, 17, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (51, 17, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (52, 18, '普通号', 1500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (53, 18, '专家号', 3000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (54, 18, '特需号', 10000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (55, 19, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (56, 19, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (57, 19, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (58, 20, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (59, 20, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (60, 20, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (61, 21, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (62, 21, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (63, 21, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (64, 22, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (65, 22, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (66, 22, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (67, 23, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (68, 23, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (69, 23, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (70, 24, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (71, 24, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (72, 24, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (73, 25, '普通号', 2500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (74, 25, '专家号', 5000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (75, 25, '特需号', 20000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (76, 26, '普通号', 1500, 1, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (77, 26, '专家号', 3000, 2, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_appointment_item` VALUES (78, 26, '特需号', 10000, 3, 1, '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- ----------------------------
-- 新增医生
-- ----------------------------
-- 复旦大学附属儿科医院（儿科）
INSERT INTO `tb_doctor` VALUES (16, 7, 3, '陈建平', '主任医师', '', '复旦大学附属儿科医院儿内科主任，从事儿科临床工作35年，擅长小儿呼吸系统疾病、哮喘及过敏性疾病的诊治，对儿童重症肺炎有丰富的临床经验。', 48, 1800, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (17, 7, 3, '李敏', '副主任医师', '', '儿科副主任医师，专注新生儿疾病及婴幼儿喂养指导，擅长早产儿管理及新生儿黄疸的规范化治疗。', 44, 900, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (18, 7, 3, '周晓峰', '主治医师', '', '儿科主治医师，擅长儿童常见病如发热、咳嗽、腹泻的诊治，在儿童保健及计划免疫方面有丰富经验。', 39, 500, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海儿童医学中心（儿科）
INSERT INTO `tb_doctor` VALUES (19, 8, 3, '王磊', '主任医师', '', '上海儿童医学中心小儿心脏科主任，从事儿童心血管疾病诊治30年，擅长先天性心脏病的介入治疗及术后管理。', 47, 1500, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (20, 8, 3, '张婷', '副主任医师', '', '儿科血液肿瘤专家，专注儿童白血病及实体瘤的化疗与支持治疗，在儿童血液病诊治领域有深厚造诣。', 43, 700, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (21, 8, 3, '徐明', '主治医师', '', '儿科主治医师，擅长小儿消化系统疾病及营养指导，对儿童慢性腹痛、腹泻的鉴别诊断经验丰富。', 38, 350, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 复旦大学附属妇产科医院（妇产科）
INSERT INTO `tb_doctor` VALUES (22, 9, 4, '林芳', '主任医师', '', '红房子医院妇产科主任，从事妇科肿瘤诊治30余年，擅长宫颈癌、卵巢癌的根治性手术及综合治疗，在妇科微创手术领域享有盛誉。', 49, 2000, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (23, 9, 4, '顾晓燕', '副主任医师', '', '妇产科副主任医师，专注高危孕产妇管理及产前诊断，在妊娠期糖尿病、妊娠期高血压的规范化治疗方面经验丰富。', 44, 850, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (24, 9, 4, '唐艳', '主治医师', '', '妇产科主治医师，擅长妇科常见病如子宫肌瘤、卵巢囊肿的诊治，计划生育手术及宫腔镜检查技术娴熟。', 40, 450, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海市第一妇婴保健院（妇产科）
INSERT INTO `tb_doctor` VALUES (25, 10, 4, '孙丽君', '主任医师', '', '上海市第一妇婴保健院产科主任，从事围产医学30年，擅长高危妊娠的诊治及产前筛查咨询，在早产防治方面有深入研究。', 46, 1600, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (26, 10, 4, '何雯', '副主任医师', '', '妇科副主任医师，专注妇科内分泌疾病及不孕不育诊治，擅长多囊卵巢综合征、子宫内膜异位症的综合治疗。', 42, 650, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 复旦大学附属眼耳鼻喉科医院（眼科）
INSERT INTO `tb_doctor` VALUES (27, 11, 5, '孙强', '主任医师', '', '复旦大学附属眼耳鼻喉科医院眼科主任，国内白内障手术权威，擅长超声乳化白内障吸除术及高端人工晶体植入，年手术量逾千例。', 49, 2200, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (28, 11, 5, '赵敏', '副主任医师', '', '眼科副主任医师，专注青光眼及眼底病的诊治，擅长视网膜脱离、糖尿病视网膜病变的激光及手术治疗。', 45, 1000, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (29, 11, 5, '周文', '主治医师', '', '眼科主治医师，擅长近视防控及儿童斜弱视诊治，在角膜塑形镜验配及视功能训练方面经验丰富。', 41, 500, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海爱尔眼科医院（眼科）
INSERT INTO `tb_doctor` VALUES (30, 12, 5, '刘志刚', '副主任医师', '', '上海爱尔眼科医院屈光科主任，擅长飞秒激光近视矫正手术及ICL晶体植入术，已完成各类屈光手术逾万例。', 43, 1200, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (31, 12, 5, '陈晓燕', '主治医师', '', '眼科主治医师，擅长干眼症的综合诊治及眼表疾病治疗，在白内障术前术后管理方面经验丰富。', 39, 350, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 新华医院（耳鼻喉科）
INSERT INTO `tb_doctor` VALUES (32, 13, 6, '杨建平', '主任医师', '', '新华医院耳鼻咽喉-头颈外科主任，从事耳鼻喉科临床工作30年，擅长喉癌、下咽癌的根治性手术及功能重建，在头颈肿瘤外科领域造诣深厚。', 47, 1700, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (33, 13, 6, '吴敏', '副主任医师', '', '耳鼻喉科副主任医师，专注鼻科疾病诊治，擅长慢性鼻窦炎、鼻息肉的内镜微创手术及过敏性鼻炎的综合治疗。', 44, 800, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (34, 13, 6, '林晓', '主治医师', '', '耳鼻喉科主治医师，擅长儿童腺样体肥大、扁桃体炎的微创手术及分泌性中耳炎的规范化治疗。', 40, 400, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海市浦东医院（耳鼻喉科）
INSERT INTO `tb_doctor` VALUES (35, 14, 6, '黄伟', '副主任医师', '', '浦东医院耳鼻喉科副主任，擅长慢性咽炎、声带息肉的诊治及喉显微手术，对变应性鼻炎的特异性免疫治疗有丰富经验。', 41, 550, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (36, 14, 6, '张丽华', '主治医师', '', '耳鼻喉科主治医师，专注耳科疾病诊治，擅长突发性耳聋、良性阵发性位置性眩晕（耳石症）的手法复位及药物治疗。', 37, 280, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海第九人民医院（口腔科）
INSERT INTO `tb_doctor` VALUES (37, 15, 7, '郑建华', '主任医师', '', '上海第九人民医院口腔颌面外科主任，国内口腔颌面肿瘤权威，擅长口腔癌的根治性手术及术后缺损的修复重建，在颌面外科领域享有崇高声誉。', 49, 1900, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (38, 15, 7, '陈洁', '副主任医师', '', '口腔正畸科副主任医师，专注儿童及成人错颌畸形的矫治，擅长隐形矫治及自锁托槽矫治技术。', 45, 900, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海市口腔医院（口腔科）
INSERT INTO `tb_doctor` VALUES (39, 16, 7, '马晓军', '副主任医师', '', '上海市口腔医院牙体牙髓科副主任，擅长显微根管治疗及牙体美容修复，在疑难根管再治疗方面经验丰富。', 44, 750, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (40, 16, 7, '徐莉', '主治医师', '', '口腔修复科主治医师，擅长全瓷冠、贴面及种植牙修复，在前牙美学修复及可摘局部义齿设计方面具有丰富临床经验。', 40, 380, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (41, 16, 7, '高磊', '主治医师', '', '口腔颌面外科主治医师，擅长各类复杂阻生智齿的微创拔除及牙槽外科手术。', 38, 320, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海市皮肤病医院（皮肤科）
INSERT INTO `tb_doctor` VALUES (42, 17, 8, '章力', '主任医师', '', '上海市皮肤病医院皮肤内科主任，从事皮肤病临床工作30余年，擅长银屑病、白癜风等疑难皮肤病的综合治疗及生物制剂应用。', 46, 1400, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (43, 17, 8, '王婷婷', '副主任医师', '', '皮肤科副主任医师，专注痤疮、玫瑰痤疮及面部敏感性皮肤的治疗，在皮肤美容及激光治疗方面经验丰富。', 43, 700, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海市长宁区中心医院（皮肤科）
INSERT INTO `tb_doctor` VALUES (44, 18, 8, '郭峰', '副主任医师', '', '长宁区中心医院皮肤科主任，擅长湿疹、荨麻疹、带状疱疹等常见皮肤病的规范化诊治及慢性皮肤病的长期管理。', 40, 500, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (45, 18, 8, '周莉', '主治医师', '', '皮肤科主治医师，擅长真菌性皮肤病（手足癣、甲癣）及病毒性皮肤病的综合治疗。', 36, 250, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海市第六人民医院（骨科）
INSERT INTO `tb_doctor` VALUES (46, 19, 9, '罗勇', '主任医师', '', '上海市第六人民医院骨科主任，国内创伤骨科及关节外科权威，擅长复杂关节置换术及翻修术，在四肢骨折微创治疗方面享有盛誉。', 49, 2100, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (47, 19, 9, '韩冰', '副主任医师', '', '骨科副主任医师，专注脊柱外科，擅长腰椎间盘突出、腰椎管狭窄的微创手术治疗及脊柱侧弯矫形。', 46, 1100, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (48, 19, 9, '沈强', '主治医师', '', '骨科主治医师，擅长运动损伤的关节镜微创治疗，包括膝关节半月板损伤、交叉韧带重建及肩袖损伤修复。', 42, 600, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海长征医院（骨科）
INSERT INTO `tb_doctor` VALUES (49, 20, 9, '叶晓明', '主任医师', '', '长征医院骨科脊柱外科主任，国内脊柱外科领域领军人物，擅长颈椎病、腰椎滑脱及脊柱肿瘤的疑难手术，在脊柱畸形矫正方面有极深造诣。', 48, 1800, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (50, 20, 9, '钱峰', '副主任医师', '', '骨科副主任医师，专注骨肿瘤及软组织肿瘤的外科治疗，擅长四肢及骨盆恶性肿瘤的保肢手术。', 44, 650, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 瑞金医院（神经内科）
INSERT INTO `tb_doctor` VALUES (51, 21, 10, '陈伟民', '主任医师', '', '瑞金医院神经内科主任，国内脑血管病诊疗权威，擅长急性脑梗死的溶栓及介入治疗，在帕金森病及运动障碍疾病的诊治方面有深入研究。', 49, 2000, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (52, 21, 10, '李雪', '副主任医师', '', '神经内科副主任医师，专注癫痫及发作性疾病的诊断与治疗，擅长难治性癫痫的药物调整及术前评估。', 45, 950, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (53, 21, 10, '吴兵', '主治医师', '', '神经内科主治医师，擅长头痛、头晕、失眠等常见症状的鉴别诊断及治疗，在认知障碍及痴呆的早期筛查方面经验丰富。', 41, 450, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海市同济医院（神经内科）
INSERT INTO `tb_doctor` VALUES (54, 22, 10, '黄海波', '副主任医师', '', '同济医院神经内科副主任，擅长脑血管病的一级二级预防及康复治疗，对多发性硬化及视神经脊髓炎谱系疾病的诊治有丰富经验。', 44, 750, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (55, 22, 10, '赵莹', '主治医师', '', '神经内科主治医师，擅长周围神经病及肌肉疾病的电生理诊断与治疗，在重症肌无力及格林-巴利综合征的综合管理方面经验丰富。', 39, 300, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 复旦大学附属中山医院（内科）
INSERT INTO `tb_doctor` VALUES (56, 23, 1, '葛建华', '主任医师', '', '中山医院心内科主任，国内心血管疾病权威，擅长冠心病、心律失常的介入治疗及心力衰竭的综合管理，在心脏起搏器植入方面经验丰富。', 49, 2500, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (57, 23, 1, '高敏', '副主任医师', '', '消化内科副主任医师，擅长慢性胃炎、消化性溃疡、炎症性肠病的诊治及胃肠镜下的微创治疗。', 46, 950, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (58, 23, 1, '陶然', '主治医师', '', '呼吸内科主治医师，擅长慢性阻塞性肺疾病、支气管哮喘的规范化治疗及肺部结节的早期鉴别诊断。', 42, 500, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海市第十人民医院（内科）
INSERT INTO `tb_doctor` VALUES (59, 24, 1, '秦明', '主任医师', '', '上海市第十人民医院内分泌科主任，擅长糖尿病及甲状腺疾病的综合管理，在骨质疏松诊疗方面有丰富的临床经验。', 46, 1300, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (60, 24, 1, '沈琳', '副主任医师', '', '肾内科副主任医师，擅长慢性肾小球肾炎、肾功能不全的规范化治疗及血液透析通路建立与维护。', 43, 700, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海长海医院（外科）
INSERT INTO `tb_doctor` VALUES (61, 25, 2, '张卫东', '主任医师', '', '长海医院普外科主任，国内肝胆胰外科权威，擅长肝癌、胰腺癌的根治性手术及腹腔镜微创手术，在门脉高压症的外科治疗方面有深厚造诣。', 48, 1800, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (62, 25, 2, '李志强', '副主任医师', '', '长海医院泌尿外科副主任，专注泌尿系肿瘤及微创手术，擅长前列腺癌根治术及肾癌保留肾单位手术。', 44, 850, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (63, 25, 2, '王磊', '主治医师', '', '普外科主治医师，擅长甲状腺、乳腺良性疾病的微创手术及腹股沟疝的腹腔镜无张力修补术。', 40, 420, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- 上海市普陀区中心医院（外科）
INSERT INTO `tb_doctor` VALUES (64, 26, 2, '陈国华', '副主任医师', '', '普陀区中心医院普外科副主任，擅长胆囊结石、阑尾炎等常见疾病的腹腔镜微创手术及肛肠疾病的规范化治疗。', 41, 550, '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor` VALUES (65, 26, 2, '黄燕', '主治医师', '', '普外科主治医师，擅长乳腺良性肿瘤的微创旋切手术及甲状腺结节的精细化手术治疗。', 37, 280, '2026-06-01 08:00:00', '2026-06-01 08:00:00');

-- ----------------------------
-- 新增医生排班（每位医生未来7天）
-- ----------------------------
-- Doctor 16（陈建平，儿科·主任医师 → 专家号fee_id=20）
INSERT INTO `tb_doctor_schedule` VALUES (101501, 16, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101502, 16, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101503, 16, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101504, 16, CURDATE() + INTERVAL 2 DAY, '下午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101505, 16, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101506, 16, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101507, 16, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101508, 16, CURDATE() + INTERVAL 4 DAY, '下午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101509, 16, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101510, 16, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101511, 16, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101512, 16, CURDATE() + INTERVAL 6 DAY, '下午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101513, 16, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101514, 16, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 20, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 17（李敏，儿科·副主任医师 → 专家号fee_id=20）
INSERT INTO `tb_doctor_schedule` VALUES (101601, 17, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 20, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101602, 17, CURDATE() + INTERVAL 1 DAY, '下午', 25, 25, 20, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101603, 17, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 20, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101604, 17, CURDATE() + INTERVAL 3 DAY, '下午', 25, 25, 20, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101605, 17, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 20, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101606, 17, CURDATE() + INTERVAL 5 DAY, '下午', 25, 25, 20, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101607, 17, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 20, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101608, 17, CURDATE() + INTERVAL 7 DAY, '下午', 25, 25, 20, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 18（周晓峰，儿科·主治医师 → 普通号fee_id=19）
INSERT INTO `tb_doctor_schedule` VALUES (101701, 18, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101702, 18, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101703, 18, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101704, 18, CURDATE() + INTERVAL 2 DAY, '下午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101705, 18, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101706, 18, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101707, 18, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101708, 18, CURDATE() + INTERVAL 4 DAY, '下午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101709, 18, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101710, 18, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101711, 18, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101712, 18, CURDATE() + INTERVAL 6 DAY, '下午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101713, 18, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101714, 18, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 19, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 19（王磊，儿科·主任医师 → 专家号fee_id=23）
INSERT INTO `tb_doctor_schedule` VALUES (101801, 19, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101802, 19, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101803, 19, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101804, 19, CURDATE() + INTERVAL 2 DAY, '下午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101805, 19, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101806, 19, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101807, 19, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101808, 19, CURDATE() + INTERVAL 4 DAY, '下午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101809, 19, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101810, 19, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101811, 19, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101812, 19, CURDATE() + INTERVAL 6 DAY, '下午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101813, 19, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101814, 19, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 23, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 20（张婷，儿科·副主任医师 → 专家号fee_id=23）
INSERT INTO `tb_doctor_schedule` VALUES (101901, 20, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 23, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101902, 20, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 23, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101903, 20, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 23, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (101904, 20, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 23, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 21（徐明，儿科·主治医师 → 普通号fee_id=22）
INSERT INTO `tb_doctor_schedule` VALUES (102001, 21, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 22, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102002, 21, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 22, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102003, 21, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 22, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102004, 21, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 22, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102005, 21, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 22, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102006, 21, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 22, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102007, 21, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 22, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102008, 21, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 22, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 22（林芳，妇产科·主任医师 → 专家号fee_id=26）
INSERT INTO `tb_doctor_schedule` VALUES (102101, 22, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 26, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102102, 22, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 26, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102103, 22, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 26, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102104, 22, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 26, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102105, 22, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 26, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102106, 22, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 26, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102107, 22, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 26, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102108, 22, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 26, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 23（顾晓燕，妇产科·副主任医师 → 专家号fee_id=26）
INSERT INTO `tb_doctor_schedule` VALUES (102201, 23, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 26, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102202, 23, CURDATE() + INTERVAL 2 DAY, '下午', 25, 25, 26, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102203, 23, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 26, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102204, 23, CURDATE() + INTERVAL 4 DAY, '下午', 25, 25, 26, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102205, 23, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 26, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102206, 23, CURDATE() + INTERVAL 6 DAY, '下午', 25, 25, 26, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 24（唐艳，妇产科·主治医师 → 普通号fee_id=25）
INSERT INTO `tb_doctor_schedule` VALUES (102301, 24, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 25, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102302, 24, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 25, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102303, 24, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 25, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102304, 24, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 25, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102305, 24, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 25, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102306, 24, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 25, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102307, 24, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 25, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102308, 24, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 25, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 25（孙丽君，妇产科·主任医师 → 专家号fee_id=29）
INSERT INTO `tb_doctor_schedule` VALUES (102401, 25, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 29, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102402, 25, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 29, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102403, 25, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 29, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102404, 25, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 29, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102405, 25, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 29, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102406, 25, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 29, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102407, 25, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 29, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102408, 25, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 29, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 26（何雯，妇产科·副主任医师 → 专家号fee_id=29）
INSERT INTO `tb_doctor_schedule` VALUES (102501, 26, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 29, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102502, 26, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 29, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102503, 26, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 29, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 27（孙强，眼科·主任医师 → 专家号fee_id=32）
INSERT INTO `tb_doctor_schedule` VALUES (102601, 27, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102602, 27, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102603, 27, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102604, 27, CURDATE() + INTERVAL 2 DAY, '下午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102605, 27, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102606, 27, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102607, 27, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102608, 27, CURDATE() + INTERVAL 4 DAY, '下午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102609, 27, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102610, 27, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102611, 27, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102612, 27, CURDATE() + INTERVAL 6 DAY, '下午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102613, 27, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102614, 27, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 32, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 28（赵敏，眼科·副主任医师 → 专家号fee_id=32）
INSERT INTO `tb_doctor_schedule` VALUES (102701, 28, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 32, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102702, 28, CURDATE() + INTERVAL 1 DAY, '下午', 25, 25, 32, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102703, 28, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 32, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102704, 28, CURDATE() + INTERVAL 3 DAY, '下午', 25, 25, 32, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102705, 28, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 32, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102706, 28, CURDATE() + INTERVAL 5 DAY, '下午', 25, 25, 32, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102707, 28, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 32, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102708, 28, CURDATE() + INTERVAL 7 DAY, '下午', 25, 25, 32, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 29（周文，眼科·主治医师 → 普通号fee_id=31）
INSERT INTO `tb_doctor_schedule` VALUES (102801, 29, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 31, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102802, 29, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 31, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102803, 29, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 31, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102804, 29, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 31, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102805, 29, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 31, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102806, 29, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 31, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102807, 29, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 31, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 30（刘志刚，眼科·副主任医师 → 专家号fee_id=35）
INSERT INTO `tb_doctor_schedule` VALUES (102901, 30, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 35, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102902, 30, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 35, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102903, 30, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 35, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (102904, 30, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 35, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 31（陈晓燕，眼科·主治医师 → 普通号fee_id=34）
INSERT INTO `tb_doctor_schedule` VALUES (103001, 31, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 34, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103002, 31, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 34, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103003, 31, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 34, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 32（杨建平，耳鼻喉科·主任医师 → 专家号fee_id=38）
INSERT INTO `tb_doctor_schedule` VALUES (103101, 32, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 38, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103102, 32, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 38, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103103, 32, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 38, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103104, 32, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 38, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103105, 32, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 38, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103106, 32, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 38, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103107, 32, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 38, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103108, 32, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 38, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 33（吴敏，耳鼻喉科·副主任医师 → 专家号fee_id=38）
INSERT INTO `tb_doctor_schedule` VALUES (103201, 33, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 38, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103202, 33, CURDATE() + INTERVAL 2 DAY, '下午', 25, 25, 38, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103203, 33, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 38, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103204, 33, CURDATE() + INTERVAL 4 DAY, '下午', 25, 25, 38, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103205, 33, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 38, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103206, 33, CURDATE() + INTERVAL 6 DAY, '下午', 25, 25, 38, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 34（林晓，耳鼻喉科·主治医师 → 普通号fee_id=37）
INSERT INTO `tb_doctor_schedule` VALUES (103301, 34, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 37, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103302, 34, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 37, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103303, 34, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 37, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103304, 34, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 37, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103305, 34, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 37, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103306, 34, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 37, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103307, 34, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 37, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 35（黄伟，耳鼻喉科·副主任医师 → 专家号fee_id=41）
INSERT INTO `tb_doctor_schedule` VALUES (103401, 35, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 41, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103402, 35, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 41, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103403, 35, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 41, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103404, 35, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 41, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 36（张丽华，耳鼻喉科·主治医师 → 普通号fee_id=40）
INSERT INTO `tb_doctor_schedule` VALUES (103501, 36, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 40, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103502, 36, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 40, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103503, 36, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 40, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 37（郑建华，口腔科·主任医师 → 专家号fee_id=44）
INSERT INTO `tb_doctor_schedule` VALUES (103601, 37, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 44, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103602, 37, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 44, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103603, 37, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 44, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103604, 37, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 44, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103605, 37, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 44, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103606, 37, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 44, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103607, 37, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 44, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103608, 37, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 44, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 38（陈洁，口腔科·副主任医师 → 专家号fee_id=44）
INSERT INTO `tb_doctor_schedule` VALUES (103701, 38, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 44, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103702, 38, CURDATE() + INTERVAL 2 DAY, '下午', 25, 25, 44, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103703, 38, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 44, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103704, 38, CURDATE() + INTERVAL 4 DAY, '下午', 25, 25, 44, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103705, 38, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 44, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103706, 38, CURDATE() + INTERVAL 6 DAY, '下午', 25, 25, 44, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 39（马晓军，口腔科·副主任医师 → 专家号fee_id=47）
INSERT INTO `tb_doctor_schedule` VALUES (103801, 39, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 47, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103802, 39, CURDATE() + INTERVAL 1 DAY, '下午', 25, 25, 47, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103803, 39, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 47, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103804, 39, CURDATE() + INTERVAL 3 DAY, '下午', 25, 25, 47, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103805, 39, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 47, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103806, 39, CURDATE() + INTERVAL 5 DAY, '下午', 25, 25, 47, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103807, 39, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 47, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103808, 39, CURDATE() + INTERVAL 7 DAY, '下午', 25, 25, 47, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 40（徐莉，口腔科·主治医师 → 普通号fee_id=46）
INSERT INTO `tb_doctor_schedule` VALUES (103901, 40, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 46, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103902, 40, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 46, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103903, 40, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 46, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103904, 40, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 46, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103905, 40, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 46, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103906, 40, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 46, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (103907, 40, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 46, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 41（高磊，口腔科·主治医师 → 普通号fee_id=46）
INSERT INTO `tb_doctor_schedule` VALUES (104001, 41, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 46, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104002, 41, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 46, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104003, 41, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 46, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104004, 41, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 46, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 42（章力，皮肤科·主任医师 → 专家号fee_id=50）
INSERT INTO `tb_doctor_schedule` VALUES (104101, 42, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 50, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104102, 42, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 50, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104103, 42, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 50, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104104, 42, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 50, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104105, 42, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 50, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104106, 42, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 50, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104107, 42, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 50, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104108, 42, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 50, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 43（王婷婷，皮肤科·副主任医师 → 专家号fee_id=50）
INSERT INTO `tb_doctor_schedule` VALUES (104201, 43, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 50, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104202, 43, CURDATE() + INTERVAL 2 DAY, '下午', 25, 25, 50, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104203, 43, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 50, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104204, 43, CURDATE() + INTERVAL 4 DAY, '下午', 25, 25, 50, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104205, 43, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 50, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104206, 43, CURDATE() + INTERVAL 6 DAY, '下午', 25, 25, 50, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 44（郭峰，皮肤科·副主任医师 → 专家号fee_id=53）
INSERT INTO `tb_doctor_schedule` VALUES (104301, 44, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 53, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104302, 44, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 53, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104303, 44, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 53, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104304, 44, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 53, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 45（周莉，皮肤科·主治医师 → 普通号fee_id=52）
INSERT INTO `tb_doctor_schedule` VALUES (104401, 45, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 52, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104402, 45, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 52, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104403, 45, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 52, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 46（罗勇，骨科·主任医师 → 专家号fee_id=56）
INSERT INTO `tb_doctor_schedule` VALUES (104501, 46, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 56, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104502, 46, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 56, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104503, 46, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 56, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104504, 46, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 56, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104505, 46, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 56, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104506, 46, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 56, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104507, 46, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 56, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104508, 46, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 56, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 47（韩冰，骨科·副主任医师 → 专家号fee_id=56）
INSERT INTO `tb_doctor_schedule` VALUES (104601, 47, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 56, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104602, 47, CURDATE() + INTERVAL 2 DAY, '下午', 25, 25, 56, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104603, 47, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 56, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104604, 47, CURDATE() + INTERVAL 4 DAY, '下午', 25, 25, 56, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104605, 47, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 56, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104606, 47, CURDATE() + INTERVAL 6 DAY, '下午', 25, 25, 56, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 48（沈强，骨科·主治医师 → 普通号fee_id=55）
INSERT INTO `tb_doctor_schedule` VALUES (104701, 48, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 55, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104702, 48, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 55, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104703, 48, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 55, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104704, 48, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 55, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104705, 48, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 55, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104706, 48, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 55, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104707, 48, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 55, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 49（叶晓明，骨科·主任医师 → 专家号fee_id=59）
INSERT INTO `tb_doctor_schedule` VALUES (104801, 49, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 59, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104802, 49, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 59, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104803, 49, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 59, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104804, 49, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 59, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104805, 49, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 59, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104806, 49, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 59, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104807, 49, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 59, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104808, 49, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 59, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 50（钱峰，骨科·副主任医师 → 专家号fee_id=59）
INSERT INTO `tb_doctor_schedule` VALUES (104901, 50, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 59, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104902, 50, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 59, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (104903, 50, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 59, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 51（陈伟民，神经内科·主任医师 → 专家号fee_id=62）
INSERT INTO `tb_doctor_schedule` VALUES (105001, 51, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 62, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105002, 51, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 62, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105003, 51, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 62, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105004, 51, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 62, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105005, 51, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 62, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105006, 51, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 62, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105007, 51, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 62, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105008, 51, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 62, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 52（李雪，神经内科·副主任医师 → 专家号fee_id=62）
INSERT INTO `tb_doctor_schedule` VALUES (105101, 52, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 62, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105102, 52, CURDATE() + INTERVAL 2 DAY, '下午', 25, 25, 62, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105103, 52, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 62, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105104, 52, CURDATE() + INTERVAL 4 DAY, '下午', 25, 25, 62, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105105, 52, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 62, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105106, 52, CURDATE() + INTERVAL 6 DAY, '下午', 25, 25, 62, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 53（吴兵，神经内科·主治医师 → 普通号fee_id=61）
INSERT INTO `tb_doctor_schedule` VALUES (105201, 53, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 61, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105202, 53, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 61, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105203, 53, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 61, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105204, 53, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 61, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105205, 53, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 61, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105206, 53, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 61, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105207, 53, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 61, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 54（黄海波，神经内科·副主任医师 → 专家号fee_id=65）
INSERT INTO `tb_doctor_schedule` VALUES (105301, 54, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 65, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105302, 54, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 65, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105303, 54, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 65, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105304, 54, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 65, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 55（赵莹，神经内科·主治医师 → 普通号fee_id=64）
INSERT INTO `tb_doctor_schedule` VALUES (105401, 55, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 64, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105402, 55, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 64, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105403, 55, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 64, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 56（葛建华，内科·主任医师 → 专家号fee_id=68）
INSERT INTO `tb_doctor_schedule` VALUES (105501, 56, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 68, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105502, 56, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 68, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105503, 56, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 68, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105504, 56, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 68, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105505, 56, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 68, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105506, 56, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 68, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105507, 56, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 68, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105508, 56, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 68, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 57（高敏，内科·副主任医师 → 专家号fee_id=68）
INSERT INTO `tb_doctor_schedule` VALUES (105601, 57, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 68, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105602, 57, CURDATE() + INTERVAL 2 DAY, '下午', 25, 25, 68, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105603, 57, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 68, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105604, 57, CURDATE() + INTERVAL 4 DAY, '下午', 25, 25, 68, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105605, 57, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 68, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105606, 57, CURDATE() + INTERVAL 6 DAY, '下午', 25, 25, 68, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 58（陶然，内科·主治医师 → 普通号fee_id=67）
INSERT INTO `tb_doctor_schedule` VALUES (105701, 58, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 67, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105702, 58, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 67, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105703, 58, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 67, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105704, 58, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 67, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105705, 58, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 67, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105706, 58, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 67, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105707, 58, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 67, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 59（秦明，内科·主任医师 → 专家号fee_id=71）
INSERT INTO `tb_doctor_schedule` VALUES (105801, 59, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 71, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105802, 59, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 71, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105803, 59, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 71, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105804, 59, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 71, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105805, 59, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 71, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105806, 59, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 71, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105807, 59, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 71, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105808, 59, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 71, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 60（沈琳，内科·副主任医师 → 专家号fee_id=71）
INSERT INTO `tb_doctor_schedule` VALUES (105901, 60, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 71, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105902, 60, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 71, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (105903, 60, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 71, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 61（张卫东，外科·主任医师 → 专家号fee_id=74）
INSERT INTO `tb_doctor_schedule` VALUES (106001, 61, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 74, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106002, 61, CURDATE() + INTERVAL 1 DAY, '下午', 30, 30, 74, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106003, 61, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 74, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106004, 61, CURDATE() + INTERVAL 3 DAY, '下午', 30, 30, 74, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106005, 61, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 74, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106006, 61, CURDATE() + INTERVAL 5 DAY, '下午', 30, 30, 74, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106007, 61, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 74, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106008, 61, CURDATE() + INTERVAL 7 DAY, '下午', 30, 30, 74, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 62（李志强，外科·副主任医师 → 专家号fee_id=74）
INSERT INTO `tb_doctor_schedule` VALUES (106101, 62, CURDATE() + INTERVAL 2 DAY, '上午', 25, 25, 74, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106102, 62, CURDATE() + INTERVAL 2 DAY, '下午', 25, 25, 74, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106103, 62, CURDATE() + INTERVAL 4 DAY, '上午', 25, 25, 74, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106104, 62, CURDATE() + INTERVAL 4 DAY, '下午', 25, 25, 74, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106105, 62, CURDATE() + INTERVAL 6 DAY, '上午', 25, 25, 74, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106106, 62, CURDATE() + INTERVAL 6 DAY, '下午', 25, 25, 74, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 13:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 17:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 63（王磊，外科·主治医师 → 普通号fee_id=73）
INSERT INTO `tb_doctor_schedule` VALUES (106201, 63, CURDATE() + INTERVAL 1 DAY, '上午', 30, 30, 73, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106202, 63, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 73, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106203, 63, CURDATE() + INTERVAL 3 DAY, '上午', 30, 30, 73, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106204, 63, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 73, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106205, 63, CURDATE() + INTERVAL 5 DAY, '上午', 30, 30, 73, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106206, 63, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 73, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106207, 63, CURDATE() + INTERVAL 7 DAY, '上午', 30, 30, 73, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 64（陈国华，外科·副主任医师 → 专家号fee_id=77）
INSERT INTO `tb_doctor_schedule` VALUES (106301, 64, CURDATE() + INTERVAL 1 DAY, '上午', 25, 25, 77, CONCAT(CURDATE() + INTERVAL 1 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 1 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106302, 64, CURDATE() + INTERVAL 3 DAY, '上午', 25, 25, 77, CONCAT(CURDATE() + INTERVAL 3 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 3 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106303, 64, CURDATE() + INTERVAL 5 DAY, '上午', 25, 25, 77, CONCAT(CURDATE() + INTERVAL 5 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 5 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106304, 64, CURDATE() + INTERVAL 7 DAY, '上午', 25, 25, 77, CONCAT(CURDATE() + INTERVAL 7 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 7 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
-- Doctor 65（黄燕，外科·主治医师 → 普通号fee_id=76）
INSERT INTO `tb_doctor_schedule` VALUES (106401, 65, CURDATE() + INTERVAL 2 DAY, '上午', 30, 30, 76, CONCAT(CURDATE() + INTERVAL 2 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 2 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106402, 65, CURDATE() + INTERVAL 4 DAY, '上午', 30, 30, 76, CONCAT(CURDATE() + INTERVAL 4 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 4 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');
INSERT INTO `tb_doctor_schedule` VALUES (106403, 65, CURDATE() + INTERVAL 6 DAY, '上午', 30, 30, 76, CONCAT(CURDATE() + INTERVAL 6 DAY, ' 08:00:00'), CONCAT(CURDATE() + INTERVAL 6 DAY, ' 12:00:00'), '2026-06-01 08:00:00', '2026-06-01 08:00:00');

SET FOREIGN_KEY_CHECKS = 1;
