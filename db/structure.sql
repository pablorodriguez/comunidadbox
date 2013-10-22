CREATE TABLE `addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `street` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lat` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lng` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `addresses_state_id_fk` (`state_id`) USING BTREE,
  KEY `addresses_user_id_fk` (`user_id`) USING BTREE,
  KEY `addresses_company_id_fk` (`company_id`) USING BTREE,
  CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `addresses_ibfk_2` FOREIGN KEY (`state_id`) REFERENCES `states` (`id`),
  CONSTRAINT `addresses_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5402 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  `monday` tinyint(1) DEFAULT '0',
  `tuesday` tinyint(1) DEFAULT '0',
  `wednesday` tinyint(1) DEFAULT '0',
  `thursday` tinyint(1) DEFAULT '0',
  `friday` tinyint(1) DEFAULT '0',
  `saturday` tinyint(1) DEFAULT '0',
  `sunday` tinyint(1) DEFAULT '0',
  `no_end` tinyint(1) DEFAULT '0',
  `next_time` datetime DEFAULT NULL,
  `last_time` datetime DEFAULT NULL,
  `car_id` int(11) DEFAULT NULL,
  `client_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `alarms_user_id_fk` (`user_id`) USING BTREE,
  KEY `alarms_company_id_fk` (`company_id`),
  CONSTRAINT `alarms_company_id_fk` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `alarms_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `authentications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `bdrb_job_queues` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `args` text COLLATE utf8_unicode_ci,
  `worker_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `worker_method` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `job_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `taken` int(11) DEFAULT NULL,
  `finished` int(11) DEFAULT NULL,
  `timeout` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `archived_at` datetime DEFAULT NULL,
  `tag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `submitter_info` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `runner_info` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `worker_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scheduled_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `brands` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `budgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `creator_id` int(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `model_id` int(11) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `car_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `comment` text,
  PRIMARY KEY (`id`),
  KEY `budgets_user_id_fk` (`user_id`),
  KEY `budgets_car_id_fk` (`car_id`),
  KEY `budgets_company_id_fk` (`company_id`),
  CONSTRAINT `budgets_car_id_fk` FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`) ON DELETE CASCADE,
  CONSTRAINT `budgets_company_id_fk` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `budgets_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6855 DEFAULT CHARSET=latin1;

CREATE TABLE `car_service_offers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `car_id` int(11) DEFAULT NULL,
  `service_offer_id` int(11) DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `car_service_offers_car_id_fk` (`car_id`) USING BTREE,
  KEY `car_service_offers_service_offer_id_fk` (`service_offer_id`) USING BTREE,
  CONSTRAINT `car_service_offers_ibfk_1` FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`) ON DELETE CASCADE,
  CONSTRAINT `car_service_offers_ibfk_2` FOREIGN KEY (`service_offer_id`) REFERENCES `service_offers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  `kmUpdatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `cars_brand_id_fk` (`brand_id`) USING BTREE,
  KEY `cars_model_id_fk` (`model_id`) USING BTREE,
  KEY `cars_user_id_fk` (`user_id`) USING BTREE,
  CONSTRAINT `cars_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`),
  CONSTRAINT `cars_ibfk_2` FOREIGN KEY (`model_id`) REFERENCES `models` (`id`),
  CONSTRAINT `cars_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12707 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `companies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cuit` varchar(13) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `companies_country_id_fk` (`country_id`) USING BTREE,
  KEY `companies_user_id_fk` (`user_id`) USING BTREE,
  CONSTRAINT `companies_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`),
  CONSTRAINT `companies_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `companies_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `companies_users_company_id_fk` (`company_id`),
  KEY `companies_users_user_id_fk` (`user_id`),
  CONSTRAINT `companies_users_company_id_fk` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `companies_users_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11343 DEFAULT CHARSET=latin1;

CREATE TABLE `company_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_id` int(11) DEFAULT NULL,
  `service_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `company_services_company_id_fk` (`company_id`) USING BTREE,
  KEY `company_services_service_type_id_fk` (`service_type_id`) USING BTREE,
  CONSTRAINT `company_services_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `company_services_ibfk_2` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `message` text,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
  `handler` text COLLATE utf8_unicode_ci,
  `last_error` text COLLATE utf8_unicode_ci,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `delayed_jobs_priority` (`priority`,`run_at`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `car_id` int(11) DEFAULT NULL,
  `service_type_id` int(11) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `service_done_id` int(11) DEFAULT NULL,
  `km` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `status_o` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dueDate` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `events_service_id_fk` (`service_id`) USING BTREE,
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=36857 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `guests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `brand` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `km` int(11) DEFAULT NULL,
  `kmavg` int(11) DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `material_service_type_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_type_template_id` int(11) DEFAULT NULL,
  `material_service_type_id` int(11) DEFAULT NULL,
  `material` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `material_service_type_templates_service_type_template_id_fk` (`service_type_template_id`),
  CONSTRAINT `material_service_type_templates_service_type_template_id_fk` FOREIGN KEY (`service_type_template_id`) REFERENCES `service_type_templates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

