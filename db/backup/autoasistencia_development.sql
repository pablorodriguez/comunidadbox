/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50145
Source Host           : localhost:3306
Source Database       : autoasistencia_development

Target Server Type    : MYSQL
Target Server Version : 50145
File Encoding         : 65001

Date: 2010-05-28 10:23:12
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `addresses`
-- ----------------------------
DROP TABLE IF EXISTS `addresses`;
CREATE TABLE `addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `department_id` int(11) DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `street` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of addresses
-- ----------------------------
INSERT INTO `addresses` VALUES ('1', '64810937', '1', 'Godoy Cruz', 'Portugal 1547', '5501', '4', 'Casa', '2010-05-15 11:49:26', '2010-05-15 11:49:26');
INSERT INTO `addresses` VALUES ('2', '450215437', '1', 'General Alvear', 'Rio Negro s/n', '5004', '1', 'Casa', '2010-05-25 03:58:52', '2010-05-25 03:58:52');
INSERT INTO `addresses` VALUES ('3', '717179523', '3', 'General Alvear', '12 de Agosto', '5004', '1', 'Comercio', '2010-05-25 04:00:23', '2010-05-25 04:00:48');

-- ----------------------------
-- Table structure for `alarms`
-- ----------------------------
DROP TABLE IF EXISTS `alarms`;
CREATE TABLE `alarms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `time` int(11) DEFAULT NULL,
  `time_unit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_ini` datetime DEFAULT NULL,
  `date_end` datetime DEFAULT NULL,
  `date_alarm` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of alarms
-- ----------------------------
INSERT INTO `alarms` VALUES ('1', 'Pago de Seguro', 'Pagar el serguro Mercatil Andina', '1', 'Hs', 'Activado', '2010-01-17 10:32:00', '2010-12-31 10:32:00', '2010-05-27 06:55:00', '1', '2010-05-26 11:38:13', '2010-05-27 18:55:10');
INSERT INTO `alarms` VALUES ('2', 'Pago de Seguro Auto', 'Paga el seguro del auto a Mercantil Andina', '1', 'Días', 'Activado', '2010-01-01 13:47:00', '2010-12-31 13:47:00', '2010-05-27 14:53:00', '4', '2010-05-27 14:48:03', '2010-05-27 14:52:53');

-- ----------------------------
-- Table structure for `brands`
-- ----------------------------
DROP TABLE IF EXISTS `brands`;
CREATE TABLE `brands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of brands
-- ----------------------------
INSERT INTO `brands` VALUES ('1', 'VOLKSWAGEN', '2010-05-12 14:38:32', '2010-05-12 14:38:32');
INSERT INTO `brands` VALUES ('2', 'CHEVROLET', '2010-05-12 14:38:32', '2010-05-12 14:38:32');
INSERT INTO `brands` VALUES ('3', 'CITROEN', '2010-05-12 14:38:32', '2010-05-12 14:38:32');

-- ----------------------------
-- Table structure for `car_service_offers`
-- ----------------------------
DROP TABLE IF EXISTS `car_service_offers`;
CREATE TABLE `car_service_offers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `car_id` int(11) DEFAULT NULL,
  `service_offer_id` int(11) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of car_service_offers
-- ----------------------------
INSERT INTO `car_service_offers` VALUES ('16', '1', '13', 'Aceptado', '2010-05-27 20:38:33', '2010-05-27 21:49:11');

-- ----------------------------
-- Table structure for `cars`
-- ----------------------------
DROP TABLE IF EXISTS `cars`;
CREATE TABLE `cars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `model_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `km` int(11) DEFAULT NULL,
  `kmAverageMonthly` int(11) DEFAULT NULL,
  `public` tinyint(1) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `fuel` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of cars