CREATE TABLE `material_service_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `material_id` int(11) DEFAULT NULL,
  `service_type_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `material_service_types_material_id_fk` (`material_id`) USING BTREE,
  KEY `index_material_service_types_on_service_type_id` (`service_type_id`) USING BTREE,
  CONSTRAINT `material_service_types_ibfk_1` FOREIGN KEY (`material_id`) REFERENCES `materials` (`id`),
  CONSTRAINT `material_service_types_ibfk_2` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35527 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `material_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_id` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `material` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `material_service_type_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `material_services_service_id_fk` (`service_id`) USING BTREE,
  KEY `material_services_material_service_type_id_fk` (`material_service_type_id`) USING BTREE,
  CONSTRAINT `material_services_ibfk_1` FOREIGN KEY (`material_service_type_id`) REFERENCES `material_service_types` (`id`),
  CONSTRAINT `material_services_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=84428 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `materials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `prov_code` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `sub_category_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `brand` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `material_code` (`code`),
  KEY `material_prov_code` (`prov_code`),
  KEY `material_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=35500 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text,
  `read` tinyint(1) DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `receiver_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `workorder_id` int(11) DEFAULT NULL,
  `budget_id` int(11) DEFAULT NULL,
  `message_id` int(11) DEFAULT NULL,
  `alarm_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `messages_user_id_fk` (`user_id`),
  KEY `messages_workorder_id_fk` (`workorder_id`),
  KEY `messages_budget_id_fk` (`budget_id`),
  KEY `messages_event_id_fk` (`event_id`),
  KEY `messages_alarm_id_fk` (`alarm_id`),
  KEY `messages_message_id_fk` (`message_id`),
  CONSTRAINT `messages_alarm_id_fk` FOREIGN KEY (`alarm_id`) REFERENCES `alarms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_budget_id_fk` FOREIGN KEY (`budget_id`) REFERENCES `budgets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_event_id_fk` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_message_id_fk` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `messages_workorder_id_fk` FOREIGN KEY (`workorder_id`) REFERENCES `workorders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

CREATE TABLE `models` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `models_brand_id_fk` (`brand_id`) USING BTREE,
  CONSTRAINT `models_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2657 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text,
  `due_date` datetime DEFAULT NULL,
  `recall` datetime DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `workorder_id` int(11) DEFAULT NULL,
  `note_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `creator_id` int(11) NOT NULL,
  `budget_id` int(11) DEFAULT NULL,
  `viewed` tinyint(1) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `receiver_id` int(11) DEFAULT NULL,
  `respond_to_id` int(11) DEFAULT NULL,
  `alarm_id` int(11) DEFAULT NULL,
  `car_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `notes_user_id_fk` (`user_id`),
  KEY `notes_workorder_id_fk` (`workorder_id`),
  KEY `notes_note_id_fk` (`note_id`),
  KEY `notes_budget_id_fk` (`budget_id`),
  KEY `notes_receiver_id_fk` (`receiver_id`),
  KEY `notes_car_id_fk` (`car_id`),
  KEY `notes_company_id_fk` (`company_id`),
  CONSTRAINT `notes_budget_id_fk` FOREIGN KEY (`budget_id`) REFERENCES `budgets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notes_car_id_fk` FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notes_company_id_fk` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `notes_note_id_fk` FOREIGN KEY (`note_id`) REFERENCES `notes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notes_receiver_id_fk` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notes_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notes_workorder_id_fk` FOREIGN KEY (`workorder_id`) REFERENCES `workorders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1872 DEFAULT CHARSET=latin1;

CREATE TABLE `payment_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `price_list_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price_list_id` int(11) DEFAULT NULL,
  `material_service_type_id` int(11) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `price_list_items_price_list_id_fk` (`price_list_id`) USING BTREE,
  KEY `price_list_items_material_service_type_id_fk` (`material_service_type_id`) USING BTREE,
  CONSTRAINT `price_list_items_ibfk_1` FOREIGN KEY (`material_service_type_id`) REFERENCES `material_service_types` (`id`),
  CONSTRAINT `price_list_items_ibfk_2` FOREIGN KEY (`price_list_id`) REFERENCES `price_lists` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=835967 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `price_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `ranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_rank` int(1) DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `cal` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `workorder_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ranks_workorder_id_fk` (`workorder_id`),
  CONSTRAINT `ranks_workorder_id_fk` FOREIGN KEY (`workorder_id`) REFERENCES `workorders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `detail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `service_filters_service_type_id_fk` (`service_type_id`) USING BTREE,
  KEY `service_filters_model_id_fk` (`model_id`) USING BTREE,
  KEY `service_filters_brand_id_fk` (`brand_id`) USING BTREE,
  KEY `service_filters_state_id_fk` (`state_id`) USING BTREE,
  KEY `service_filters_user_id_fk` (`user_id`) USING BTREE,
  CONSTRAINT `service_filters_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE CASCADE,
  CONSTRAINT `service_filters_ibfk_2` FOREIGN KEY (`model_id`) REFERENCES `models` (`id`) ON DELETE CASCADE,
  CONSTRAINT `service_filters_ibfk_3` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `service_filters_ibfk_4` FOREIGN KEY (`state_id`) REFERENCES `states` (`id`) ON DELETE CASCADE,
  CONSTRAINT `service_filters_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `service_offers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `price` float DEFAULT NULL,
  `final_price` float DEFAULT NULL,
  `discount` float DEFAULT NULL,
  `percent` float DEFAULT NULL,
  `status_old` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  `since` date DEFAULT NULL,
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
  PRIMARY KEY (`id`),
  KEY `service_offers_company_id_fk` (`company_id`) USING BTREE,
  KEY `service_offers_service_type_id_fk` (`service_type_id`) USING BTREE,
  CONSTRAINT `service_offers_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `service_offers_ibfk_2` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `service_type_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `service_type_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `service_type_templates_service_type_id_fk` (`service_type_id`),
  KEY `service_type_templates_company_id_fk` (`company_id`),
  CONSTRAINT `service_type_templates_company_id_fk` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `service_type_templates_service_type_id_fk` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

CREATE TABLE `service_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `kms` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `active` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `code` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `service_types_tasks` (
  `service_type_id` int(11) DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  KEY `index_service_types_tasks_on_service_type_id` (`service_type_id`) USING BTREE,
  KEY `index_service_types_tasks_on_task_id` (`task_id`) USING BTREE,
  CONSTRAINT `service_types_tasks_ibfk_1` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `service_types_tasks_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `workorder_id` int(11) DEFAULT NULL,
  `service_type_id` int(11) DEFAULT NULL,
  `material` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  `operator_id` int(11) DEFAULT NULL,
  `budget_id` int(11) DEFAULT NULL,
  `car_service_offer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `services_workorder_id_fk` (`workorder_id`) USING BTREE,
  KEY `services_service_type_id_fk` (`service_type_id`) USING BTREE,
  KEY `services_operator_id_fk` (`operator_id`),
  KEY `services_budget_id_fk` (`budget_id`),
  KEY `services_car_service_offer_id_fk` (`car_service_offer_id`),
  CONSTRAINT `services_budget_id_fk` FOREIGN KEY (`budget_id`) REFERENCES `budgets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `services_car_service_offer_id_fk` FOREIGN KEY (`car_service_offer_id`) REFERENCES `car_service_offers` (`id`),
  CONSTRAINT `services_ibfk_1` FOREIGN KEY (`service_type_id`) REFERENCES `service_types` (`id`),
  CONSTRAINT `services_ibfk_2` FOREIGN KEY (`workorder_id`) REFERENCES `workorders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `services_operator_id_fk` FOREIGN KEY (`operator_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41685 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `services_tasks` (
  `service_id` int(11) DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  KEY `services_tasks_service_id_fk` (`service_id`) USING BTREE,
  KEY `services_tasks_task_id_fk` (`task_id`) USING BTREE,
  CONSTRAINT `services_tasks_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`),
  CONSTRAINT `services_tasks_ibfk_2` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`) USING BTREE,
  KEY `index_sessions_on_updated_at` (`updated_at`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=73829 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `country_id` int(11) DEFAULT NULL,
  `short_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `states_country_id_fk` (`country_id`) USING BTREE,
  CONSTRAINT `states_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` text COLLATE utf8_unicode_ci,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `user_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_roles_user_id_fk` (`user_id`) USING BTREE,
  KEY `user_roles_role_id_fk` (`role_id`) USING BTREE,
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_roles_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=450215530 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `employer_id` int(11) DEFAULT NULL,
  `creator_id` int(11) DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `password_salt` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `confirmation_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `company_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cuit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT NULL,
  `disable` tinyint(1) DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `failed_attempts` int(11) DEFAULT '0',
  `unlock_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `authenticatable` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `invitation_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`) USING BTREE,
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`) USING BTREE,
  KEY `users_employer_id_fk` (`employer_id`) USING BTREE,
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`employer_id`) REFERENCES `companies` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11378 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `workorders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` text COLLATE utf8_unicode_ci,
  `company_id` int(11) DEFAULT NULL,
  `car_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `km` int(11) DEFAULT NULL,
  `performed` date DEFAULT NULL,
  `status` int(2) DEFAULT NULL,
  `payment_method_id` int(11) DEFAULT NULL,
  `company_info` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `budget_id` int(11) DEFAULT NULL,
  `deliver` datetime DEFAULT NULL,
  `deliver_actual` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workorders_car_id_fk` (`car_id`) USING BTREE,
  KEY `workorders_company_id_fk` (`company_id`) USING BTREE,
  KEY `workorders_user_id_fk` (`user_id`) USING BTREE,
  KEY `workorders_payment_method_id_fk` (`payment_method_id`),
  KEY `workorders_budget_id_fk` (`budget_id`),
  CONSTRAINT `workorders_budget_id_fk` FOREIGN KEY (`budget_id`) REFERENCES `budgets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `workorders_ibfk_1` FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`),
  CONSTRAINT `workorders_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`),
  CONSTRAINT `workorders_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `workorders_payment_method_id_fk` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18269 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20090310164025');

INSERT INTO schema_migrations (version) VALUES ('20090310164028');

INSERT INTO schema_migrations (version) VALUES ('20090310164030');

INSERT INTO schema_migrations (version) VALUES ('20090310164040');

INSERT INTO schema_migrations (version) VALUES ('20090310215847');

INSERT INTO schema_migrations (version) VALUES ('20090312200011');

INSERT INTO schema_migrations (version) VALUES ('20090312200013');

INSERT INTO schema_migrations (version) VALUES ('20090313155312');

INSERT INTO schema_migrations (version) VALUES ('20090323235219');

INSERT INTO schema_migrations (version) VALUES ('20090331035116');

INSERT INTO schema_migrations (version) VALUES ('20090401105206');

INSERT INTO schema_migrations (version) VALUES ('20090401105359');

INSERT INTO schema_migrations (version) VALUES ('20090604163203');

INSERT INTO schema_migrations (version) VALUES ('20090718154621');

INSERT INTO schema_migrations (version) VALUES ('20090718154630');

INSERT INTO schema_migrations (version) VALUES ('20090718154631');

INSERT INTO schema_migrations (version) VALUES ('20090718154641');

INSERT INTO schema_migrations (version) VALUES ('20090818152833');

INSERT INTO schema_migrations (version) VALUES ('20090910011602');

INSERT INTO schema_migrations (version) VALUES ('20100322141327');

INSERT INTO schema_migrations (version) VALUES ('20100322230455');

INSERT INTO schema_migrations (version) VALUES ('20100403051616');

INSERT INTO schema_migrations (version) VALUES ('20100403212215');

INSERT INTO schema_migrations (version) VALUES ('20100403213940');

INSERT INTO schema_migrations (version) VALUES ('20100519125613');

INSERT INTO schema_migrations (version) VALUES ('20100522122438');

INSERT INTO schema_migrations (version) VALUES ('20100522152617');

INSERT INTO schema_migrations (version) VALUES ('20100612200319');

INSERT INTO schema_migrations (version) VALUES ('20100615131626');

INSERT INTO schema_migrations (version) VALUES ('20100629210845');

INSERT INTO schema_migrations (version) VALUES ('20101013234934');

INSERT INTO schema_migrations (version) VALUES ('20101108192416');

INSERT INTO schema_migrations (version) VALUES ('20101128004009');

INSERT INTO schema_migrations (version) VALUES ('20110110224540');

INSERT INTO schema_migrations (version) VALUES ('20110228233114');

INSERT INTO schema_migrations (version) VALUES ('20110423143341');

INSERT INTO schema_migrations (version) VALUES ('20110504160508');

INSERT INTO schema_migrations (version) VALUES ('20110723213216');

INSERT INTO schema_migrations (version) VALUES ('20110723214622');

INSERT INTO schema_migrations (version) VALUES ('20110807152444');

INSERT INTO schema_migrations (version) VALUES ('20110827180015');

INSERT INTO schema_migrations (version) VALUES ('20110914223158');

INSERT INTO schema_migrations (version) VALUES ('20111008024234');

INSERT INTO schema_migrations (version) VALUES ('20111103204831');

INSERT INTO schema_migrations (version) VALUES ('20111104234130');

INSERT INTO schema_migrations (version) VALUES ('20111107210632');

INSERT INTO schema_migrations (version) VALUES ('20111124213015');

INSERT INTO schema_migrations (version) VALUES ('20111130193332');

INSERT INTO schema_migrations (version) VALUES ('20111130205618');

INSERT INTO schema_migrations (version) VALUES ('20111205142904');

INSERT INTO schema_migrations (version) VALUES ('20111209184911');

INSERT INTO schema_migrations (version) VALUES ('20111216053016');

INSERT INTO schema_migrations (version) VALUES ('20120124223757');

INSERT INTO schema_migrations (version) VALUES ('20120124223828');

INSERT INTO schema_migrations (version) VALUES ('20120210152939');

INSERT INTO schema_migrations (version) VALUES ('20120302115247');

INSERT INTO schema_migrations (version) VALUES ('20120323171733');

INSERT INTO schema_migrations (version) VALUES ('20120901130832');

INSERT INTO schema_migrations (version) VALUES ('20120917121644');

INSERT INTO schema_migrations (version) VALUES ('20121116040614');

INSERT INTO schema_migrations (version) VALUES ('20121120215638');

INSERT INTO schema_migrations (version) VALUES ('20121121212047');

INSERT INTO schema_migrations (version) VALUES ('20121210120035');

INSERT INTO schema_migrations (version) VALUES ('20130226212223');

INSERT INTO schema_migrations (version) VALUES ('20130311230123');

INSERT INTO schema_migrations (version) VALUES ('20130311230442');

INSERT INTO schema_migrations (version) VALUES ('20130425215759');

INSERT INTO schema_migrations (version) VALUES ('20130611133223');

INSERT INTO schema_migrations (version) VALUES ('20130611150224');

INSERT INTO schema_migrations (version) VALUES ('20130925231943');

INSERT INTO schema_migrations (version) VALUES ('20131015181849');

INSERT INTO schema_migrations (version) VALUES ('20131015182540');