-- ----------------------------
INSERT INTO `cars` VALUES ('1', 'HRJ549', '1', '1', '2009', '5000', '2000', '1', '4', 'Nafta', '1', '2010-05-12 14:38:33', '2010-05-22 15:18:21');
INSERT INTO `cars` VALUES ('2', 'GRT458', '2', '1', '2005', '30000', '1500', '0', '5', 'Gasoil', null, '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `cars` VALUES ('3', 'DER668', '4', '2', '2006', '45000', '2000', '0', '5', 'Nafta', null, '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `cars` VALUES ('4', 'FGG212', '5', '2', '2009', '12000', '800', '0', '6', 'Gasoil', '3', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `cars` VALUES ('5', 'HGG002', '6', '3', '2008', '17000', '1200', '0', '6', 'Gas', '3', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `cars` VALUES ('6', 'LLL123', '6', '3', '2000', '60000', '1000', '0', '4', 'Nafta', '1', '2010-05-15 11:49:26', '2010-05-26 02:52:24');
INSERT INTO `cars` VALUES ('7', 'WSD322', '5', '2', '2004', '45000', '1500', '0', '4', 'Gas', null, '2010-05-26 02:52:24', '2010-05-26 02:52:24');

-- ----------------------------
-- Table structure for `companies`
-- ----------------------------
DROP TABLE IF EXISTS `companies`;
CREATE TABLE `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of companies
-- ----------------------------
INSERT INTO `companies` VALUES ('1', '10Fincas', 'Portugal 1547', '1', 'Godoy Cruz', '1', '0261-4526157', '5501', 'www.10fincas.com', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `companies` VALUES ('2', 'IMER', 'Rio Negro s/n', '1', 'Real del Padre', '1', '0261-4526157', '5624', 'www.imer.com', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `companies` VALUES ('3', 'Neumaticos Valle Grande', '', null, 'Ciudad', null, '', '', '', '2010-05-17 12:32:04', '2010-05-17 12:32:04');

-- ----------------------------
-- Table structure for `company_services`
-- ----------------------------
DROP TABLE IF EXISTS `company_services`;
CREATE TABLE `company_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) DEFAULT NULL,
  `service_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=450215449 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of company_services
-- ----------------------------
INSERT INTO `company_services` VALUES ('64810937', '2', '3');
INSERT INTO `company_services` VALUES ('450215437', '2', '4');
INSERT INTO `company_services` VALUES ('450215440', '1', '3');
INSERT INTO `company_services` VALUES ('450215441', '1', '2');
INSERT INTO `company_services` VALUES ('450215442', '1', '1');
INSERT INTO `company_services` VALUES ('450215443', '1', '4');
INSERT INTO `company_services` VALUES ('450215444', '1', '5');
INSERT INTO `company_services` VALUES ('450215445', '1', '6');
INSERT INTO `company_services` VALUES ('450215446', '3', '1');
INSERT INTO `company_services` VALUES ('450215447', '3', '3');
INSERT INTO `company_services` VALUES ('450215448', '3', '2');

-- ----------------------------
-- Table structure for `countries`
-- ----------------------------
DROP TABLE IF EXISTS `countries`;
CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of countries
-- ----------------------------
INSERT INTO `countries` VALUES ('1', 'Argentina', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `countries` VALUES ('2', 'Brazil', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `countries` VALUES ('3', 'Chile', '2010-05-12 14:38:33', '2010-05-12 14:38:33');

-- ----------------------------
-- Table structure for `departments`
-- ----------------------------
DROP TABLE IF EXISTS `departments`;
CREATE TABLE `departments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=973100823 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of departments
-- ----------------------------
INSERT INTO `departments` VALUES ('64810937', '1', 'Godoy Cruz', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `departments` VALUES ('78719920', '2', 'Capital Federal', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `departments` VALUES ('450215437', '1', 'General Alvear', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `departments` VALUES ('498629140', '2', 'Gral. Villegas', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `departments` VALUES ('717179523', '3', 'Rio Cuarto', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `departments` VALUES ('768773788', '1', 'San Rafael', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `departments` VALUES ('867572539', '1', 'Ciudad', '2010-05-12 14:38:33', '2010-05-12 14:38:33');
INSERT INTO `departments` VALUES ('973100822', '3', 'Union', '2010-05-12 14:38:33', '2010-05-12 14:38:33');

-- ----------------------------
-- Table structure for `events`
-- ----------------------------
DROP TABLE IF EXISTS `events`;
CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `car_id` int(11) DEFAULT NULL,
  `service_type_id` int(11) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dueDate` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=973100835 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of events
-- ----------------------------
INSERT INTO `events` VALUES ('973100833', '1', '2', 'Activa', '2010-06-26', '2010-05-26 17:00:01', '2010-05-26 17:00:01');
INSERT INTO `events` VALUES ('973100834', '1', '2', 'Activa', '2012-06-26', '2010-05-26 21:05:54', '2010-05-26 21:05:54');

-- ----------------------------
-- Table structure for `material_service_types`
-- ----------------------------
DROP TABLE IF EXISTS `material_service_types`;
CREATE TABLE `material_service_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `material_id` int(11) DEFAULT NULL,
  `service_type_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of material_service_types
-- ----------------------------
INSERT INTO `material_service_types` VALUES ('1', '1', '2', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `material_service_types` VALUES ('2', '3', '2', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `material_service_types` VALUES ('3', '4', '2', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `material_service_types` VALUES ('4', '5', '5', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `material_service_types` VALUES ('5', '2', '2', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `material_service_types` VALUES ('6', '6', '3', '2010-05-15 12:15:38', '2010-05-15 12:15:38');
INSERT INTO `material_service_types` VALUES ('7', '6', '4', '2010-05-15 12:15:50', '2010-05-15 12:15:50');
INSERT INTO `material_service_types` VALUES ('8', '6', '1', '2010-05-26 12:12:15', '2010-05-26 12:12:15');
INSERT INTO `material_service_types` VALUES ('9', '6', '2', '2010-05-26 12:12:19', '2010-05-26 12:12:19');
INSERT INTO `material_service_types` VALUES ('10', '6', '5', '2010-05-26 12:12:23', '2010-05-26 12:12:23');
INSERT INTO `material_service_types` VALUES ('11', '6', '6', '2010-05-26 12:12:28', '2010-05-26 12:12:28');
INSERT INTO `material_service_types` VALUES ('12', '6', '7', '2010-05-26 12:12:33', '2010-05-26 12:12:33');

-- ----------------------------
-- Table structure for `material_services`
-- ----------------------------
DROP TABLE IF EXISTS `material_services`;
CREATE TABLE `material_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_id` int(11) DEFAULT NULL,
  `row` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `material_service_type_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of material_services
-- ----------------------------
INSERT INTO `material_services` VALUES ('5', '2', '2', '2', '23.5', '2', '2010-05-12 14:50:51', '2010-05-12 14:50:51');
INSERT INTO `material_services` VALUES ('6', '3', '3', '2', '101.65', '3', '2010-05-12 14:54:01', '2010-05-12 14:54:01');
INSERT INTO `material_services` VALUES ('7', '4', '4', '2', '23.5', '2', '2010-05-15 12:11:17', '2010-05-15 12:11:17');
INSERT INTO `material_services` VALUES ('8', '5', '5', '2', '23.5', '2', '2010-05-17 23:09:33', '2010-05-17 23:09:33');
INSERT INTO `material_services` VALUES ('9', '6', '6', '2', '23.5', '2', '2010-05-17 23:12:31', '2010-05-17 23:12:31');
INSERT INTO `material_services` VALUES ('10', '7', '7', '1', '23.5', '2', '2010-05-17 23:14:54', '2010-05-17 23:14:54');
INSERT INTO `material_services` VALUES ('11', '8', '8', '2', '23.5', '2', '2010-05-17 23:17:37', '2010-05-17 23:17:37');
INSERT INTO `material_services` VALUES ('12', '9', '9', '2', '23.5', '2', '2010-05-18 16:13:22', '2010-05-18 16:13:22');
INSERT INTO `material_services` VALUES ('13', '10', '10', '4', '101.65', '3', '2010-05-22 15:18:21', '2010-05-22 15:18:21');
INSERT INTO `material_services` VALUES ('14', '11', '11', '2', '11.5', '1', '2010-05-22 15:18:21', '2010-05-22 15:18:21');
INSERT INTO `material_services` VALUES ('15', '12', '12', '2', '23.5', '2', '2010-05-25 03:35:41', '2010-05-25 03:35:41');
INSERT INTO `material_services` VALUES ('16', '13', '13', '2', '23.5', '2', '2010-05-26 17:00:01', '2010-05-26 17:00:01');
INSERT INTO `material_services` VALUES ('17', '14', '14', '2', '24', '2', '2010-05-26 21:05:54', '2010-05-26 21:05:54');
INSERT INTO `material_services` VALUES ('18', '14', '15', '1', '80', '9', '2010-05-26 21:05:54', '2010-05-26 21:05:54');

-- ----------------------------
-- Table structure for `materials`
-- ----------------------------
DROP TABLE IF EXISTS `materials`;
CREATE TABLE `materials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `brand` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `model` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `measurement` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of materials
-- ----------------------------
INSERT INTO `materials` VALUES ('1', '2345FA', 'Cubierta', 'Firestone', 'F-570', '133-58', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `materials` VALUES ('2', '2566FR', 'Cubierta', 'Firestone', 'F-320', '356-16', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `materials` VALUES ('3', '4322GT', 'Cubierta', 'Firestone', 'F-320', '356-18', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `materials` VALUES ('4', '6782VB', 'Cubierta', 'Goodyear', 'G-320', '356-16', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `materials` VALUES ('5', '9882NJ', 'Extremo Dirección', 'Liquid', 'D33', '15/88', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `materials` VALUES ('6', 'MM345', 'Mano de Obra', 'Operario', 'Modelo', '', '2010-05-15 12:15:31', '2010-05-15 12:15:31');

-- ----------------------------
-- Table structure for `models`
-- ----------------------------
DROP TABLE IF EXISTS `models`;
CREATE TABLE `models` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of models
-- ----------------------------
INSERT INTO `models` VALUES ('1', 'BORA', '1', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `models` VALUES ('2', 'PASSAT', '1', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `models` VALUES ('3', 'SURAN', '1', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `models` VALUES ('4', 'ASTRA', '2', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `models` VALUES ('5', 'VECTRA', '2', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `models` VALUES ('6', 'C3', '3', '2010-05-12 14:38:34', '2010-05-12 14:38:34');

-- ----------------------------
-- Table structure for `price_list_items`
-- ----------------------------
DROP TABLE IF EXISTS `price_list_items`;
CREATE TABLE `price_list_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price_list_id` int(11) DEFAULT NULL,
  `material_service_type_id` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of price_list_items
-- ----------------------------
INSERT INTO `price_list_items` VALUES ('22', '2', '9', '50', '2010-05-26 21:06:44', '2010-05-26 21:06:44');
INSERT INTO `price_list_items` VALUES ('26', '1', '9', '80', '2010-05-27 23:40:38', '2010-05-27 23:40:38');
INSERT INTO `price_list_items` VALUES ('27', '1', '1', '300', '2010-05-27 23:40:38', '2010-05-27 23:40:38');
INSERT INTO `price_list_items` VALUES ('28', '1', '5', '250', '2010-05-27 23:40:38', '2010-05-27 23:40:38');

-- ----------------------------
-- Table structure for `price_lists`
-- ----------------------------
DROP TABLE IF EXISTS `price_lists`;
CREATE TABLE `price_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of price_lists
-- ----------------------------
INSERT INTO `price_lists` VALUES ('1', 'Lista A', '1', '1', '2010-05-12 14:38:34', '2010-05-27 22:33:30');
INSERT INTO `price_lists` VALUES ('2', 'Lista B', '0', '1', '2010-05-12 14:38:34', '2010-05-27 22:33:30');

-- ----------------------------
-- Table structure for `ranks`
-- ----------------------------
DROP TABLE IF EXISTS `ranks`;
CREATE TABLE `ranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of ranks
-- ----------------------------

-- ----------------------------
-- Table structure for `roles`
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES ('1', 'company_admin', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `roles` VALUES ('2', 'company_employee', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `roles` VALUES ('3', 'car_owner', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `roles` VALUES ('4', 'super_admin', '2010-05-12 14:38:34', '2010-05-12 14:38:34');

-- ----------------------------
-- Table structure for `schema_migrations`
-- ----------------------------
DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of schema_migrations
-- ----------------------------
INSERT INTO `schema_migrations` VALUES ('20090312200013');
INSERT INTO `schema_migrations` VALUES ('20090313154144');
INSERT INTO `schema_migrations` VALUES ('20090313154641');
INSERT INTO `schema_migrations` VALUES ('20090313155312');
INSERT INTO `schema_migrations` VALUES ('20090313164011');
INSERT INTO `schema_migrations` VALUES ('20090313164030');
INSERT INTO `schema_migrations` VALUES ('20090314203004');
INSERT INTO `schema_migrations` VALUES ('20090323235026');
INSERT INTO `schema_migrations` VALUES ('20090323235114');
INSERT INTO `schema_migrations` VALUES ('20090323235219');
INSERT INTO `schema_migrations` VALUES ('20090331035116');
INSERT INTO `schema_migrations` VALUES ('20090331215847');
INSERT INTO `schema_migrations` VALUES ('20090401105206');
INSERT INTO `schema_migrations` VALUES ('20090401105359');
INSERT INTO `schema_migrations` VALUES ('20090604163203');
INSERT INTO `schema_migrations` VALUES ('20090717221424');
INSERT INTO `schema_migrations` VALUES ('20090818152833');
INSERT INTO `schema_migrations` VALUES ('20090910011602');
INSERT INTO `schema_migrations` VALUES ('20100322141327');
INSERT INTO `schema_migrations` VALUES ('20100322230455');
INSERT INTO `schema_migrations` VALUES ('20100322231042');
INSERT INTO `schema_migrations` VALUES ('20100403051616');
INSERT INTO `schema_migrations` VALUES ('20100403212215');
INSERT INTO `schema_migrations` VALUES ('20100403213940');
INSERT INTO `schema_migrations` VALUES ('20100519125613');
INSERT INTO `schema_migrations` VALUES ('20100522122438');
INSERT INTO `schema_migrations` VALUES ('20100522152617');

-- ----------------------------
-- Table structure for `service_filters`
-- ----------------------------
DROP TABLE IF EXISTS `service_filters`;
CREATE TABLE `service_filters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fuel` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `service_type_id` int(11) DEFAULT NULL,
  `model_id` int(11) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of service_filters
-- ----------------------------
INSERT INTO `service_filters` VALUES ('1', '', null, '', 'Auto Mendoza', '2', null, null, '1', '64810937', '1', '2010-05-22 14:18:47', '2010-05-22 14:18:47');

-- ----------------------------
-- Table structure for `service_offers`
-- ----------------------------
DROP TABLE IF EXISTS `service_offers`;
CREATE TABLE `service_offers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price` float DEFAULT NULL,
  `final_price` float DEFAULT NULL,
  `discount` float DEFAULT NULL,
  `percent` float DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `from` date DEFAULT NULL,
  `until` date DEFAULT NULL,
  `monday` tinyint(1) DEFAULT '0',
  `tuesday` tinyint(1) DEFAULT '0',
  `wednesday` tinyint(1) DEFAULT '0',
  `thursday` tinyint(1) DEFAULT '0',
  `friday` tinyint(1) DEFAULT '0',
  `saturday` tinyint(1) DEFAULT '0',
  `sunday` tinyint(1) DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `service_type_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `send_at` date DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of service_offers
-- ----------------------------
INSERT INTO `service_offers` VALUES ('13', '500', '450', null, '10', 'Enviado', '2010-05-27', '2010-05-31', '1', '1', '1', '1', '1', '1', '1', 'cambia tus neumaticos', '2', '1', null, 'Nuevo', '2010-05-27 20:38:33', '2010-05-27 20:45:56');

-- ----------------------------
-- Table structure for `service_types`
-- ----------------------------
DROP TABLE IF EXISTS `service_types`;
CREATE TABLE `service_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `kms` int(11) DEFAULT NULL,
  `periodic` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `active` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of service_types
-- ----------------------------
INSERT INTO `service_types` VALUES ('1', 'Cambio de Aceite', '10000', '6', '0', '1', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `service_types` VALUES ('2', 'Cambio de Neumaticos', '50000', '36', '0', '1', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `service_types` VALUES ('3', 'Balanceo', '40000', '24', '4', '1', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `service_types` VALUES ('4', 'Revisión Integral', '20000', '12', null, '1', '2010-05-12 14:38:34', '2010-05-15 13:58:41');
INSERT INTO `service_types` VALUES ('5', 'Tren Delantero', '60000', '48', '4', '1', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `service_types` VALUES ('6', 'Reparación General', null, null, '4', '0', '2010-05-15 13:45:08', '2010-05-15 13:45:08');
INSERT INTO `service_types` VALUES ('7', 'Reparación Tren Delantero', null, null, '6', '0', '2010-05-15 13:47:33', '2010-05-15 13:47:33');

-- ----------------------------
-- Table structure for `services`
-- ----------------------------
DROP TABLE IF EXISTS `services`;
CREATE TABLE `services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `row` int(11) DEFAULT NULL,
  `km` int(11) DEFAULT NULL,
  `service_type_id` int(11) DEFAULT NULL,
  `work_order_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of services
-- ----------------------------
INSERT INTO `services` VALUES ('5', null, '2', null, '2', '5', '2010-05-17 23:09:33', '2010-05-17 23:09:33');
INSERT INTO `services` VALUES ('6', null, '3', null, '2', '6', '2010-05-17 23:12:31', '2010-05-17 23:12:31');
INSERT INTO `services` VALUES ('7', null, '4', null, '2', '7', '2010-05-17 23:14:54', '2010-05-17 23:14:54');
INSERT INTO `services` VALUES ('8', null, '5', null, '2', '8', '2010-05-17 23:17:37', '2010-05-17 23:17:37');
INSERT INTO `services` VALUES ('9', null, '6', null, '2', '9', '2010-05-18 16:13:22', '2010-05-18 16:13:22');
INSERT INTO `services` VALUES ('10', null, '7', null, '2', '10', '2010-05-22 15:18:21', '2010-05-22 15:18:21');
INSERT INTO `services` VALUES ('11', null, '8', null, '2', '10', '2010-05-22 15:18:21', '2010-05-22 15:18:21');
INSERT INTO `services` VALUES ('12', null, '9', null, '2', '11', '2010-05-25 03:35:41', '2010-05-25 03:35:41');
INSERT INTO `services` VALUES ('13', null, '10', null, '2', '12', '2010-05-26 17:00:01', '2010-05-26 17:00:01');
INSERT INTO `services` VALUES ('14', null, '11', null, '2', '13', '2010-05-26 21:05:54', '2010-05-26 21:05:54');

-- ----------------------------
-- Table structure for `sessions`
-- ----------------------------
DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of sessions
-- ----------------------------
INSERT INTO `sessions` VALUES ('1', 'e0acaa6fd6d12b00d173626590ef5181', 'BAh7CzoLY2FyX2lkIgYxOgl1c2VyaQY6D3dvcmtfb3JkZXJvOg5Xb3JrT3Jk\nZXINOhxAbmV3X3JlY29yZF9iZWZvcmVfc2F2ZVQ6EEBuZXdfcmVjb3JkRjoM\nQGVycm9yc286GUFjdGl2ZVJlY29yZDo6RXJyb3JzBzsLSUM6H0FjdGl2ZVN1\ncHBvcnQ6Ok9yZGVyZWRIYXNoewAGOgpAa2V5c1sAOgpAYmFzZUAHOg5Ac2Vy\ndmljZXNvOjNBY3RpdmVSZWNvcmQ6OkFzc29jaWF0aW9uczo6SGFzTWFueUFz\nc29jaWF0aW9uCzoQQHJlZmxlY3Rpb25vOjRBY3RpdmVSZWNvcmQ6OlJlZmxl\nY3Rpb246OkFzc29jaWF0aW9uUmVmbGVjdGlvbg06C0BrbGFzc2MMU2Vydmlj\nZToWQHByaW1hcnlfa2V5X25hbWUiEndvcmtfb3JkZXJfaWQ6E0BhY3RpdmVf\ncmVjb3JkYw5Xb3JrT3JkZXI6C0BtYWNybzoNaGFzX21hbnk6F0BxdW90ZWRf\ndGFibGVfbmFtZSIPYHNlcnZpY2VzYDoQQGNsYXNzX25hbWUiDFNlcnZpY2U6\nCkBuYW1lOg1zZXJ2aWNlczoNQG9wdGlvbnN7BzoLZXh0ZW5kWwA6Cm9yZGVy\nOghyb3c6EEBmaW5kZXJfc3FsIiFgc2VydmljZXNgLndvcmtfb3JkZXJfaWQg\nPSAzOhFAY291bnRlcl9zcWxAFDoLQG93bmVyQAc6DEBsb2FkZWRUOgxAdGFy\nZ2V0WwZvOgxTZXJ2aWNlEDoQQHdvcmtfb3JkZXJvOjVBY3RpdmVSZWNvcmQ6\nOkFzc29jaWF0aW9uczo6QmVsb25nc1RvQXNzb2NpYXRpb24KOxJvOxMLOxRA\nDzsWQA07FzoPYmVsb25nc190bzsaIg5Xb3JrT3JkZXI7GzsHOx17ADsjQBY6\nDUB1cGRhdGVkVDskVDslQAc7CVQ6CUBjYXJvOygKOxJvOxMMOxRjCENhcjsV\nIgtjYXJfaWQ7FkANOxc7KTsaIghDYXI7GzoIY2FyOx17ADsjQBY7KlQ7JFQ7\nJW86CENhcgc6FkBhdHRyaWJ1dGVzX2NhY2hlewA6EEBhdHRyaWJ1dGVzexEi\nFWttQXZlcmFnZU1vbnRobHkiCTIwMDAiD3VwZGF0ZWRfYXQiGDIwMTAtMDUt\nMTIgMTQ6Mzg6MzMiDWJyYW5kX2lkIgYxIgtwdWJsaWMiBjEiB2ttIgk1MDAw\nIglmdWVsIgpOYWZ0YSILZG9tYWluIgtIUko1NDkiB2lkIgYxIgl5ZWFyIgky\nMDA5Igx1c2VyX2lkIgYxIg9jcmVhdGVkX2F0IhgyMDEwLTA1LTEyIDE0OjM4\nOjMzIg1tb2RlbF9pZCIGMTsKRjsLbzsMBzsLSUM7DXsABjsOWwA7D0AWOy57\nADoNQHJvd3NfaWRpBjoYQGNoYW5nZWRfYXR0cmlidXRlc3sAOy97DiILc3Rh\ndHVzMCIPdXBkYXRlZF9hdEl1OglUaW1lDY6RG4AgxRHYBjofQG1hcnNoYWxf\nd2l0aF91dGNfY29lcmNpb25UIgdrbTAiCHJvd2kHIhRzZXJ2aWNlX3R5cGVf\naWRpByISd29ya19vcmRlcl9pZGkIIgdpZGkIIgtjYXJfaWRpBiIPY3JlYXRl\nZF9hdEBEOhdAbWF0ZXJpYWxfc2VydmljZXNvOxELOxJvOxMNOxRjFE1hdGVy\naWFsU2VydmljZTsVIg9zZXJ2aWNlX2lkOxZADTsXOxg7GSIYYG1hdGVyaWFs\nX3NlcnZpY2VzYDsaIhRNYXRlcmlhbFNlcnZpY2U7GzoWbWF0ZXJpYWxfc2Vy\ndmljZXM7HXsHOx5bADsfOyA7ISInYG1hdGVyaWFsX3NlcnZpY2VzYC5zZXJ2\naWNlX2lkID0gMzsiQFQ7I0AWOyRUOyVbBm86FE1hdGVyaWFsU2VydmljZQw7\nCkY7C287DAc7C0lDOw17AAY7DlsAOw9AVjoMQGRldGFpbCI1WzY3ODJWQl0g\nQ3ViaWVydGEgR29vZHllYXIgRy0zMjAgMzU2LTE2ICQgMTAxLjY1OhtAbWF0\nZXJpYWxfc2VydmljZV90eXBlbzsoCjsSbzsTDDsVIh1tYXRlcmlhbF9zZXJ2\naWNlX3R5cGVfaWQ7FGMYTWF0ZXJpYWxTZXJ2aWNlVHlwZTsWQE47FzspOxoi\nGE1hdGVyaWFsU2VydmljZVR5cGU7HXsAOxs6Gm1hdGVyaWFsX3NlcnZpY2Vf\ndHlwZTsqVDsjQFY7JFQ7JW86GE1hdGVyaWFsU2VydmljZVR5cGUIOy57ADoO\nQG1hdGVyaWFsbzsoCTsSbzsTDDsVIhBtYXRlcmlhbF9pZDsUYw1NYXRlcmlh\nbDsWQF47FzspOxoiDU1hdGVyaWFsOxs6DW1hdGVyaWFsOx17ADsjQGE7JFQ7\nJW86DU1hdGVyaWFsBzsuewA7L3sNIgpicmFuZCINR29vZHllYXIiCW5hbWUi\nDUN1YmllcnRhIg91cGRhdGVkX2F0IhgyMDEwLTA1LTEyIDE0OjM4OjM0Iglj\nb2RlIgs2NzgyVkIiB2lkIgY0IhBtZWFzdXJlbWVudCILMzU2LTE2Igptb2Rl\nbCIKRy0zMjAiD2NyZWF0ZWRfYXQiGDIwMTAtMDUtMTIgMTQ6Mzg6MzQ7L3sK\nIhBtYXRlcmlhbF9pZCIGNCIPdXBkYXRlZF9hdCIYMjAxMC0wNS0xMiAxNDoz\nODozNCIUc2VydmljZV90eXBlX2lkIgYyIgdpZCIGMyIPY3JlYXRlZF9hdCIY\nMjAxMC0wNS0xMiAxNDozODozNDsuewA7MXsAOy97DSIPdXBkYXRlZF9hdEl1\nOzINjpEbgND7EdgGOzNUIgpwcmljZWYaMTAxLjY1MDAwMDAwMDAwMDAxAJma\nIghyb3dpCCIHaWRpCyIPc2VydmljZV9pZGkIIgthbW91bnRpByIdbWF0ZXJp\nYWxfc2VydmljZV90eXBlX2lkaQgiD2NyZWF0ZWRfYXRAAYY6EkBzZXJ2aWNl\nX3R5cGVvOygKOxJvOxMMOxRjEFNlcnZpY2VUeXBlOxUiFHNlcnZpY2VfdHlw\nZV9pZDsWQA07FzspOxoiEFNlcnZpY2VUeXBlOx17ADsbOhFzZXJ2aWNlX3R5\ncGU7KlQ7I0AWOyRUOyVvOhBTZXJ2aWNlVHlwZQc7LnsAOy97DSIJbmFtZSIZ\nQ2FtYmlvIGRlIE5ldW1hdGljb3MiD3VwZGF0ZWRfYXQiGDIwMTAtMDUtMTIg\nMTQ6Mzg6MzQiB2lkIgYyIghrbXMiCjUwMDAwIg1wZXJpb2RpYyIHMzYiDnBh\ncmVudF9pZCIGMCILYWN0aXZlIgYxIg9jcmVhdGVkX2F0IhgyMDEwLTA1LTEy\nIDE0OjM4OjM0Oy57ADswaQY7MXsAOy97CCIPdXBkYXRlZF9hdEl1OzINjpEb\ngKhbEdgGOzNUIgdpZGkIIg9jcmVhdGVkX2F0QAGsOhBfY3NyZl90b2tlbiIx\nNWJuUFpXYmczNHFyaE5CQWlxVWxia2d3U0pGdUZiRUtiSmVWeWc1cExkaz06\nDHNlcnZpY2VvOyYJOwpUOy57ADswaQA7L3sNIgtzdGF0dXMwIg91cGRhdGVk\nX2F0MCIHa20wIghyb3cwIhRzZXJ2aWNlX3R5cGVfaWQwIhJ3b3JrX29yZGVy\nX2lkMCILY2FyX2lkMCIPY3JlYXRlZF9hdDAiCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoLbm90aWNlIhxTZSBoYSBj\ncmVhZG8gbGEgb2ZlcnRhIQY6CkB1c2VkewY7RFQ=\n', '2010-05-12 13:16:33', '2010-05-12 15:08:14');
INSERT INTO `sessions` VALUES ('2', 'c3bbde40fb0000fb2d90dcba4450d318', 'BAh7CToJdXNlcmkGOg5yZXR1cm5fdG8iFC9zZXJ2aWNlX29mZmVyczoQX2Nz\ncmZfdG9rZW4iMVAwWVA5ejQwYktRSTI3YWJTdUIxcVlzL29PVGNNck5ZcENN\nZTRJSVlUN0k9IgpmbGFzaElDOidBY3Rpb25Db250cm9sbGVyOjpGbGFzaDo6\nRmxhc2hIYXNoewAGOgpAdXNlZHsA\n', '2010-05-12 15:15:45', '2010-05-12 15:22:49');
INSERT INTO `sessions` VALUES ('3', '7948c12b4e9469747da0ce66f3514f81', 'BAh7CToJdXNlcmkGOhBfY3NyZl90b2tlbiIxZ2xqa2JqSVhyWkcxY2ZlUUlF\nb0EyL0RQVktITXAzcmFwTzN2cUhLZzZxND0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA6DnJldHVy\nbl90byIeL3VzZXJzL2xpc3Rfc2VydmljZV9vZmZlcg==\n', '2010-05-12 15:22:53', '2010-05-12 16:27:40');
INSERT INTO `sessions` VALUES ('4', 'bd6f406a1743fc9352e7654e71041eca', 'BAh7CToJdXNlcmkIOhBfY3NyZl90b2tlbiIxVnBpVXFVQ1ZnbUgzck5Mb3Fq\nYWZnTWs4Wm1MRlVraDFYSlNFcTV1blhORT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA6DnJldHVy\nbl90byIeL3VzZXJzL2xpc3Rfc2VydmljZV9vZmZlcg==\n', '2010-05-12 22:32:06', '2010-05-12 22:33:08');
INSERT INTO `sessions` VALUES ('5', 'a4c8092283a638e5dcde89ce488eecc0', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxV2hlTGJOM2lkNmVYWEhPbFds\nM3R5Q2ZRSDA5Y0YvOE4yVGxWbzhpdUZlST0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-14 19:11:38', '2010-05-14 19:12:10');
INSERT INTO `sessions` VALUES ('6', 'd5f87e4bbba4fc0dd3b90becb6fd4180', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxTFpIYnkwMVFSd3pOZ2tGQ0Nn\nVEl5MXVFT252L0NudWhpTkY2a1pvNWtyUT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-14 19:12:43', '2010-05-14 19:36:26');
INSERT INTO `sessions` VALUES ('7', 'd0e9bde5d85b60f1c06cf0e60f86884d', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxb3RkbVQwZWxyN3B1WEJaTHla\nTlBlUUNyQWFKa29rZm81U2dLaXYzbmlzTT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-14 19:42:09', '2010-05-14 20:13:40');
INSERT INTO `sessions` VALUES ('8', 'e5724443a2deb64e1601e33ff0675352', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxQW5zdVQrYkxPVUVjV2RDK2Rh\ndm9tT1M5VWpxZzFnTEpIYXRaRUhwUWM0TT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-14 22:14:47', '2010-05-14 22:15:07');
INSERT INTO `sessions` VALUES ('9', '238e7639f9d11eda817cde226856ac32', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxY3FqVENrU1g5VElFUFY4aTBP\neXpQdk9GVHBZRXRKdTZXdE93ZGx6MU9Gcz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-14 23:08:51', '2010-05-14 23:08:58');
INSERT INTO `sessions` VALUES ('10', '909a2eaeb3628ca31a4e01ceb3ced5cb', 'BAh7CDoJdXNlcmkJOhBfY3NyZl90b2tlbiIxYXN4NzB3RlZXTGgxTnZxQUJR\nSG1SLzhEdVYwc3lXSTdXbTh0WEFvUitKUT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-15 11:47:18', '2010-05-15 11:54:38');
INSERT INTO `sessions` VALUES ('11', '7d6d5fabffcaebf6dd9ad7f0bfcfb7fe', 'BAh7CDoJdXNlcmkJOhBfY3NyZl90b2tlbiIxZlkxM1FValFJQURoTWJnMlVH\nR1JUT3h6eGo1K04vMSttcFJrMXdaWFdxVT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-15 11:56:23', '2010-05-15 11:59:51');
INSERT INTO `sessions` VALUES ('12', 'f1e9da6ca12fc44df82ff63b57e1ce2e', 'BAh7CzoPd29ya19vcmRlcm86DldvcmtPcmRlcgo6DkBzZXJ2aWNlc286M0Fj\ndGl2ZVJlY29yZDo6QXNzb2NpYXRpb25zOjpIYXNNYW55QXNzb2NpYXRpb24L\nOhBAcmVmbGVjdGlvbm86NEFjdGl2ZVJlY29yZDo6UmVmbGVjdGlvbjo6QXNz\nb2NpYXRpb25SZWZsZWN0aW9uDToWQHByaW1hcnlfa2V5X25hbWUiEndvcmtf\nb3JkZXJfaWQ6C0BrbGFzc2MMU2VydmljZToTQGFjdGl2ZV9yZWNvcmRjDldv\ncmtPcmRlcjoXQHF1b3RlZF90YWJsZV9uYW1lIg9gc2VydmljZXNgOgtAbWFj\ncm86DWhhc19tYW55OhBAY2xhc3NfbmFtZSIMU2VydmljZToNQG9wdGlvbnN7\nBzoLZXh0ZW5kWwA6Cm9yZGVyOghyb3c6CkBuYW1lOg1zZXJ2aWNlczoRQGNv\ndW50ZXJfc3FsIiRgc2VydmljZXNgLndvcmtfb3JkZXJfaWQgPSBOVUxMOhBA\nZmluZGVyX3NxbEAQOgxAbG9hZGVkVDoLQG93bmVyQAY6DEB0YXJnZXRbBm86\nDFNlcnZpY2UOOhJAc2VydmljZV90eXBlbzo1QWN0aXZlUmVjb3JkOjpBc3Nv\nY2lhdGlvbnM6OkJlbG9uZ3NUb0Fzc29jaWF0aW9uCjsJbzsKDDsLIhRzZXJ2\naWNlX3R5cGVfaWQ7DGMQU2VydmljZVR5cGU7DUAKOw86D2JlbG9uZ3NfdG87\nESIQU2VydmljZVR5cGU7FjoRc2VydmljZV90eXBlOxJ7ADoNQHVwZGF0ZWRU\nOxtAEjsaVDscbzoQU2VydmljZVR5cGUHOhZAYXR0cmlidXRlc19jYWNoZXsA\nOhBAYXR0cmlidXRlc3sNIgluYW1lIhlDYW1iaW8gZGUgTmV1bWF0aWNvcyIP\ndXBkYXRlZF9hdCIYMjAxMC0wNS0xMiAxNDozODozNCIHaWQiBjIiCGttcyIK\nNTAwMDAiDnBhcmVudF9pZCIGMCINcGVyaW9kaWMiBzM2Ig9jcmVhdGVkX2F0\nIhgyMDEwLTA1LTEyIDE0OjM4OjM0IgthY3RpdmUiBjE6EEB3b3JrX29yZGVy\nbzsfCjsJbzsKCzsMQAs7DUAKOw87IDsRIg5Xb3JrT3JkZXI7EnsAOxY7ADsi\nVDsaVDsbQBI7HEAGOhBAbmV3X3JlY29yZFQ6DUByb3dzX2lkaQY7JHsAOhdA\nbWF0ZXJpYWxfc2VydmljZXNvOwgLOwlvOwoNOwxjFE1hdGVyaWFsU2Vydmlj\nZTsLIg9zZXJ2aWNlX2lkOw1ACjsPOxA7DiIYYG1hdGVyaWFsX3NlcnZpY2Vz\nYDsRIhRNYXRlcmlhbFNlcnZpY2U7FjoWbWF0ZXJpYWxfc2VydmljZXM7EnsH\nOxNbADsUOxU7GSIqYG1hdGVyaWFsX3NlcnZpY2VzYC5zZXJ2aWNlX2lkID0g\nTlVMTDsYQDk7G0ASOxpUOxxbBm86FE1hdGVyaWFsU2VydmljZQs7J1Q7JHsA\nOhtAbWF0ZXJpYWxfc2VydmljZV90eXBlbzsfCjsJbzsKDDsMYxhNYXRlcmlh\nbFNlcnZpY2VUeXBlOwsiHW1hdGVyaWFsX3NlcnZpY2VfdHlwZV9pZDsNQDM7\nDzsgOxEiGE1hdGVyaWFsU2VydmljZVR5cGU7FjoabWF0ZXJpYWxfc2Vydmlj\nZV90eXBlOxJ7ADsiVDsbQDs7GlQ7HG86GE1hdGVyaWFsU2VydmljZVR5cGUI\nOyR7ADoOQG1hdGVyaWFsbzsfCTsJbzsKDDsMYw1NYXRlcmlhbDsLIhBtYXRl\ncmlhbF9pZDsNQD87DzsgOxEiDU1hdGVyaWFsOxJ7ADsWOg1tYXRlcmlhbDsa\nVDsbQEM7HG86DU1hdGVyaWFsBzskewA7JXsNIgluYW1lIg1DdWJpZXJ0YSIK\nYnJhbmQiDkZpcmVzdG9uZSIPdXBkYXRlZF9hdCIYMjAxMC0wNS0xMiAxNDoz\nODozNCIJY29kZSILNDMyMkdUIgdpZCIGMyIQbWVhc3VyZW1lbnQiCzM1Ni0x\nOCIKbW9kZWwiCkYtMzIwIg9jcmVhdGVkX2F0IhgyMDEwLTA1LTEyIDE0OjM4\nOjM0OyV7CiIPdXBkYXRlZF9hdCIYMjAxMC0wNS0xMiAxNDozODozNCIQbWF0\nZXJpYWxfaWQiBjMiFHNlcnZpY2VfdHlwZV9pZCIGMiIHaWQiBjIiD2NyZWF0\nZWRfYXQiGDIwMTAtMDUtMTIgMTQ6Mzg6MzQ6DEBkZXRhaWwiNFs0MzIyR1Rd\nIEN1YmllcnRhIEZpcmVzdG9uZSBGLTMyMCAzNTYtMTggJCAyMy41OyV7DCIP\ndXBkYXRlZF9hdDAiCnByaWNlZgkyMy41Ighyb3dpBiIPc2VydmljZV9pZDAi\nC2Ftb3VudGkHIh1tYXRlcmlhbF9zZXJ2aWNlX3R5cGVfaWRpByIPY3JlYXRl\nZF9hdDA6GEBjaGFuZ2VkX2F0dHJpYnV0ZXN7CSIKcHJpY2UwIghyb3cwIgth\nbW91bnQwIh1tYXRlcmlhbF9zZXJ2aWNlX3R5cGVfaWQwOyV7DSILc3RhdHVz\nMCIPdXBkYXRlZF9hdDAiB2ttMCIIcm93aQYiFHNlcnZpY2VfdHlwZV9pZGkH\nIhJ3b3JrX29yZGVyX2lkMCILY2FyX2lkaQsiD2NyZWF0ZWRfYXQwOzN7CCII\ncm93MCIUc2VydmljZV90eXBlX2lkMCILY2FyX2lkMDoJQGNhcm87Hwo7CW87\nCgw7CyILY2FyX2lkOwxjCENhcjsNQAo7DzsgOxEiCENhcjsSewA7FjoIY2Fy\nOyJUOxpUOxtAEjscbzoIQ2FyBzskewA7JXsRIhVrbUF2ZXJhZ2VNb250aGx5\nIgkxMDAwIg1icmFuZF9pZCIGMyIPdXBkYXRlZF9hdCIYMjAxMC0wNS0xNSAx\nMTo0OToyNiIHa20iCjYwMDAwIgtwdWJsaWMiBjAiC2RvbWFpbiILTExMMTIz\nIglmdWVsIghHYXMiB2lkIgY2Igl5ZWFyIgkyMDAwIgx1c2VyX2lkIgY0Ig1t\nb2RlbF9pZCIGNiIPY3JlYXRlZF9hdCIYMjAxMC0wNS0xNSAxMTo0OToyNjsn\nVDsoaQY7JHsAOyV7ByIPdXBkYXRlZF9hdDAiD2NyZWF0ZWRfYXQwOgtjYXJf\naWQiBjY6CXVzZXJpBjoQX2NzcmZfdG9rZW4iMUdGeGVsUThGK3Y5cG9RUnFK\nRWpSbUQ2Z013SE1pRHR0RzZZY1NpOWJYbUk9OgxzZXJ2aWNlbzsdCTsnVDso\naQA7JHsAOyV7DSILc3RhdHVzMCIPdXBkYXRlZF9hdDAiB2ttMCISd29ya19v\ncmRlcl9pZDAiFHNlcnZpY2VfdHlwZV9pZDAiCHJvdzAiC2Nhcl9pZDAiD2Ny\nZWF0ZWRfYXQwIgpmbGFzaElDOidBY3Rpb25Db250cm9sbGVyOjpGbGFzaDo6\nRmxhc2hIYXNoewAGOgpAdXNlZHsA\n', '2010-05-15 11:56:24', '2010-05-15 13:52:03');
INSERT INTO `sessions` VALUES ('13', 'c724be4e34403ce3dbc55d189aae3355', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxWldxTmRhMm9PdXVuWnRGREVk\nbzdZeFJtbWc1YlRjQlFNNDgyNFkvV2xGYz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-15 11:57:07', '2010-05-15 11:57:22');
INSERT INTO `sessions` VALUES ('14', '90393cfa3980326d56b93d9769eca925', 'BAh7CToJdXNlcmkIOhBtYXRlcmlhbF9pZCIGNjoQX2NzcmZfdG9rZW4iMStT\nWFE3ZlByZGpZNUN4RDhzKzZ5bGZUancyMG9XejJvNkwzTDFvSEFvcDg9Igpm\nbGFzaElDOidBY3Rpb25Db250cm9sbGVyOjpGbGFzaDo6Rmxhc2hIYXNoewAG\nOgpAdXNlZHsA\n', '2010-05-15 11:59:00', '2010-05-15 13:52:42');
INSERT INTO `sessions` VALUES ('15', 'a6b8ecfff4f50be64caac7dc981883fa', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxZytJKzJUUEVkZjVMeWFtUGRy\ndnRXZUNpYThqd1hTanNsQVRTSEpWRUdlbz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-15 13:52:56', '2010-05-15 13:53:05');
INSERT INTO `sessions` VALUES ('16', '358194bfc97b70edcf50227e1be0129c', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxSkhYQVdzbEpBVDQ5WmJwR2tk\nOFFXMHp0VElkUE9hNGE4cHZRU2R1OGNpQT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoLbm90aWNlIiNVZHMuIGEg\naW5ncmVzYWRvIGNvbiBFeGl0byAhISEGOgpAdXNlZHsGOwhU\n', '2010-05-15 13:53:15', '2010-05-15 13:54:15');
INSERT INTO `sessions` VALUES ('17', 'e2c27f3fe8484b41d0cf3b195a80647c', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxM0RsZE1xaUliVDBmVU1ZQ1gy\neFFuaDViRXdIVDkveG9jMGwreE1GVDMxZz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-15 13:54:35', '2010-05-15 13:54:46');
INSERT INTO `sessions` VALUES ('18', '80c4511856b3d230f7d2a794ae1ccf25', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxdkpON3hjb3BoVStsL2NMNzB6\nbVJHOEUyaUc5ZVlwVytEeURXM1IxU1pDTT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoLbm90aWNlIipTZXJ2aWNl\nVHlwZSB3YXMgc3VjY2Vzc2Z1bGx5IHVwZGF0ZWQuBjoKQHVzZWR7BjsIVA==\n', '2010-05-15 13:54:49', '2010-05-15 13:58:42');
INSERT INTO `sessions` VALUES ('19', '91a7eb0e5ac12e920413b337ac3ada58', 'BAh7CzoPd29ya19vcmRlcm86DldvcmtPcmRlcgk6EEBuZXdfcmVjb3JkVDoW\nQGF0dHJpYnV0ZXNfY2FjaGV7ADoNQHJvd3NfaWRpADoQQGF0dHJpYnV0ZXN7\nByIPdXBkYXRlZF9hdDAiD2NyZWF0ZWRfYXQwOgl1c2VyaQY6C2Nhcl9pZCIG\nNjoQX2NzcmZfdG9rZW4iMVg2YzF3am5DT3llck4rM1M2bmM5V1VMYXg5Z2l2\nVWFGRkR6QUg4S1FoVms9OgxzZXJ2aWNlbzoMU2VydmljZQo7B1Q7CHsAOhdA\nbWF0ZXJpYWxfc2VydmljZXNvOjNBY3RpdmVSZWNvcmQ6OkFzc29jaWF0aW9u\nczo6SGFzTWFueUFzc29jaWF0aW9uCzoQQHJlZmxlY3Rpb25vOjRBY3RpdmVS\nZWNvcmQ6OlJlZmxlY3Rpb246OkFzc29jaWF0aW9uUmVmbGVjdGlvbg06FkBw\ncmltYXJ5X2tleV9uYW1lIg9zZXJ2aWNlX2lkOgtAa2xhc3NjFE1hdGVyaWFs\nU2VydmljZToTQGFjdGl2ZV9yZWNvcmRjDFNlcnZpY2U6F0BxdW90ZWRfdGFi\nbGVfbmFtZSIYYG1hdGVyaWFsX3NlcnZpY2VzYDoLQG1hY3JvOg1oYXNfbWFu\neToQQGNsYXNzX25hbWUiFE1hdGVyaWFsU2VydmljZToNQG9wdGlvbnN7BzoL\nZXh0ZW5kWwA6Cm9yZGVyOghyb3c6CkBuYW1lOhZtYXRlcmlhbF9zZXJ2aWNl\nczoRQGNvdW50ZXJfc3FsIipgbWF0ZXJpYWxfc2VydmljZXNgLnNlcnZpY2Vf\naWQgPSBOVUxMOhBAZmluZGVyX3NxbEAYOgxAbG9hZGVkVDoLQG93bmVyQA06\nDEB0YXJnZXRbADsJaQA7CnsNIgtzdGF0dXMwIg91cGRhdGVkX2F0MCIHa20w\nIhJ3b3JrX29yZGVyX2lkMCIUc2VydmljZV90eXBlX2lkMCIIcm93MCILY2Fy\nX2lkMCIPY3JlYXRlZF9hdDAiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6\nOkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-15 13:59:26', '2010-05-17 11:31:26');
INSERT INTO `sessions` VALUES ('20', 'bf120728b15a5e66ea174bfefcf6081a', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxeUUrOUR0ZzNPbFlzb3lUZEtS\ncVNVRzNGUWlBQWhJdHdSRVlCTVVxL2hvZz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-17 11:31:28', '2010-05-17 11:31:37');
INSERT INTO `sessions` VALUES ('21', '74cfaac5f32f1b7abccbf180bcbe2239', 'BAh7CzoPd29ya19vcmRlcm86DldvcmtPcmRlcg46HEBuZXdfcmVjb3JkX2Jl\nZm9yZV9zYXZlVDoQQG5ld19yZWNvcmRGOg5Ac2VydmljZXNvOjNBY3RpdmVS\nZWNvcmQ6OkFzc29jaWF0aW9uczo6SGFzTWFueUFzc29jaWF0aW9uCzoQQHJl\nZmxlY3Rpb25vOjRBY3RpdmVSZWNvcmQ6OlJlZmxlY3Rpb246OkFzc29jaWF0\naW9uUmVmbGVjdGlvbg06FkBwcmltYXJ5X2tleV9uYW1lIhJ3b3JrX29yZGVy\nX2lkOgtAa2xhc3NjDFNlcnZpY2U6E0BhY3RpdmVfcmVjb3JkYw5Xb3JrT3Jk\nZXI6F0BxdW90ZWRfdGFibGVfbmFtZSIPYHNlcnZpY2VzYDoLQG1hY3JvOg1o\nYXNfbWFueToQQGNsYXNzX25hbWUiDFNlcnZpY2U6DUBvcHRpb25zewc6C2V4\ndGVuZFsAOgpvcmRlcjoIcm93OgpAbmFtZToNc2VydmljZXM6DEBsb2FkZWRU\nOhFAY291bnRlcl9zcWwiIWBzZXJ2aWNlc2Aud29ya19vcmRlcl9pZCA9IDg6\nEEBmaW5kZXJfc3FsQBA6C0Bvd25lckAGOgxAdGFyZ2V0WwZvOgxTZXJ2aWNl\nDzoXQG1hdGVyaWFsX3NlcnZpY2VzbzsKCzsLbzsMDTsOYxRNYXRlcmlhbFNl\ncnZpY2U7DSIPc2VydmljZV9pZDsPQAo7ETsSOxAiGGBtYXRlcmlhbF9zZXJ2\naWNlc2A7EyIUTWF0ZXJpYWxTZXJ2aWNlOxg6Fm1hdGVyaWFsX3NlcnZpY2Vz\nOxR7BzsVWwA7FjsXOxpUOxwiJ2BtYXRlcmlhbF9zZXJ2aWNlc2Auc2Vydmlj\nZV9pZCA9IDg7G0AbOx1AEjseWwZvOhRNYXRlcmlhbFNlcnZpY2UMOwhGOgxA\nZXJyb3JzbzoZQWN0aXZlUmVjb3JkOjpFcnJvcnMHOyNJQzofQWN0aXZlU3Vw\ncG9ydDo6T3JkZXJlZEhhc2h7AAY6CkBrZXlzWwA6CkBiYXNlQB06FkBhdHRy\naWJ1dGVzX2NhY2hlewA6G0BtYXRlcmlhbF9zZXJ2aWNlX3R5cGVvOjVBY3Rp\ndmVSZWNvcmQ6OkFzc29jaWF0aW9uczo6QmVsb25nc1RvQXNzb2NpYXRpb24K\nOwtvOwwMOw5jGE1hdGVyaWFsU2VydmljZVR5cGU7DSIdbWF0ZXJpYWxfc2Vy\ndmljZV90eXBlX2lkOw9AFTsROg9iZWxvbmdzX3RvOxMiGE1hdGVyaWFsU2Vy\ndmljZVR5cGU7GDoabWF0ZXJpYWxfc2VydmljZV90eXBlOxR7ADoNQHVwZGF0\nZWRUOxpUOx1AHTsebzoYTWF0ZXJpYWxTZXJ2aWNlVHlwZQg6DkBtYXRlcmlh\nbG87Kgk7C287DAw7DmMNTWF0ZXJpYWw7DSIQbWF0ZXJpYWxfaWQ7D0AkOxE7\nKzsTIg1NYXRlcmlhbDsUewA7GDoNbWF0ZXJpYWw7GlQ7HUAoOx5vOg1NYXRl\ncmlhbAc7KHsAOhBAYXR0cmlidXRlc3sNIgluYW1lIg1DdWJpZXJ0YSIKYnJh\nbmQiDkZpcmVzdG9uZSIPdXBkYXRlZF9hdCIYMjAxMC0wNS0xMiAxNDozODoz\nNCIJY29kZSILNDMyMkdUIgdpZCIGMyIQbWVhc3VyZW1lbnQiCzM1Ni0xOCIK\nbW9kZWwiCkYtMzIwIg9jcmVhdGVkX2F0IhgyMDEwLTA1LTEyIDE0OjM4OjM0\nOyh7ADsyewoiD3VwZGF0ZWRfYXQiGDIwMTAtMDUtMTIgMTQ6Mzg6MzQiEG1h\ndGVyaWFsX2lkIgYzIhRzZXJ2aWNlX3R5cGVfaWQiBjIiB2lkIgYyIg9jcmVh\ndGVkX2F0IhgyMDEwLTA1LTEyIDE0OjM4OjM0OzJ7DSIPdXBkYXRlZF9hdEl1\nOglUaW1lDTeSG4AAL11GBjofQG1hcnNoYWxfd2l0aF91dGNfY29lcmNpb25U\nIgpwcmljZWYJMjMuNSIIcm93aQ0iD3NlcnZpY2VfaWRpDSIHaWRpECILYW1v\ndW50aQciHW1hdGVyaWFsX3NlcnZpY2VfdHlwZV9pZGkHIg9jcmVhdGVkX2F0\nQFA6GEBjaGFuZ2VkX2F0dHJpYnV0ZXN7ADoMQGRldGFpbCI0WzQzMjJHVF0g\nQ3ViaWVydGEgRmlyZXN0b25lIEYtMzIwIDM1Ni0xOCAkIDIzLjU7B1Q7CEY6\nEkBzZXJ2aWNlX3R5cGVvOyoKOwtvOwwMOw0iFHNlcnZpY2VfdHlwZV9pZDsO\nYxBTZXJ2aWNlVHlwZTsPQAo7ETsrOxMiEFNlcnZpY2VUeXBlOxg6EXNlcnZp\nY2VfdHlwZTsUewA7LVQ7GlQ7HUASOx5vOhBTZXJ2aWNlVHlwZQc7KHsAOzJ7\nDSIJbmFtZSIZQ2FtYmlvIGRlIE5ldW1hdGljb3MiD3VwZGF0ZWRfYXQiGDIw\nMTAtMDUtMTIgMTQ6Mzg6MzQiB2lkIgYyIghrbXMiCjUwMDAwIg5wYXJlbnRf\naWQiBjAiDXBlcmlvZGljIgczNiIPY3JlYXRlZF9hdCIYMjAxMC0wNS0xMiAx\nNDozODozNCILYWN0aXZlIgYxOhBAd29ya19vcmRlcm87Kgo7C287DAs7DkAL\nOw9ACjsROys7EyIOV29ya09yZGVyOxR7ADsYOwA7LVQ7GlQ7HUASOx5ABjsj\nbzskBzsjSUM7JXsABjsmWwA7J0ASOyh7ADoNQHJvd3NfaWRpBjsyew0iC3N0\nYXR1czAiD3VwZGF0ZWRfYXRJdTszDTeSG4Cw6FxGBjs0VCIHa20wIghyb3dp\nCiIUc2VydmljZV90eXBlX2lkaQciEndvcmtfb3JkZXJfaWRpDSIHaWRpDSIP\nY3JlYXRlZF9hdEB/OzV7ADsjbzskBzsjSUM7JXsABjsmWwA7J0AGOyh7ADs7\naQY7MnsJIg91cGRhdGVkX2F0SXU7Mw03khuASKZcRgY7NFQiB2lkaQ0iC2Nh\ncl9pZGkGIg9jcmVhdGVkX2F0QAGIOzV7ADoJQGNhcm87Kgo7C287DAw7DmMI\nQ2FyOw0iC2Nhcl9pZDsPQAs7ETsrOxMiCENhcjsYOghjYXI7FHsAOy1UOxpU\nOx1ABjsebzoIQ2FyDDsHRjoNQGNvbXBhbnlvOyoKOwtvOwwMOw5jDENvbXBh\nbnk7DSIPY29tcGFueV9pZDsPQAGPOxE7KzsTIgxDb21wYW55Oxg6DGNvbXBh\nbnk7FHsAOy1UOxpUOx1AAZM7Hm86DENvbXBhbnkHOyh7ADsyexAiCWNpdHki\nC0NpdWRhZCIJbmFtZSIbTmV1bWF0aWNvIFZhbGxlIEdyYW5kZSIPdXBkYXRl\nZF9hdCIYMjAxMC0wNS0xNyAxMjozMjowNCIIemlwIgAiD2NvdW50cnlfaWQw\nIgx3ZWJzaXRlIgAiB2lkIgYzIgpwaG9uZSIAIg1zdGF0ZV9pZDAiDGFkZHJl\nc3MiACIPY3JlYXRlZF9hdCIYMjAxMC0wNS0xNyAxMjozMjowNDoLQG1vZGVs\nbzsqCTsLbzsMDDsNIg1tb2RlbF9pZDsOYwpNb2RlbDsPQAGPOxE7KzsTIgpN\nb2RlbDsYOgptb2RlbDsUewA7GlQ7HUABkzsebzoKTW9kZWwHOyh7ADsyewoi\nCW5hbWUiCUJPUkEiD3VwZGF0ZWRfYXQiGDIwMTAtMDUtMTIgMTQ6Mzg6MzQi\nDWJyYW5kX2lkIgYxIgdpZCIGMSIPY3JlYXRlZF9hdCIYMjAxMC0wNS0xMiAx\nNDozODozNDsjbzskBzsjSUM7JXsABjsmWwA7J0ABkzsoewA7MnsSIhVrbUF2\nZXJhZ2VNb250aGx5IgkyMDAwIg91cGRhdGVkX2F0SXU7Mw03khuAKF5bRgY7\nNFQiDWJyYW5kX2lkIgYxIgtwdWJsaWMiBjEiB2ttIgk1MDAwIglmdWVsIgpO\nYWZ0YSILZG9tYWluIgtIUko1NDkiB2lkIgYxIg9jb21wYW55X2lkaQgiCXll\nYXIiCTIwMDkiDHVzZXJfaWQiBjEiD2NyZWF0ZWRfYXQiGDIwMTAtMDUtMTIg\nMTQ6Mzg6MzMiDW1vZGVsX2lkIgYxOzV7ADoJdXNlcmkLOgtjYXJfaWQiBjE6\nEF9jc3JmX3Rva2VuIjE2SWVzL2ZLVXBXQ0VvOG9PNk5EcTFaTndYd0VkQlVY\nSitXWXlGR1NYVkhJPToMc2VydmljZW87Hwk7CFQ7KHsAOztpADsyewwiC3N0\nYXR1czAiD3VwZGF0ZWRfYXQwIgdrbTAiEndvcmtfb3JkZXJfaWQwIhRzZXJ2\naWNlX3R5cGVfaWQwIghyb3cwIg9jcmVhdGVkX2F0MCIKZmxhc2hJQzonQWN0\naW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7AA==\n', '2010-05-17 12:17:19', '2010-05-18 13:46:52');
INSERT INTO `sessions` VALUES ('22', '65d202a98c7eba59fc6bfb3f1bb042d9', 'BAh7CzoPd29ya19vcmRlcm86DldvcmtPcmRlcg46DUByb3dzX2lkaQY6HEBu\nZXdfcmVjb3JkX2JlZm9yZV9zYXZlVDoQQG5ld19yZWNvcmRGOgxAZXJyb3Jz\nbzoZQWN0aXZlUmVjb3JkOjpFcnJvcnMHOwpJQzofQWN0aXZlU3VwcG9ydDo6\nT3JkZXJlZEhhc2h7AAY6CkBrZXlzWwA6CkBiYXNlQAY6FkBhdHRyaWJ1dGVz\nX2NhY2hlewA6EEBhdHRyaWJ1dGVzewkiD3VwZGF0ZWRfYXRJdToJVGltZQ1Q\nkhuAoDJfNQY6H0BtYXJzaGFsX3dpdGhfdXRjX2NvZXJjaW9uVCIHaWRpDiIL\nY2FyX2lkaQsiD2NyZWF0ZWRfYXRADToYQGNoYW5nZWRfYXR0cmlidXRlc3sA\nOglAY2Fybzo1QWN0aXZlUmVjb3JkOjpBc3NvY2lhdGlvbnM6OkJlbG9uZ3NU\nb0Fzc29jaWF0aW9uCjoQQHJlZmxlY3Rpb25vOjRBY3RpdmVSZWNvcmQ6OlJl\nZmxlY3Rpb246OkFzc29jaWF0aW9uUmVmbGVjdGlvbgw6C0BrbGFzc2MIQ2Fy\nOhZAcHJpbWFyeV9rZXlfbmFtZSILY2FyX2lkOhNAYWN0aXZlX3JlY29yZGMO\nV29ya09yZGVyOgtAbWFjcm86D2JlbG9uZ3NfdG86EEBjbGFzc19uYW1lIghD\nYXI6CkBuYW1lOghjYXI6DUBvcHRpb25zewA6DUB1cGRhdGVkVDoMQGxvYWRl\nZFQ6C0Bvd25lckAGOgxAdGFyZ2V0bzoIQ2FyDDoLQG1vZGVsbzsVCTsWbzsX\nDDsZIg1tb2RlbF9pZDsYYwpNb2RlbDsaQBQ7GzscOx0iCk1vZGVsOx46Cm1v\nZGVsOyB7ADsiVDsjQBk7JG86Ck1vZGVsBzsPewA7EHsKIgluYW1lIgdDMyIP\ndXBkYXRlZF9hdCIYMjAxMC0wNS0xMiAxNDozODozNCINYnJhbmRfaWQiBjMi\nB2lkIgY2Ig9jcmVhdGVkX2F0IhgyMDEwLTA1LTEyIDE0OjM4OjM0OwhGOwpv\nOwsHOwpJQzsMewAGOw1bADsOQBk7D3sAOxB7EiIVa21BdmVyYWdlTW9udGhs\neSIJMTAwMCIPdXBkYXRlZF9hdCIYMjAxMC0wNS0xNSAxMTo0OToyNiINYnJh\nbmRfaWQiBjMiC3B1YmxpYyIGMCIHa20iCjYwMDAwIglmdWVsIghHYXMiC2Rv\nbWFpbiILTExMMTIzIgdpZCIGNiIPY29tcGFueV9pZGkIIgl5ZWFyIgkyMDAw\nIgx1c2VyX2lkIgY0Ig9jcmVhdGVkX2F0IhgyMDEwLTA1LTE1IDExOjQ5OjI2\nIg1tb2RlbF9pZCIGNjsTewA6DUBjb21wYW55bzsVCjsWbzsXDDsYYwxDb21w\nYW55OxkiD2NvbXBhbnlfaWQ7GkAUOxs7HDsdIgxDb21wYW55Ox46DGNvbXBh\nbnk7IHsAOyFUOyJUOyNAGTskbzoMQ29tcGFueQc7D3sAOxB7ECIJY2l0eSIL\nQ2l1ZGFkIgluYW1lIhtOZXVtYXRpY28gVmFsbGUgR3JhbmRlIg91cGRhdGVk\nX2F0IhgyMDEwLTA1LTE3IDEyOjMyOjA0Igh6aXAiACIPY291bnRyeV9pZDAi\nDHdlYnNpdGUiACIHaWQiBjMiCnBob25lIgAiDXN0YXRlX2lkMCIMYWRkcmVz\ncyIAIg9jcmVhdGVkX2F0IhgyMDEwLTA1LTE3IDEyOjMyOjA0Og5Ac2Vydmlj\nZXNvOjNBY3RpdmVSZWNvcmQ6OkFzc29jaWF0aW9uczo6SGFzTWFueUFzc29j\naWF0aW9uCzsWbzsXDTsZIhJ3b3JrX29yZGVyX2lkOxhjDFNlcnZpY2U7GkAW\nOhdAcXVvdGVkX3RhYmxlX25hbWUiD2BzZXJ2aWNlc2A7GzoNaGFzX21hbnk7\nHSIMU2VydmljZTsgewc6C2V4dGVuZFsAOgpvcmRlcjoIcm93Ox46DXNlcnZp\nY2VzOyJUOhFAY291bnRlcl9zcWwiIWBzZXJ2aWNlc2Aud29ya19vcmRlcl9p\nZCA9IDk6EEBmaW5kZXJfc3FsQHE7I0AGOyRbBm86DFNlcnZpY2UPOhJAc2Vy\ndmljZV90eXBlbzsVCjsWbzsXDDsZIhRzZXJ2aWNlX3R5cGVfaWQ7GGMQU2Vy\ndmljZVR5cGU7GkBsOxs7HDsdIhBTZXJ2aWNlVHlwZTseOhFzZXJ2aWNlX3R5\ncGU7IHsAOyFUOyJUOyNAczskbzoQU2VydmljZVR5cGUHOw97ADsQew0iCW5h\nbWUiGUNhbWJpbyBkZSBOZXVtYXRpY29zIg91cGRhdGVkX2F0IhgyMDEwLTA1\nLTEyIDE0OjM4OjM0IgdpZCIGMiIIa21zIgo1MDAwMCIOcGFyZW50X2lkIgYw\nIg1wZXJpb2RpYyIHMzYiD2NyZWF0ZWRfYXQiGDIwMTAtMDUtMTIgMTQ6Mzg6\nMzQiC2FjdGl2ZSIGMTsHaQY7CFQ7CUY7Cm87Cwc7CklDOwx7AAY7DVsAOw5A\nczoXQG1hdGVyaWFsX3NlcnZpY2VzbzstCzsWbzsXDTsYYxRNYXRlcmlhbFNl\ncnZpY2U7GSIPc2VydmljZV9pZDsaQGw7GzsvOy4iGGBtYXRlcmlhbF9zZXJ2\naWNlc2A7HSIUTWF0ZXJpYWxTZXJ2aWNlOx46Fm1hdGVyaWFsX3NlcnZpY2Vz\nOyB7BzswWwA7MTsyOyJUOzUiJ2BtYXRlcmlhbF9zZXJ2aWNlc2Auc2Vydmlj\nZV9pZCA9IDk7NEABkzsjQHM7JFsGbzoUTWF0ZXJpYWxTZXJ2aWNlDDobQG1h\ndGVyaWFsX3NlcnZpY2VfdHlwZW87FQo7Fm87Fww7GGMYTWF0ZXJpYWxTZXJ2\naWNlVHlwZTsZIh1tYXRlcmlhbF9zZXJ2aWNlX3R5cGVfaWQ7GkABjTsbOxw7\nHSIYTWF0ZXJpYWxTZXJ2aWNlVHlwZTseOhptYXRlcmlhbF9zZXJ2aWNlX3R5\ncGU7IHsAOyFUOyJUOyNAAZU7JG86GE1hdGVyaWFsU2VydmljZVR5cGUIOw97\nADoOQG1hdGVyaWFsbzsVCTsWbzsXDDsYYw1NYXRlcmlhbDsZIhBtYXRlcmlh\nbF9pZDsaQAGYOxs7HDsdIg1NYXRlcmlhbDsgewA7HjoNbWF0ZXJpYWw7IlQ7\nI0ABnDskbzoNTWF0ZXJpYWwHOw97ADsQew0iCW5hbWUiDUN1YmllcnRhIgpi\ncmFuZCIORmlyZXN0b25lIg91cGRhdGVkX2F0IhgyMDEwLTA1LTEyIDE0OjM4\nOjM0Igljb2RlIgs0MzIyR1QiB2lkIgYzIhBtZWFzdXJlbWVudCILMzU2LTE4\nIgptb2RlbCIKRi0zMjAiD2NyZWF0ZWRfYXQiGDIwMTAtMDUtMTIgMTQ6Mzg6\nMzQ7EHsKIg91cGRhdGVkX2F0IhgyMDEwLTA1LTEyIDE0OjM4OjM0IhBtYXRl\ncmlhbF9pZCIGMyIUc2VydmljZV90eXBlX2lkIgYyIgdpZCIGMiIPY3JlYXRl\nZF9hdCIYMjAxMC0wNS0xMiAxNDozODozNDsJRjoMQGRldGFpbCI0WzQzMjJH\nVF0gQ3ViaWVydGEgRmlyZXN0b25lIEYtMzIwIDM1Ni0xOCAkIDIzLjU7Cm87\nCwc7CklDOwx7AAY7DVsAOw5AAZU7D3sAOxB7DSIPdXBkYXRlZF9hdEl1OxEN\nUJIbgDi7YjUGOxJUIgpwcmljZWYJMjMuNSIIcm93aQ4iD3NlcnZpY2VfaWRp\nDiIHaWRpESILYW1vdW50aQciHW1hdGVyaWFsX3NlcnZpY2VfdHlwZV9pZGkH\nIg9jcmVhdGVkX2F0QAHJOxN7ADsPewA6EEB3b3JrX29yZGVybzsVCjsWbzsX\nCzsYQBY7GkBsOxs7HDsdIg5Xb3JrT3JkZXI7IHsAOx47ADshVDsiVDsjQHM7\nJEAGOxB7DSILc3RhdHVzMCIPdXBkYXRlZF9hdEl1OxENUJIbgHALYjUGOxJU\nIgdrbTAiCHJvd2kLIhRzZXJ2aWNlX3R5cGVfaWRpByISd29ya19vcmRlcl9p\nZGkOIgdpZGkOIg9jcmVhdGVkX2F0QAHbOxN7ADoJdXNlcmkLOgtjYXJfaWQi\nBjY6EF9jc3JmX3Rva2VuIjFYQVNnYUtDM2QyL2s3WEkwM3E4TlZpS1UyWEhD\nT2pGc01kSU1aVjdmWVRvPToMc2VydmljZW87Ngk7B2kAOwlUOw97ADsQewwi\nC3N0YXR1czAiD3VwZGF0ZWRfYXQwIgdrbTAiEndvcmtfb3JkZXJfaWQwIhRz\nZXJ2aWNlX3R5cGVfaWQwIghyb3cwIg9jcmVhdGVkX2F0MCIKZmxhc2hJQzon\nQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7\nAA==\n', '2010-05-18 15:11:05', '2010-05-18 22:52:16');
INSERT INTO `sessions` VALUES ('23', 'c97ec4825798e5aa89af68345e21dc8c', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxYk1xdWh5YXJkc1NWaXdDb0tG\nMVZ4b3doWHc2Vkp0OFZXa0luN1g3Y0lCdz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-19 20:23:34', '2010-05-19 20:23:48');
INSERT INTO `sessions` VALUES ('24', '74302b507ff64e4e9facf37e57fab187', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxMWlOZHhoNHpFbFZWRXQ3OXlN\namU2VjBhM2pCcVdZblZRSWp6SFZNSmZHND0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-19 20:24:12', '2010-05-19 20:24:21');
INSERT INTO `sessions` VALUES ('25', 'c7f41d70f0d10e9a171a6f7aa37ae00a', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxek1XWEZ6elN3YTdaYWhWSGYw\nUGFGT1ZkRTRvbGNZVm11MG11c1I1aUtjbz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-20 13:11:55', '2010-05-20 13:12:13');
INSERT INTO `sessions` VALUES ('26', 'eed2a17d04f0179eef5caf48382d4255', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxVlRDU2RsYVYxR0NlM2p1MVV2\nSC8wbHEweXFWWktRSzMrVjVxQUlRbDZhRT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-20 13:12:14', '2010-05-20 13:12:25');
INSERT INTO `sessions` VALUES ('27', 'c258d878e015e201389df7be28273e9a', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxVG9kOXBhTzA2UnFBOExzQVVP\nbGQvYTB4L2NQN2tqWG5obDRWSExjQnRWaz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-22 11:17:44', '2010-05-22 11:18:34');
INSERT INTO `sessions` VALUES ('28', 'dbbc5d791cc5bfad43f626188be68a7b', 'BAh7CToOcmV0dXJuX3RvIh4vdXNlcnMvbGlzdF9zZXJ2aWNlX29mZmVyOgl1\nc2VyaQs6EF9jc3JmX3Rva2VuIjFIcXhYY3FLWkNjaGh5SFJNVXdmYnllMFBw\nQk5jY0ZqVmt2SGhEYU04M3JFPSIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxl\ncjo6Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7AA==\n', '2010-05-22 11:18:56', '2010-05-22 11:42:14');
INSERT INTO `sessions` VALUES ('29', '3fd80cc9aaa3e135a15c52de4fec5f0c', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxWTNBb2I0dEJQcVhscDhEbXpQ\nTmFaeFJkKzVNbWZ5cU5ibWRSSHh4T2hQTT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoLbm90aWNlIiRVZHMuIGhh\nIGluZ3Jlc2FkbyBjb24gRXhpdG8gISEhBjoKQHVzZWR7BjsIVA==\n', '2010-05-22 11:19:09', '2010-05-22 11:20:10');
INSERT INTO `sessions` VALUES ('30', '8f01d867e000668e2dde5404fa4418cf', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxN2dDOFBpbUl1dnZOS3NyN0lo\naE1XSHZpL3lRMEJlclpPZHVvRW5iWGtqbz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoLbm90aWNlIiFTZSBoYSBh\nY3R1YWxpemFkbyBsYSBvZmVydGEhBjoKQHVzZWR7BjsIVA==\n', '2010-05-22 11:24:31', '2010-05-22 14:21:03');
INSERT INTO `sessions` VALUES ('31', 'c52df6b5470947fa909be345172eadce', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxaDhZZUYzZzB3Qk5VNWtQU1Vw\nV1h3Z2hkZFJUUTJrSUJ6aUVKVzVmckdwUT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-22 11:28:40', '2010-05-22 11:28:53');
INSERT INTO `sessions` VALUES ('32', '5a64fa64d9585873df0bc51f513c545b', 'BAh7CzoJdXNlcmkJOg5yZXR1cm5fdG8iFC9zZXJ2aWNlX29mZmVyczoPd29y\na19vcmRlcm86DldvcmtPcmRlcgk6DUByb3dzX2lkaQA6EEBuZXdfcmVjb3Jk\nVDoWQGF0dHJpYnV0ZXNfY2FjaGV7ADoQQGF0dHJpYnV0ZXN7CCIPdXBkYXRl\nZF9hdDAiC2Nhcl9pZDAiD2NyZWF0ZWRfYXQwOhBfY3NyZl90b2tlbiIxZ2FG\nNlE4czhsTEFKRFhOT3BNSXh2ZUZjSlRHQXZtZ3hLdytnOHRqUTQwRT06DHNl\ncnZpY2VvOgxTZXJ2aWNlCTsJaQA7ClQ7C3sAOwx7DCILc3RhdHVzMCIPdXBk\nYXRlZF9hdDAiB2ttMCIIcm93MCIUc2VydmljZV90eXBlX2lkMCISd29ya19v\ncmRlcl9pZDAiD2NyZWF0ZWRfYXQwIgpmbGFzaElDOidBY3Rpb25Db250cm9s\nbGVyOjpGbGFzaDo6Rmxhc2hIYXNoewAGOgpAdXNlZHsA\n', '2010-05-22 11:33:41', '2010-05-22 15:22:58');
INSERT INTO `sessions` VALUES ('33', '5c93dbfe172c0b54449ceec7ca392852', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxenBiSkhQeGRjTzQxd3Q0SDBk\ndC9wTXhYWC9xR1hYRUZiUlZqUU5Yc0FwND0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-22 14:33:24', '2010-05-22 14:33:31');
INSERT INTO `sessions` VALUES ('34', 'be650aaf1c5cc03131c106477e26b6a6', 'BAh7CzoJdXNlcmkGOg93b3JrX29yZGVybzoOV29ya09yZGVyCzoQQG5ld19y\nZWNvcmRUOhZAYXR0cmlidXRlc19jYWNoZXsAOglAY2Fybzo1QWN0aXZlUmVj\nb3JkOjpBc3NvY2lhdGlvbnM6OkJlbG9uZ3NUb0Fzc29jaWF0aW9uCjoQQHJl\nZmxlY3Rpb25vOjRBY3RpdmVSZWNvcmQ6OlJlZmxlY3Rpb246OkFzc29jaWF0\naW9uUmVmbGVjdGlvbgw6FkBwcmltYXJ5X2tleV9uYW1lIgtjYXJfaWQ6C0Br\nbGFzc2MIQ2FyOhNAYWN0aXZlX3JlY29yZGMOV29ya09yZGVyOgtAbWFjcm86\nD2JlbG9uZ3NfdG86EEBjbGFzc19uYW1lIghDYXI6DUBvcHRpb25zewA6CkBu\nYW1lOghjYXI6DUB1cGRhdGVkVDoMQGxvYWRlZFQ6C0Bvd25lckAGOgxAdGFy\nZ2V0bzoIQ2FyBzsJewA6EEBhdHRyaWJ1dGVzexIiFWttQXZlcmFnZU1vbnRo\nbHkiCTEwMDAiDWJyYW5kX2lkIgYzIg91cGRhdGVkX2F0IhgyMDEwLTA1LTI1\nIDAzOjM1OjQxIgdrbSIKNjAwMDAiC3B1YmxpYyIGMCILZG9tYWluIgtMTEwx\nMjMiCWZ1ZWwiCEdhcyIHaWQiBjYiCXllYXIiCTIwMDAiD2NvbXBhbnlfaWQi\nBjEiDHVzZXJfaWQiBjQiDW1vZGVsX2lkIgY2Ig9jcmVhdGVkX2F0IhgyMDEw\nLTA1LTE1IDExOjQ5OjI2OhhAY2hhbmdlZF9hdHRyaWJ1dGVzewYiC2Nhcl9p\nZDA7HHsKIg91cGRhdGVkX2F0MCIRdXNlcl9yYW5rX2lkMCIUY29tcGFueV9y\nYW5rX2lkMCILY2FyX2lkaQsiD2NyZWF0ZWRfYXQwOg1Acm93c19pZGkAOhBf\nY3NyZl90b2tlbiIxR2U0QWFOVjB0U1V4WFRhOE0xYlZxQjRvSnlHR2dNWWJI\nVEhkTUcxNGxSYz06DHNlcnZpY2VvOgxTZXJ2aWNlCjsIVDoXQG1hdGVyaWFs\nX3NlcnZpY2VzbzozQWN0aXZlUmVjb3JkOjpBc3NvY2lhdGlvbnM6Okhhc01h\nbnlBc3NvY2lhdGlvbgs7DG87DQ07DiIPc2VydmljZV9pZDsPYxRNYXRlcmlh\nbFNlcnZpY2U7EGMMU2VydmljZToXQHF1b3RlZF90YWJsZV9uYW1lIhhgbWF0\nZXJpYWxfc2VydmljZXNgOxE6DWhhc19tYW55OxMiFE1hdGVyaWFsU2Vydmlj\nZTsUewc6C2V4dGVuZFsAOgpvcmRlcjoIcm93OxU6Fm1hdGVyaWFsX3NlcnZp\nY2VzOxhUOhFAY291bnRlcl9zcWwiKmBtYXRlcmlhbF9zZXJ2aWNlc2Auc2Vy\ndmljZV9pZCA9IE5VTEw6EEBmaW5kZXJfc3FsQD87GUA1OxpbADsJewA7HHsM\nIgtzdGF0dXMwIg91cGRhdGVkX2F0MCIHa20wIhJ3b3JrX29yZGVyX2lkMCIU\nc2VydmljZV90eXBlX2lkMCIIcm93MCIPY3JlYXRlZF9hdDA7HmkAOgtjYXJf\naWQiBjYiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6OkZsYXNoOjpGbGFz\naEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-22 15:11:38', '2010-05-25 04:01:04');
INSERT INTO `sessions` VALUES ('35', '598ab55a48c2c4b96690a3fdb15090e7', 'BAh7CDoJdXNlcmkJOhBfY3NyZl90b2tlbiIxYnlCVTZRc2dPZlJBRXA3RkhS\nclVmVXdhNkpxMHBtOUp1eXc4UitIOVFNWT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-24 02:32:49', '2010-05-24 02:42:19');
INSERT INTO `sessions` VALUES ('36', '2ae773363f1df7742c648bc72b9ccf87', 'BAh7CDoJdXNlcmkLOhBfY3NyZl90b2tlbiIxNVpoeXVUdlVOQmVtYzgxQlN5\ndzd5bW5VN0c3RlVWNWJKMUZmcGRqMXcrMD0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-24 02:33:10', '2010-05-24 02:36:36');
INSERT INTO `sessions` VALUES ('37', '87efdbbf0f7fbe825217abff220744ad', 'BAh7CDoJdXNlcmkJOhBfY3NyZl90b2tlbiIxNURIT2J6b1V1OVMrSkdIU0pN\nRWFDRUZsMHlDRTdhOU1qRWptT2xWQ1V0RT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-26 00:57:43', '2010-05-26 02:52:28');
INSERT INTO `sessions` VALUES ('38', '8903bd32bc0de89960030b0e8a78f5cd', 'BAh7CjoJdXNlcmkIOhFzZXJ2aWNlX3R5cGUiBjE6EF9jc3JmX3Rva2VuIjFo\nU1dxSjgrNWprV1ZkRmtBRWVlWDZSdDNVN2VLVU9FR0RZWlFGd1NXR3FFPToQ\nbWF0ZXJpYWxfaWQiBjYiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6OkZs\nYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-26 00:58:03', '2010-05-26 16:37:16');
INSERT INTO `sessions` VALUES ('39', 'b012488d5f1ef8a0708e05e87af28162', 'BAh7CzoJdXNlcmkGOg93b3JrX29yZGVybzoOV29ya09yZGVyCzoQQG5ld19y\nZWNvcmRUOg1Acm93c19pZGkAOhZAYXR0cmlidXRlc19jYWNoZXsAOhhAY2hh\nbmdlZF9hdHRyaWJ1dGVzewYiC2Nhcl9pZDA6EEBhdHRyaWJ1dGVzewsiD3Vw\nZGF0ZWRfYXQwIhF1c2VyX3JhbmtfaWQwIhRjb21wYW55X3JhbmtfaWQwIgtj\nYXJfaWRpBiIPY29tcGFueV9pZDAiD2NyZWF0ZWRfYXQwOglAY2Fybzo1QWN0\naXZlUmVjb3JkOjpBc3NvY2lhdGlvbnM6OkJlbG9uZ3NUb0Fzc29jaWF0aW9u\nCjoQQHJlZmxlY3Rpb25vOjRBY3RpdmVSZWNvcmQ6OlJlZmxlY3Rpb246OkFz\nc29jaWF0aW9uUmVmbGVjdGlvbgw6E0BhY3RpdmVfcmVjb3JkYw5Xb3JrT3Jk\nZXI6C0BtYWNybzoPYmVsb25nc190bzoQQGNsYXNzX25hbWUiCENhcjoKQG5h\nbWU6CGNhcjoNQG9wdGlvbnN7ADoLQGtsYXNzYwhDYXI6FkBwcmltYXJ5X2tl\neV9uYW1lIgtjYXJfaWQ6C0Bvd25lckAGOg1AdXBkYXRlZFQ6DEBsb2FkZWRU\nOgxAdGFyZ2V0bzoIQ2FyBzsKewA7DHsSIhVrbUF2ZXJhZ2VNb250aGx5Igky\nMDAwIg91cGRhdGVkX2F0IhgyMDEwLTA1LTIyIDE1OjE4OjIxIg1icmFuZF9p\nZCIGMSILcHVibGljIgYxIgdrbSIJNTAwMCIJZnVlbCIKTmFmdGEiC2RvbWFp\nbiILSFJKNTQ5IgdpZCIGMSIPY29tcGFueV9pZCIGMSIJeWVhciIJMjAwOSIM\ndXNlcl9pZCIGMSIPY3JlYXRlZF9hdCIYMjAxMC0wNS0xMiAxNDozODozMyIN\nbW9kZWxfaWQiBjE6C2Nhcl9pZCIGMToQX2NzcmZfdG9rZW4iMUJ2OVdtU0hu\nOURqdHZaTGw3TERXKzhGVWVkOHdxV3FTSFUzZ1VMdXk3d0k9OgxzZXJ2aWNl\nbzoMU2VydmljZQo7CFQ7CWkAOhdAbWF0ZXJpYWxfc2VydmljZXNvOjNBY3Rp\ndmVSZWNvcmQ6OkFzc29jaWF0aW9uczo6SGFzTWFueUFzc29jaWF0aW9uCzsP\nbzsQDTsRYwxTZXJ2aWNlOxI6DWhhc19tYW55OhdAcXVvdGVkX3RhYmxlX25h\nbWUiGGBtYXRlcmlhbF9zZXJ2aWNlc2A7FCIUTWF0ZXJpYWxTZXJ2aWNlOxU6\nFm1hdGVyaWFsX3NlcnZpY2VzOxd7BzoLZXh0ZW5kWwA6Cm9yZGVyOghyb3c7\nGGMUTWF0ZXJpYWxTZXJ2aWNlOxkiD3NlcnZpY2VfaWQ6EEBmaW5kZXJfc3Fs\nIipgbWF0ZXJpYWxfc2VydmljZXNgLnNlcnZpY2VfaWQgPSBOVUxMOhFAY291\nbnRlcl9zcWxAQTsaQDc7HFQ7HVsAOwp7ADsMewwiC3N0YXR1czAiD3VwZGF0\nZWRfYXQwIgdrbTAiCHJvdzAiFHNlcnZpY2VfdHlwZV9pZDAiEndvcmtfb3Jk\nZXJfaWQwIg9jcmVhdGVkX2F0MCIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxl\ncjo6Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7AA==\n', '2010-05-26 00:58:43', '2010-05-26 12:11:14');
INSERT INTO `sessions` VALUES ('40', 'a3f7f123f3f79fb41b4d8aabc9a6f7ab', 'BAh7CzoJdXNlcmkLOg93b3JrX29yZGVybzoOV29ya09yZGVyCzoQQG5ld19y\nZWNvcmRUOg1Acm93c19pZGkAOhZAYXR0cmlidXRlc19jYWNoZXsAOhhAY2hh\nbmdlZF9hdHRyaWJ1dGVzewYiC2Nhcl9pZDA6EEBhdHRyaWJ1dGVzewsiD3Vw\nZGF0ZWRfYXQwIhF1c2VyX3JhbmtfaWQwIhRjb21wYW55X3JhbmtfaWQwIgtj\nYXJfaWRpCSIPY29tcGFueV9pZDAiD2NyZWF0ZWRfYXQwOglAY2Fybzo1QWN0\naXZlUmVjb3JkOjpBc3NvY2lhdGlvbnM6OkJlbG9uZ3NUb0Fzc29jaWF0aW9u\nCjoQQHJlZmxlY3Rpb25vOjRBY3RpdmVSZWNvcmQ6OlJlZmxlY3Rpb246OkFz\nc29jaWF0aW9uUmVmbGVjdGlvbgw6E0BhY3RpdmVfcmVjb3JkYw5Xb3JrT3Jk\nZXI6C0BtYWNybzoPYmVsb25nc190bzoQQGNsYXNzX25hbWUiCENhcjoNQG9w\ndGlvbnN7ADoKQG5hbWU6CGNhcjoWQHByaW1hcnlfa2V5X25hbWUiC2Nhcl9p\nZDoLQGtsYXNzYwhDYXI6C0Bvd25lckAGOg1AdXBkYXRlZFQ6DEBsb2FkZWRU\nOgxAdGFyZ2V0bzoIQ2FyBzsKewA7DHsSIhVrbUF2ZXJhZ2VNb250aGx5Igg4\nMDAiDWJyYW5kX2lkIgYyIg91cGRhdGVkX2F0IhgyMDEwLTA1LTEyIDE0OjM4\nOjMzIgdrbSIKMTIwMDAiC3B1YmxpYyIGMCILZG9tYWluIgtGR0cyMTIiCWZ1\nZWwiC0dhc29pbCIHaWQiBjQiCXllYXIiCTIwMDkiD2NvbXBhbnlfaWQiBjMi\nDHVzZXJfaWQiBjYiDW1vZGVsX2lkIgY1Ig9jcmVhdGVkX2F0IhgyMDEwLTA1\nLTEyIDE0OjM4OjMzOhBfY3NyZl90b2tlbiIxamtsK2dQcUZQNlN0UmppNXR6\ncmh6RGRLTDdFdVdWaHU2d1F1dkpXczArbz06C2Nhcl9pZCIGNDoMc2Vydmlj\nZW86DFNlcnZpY2UKOwhUOhdAbWF0ZXJpYWxfc2VydmljZXNvOjNBY3RpdmVS\nZWNvcmQ6OkFzc29jaWF0aW9uczo6SGFzTWFueUFzc29jaWF0aW9uCzsPbzsQ\nDTsRYwxTZXJ2aWNlOhdAcXVvdGVkX3RhYmxlX25hbWUiGGBtYXRlcmlhbF9z\nZXJ2aWNlc2A7EjoNaGFzX21hbnk7FCIUTWF0ZXJpYWxTZXJ2aWNlOxV7BzoL\nZXh0ZW5kWwA6Cm9yZGVyOghyb3c7FjoWbWF0ZXJpYWxfc2VydmljZXM7GCIP\nc2VydmljZV9pZDsZYxRNYXRlcmlhbFNlcnZpY2U6EUBjb3VudGVyX3NxbCIq\nYG1hdGVyaWFsX3NlcnZpY2VzYC5zZXJ2aWNlX2lkID0gTlVMTDoQQGZpbmRl\ncl9zcWxAQTsaQDc7HFQ7HVsAOwlpADsKewA7DHsMIgtzdGF0dXMwIg91cGRh\ndGVkX2F0MCIHa20wIhJ3b3JrX29yZGVyX2lkMCIUc2VydmljZV90eXBlX2lk\nMCIIcm93MCIPY3JlYXRlZF9hdDAiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xs\nZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-26 01:46:38', '2010-05-26 11:57:03');
INSERT INTO `sessions` VALUES ('41', 'e55a7adf0b29f2bb76f0ef5a02a7cc4a', 'BAh7CjoQbWF0ZXJpYWxfaWQiBjI6CXVzZXJpCDoRc2VydmljZV90eXBlIgYz\nOhBfY3NyZl90b2tlbiIxOTNBM3VxV01qdysvbkszMDFERmF5ZTNBUmk0RmEy\ndDdmTkVqcVZWMVNocz0iCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6OkZs\nYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-26 12:22:55', '2010-05-26 12:47:38');
INSERT INTO `sessions` VALUES ('42', '757728102e3e745b0c862eb0bada5bf7', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxclNXK2s0ZjJDazhvVU43YVYx\nQysxVGE3KzBMV29jay9UQW9zREVZR0ZRMD0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-26 12:47:58', '2010-05-26 12:48:44');
INSERT INTO `sessions` VALUES ('43', '4a690889f7c063d61b0a2a7a28f90100', 'BAh7CzoLY2FyX2lkIgYxOgl1c2VyaQY6D3dvcmtfb3JkZXJvOg5Xb3JrT3Jk\nZXILOhBAbmV3X3JlY29yZFQ6CUBjYXJvOjVBY3RpdmVSZWNvcmQ6OkFzc29j\naWF0aW9uczo6QmVsb25nc1RvQXNzb2NpYXRpb24KOhBAcmVmbGVjdGlvbm86\nNEFjdGl2ZVJlY29yZDo6UmVmbGVjdGlvbjo6QXNzb2NpYXRpb25SZWZsZWN0\naW9uDDoTQGFjdGl2ZV9yZWNvcmRjDldvcmtPcmRlcjoLQG1hY3JvOg9iZWxv\nbmdzX3RvOhBAY2xhc3NfbmFtZSIIQ2FyOg1Ab3B0aW9uc3sAOgpAbmFtZToI\nY2FyOhZAcHJpbWFyeV9rZXlfbmFtZSILY2FyX2lkOgtAa2xhc3NjCENhcjoL\nQG93bmVyQAc6DUB1cGRhdGVkVDoMQGxvYWRlZFQ6DEB0YXJnZXRvOghDYXIH\nOhZAYXR0cmlidXRlc19jYWNoZXsAOhBAYXR0cmlidXRlc3sSIhVrbUF2ZXJh\nZ2VNb250aGx5IgkyMDAwIg1icmFuZF9pZCIGMSIPdXBkYXRlZF9hdCIYMjAx\nMC0wNS0yMiAxNToxODoyMSIHa20iCTUwMDAiC3B1YmxpYyIGMSILZG9tYWlu\nIgtIUko1NDkiCWZ1ZWwiCk5hZnRhIgdpZCIGMSIJeWVhciIJMjAwOSIPY29t\ncGFueV9pZCIGMSIMdXNlcl9pZCIGMSINbW9kZWxfaWQiBjEiD2NyZWF0ZWRf\nYXQiGDIwMTAtMDUtMTIgMTQ6Mzg6MzM7HHsAOhhAY2hhbmdlZF9hdHRyaWJ1\ndGVzewYiC2Nhcl9pZDA7HXsLIg91cGRhdGVkX2F0MCIRdXNlcl9yYW5rX2lk\nMCIUY29tcGFueV9yYW5rX2lkMCILY2FyX2lkaQYiD2NvbXBhbnlfaWQwIg9j\ncmVhdGVkX2F0MDoNQHJvd3NfaWRpADoQX2NzcmZfdG9rZW4iMWdQYno4dVJV\nVEF3OHl6WnNaRkpRZzNFWlNFMElra0hRa2RzOGl2Syt5a2s9OgxzZXJ2aWNl\nbzoMU2VydmljZQw7CVQ6F0BtYXRlcmlhbF9zZXJ2aWNlc286M0FjdGl2ZVJl\nY29yZDo6QXNzb2NpYXRpb25zOjpIYXNNYW55QXNzb2NpYXRpb24LOhFAY291\nbnRlcl9zcWwiKmBtYXRlcmlhbF9zZXJ2aWNlc2Auc2VydmljZV9pZCA9IE5V\nTEw6EEBmaW5kZXJfc3FsQDk7DG87DQ07DmMMU2VydmljZToXQHF1b3RlZF90\nYWJsZV9uYW1lIhhgbWF0ZXJpYWxfc2VydmljZXNgOw86DWhhc19tYW55OxEi\nFE1hdGVyaWFsU2VydmljZTsSewc6C2V4dGVuZFsAOgpvcmRlcjoIcm93OxM6\nFm1hdGVyaWFsX3NlcnZpY2VzOxUiD3NlcnZpY2VfaWQ7FmMUTWF0ZXJpYWxT\nZXJ2aWNlOxdANzsZVDsaWwZvOhRNYXRlcmlhbFNlcnZpY2ULOhtAbWF0ZXJp\nYWxfc2VydmljZV90eXBlbzsLCjsMbzsNDDsOQEE7DzsQOxEiGE1hdGVyaWFs\nU2VydmljZVR5cGU7EnsAOxM6Gm1hdGVyaWFsX3NlcnZpY2VfdHlwZTsVIh1t\nYXRlcmlhbF9zZXJ2aWNlX3R5cGVfaWQ7FmMYTWF0ZXJpYWxTZXJ2aWNlVHlw\nZTsXQEM7GFQ7GVQ7Gm86GE1hdGVyaWFsU2VydmljZVR5cGUHOxx7ADsdewoi\nEG1hdGVyaWFsX2lkIgY2Ig91cGRhdGVkX2F0IhgyMDEwLTA1LTI2IDEyOjEy\nOjE5IhRzZXJ2aWNlX3R5cGVfaWQiBjIiB2lkIgY5Ig9jcmVhdGVkX2F0Ihgy\nMDEwLTA1LTI2IDEyOjEyOjE5OwlUOgxAZGV0YWlsIi9bTU0zNDVdIE1hbm8g\nZGUgT2JyYSBPcGVyYXJpbyBNb2RlbG8gICQgNTA7HHsAOx57CSIKcHJpY2Uw\nIghyb3cwIgthbW91bnQwIh1tYXRlcmlhbF9zZXJ2aWNlX3R5cGVfaWQwOx17\nDCIPdXBkYXRlZF9hdDAiCnByaWNlZgc1MCIIcm93aQYiD3NlcnZpY2VfaWQw\nIgthbW91bnRpByIdbWF0ZXJpYWxfc2VydmljZV90eXBlX2lkaQ4iD2NyZWF0\nZWRfYXQwOxx7ADoSQHNlcnZpY2VfdHlwZW87Cwo7DG87DQw7DkA7Ow87EDsR\nIhBTZXJ2aWNlVHlwZTsSewA7EzoRc2VydmljZV90eXBlOxZjEFNlcnZpY2VU\neXBlOxUiFHNlcnZpY2VfdHlwZV9pZDsXQDc7GFQ7GVQ7Gm86EFNlcnZpY2VU\neXBlBzscewA7HXsNIgluYW1lIhlDYW1iaW8gZGUgTmV1bWF0aWNvcyIPdXBk\nYXRlZF9hdCIYMjAxMC0wNS0xMiAxNDozODozNCIHaWQiBjIiCGttcyIKNTAw\nMDAiDXBlcmlvZGljIgczNiIOcGFyZW50X2lkIgYwIgthY3RpdmUiBjEiD2Ny\nZWF0ZWRfYXQiGDIwMTAtMDUtMTIgMTQ6Mzg6MzQ7HnsGIhRzZXJ2aWNlX3R5\ncGVfaWQwOx17DCILc3RhdHVzMCIPdXBkYXRlZF9hdDAiB2ttMCISd29ya19v\ncmRlcl9pZDAiFHNlcnZpY2VfdHlwZV9pZGkHIghyb3cwIg9jcmVhdGVkX2F0\nMDsfaQYiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6OkZsYXNoOjpGbGFz\naEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-26 16:37:00', '2010-05-26 22:08:22');
INSERT INTO `sessions` VALUES ('44', '8d96c50c926b6b391ed68c8ccb85428b', 'BAh7CjoJdXNlcmkIOg5yZXR1cm5fdG8iGS9wcmljZV9saXN0cy8xL2l0ZW1z\nOhBtYXRlcmlhbF9pZCIGNjoQX2NzcmZfdG9rZW4iMUZWK2FaOG1QWW95K0NX\nSG1PWnlTcjhzVkdhMG83Z3ZaRVRwOHMrZ0ppOHc9IgpmbGFzaElDOidBY3Rp\nb25Db250cm9sbGVyOjpGbGFzaDo6Rmxhc2hIYXNoewAGOgpAdXNlZHsA\n', '2010-05-26 20:46:39', '2010-05-26 23:59:15');
INSERT INTO `sessions` VALUES ('45', '75bf677f6126387f45de1a49c950c651', 'BAh7CzoLY2FyX2lkIgYxOgl1c2VyaQY6D3dvcmtfb3JkZXJvOg5Xb3JrT3Jk\nZXILOhBAbmV3X3JlY29yZFQ6FkBhdHRyaWJ1dGVzX2NhY2hlewA6DUByb3dz\nX2lkaQA6CUBjYXJvOjVBY3RpdmVSZWNvcmQ6OkFzc29jaWF0aW9uczo6QmVs\nb25nc1RvQXNzb2NpYXRpb24KOhBAcmVmbGVjdGlvbm86NEFjdGl2ZVJlY29y\nZDo6UmVmbGVjdGlvbjo6QXNzb2NpYXRpb25SZWZsZWN0aW9uDDoTQGFjdGl2\nZV9yZWNvcmRjDldvcmtPcmRlcjoLQG1hY3JvOg9iZWxvbmdzX3RvOhBAY2xh\nc3NfbmFtZSIIQ2FyOgpAbmFtZToIY2FyOg1Ab3B0aW9uc3sAOgtAa2xhc3Nj\nCENhcjoWQHByaW1hcnlfa2V5X25hbWUiC2Nhcl9pZDoLQG93bmVyQAc6DUB1\ncGRhdGVkVDoMQGxvYWRlZFQ6DEB0YXJnZXRvOghDYXIHOwp7ADoQQGF0dHJp\nYnV0ZXN7EiIVa21BdmVyYWdlTW9udGhseSIJMjAwMCIPdXBkYXRlZF9hdCIY\nMjAxMC0wNS0yMiAxNToxODoyMSINYnJhbmRfaWQiBjEiC3B1YmxpYyIGMSIH\na20iCTUwMDAiCWZ1ZWwiCk5hZnRhIgtkb21haW4iC0hSSjU0OSIHaWQiBjEi\nD2NvbXBhbnlfaWQiBjEiCXllYXIiCTIwMDkiDHVzZXJfaWQiBjQiD2NyZWF0\nZWRfYXQiGDIwMTAtMDUtMTIgMTQ6Mzg6MzMiDW1vZGVsX2lkIgYxOhhAY2hh\nbmdlZF9hdHRyaWJ1dGVzewYiC2Nhcl9pZDA7HnsLIg91cGRhdGVkX2F0MCIR\ndXNlcl9yYW5rX2lkMCIUY29tcGFueV9yYW5rX2lkMCILY2FyX2lkaQYiD2Nv\nbXBhbnlfaWQwIg9jcmVhdGVkX2F0MDoQX2NzcmZfdG9rZW4iMU91Rm5oREsz\nR2JvdmpaOE5jL1FvNEc1ODRRMXJpYUlSNHJud2M2TmZDQWc9OgxzZXJ2aWNl\nbzoMU2VydmljZQo7CVQ6F0BtYXRlcmlhbF9zZXJ2aWNlc286M0FjdGl2ZVJl\nY29yZDo6QXNzb2NpYXRpb25zOjpIYXNNYW55QXNzb2NpYXRpb24LOw5vOw8N\nOxBjDFNlcnZpY2U7EToNaGFzX21hbnk6F0BxdW90ZWRfdGFibGVfbmFtZSIY\nYG1hdGVyaWFsX3NlcnZpY2VzYDsTIhRNYXRlcmlhbFNlcnZpY2U7FDoWbWF0\nZXJpYWxfc2VydmljZXM7FnsHOgtleHRlbmRbADoKb3JkZXI6CHJvdzsXYxRN\nYXRlcmlhbFNlcnZpY2U7GCIPc2VydmljZV9pZDoQQGZpbmRlcl9zcWwiKmBt\nYXRlcmlhbF9zZXJ2aWNlc2Auc2VydmljZV9pZCA9IE5VTEw6EUBjb3VudGVy\nX3NxbEBBOxlANzsbVDscWwA7CnsAOwtpADseewwiC3N0YXR1czAiD3VwZGF0\nZWRfYXQwIgdrbTAiCHJvdzAiFHNlcnZpY2VfdHlwZV9pZDAiEndvcmtfb3Jk\nZXJfaWQwIg9jcmVhdGVkX2F0MCIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxl\ncjo6Rmxhc2g6OkZsYXNoSGFzaHsGOgtub3RpY2UiF0FsYXJtYSBhY3R1YWxp\nemFkYQY6CkB1c2VkewY7LlQ=\n', '2010-05-26 22:25:32', '2010-05-26 23:55:22');
INSERT INTO `sessions` VALUES ('46', 'edce4e5b1dc7f3b469e2b50380300450', 'BAh7CDoJdXNlcmkJOhBfY3NyZl90b2tlbiIxR1l4WjF6TXcxVWZoK0NCclFL\nMVFDOFNENTcvSjZUNXg2czdnUEZ5OEp5VT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-26 23:28:31', '2010-05-26 23:29:03');
INSERT INTO `sessions` VALUES ('47', 'e1b2a81e69f3c3cbc053fd1b66a4d049', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxYlg2R3lBTmxYOVdlNGtJR09s\nNWkvY2haWUpHamNDZjhnUGRpQy9BN0xsST0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-26 23:58:10', '2010-05-26 23:58:43');
INSERT INTO `sessions` VALUES ('48', '707eccf3b51833b762b971049c7a3520', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxZ1pEM1RrZjFoeXZzUGcvdFBp\nRGs0dVdRc3BXNU1QUGE2TXBHNTNONGYxcz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-27 03:33:36', '2010-05-27 04:38:28');
INSERT INTO `sessions` VALUES ('49', '4383ae011f679f247b4a5e3bf10b6bb6', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxRENlL3RYTkVLUXVaS1hFRHVP\neUUxRW54dFlMdW0zM28rZU5XUzBhdklJbz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-27 04:02:53', '2010-05-27 04:04:15');
INSERT INTO `sessions` VALUES ('50', '516e626f8bdf5dbf940259924233d329', 'BAh7BzoQX2NzcmZfdG9rZW4iMU9UL2l1M2xqMnNsNjl6ZEo0ZEQ0eVNSYTBJ\nVEhrWmpRMnlHNHJKN0ZUY2c9IgpmbGFzaElDOidBY3Rpb25Db250cm9sbGVy\nOjpGbGFzaDo6Rmxhc2hIYXNoewY6C25vdGljZSIiVWRzLiBzYWxpbyBkZWwg\nbGEgYXBsaWNhY2nDs24GOgpAdXNlZHsGOwdU\n', '2010-05-27 04:06:03', '2010-05-27 04:06:03');
INSERT INTO `sessions` VALUES ('51', '18a93d33b46c66554c3bf51ec238190a', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxb2lnVmx5MUtrZndCa0Ribkkw\nZmwvTUpsNGExRHQ0ZUNtQTlNMElCNkxHMD0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-27 04:09:28', '2010-05-27 04:41:58');
INSERT INTO `sessions` VALUES ('52', '0a49b9ba12db04e8de6109ff1373e06d', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxMDZla0RITnRWbjh5anBpMUZT\nQ05zTGRFOG0vUUdTR1MreHdoQ2wxTm9aVT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-27 04:09:39', '2010-05-27 04:39:49');
INSERT INTO `sessions` VALUES ('53', 'f6cae98ddbbecfd2c431014c2edfaa51', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxOVpJeGNyQnAvOWw0VVFjMWFy\nMlcvY2hIcTRHRGJLSVRHdU84TnQyTHdKST0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoLbm90aWNlIhxTZSBoYSBj\ncmVhZG8gbGEgb2ZlcnRhIQY6CkB1c2VkewY7CFQ=\n', '2010-05-27 04:40:13', '2010-05-27 20:38:36');
INSERT INTO `sessions` VALUES ('54', 'd93a578ef78d5c16566c9ab0970df59f', 'BAh7CDoJdXNlcmkLOhBfY3NyZl90b2tlbiIxSXVGT2NvSkhKcW9UT25yTXhG\nWFpkV1BWcTMrS3Z6U1RKbVhRaFpBeE53WT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-27 04:40:34', '2010-05-27 04:41:53');
INSERT INTO `sessions` VALUES ('55', 'a3257f4f73fae8adb70c3001d54fd3cf', 'BAh7CDoJdXNlcmkJOhBfY3NyZl90b2tlbiIxbGdSRnJkNVBML2YwTWI0VTFZ\nZVRvVjBwRi9SekdqdWR1RDdtcCthcmNVdz0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoLbm90aWNlIiRVZHMuIGhh\nIGluZ3Jlc2FkbyBjb24gRXhpdG8gISEhBjoKQHVzZWR7BjsIVA==\n', '2010-05-27 04:41:10', '2010-05-27 04:41:29');
INSERT INTO `sessions` VALUES ('56', '1aba989f179434fc27cfc0e5d9bb72de', 'BAh7CToOcmV0dXJuX3RvIhQvc2VydmljZV9vZmZlcnM6CXVzZXJpCDoQX2Nz\ncmZfdG9rZW4iMTRvQUpZSzM2WWRzR25wVEFlN3g4WkhPdzNyK0ljWlgyNFJp\nVVQzOXRDUkE9IgpmbGFzaElDOidBY3Rpb25Db250cm9sbGVyOjpGbGFzaDo6\nRmxhc2hIYXNoewAGOgpAdXNlZHsA\n', '2010-05-27 14:46:05', '2010-05-27 14:46:20');
INSERT INTO `sessions` VALUES ('57', '30fb24c2e4e310a82d37f6f47ccc5d3e', 'BAh7CDoJdXNlcmkJOhBfY3NyZl90b2tlbiIxNG5IYkNHUmg3cWlZUzJMRE9B\nc1ZOaUUrWm95Uk04NC9VRFlmZm5DdXRnMD0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoLbm90aWNlIhdBbGFybWEg\nYWN0dWFsaXphZGEGOgpAdXNlZHsGOwhU\n', '2010-05-27 14:46:40', '2010-05-27 14:52:53');
INSERT INTO `sessions` VALUES ('58', 'c472dc505f941e3d49e237d617b70d0b', 'BAh7BjoQX2NzcmZfdG9rZW4iMWVqOFMyTHJybVlkZTloTXhMYlA5blJZUm1y\nM2t5MGI5MHJqNXVPRGZESUU9\n', '2010-05-27 15:28:58', '2010-05-27 15:28:58');
INSERT INTO `sessions` VALUES ('59', '52eeddf53d915943438f6afa7b91b3f6', 'BAh7CDoJdXNlcmkIOhBfY3NyZl90b2tlbiIxMmprSFpQRmNaMWxTTnNsM3R4\nR2pFM0t5RlhBN0VGTGxKQXFLUjMwbjhlUT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-27 17:27:52', '2010-05-27 17:28:13');
INSERT INTO `sessions` VALUES ('60', '0271665c2a3bba9062dcc366cc18525d', 'BAh7CDoJdXNlcmkJOhBfY3NyZl90b2tlbiIxNTM4MUZES0lBS2YrV2dBSVJH\nOHYxOGxjTm5Oanpob01XMHd5UjZYcFl0QT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-27 20:42:59', '2010-05-27 21:49:59');
INSERT INTO `sessions` VALUES ('61', '01e1cd38a2285b7629a9e381c3063863', 'BAh7CDoJdXNlcmkGOhBfY3NyZl90b2tlbiIxa1o0M21ZUUVQOHgwb3dhMzho\nQUdOakdYbWNNOVpxL3Bhc0l2N04rQ2JMOD0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-27 20:43:50', '2010-05-27 21:10:45');
INSERT INTO `sessions` VALUES ('62', 'e9c6e4039b86cda7c4723e8a9f1792f0', 'BAh7CDoJdXNlcmkIIgpmbGFzaElDOidBY3Rpb25Db250cm9sbGVyOjpGbGFz\naDo6Rmxhc2hIYXNoewAGOgpAdXNlZHsAOhBfY3NyZl90b2tlbiIxSzhFNUIy\nYkVmd3ludWxrTFhxZHZhUkFiV1Z2bTVpSVBpM1ZCK1R6aTNuMD0=\n', '2010-05-27 20:45:15', '2010-05-27 20:46:04');
INSERT INTO `sessions` VALUES ('63', '3d1ace650285ac0d99168d9d086b6e85', 'BAh7CDoJdXNlcmkJOhBfY3NyZl90b2tlbiIxTkRQbUExMWFabFoxcUVFYWcr\nMHpqNjhlM2lWQkdnT2VITm9XSU1mMkpFRT0iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2010-05-27 21:42:17', '2010-05-27 21:49:12');
INSERT INTO `sessions` VALUES ('64', 'bb5e3862045a9a9cfbf0b4cf6d95c7eb', 'BAh7CzoPd29ya19vcmRlcm86DldvcmtPcmRlcgw6DUByb3dzX2lkaQA6GEBj\naGFuZ2VkX2F0dHJpYnV0ZXN7ByIVc2VydmljZV9vZmZlcl9pZDAiC2Nhcl9p\nZDA6CUBjYXJvOjVBY3RpdmVSZWNvcmQ6OkFzc29jaWF0aW9uczo6QmVsb25n\nc1RvQXNzb2NpYXRpb24KOgtAb3duZXJABjoNQHVwZGF0ZWRUOhBAcmVmbGVj\ndGlvbm86NEFjdGl2ZVJlY29yZDo6UmVmbGVjdGlvbjo6QXNzb2NpYXRpb25S\nZWZsZWN0aW9uDDoTQGFjdGl2ZV9yZWNvcmRjDldvcmtPcmRlcjoQQGNsYXNz\nX25hbWUiCENhcjoLQGtsYXNzYwhDYXI6FkBwcmltYXJ5X2tleV9uYW1lIgtj\nYXJfaWQ6C0BtYWNybzoPYmVsb25nc190bzoKQG5hbWU6CGNhcjoNQG9wdGlv\nbnN7ADoMQGxvYWRlZFQ6DEB0YXJnZXRvOghDYXIHOhBAYXR0cmlidXRlc3sS\nIhVrbUF2ZXJhZ2VNb250aGx5IgkyMDAwIg91cGRhdGVkX2F0IhgyMDEwLTA1\nLTIyIDE1OjE4OjIxIg1icmFuZF9pZCIGMSILcHVibGljIgYxIgdrbSIJNTAw\nMCIJZnVlbCIKTmFmdGEiC2RvbWFpbiILSFJKNTQ5IgdpZCIGMSIPY29tcGFu\neV9pZCIGMSIJeWVhciIJMjAwOSIMdXNlcl9pZCIGNCIPY3JlYXRlZF9hdCIY\nMjAxMC0wNS0xMiAxNDozODozMyINbW9kZWxfaWQiBjE6FkBhdHRyaWJ1dGVz\nX2NhY2hlewA6EEBuZXdfcmVjb3JkVDoTQHNlcnZpY2Vfb2ZmZXJvOwoKOwtA\nBjsMVDsNbzsODDsPQAw7ECIRU2VydmljZU9mZmVyOxFjEVNlcnZpY2VPZmZl\ncjsSIhVzZXJ2aWNlX29mZmVyX2lkOxM7FDsVOhJzZXJ2aWNlX29mZmVyOxd7\nADsYVDsZbzoRU2VydmljZU9mZmVyCDoSQHNlcnZpY2VfdHlwZW87Cgk7C0A0\nOw1vOw4MOw9AMTsQIhBTZXJ2aWNlVHlwZTsSIhRzZXJ2aWNlX3R5cGVfaWQ7\nEWMQU2VydmljZVR5cGU7EzsUOxU6EXNlcnZpY2VfdHlwZTsXewA7GFQ7GW86\nEFNlcnZpY2VUeXBlBzsbew0iCW5hbWUiGUNhbWJpbyBkZSBOZXVtYXRpY29z\nIg91cGRhdGVkX2F0IhgyMDEwLTA1LTEyIDE0OjM4OjM0IgdpZCIGMiIIa21z\nIgo1MDAwMCIOcGFyZW50X2lkIgYwIg1wZXJpb2RpYyIHMzYiD2NyZWF0ZWRf\nYXQiGDIwMTAtMDUtMTIgMTQ6Mzg6MzQiC2FjdGl2ZSIGMTscewA7G3sbIgtz\ndGF0dXMiDEVudmlhZG8iEGZpbmFsX3ByaWNlIgg0NTAiD3VwZGF0ZWRfYXQi\nGDIwMTAtMDUtMjcgMjA6NDU6NTYiDWRpc2NvdW50MCIKdGl0bGUiCk51ZXZv\nIgx0dWVzZGF5IgYxIgpwcmljZSIINTAwIgxzZW5kX2F0MCINc2F0dXJkYXki\nBjEiCWZyb20iDzIwMTAtMDUtMjciFHNlcnZpY2VfdHlwZV9pZCIGMiINdGh1\ncnNkYXkiBjEiDndlZG5lc2RheSIGMSILc3VuZGF5IgYxIgttb25kYXkiBjEi\nB2lkIgcxMyIPY29tcGFueV9pZCIGMSIKdW50aWwiDzIwMTAtMDUtMzEiDGNv\nbW1lbnQiGmNhbWJpYSB0dXMgbmV1bWF0aWNvcyILZnJpZGF5IgYxIgxwZXJj\nZW50IgcxMCIPY3JlYXRlZF9hdCIYMjAxMC0wNS0yNyAyMDozODozMzscewA7\nG3sNIgtzdGF0dXMwIhVzZXJ2aWNlX29mZmVyX2lkaRIiD3VwZGF0ZWRfYXQw\nIhF1c2VyX3JhbmtfaWQwIhRjb21wYW55X3JhbmtfaWQwIgtjYXJfaWRpBiIP\nY29tcGFueV9pZDAiD2NyZWF0ZWRfYXQwOxx7ADoJdXNlcmkGOgtjYXJfaWQi\nBjE6DHNlcnZpY2VvOgxTZXJ2aWNlDDsHaQc6F0BtYXRlcmlhbF9zZXJ2aWNl\nc286M0FjdGl2ZVJlY29yZDo6QXNzb2NpYXRpb25zOjpIYXNNYW55QXNzb2Np\nYXRpb24LOhBAZmluZGVyX3NxbCIqYG1hdGVyaWFsX3NlcnZpY2VzYC5zZXJ2\naWNlX2lkID0gTlVMTDoRQGNvdW50ZXJfc3FsQAGCOwtAAYA7DW87Dg07D2MM\nU2VydmljZTsQIhRNYXRlcmlhbFNlcnZpY2U7EWMUTWF0ZXJpYWxTZXJ2aWNl\nOxIiD3NlcnZpY2VfaWQ7EzoNaGFzX21hbnk6F0BxdW90ZWRfdGFibGVfbmFt\nZSIYYG1hdGVyaWFsX3NlcnZpY2VzYDsVOhZtYXRlcmlhbF9zZXJ2aWNlczsX\newc6C2V4dGVuZFsAOgpvcmRlcjoIcm93OxhUOxlbB286FE1hdGVyaWFsU2Vy\ndmljZQs7CHsJIgpwcmljZTAiCHJvdzAiC2Ftb3VudDAiHW1hdGVyaWFsX3Nl\ncnZpY2VfdHlwZV9pZDA6G0BtYXRlcmlhbF9zZXJ2aWNlX3R5cGVvOwoKOwtA\nAYw7DFQ7DW87Dgw7D0ABhjsQIhhNYXRlcmlhbFNlcnZpY2VUeXBlOxFjGE1h\ndGVyaWFsU2VydmljZVR5cGU7EiIdbWF0ZXJpYWxfc2VydmljZV90eXBlX2lk\nOxM7FDsVOhptYXRlcmlhbF9zZXJ2aWNlX3R5cGU7F3sAOxhUOxlvOhhNYXRl\ncmlhbFNlcnZpY2VUeXBlBzsbewoiD3VwZGF0ZWRfYXQiGDIwMTAtMDUtMjYg\nMTI6MTI6MTkiEG1hdGVyaWFsX2lkIgY2IhRzZXJ2aWNlX3R5cGVfaWQiBjIi\nB2lkIgY5Ig9jcmVhdGVkX2F0IhgyMDEwLTA1LTI2IDEyOjEyOjE5Oxx7ADsd\nVDsbewwiD3VwZGF0ZWRfYXQwIgpwcmljZWYHODAiCHJvd2kGIg9zZXJ2aWNl\nX2lkMCILYW1vdW50aQciHW1hdGVyaWFsX3NlcnZpY2VfdHlwZV9pZGkOIg9j\ncmVhdGVkX2F0MDscewA6DEBkZXRhaWwiL1tNTTM0NV0gTWFubyBkZSBPYnJh\nIE9wZXJhcmlvIE1vZGVsbyAgJCA4MG87Mgs7CHsJIgpwcmljZTAiCHJvdzAi\nC2Ftb3VudDAiHW1hdGVyaWFsX3NlcnZpY2VfdHlwZV9pZDA7M287Cgo7C0AB\nsDsMVDsYVDsNbzsODDsQIhhNYXRlcmlhbFNlcnZpY2VUeXBlOw9AAYY7EiId\nbWF0ZXJpYWxfc2VydmljZV90eXBlX2lkOxFAAZU7EzsUOxd7ADsVOzQ7GW87\nNQc7G3sKIhBtYXRlcmlhbF9pZCIGMSIPdXBkYXRlZF9hdCIYMjAxMC0wNS0x\nMiAxNDozODozNCIUc2VydmljZV90eXBlX2lkIgYyIgdpZCIGMSIPY3JlYXRl\nZF9hdCIYMjAxMC0wNS0xMiAxNDozODozNDscewA7HVQ7G3sMIg91cGRhdGVk\nX2F0MCIKcHJpY2VmCDMwMCIIcm93aQciD3NlcnZpY2VfaWQwIgthbW91bnRp\nByIdbWF0ZXJpYWxfc2VydmljZV90eXBlX2lkaQYiD2NyZWF0ZWRfYXQwOzYi\nM1syMzQ1RkFdIEN1YmllcnRhIEZpcmVzdG9uZSBGLTU3MCAxMzMtNTggJCAz\nMDA7HHsAOwh7BiIUc2VydmljZV90eXBlX2lkMDshbzsKCjsLQAGAOwxUOw1v\nOw4MOw9AAYQ7ECIQU2VydmljZVR5cGU7EiIUc2VydmljZV90eXBlX2lkOxFA\nOTsTOxQ7FTsiOxd7ADsYVDsZbzsjBzsbew0iCW5hbWUiGUNhbWJpbyBkZSBO\nZXVtYXRpY29zIg91cGRhdGVkX2F0IhgyMDEwLTA1LTEyIDE0OjM4OjM0Igdp\nZCIGMiIIa21zIgo1MDAwMCINcGVyaW9kaWMiBzM2Ig5wYXJlbnRfaWQiBjAi\nC2FjdGl2ZSIGMSIPY3JlYXRlZF9hdCIYMjAxMC0wNS0xMiAxNDozODozNDsc\newA7HVQ7G3sMIgtzdGF0dXMwIg91cGRhdGVkX2F0MCIHa20wIghyb3cwIhRz\nZXJ2aWNlX3R5cGVfaWRpByISd29ya19vcmRlcl9pZDAiD2NyZWF0ZWRfYXQw\nOxx7ADoQX2NzcmZfdG9rZW4iMTNGbk9JcWtLYi9xQk9CRUt0NXp6Z0kxU0p5\nZUduYzZuMnFzODF5YnVPUzg9IgpmbGFzaElDOidBY3Rpb25Db250cm9sbGVy\nOjpGbGFzaDo6Rmxhc2hIYXNoewAGOgpAdXNlZHsA\n', '2010-05-27 21:54:28', '2010-05-27 23:42:15');

-- ----------------------------
-- Table structure for `states`
-- ----------------------------
DROP TABLE IF EXISTS `states`;
CREATE TABLE `states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `country_id` int(11) DEFAULT NULL,
  `short_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of states
-- ----------------------------
INSERT INTO `states` VALUES ('1', '1', 'MDZ', 'Mendoza', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `states` VALUES ('2', '1', 'BUE', 'Buenos Aires', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `states` VALUES ('3', '1', 'CORD', 'Cordoba', '2010-05-12 14:38:34', '2010-05-12 14:38:34');

-- ----------------------------
-- Table structure for `user_roles`
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=768773792 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of user_roles
-- ----------------------------
INSERT INTO `user_roles` VALUES ('64810937', '1', '1', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `user_roles` VALUES ('450215437', '2', '3', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `user_roles` VALUES ('768773788', '3', '4', '2010-05-12 14:38:34', '2010-05-12 14:38:34');
INSERT INTO `user_roles` VALUES ('768773789', '4', '3', '2010-05-15 11:49:26', '2010-05-15 11:49:26');
INSERT INTO `user_roles` VALUES ('768773790', '5', '3', '2010-05-17 12:20:47', '2010-05-17 12:20:47');
INSERT INTO `user_roles` VALUES ('768773791', '6', '1', '2010-05-17 12:32:04', '2010-05-17 12:32:04');

-- ----------------------------
-- Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `crypted_password` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salt` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'pablo', 'rodriguez', 'pablorodriguez.ar@gmail.com', '00742970dc9e6319f8019fd54864d3ea740f04b1', '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', '2010-05-07 14:38:34', '2010-05-12 14:38:34', null, null, '1', '1');
INSERT INTO `users` VALUES ('3', 'admin', 'admin', 'admin@admin.com', '00742970dc9e6319f8019fd54864d3ea740f04b1', '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', '2010-05-07 14:38:34', '2010-05-27 14:46:16', '90229bf80f3b74a96024dd22b09769ad310f2f35', '2010-06-10 14:46:16', null, '1');
INSERT INTO `users` VALUES ('4', 'Lucia', 'Rodriguez', 'pabloaustral@gmail.com', '69ebf6b1407f4fa77d5eee93ab4a972deda90146', '46acdccba0a93f17963bc6c70c942305aee37c5a', '2010-05-15 11:49:26', '2010-05-27 21:54:28', null, null, null, '1');
INSERT INTO `users` VALUES ('5', 'Hugo', 'Rodriguez', 'pablo_ro@hotmail.com', '015448fd9b77f777b849563186b0a4012056635f', '2a762687d365286f4a71cc9bf7f8041995a191f2', '2010-05-17 12:20:47', '2010-05-17 12:20:47', null, null, null, '1');
INSERT INTO `users` VALUES ('6', 'Gusatvo', 'De Antonio', 'gdeantonio@yahoo.com.ar', 'c56f15cf2a4d166cb4c82cdac5cbeee06cb0d087', '8c769379604896e6ec5be51d6f1967f6db53f6ca', '2010-05-17 12:32:04', '2010-05-17 12:32:04', null, null, '3', '1');

-- ----------------------------
-- Table structure for `work_orders`
-- ----------------------------
DROP TABLE IF EXISTS `work_orders`;
CREATE TABLE `work_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_offer_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `status` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `car_id` int(11) NOT NULL,
  `company_rank_id` int(11) DEFAULT NULL,
  `user_rank_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of work_orders
-- ----------------------------
INSERT INTO `work_orders` VALUES ('12', null, '1', null, '1', null, null, '2010-05-26 17:00:01', '2010-05-26 17:00:01');
INSERT INTO `work_orders` VALUES ('13', null, '1', null, '1', null, null, '2010-05-26 21:05:54', '2010-05-26 21:05:54');

-- ----------------------------
-- View structure for `material_details`
-- ----------------------------
DROP VIEW IF EXISTS `material_details`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `material_details` AS select `m`.`id` AS `material_id`,`mst`.`service_type_id` AS `service_type_id`,`pl`.`id` AS `price_list_id`,`mst`.`id` AS `material_service_type_id`,`pli`.`price` AS `price`,concat('[',`m`.`code`,']  ',ucase(`m`.`name`),' ',ucase(`m`.`brand`),' ',ucase(`m`.`model`),' ',`m`.`measurement`,' $ ',`pli`.`price`) AS `detail_upper`,concat('[',`m`.`code`,'] ',`m`.`name`,' ',`m`.`brand`,' ',`m`.`model`,' ',`m`.`measurement`,' $ ',`pli`.`price`) AS `detail` from ((((`materials` `m` join `service_types` `st`) join `material_service_types` `mst`) join `price_lists` `pl` on((`pl`.`active` = 1))) join `price_list_items` `pli`) where ((`pli`.`price_list_id` = `pl`.`id`) and (`pli`.`material_service_type_id` = `mst`.`id`) and (`m`.`id` = `mst`.`material_id`) and (`mst`.`service_type_id` = `st`.`id`));
