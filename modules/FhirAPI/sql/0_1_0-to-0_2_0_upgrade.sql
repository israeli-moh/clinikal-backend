--
--  Comment Meta Language Constructs:
--
--  #IfNotTable
--    argument: table_name
--    behavior: if the table_name does not exist,  the block will be executed

--  #IfTable
--    argument: table_name
--    behavior: if the table_name does exist, the block will be executed

--  #IfColumn
--    arguments: table_name colname
--    behavior:  if the table and column exist,  the block will be executed

--  #IfMissingColumn
--    arguments: table_name colname
--    behavior:  if the table exists but the column does not,  the block will be executed

--  #IfNotColumnType
--    arguments: table_name colname value
--    behavior:  If the table table_name does not have a column colname with a data type equal to value, then the block will be executed

--  #IfNotRow
--    arguments: table_name colname value
--    behavior:  If the table table_name does not have a row where colname = value, the block will be executed.

--  #IfNotRow2D
--    arguments: table_name colname value colname2 value2
--    behavior:  If the table table_name does not have a row where colname = value AND colname2 = value2, the block will be executed.

--  #IfNotRow3D
--    arguments: table_name colname value colname2 value2 colname3 value3
--    behavior:  If the table table_name does not have a row where colname = value AND colname2 = value2 AND colname3 = value3, the block will be executed.

--  #IfNotRow4D
--    arguments: table_name colname value colname2 value2 colname3 value3 colname4 value4
--    behavior:  If the table table_name does not have a row where colname = value AND colname2 = value2 AND colname3 = value3 AND colname4 = value4, the block will be executed.

--  #IfNotRow2Dx2
--    desc:      This is a very specialized function to allow adding items to the list_options table to avoid both redundant option_id and title in each element.
--    arguments: table_name colname value colname2 value2 colname3 value3
--    behavior:  The block will be executed if both statements below are true:
--               1) The table table_name does not have a row where colname = value AND colname2 = value2.
--               2) The table table_name does not have a row where colname = value AND colname3 = value3.

--  #IfRow2D
--    arguments: table_name colname value colname2 value2
--    behavior:  If the table table_name does have a row where colname = value AND colname2 = value2, the block will be executed.

--  #IfRow3D
--        arguments: table_name colname value colname2 value2 colname3 value3
--        behavior:  If the table table_name does have a row where colname = value AND colname2 = value2 AND colname3 = value3, the block will be executed.

--  #IfIndex
--    desc:      This function is most often used for dropping of indexes/keys.
--    arguments: table_name colname
--    behavior:  If the table and index exist the relevant statements are executed, otherwise not.

--  #IfNotIndex
--    desc:      This function will allow adding of indexes/keys.
--    arguments: table_name colname
--    behavior:  If the index does not exist, it will be created

--  #EndIf
--    all blocks are terminated with a #EndIf statement.

--  #IfNotListReaction
--    Custom function for creating Reaction List

--  #IfNotListOccupation
--    Custom function for creating Occupation List

--  #IfTextNullFixNeeded
--    desc: convert all text fields without default null to have default null.
--    arguments: none

--  #IfTableEngine
--    desc:      Execute SQL if the table has been created with given engine specified.
--    arguments: table_name engine
--    behavior:  Use when engine conversion requires more than one ALTER TABLE

--  #IfInnoDBMigrationNeeded
--    desc: find all MyISAM tables and convert them to InnoDB.
--    arguments: none
--    behavior: can take a long time.

--  #IfTranslationNeeded
--    desc: find all MyISAM tables and convert them to InnoDB.
--    arguments: constant_name english hebrew
--    behavior: can take a long time.


#IfNotTable fhir_rest_elements
 CREATE TABLE `fhir_rest_elements` (
  `id` int(11) NOT NULL,
  `name` varchar(128) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE `fhir_rest_elements`
  ADD PRIMARY KEY (`id`);
ALTER TABLE `fhir_rest_elements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
#EndIf


#IfNotTable encounter_reasoncode_map
CREATE TABLE encounter_reasoncode_map (
eid INT(6) UNSIGNED,
reason_code  INT(6) UNSIGNED
);
#EndIf

#IfMissingColumn facility active
ALTER TABLE facility ADD active int DEFAULT 1;
#EndIf

#IfNotTable fhir_value_sets
CREATE TABLE `fhir_value_sets` (
    `id` VARCHAR(125) NOT NULL,
    `title` VARCHAR(125) NOT NULL,
    `active` BOOLEAN NOT NULL DEFAULT 1,
    PRIMARY KEY(`id`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;
#EndIf

#IfNotTable fhir_value_set_systems
CREATE TABLE `fhir_value_set_systems` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `vs_id` VARCHAR(125) NOT NULL,
    `system` VARCHAR(125) NOT NULL,
    `type` ENUM('All', 'Partial', 'Exclude', 'Filter') NOT NULL,
    `filter` VARCHAR(125) DEFAULT NULL,
    PRIMARY KEY(`id`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;
#EndIf

ALTER TABLE `fhir_value_set_systems` MODIFY COLUMN `type` ENUM('All', 'Partial', 'Exclude', 'Filter', 'Codes') NOT NULL AFTER `system`;

#IfNotTable fhir_value_set_codes
CREATE TABLE `fhir_value_set_codes` (
    `vss_id` INT NOT NULL,
    `code` VARCHAR(125) NOT NULL,
    PRIMARY KEY(`vss_id`, `code`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8;
#EndIf

#IfNotTable encounter_reasoncode_map
CREATE TABLE encounter_reasoncode_map (
event_id INT(6),
option_id  INT(6) UNSIGNED
);
#EndIf

#IfNotTable event_codeReason_map
CREATE TABLE `event_codeReason_map` (
  `event_id` int(11) NOT NULL,
  `option_id` varchar(100) NOT NULL
)ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE event_codeReason_map ADD PRIMARY KEY (event_id, option_id);
#EndIf

#IfNotTable related_person
CREATE TABLE `related_person` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) DEFAULT NULL,
  `identifier_type` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `pid` bigint(20) NOT NULL,
  `relationship` varchar(255) DEFAULT NULL,
  `phone_home` varchar(255) DEFAULT NULL,
  `phone_cell` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#EndIf




#IfNotTable questionnaires_schemas
CREATE TABLE questionnaires_schemas(
    qid int(11) NOT NULL AUTO_INCREMENT,
    form_name varchar(255) NOT NULL,
    form_table varchar(255) NOT NULL,
    column_name varchar(255) DEFAULT NULL,
    column_type varchar(255) NOT NULL,
    question varchar(255) DEFAULT NULL,
    PRIMARY KEY (`qid`)
);
#EndIf

ALTER TABLE `questionnaires_schemas` CHANGE `column_name` `column_name` VARCHAR(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL;

#IfNotTable questionnaire_response
CREATE TABLE `questionnaire_response`(
    id bigint(20) NOT NULL AUTO_INCREMENT,
    form_name varchar(255) NOT NULL,
    encounter bigint(20) NOT NULL,
    subject bigint(20) NOT NULL,
    subject_type VARCHAR(255) NOT NULL DEFAULT 'Patient',
    create_date datetime DEFAULT current_timestamp,
    update_date datetime DEFAULT current_timestamp,
    create_by bigint(20) NOT NULL,
    update_by bigint(20) NOT NULL,
    source  bigint(20) NOT NULL,
    source_type VARCHAR(255) NOT NULL DEFAULT 'Patient',
    status  varchar(255) NOT NULL,
    PRIMARY KEY (`id`)
);
#EndIf






#IfMissingColumn form_encounter status
ALTER TABLE form_encounter ADD status VARCHAR(100) NULL  AFTER `parent_encounter_id`;
#EndIf

#IfMissingColumn form_encounter eid
ALTER TABLE form_encounter ADD eid INT NULL  AFTER `status`;
#EndIf

#IfMissingColumn form_encounter priority
ALTER TABLE form_encounter ADD priority INT DEFAULT 0 AFTER `eid`;
#EndIf

#IfMissingColumn form_encounter service_type
ALTER TABLE form_encounter ADD service_type INT DEFAULT NULL  AFTER `priority`;
#EndIf


ALTER TABLE form_encounter MODIFY COLUMN priority INT DEFAULT 1;
ALTER TABLE `openemr_postcalendar_events` MODIFY COLUMN `pc_priority` INT NOT NULL DEFAULT 1;

#IfColumn fhir_value_sets active
ALTER TABLE `fhir_value_sets` CHANGE `active` `status` ENUM('active', 'retired') NOT NULL DEFAULT 'active';
#EndIf

ALTER TABLE `openemr_postcalendar_events` CHANGE
`pc_healthcare_service_id` `pc_healthcare_service_id` INT NULL DEFAULT NULL COMMENT 'fhir_healthcare_services.id';

ALTER TABLE `fhir_healthcare_services` CHANGE
`providedBy` `providedBy` INT NULL DEFAULT NULL COMMENT 'facility.id';

#IfMissingColumn form_encounter escort_id
ALTER TABLE `form_encounter` ADD `escort_id` BIGINT(20) NULL DEFAULT NULL  COMMENT 'related_person.id' AFTER `service_type`;
#EndIf

#IfNotTable fhir_healthcare_services
RENAME TABLE `healthcare_services` TO `fhir_healthcare_services`;
#EndIf

#IfMissingColumn fhir_healthcare_services id
ALTER TABLE `fhir_healthcare_services` CHANGE `identifier` `id` INT NOT NULL AUTO_INCREMENT;
#EndIf

#IfMissingColumn openemr_postcalendar_events pc_priority
ALTER TABLE `openemr_postcalendar_events` ADD `pc_priority` INT NOT NULL DEFAULT '1' AFTER `pc_gid`;
#EndIf

#IfMissingColumn openemr_postcalendar_events pc_service_type
ALTER TABLE `openemr_postcalendar_events` ADD `pc_service_type` INT NULL DEFAULT NULL AFTER `pc_priority`;
#EndIf

#IfMissingColumn openemr_postcalendar_events pc_healthcare_service_id
ALTER TABLE `openemr_postcalendar_events` ADD `pc_healthcare_service_id` INT NULL DEFAULT NULL AFTER `pc_service_type`;
#EndIf

#IfNotRow fhir_rest_elements name Organization
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('Organization', 1);
#EndIf

#IfNotRow fhir_rest_elements name Patient
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('Patient', 1);
#EndIf

#IfNotRow fhir_rest_elements name Appointment
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('Appointment', 1);
#EndIf

#IfNotRow fhir_rest_elements name HealthcareService
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('HealthcareService', 1);
#EndIf

#IfNotRow fhir_rest_elements name ValueSet
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('ValueSet', 1);
#EndIf

#IfNotRow fhir_rest_elements name Encounter
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('Encounter', 1);
#EndIf

#IfNotRow fhir_rest_elements name DocumentReference
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('DocumentReference', 1);
#EndIf

#IfNotRow fhir_rest_elements name RelatedPerson
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('RelatedPerson', '1');
#EndIf

#IfNotRow fhir_rest_elements name Questionnaire
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('Questionnaire', '1');
#EndIf

#IfNotRow fhir_rest_elements name QuestionnaireResponse
INSERT INTO `fhir_rest_elements` ( `name`, `active`) VALUES
('QuestionnaireResponse', '1');
#EndIf

#IfNotRow fhir_rest_elements name Practitioner
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('Practitioner', 1);
#EndIf



#IfNotRow3D list_options list_id sex option_id unknown activity 0

DELETE FROM `list_options` WHERE `list_id` like "sex";

INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `notes`,`activity`)
VALUES
('sex', 'male', 'Male', '10', '1', '0','','1'),
('sex', 'female', 'Female', '20', '0', '0','', '1'),
('sex', 'other', 'Other', '30', '0', '0','', '1'),
('sex', 'unknown', 'Unknown', '40', '0', '0','' ,'0');
#EndIf


#IfNotTable fhir_questionnaire
CREATE TABLE `fhir_questionnaire` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `name`      varchar(255) NOT NULL,
    `directory` varchar(255) NOT NULL,
    `state`     tinyint(4)   DEFAULT NULL,
    `aco_spec`  varchar(255) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ;
#EndIf


#IfMissingColumn related_person full_name
ALTER TABLE `related_person` ADD `full_name` VARCHAR(255) NULL DEFAULT NULL AFTER `gender`;
#EndIf

#IfMissingColumn form_encounter arrival_way
ALTER TABLE `form_encounter`
ADD `arrival_way` VARCHAR(255) NULL DEFAULT NULL AFTER `eid`,
ADD `reason_codes_details` TEXT NULL DEFAULT NULL AFTER `arrival_way`;
#EndIf



#IfNotRow fhir_rest_elements name Condition
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES ('Condition', 1);
#EndIf

DELETE  FROM `list_options` WHERE `list_id` LIKE 'outcome';

INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `toggle_setting_1`, `toggle_setting_2`, `activity`, `subtype`, `edit_options`, `timestamp`) VALUES
('outcome', '1', 'active', 5, 0, 0, 'all', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),
('outcome', '2', 'recurrence', 10, 0, 0, 'Condition', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),
('outcome', '3', 'relapse', 15, 0, 0, 'Condition', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),
('outcome', '4', 'inactive', 20, 0, 0, 'Condition', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),
('outcome', '5', 'resolved', 25, 0, 0, 'Condition', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),
('outcome', '6', 'remission', 25, 0, 0, 'Condition', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),

('outcome', '7', 'completed', 25, 0, 0, 'MedicationStatement', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),
('outcome', '8', 'entered-in-error', 25, 0, 0, 'MedicationStatement', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),
('outcome', '9', 'intended', 25, 0, 0, 'MedicationStatement', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),
('outcome', '10', 'stopped', 25, 0, 0, 'MedicationStatement', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),
('outcome', '11', 'on-hold', 25, 0, 0, 'MedicationStatement', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),
('outcome', '12', 'unknown', 25, 0, 0, 'MedicationStatement', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44'),
('outcome', '13', 'not-taken', 25, 0, 0, 'MedicationStatement', NULL, '', 0, 0, 1, '', 1, '2021-05-26 07:07:44');

#IfNotRow fhir_rest_elements name MedicationStatement
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES ('MedicationStatement', 1);
#EndIf

ALTER TABLE `questionnaires_schemas` CHANGE `qid` `qid` INT(11) NOT NULL;
ALTER TABLE `questionnaires_schemas` DROP PRIMARY KEY;
ALTER TABLE `questionnaires_schemas` ADD PRIMARY KEY( `qid`,`form_name`);
ALTER TABLE `questionnaires_schemas` CHANGE `qid` `qid` INT(11) NOT NULL AUTO_INCREMENT;

#IfMissingColumn form_encounter secondary_status
ALTER TABLE `form_encounter`
ADD `secondary_status` VARCHAR(255) NULL AFTER `reason_codes_details`;
#EndIf

#IfMissingColumn form_encounter status_update_date
ALTER TABLE `form_encounter`
ADD `status_update_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER `secondary_status`;
#EndIf



#IfNotRow2D list_options list_id lists option_id clinikal_enc_statuses
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `toggle_setting_1`, `toggle_setting_2`, `activity`, `subtype`, `edit_options`)
VALUES
('lists', 'clinikal_enc_statuses', 'Clinikal Encounter Statuses', 0, 0, 0, '', '', '', 0, 0, 1, '', 1);
#EndIf

#IfNotRow2D list_options list_id lists option_id clinikal_enc_secondary_statuses
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `toggle_setting_1`, `toggle_setting_2`, `activity`, `subtype`, `edit_options`)
VALUES
('lists', 'clinikal_enc_secondary_statuses', 'Clinikal Encounter Secondary Statuses', 0, 0, 0, '', 'In Progress', '', 0, 0, 1, '', 1);
#EndIf


ALTER TABLE `encounter_reasoncode_map` CHANGE `reason_code` `reason_code` VARCHAR(255) NULL DEFAULT NULL;



#IfRow2D list_options list_id lists option_id clinikal_app_secondary_statuses

DELETE FROM list_options WHERE list_id = "clinikal_app_secondary_statuses" OR option_id ="clinikal_app_secondary_statuses";

#EndIf


#IfNotRow3D list_options list_id lists option_id loinc_org notes {mask: "999/999",label:"Blood pressure"}
REPLACE INTO `list_options` (`list_id`, `option_id`, `title`, `seq`,`mapping` ,`notes`, `activity`,`subtype`) VALUES
('lists', 'loinc_org', 'http://loinc.org', 0,'','', 1,''),
('loinc_org', '8480-6', 'Systolic blood pressure', 10,'bps','{"mask": "999","label":"Blood pressure"}', 1,'mmHg'),
('loinc_org', '8462-4', 'Diastolic blood pressure', 20,'bpd','{"mask": "999","label":"Blood pressure"}', 1,'mmHg'),
('loinc_org', '8308-9', 'Body height --standing', 30,'height','{"label": "Height","mask":"999"}', 1,'cm'),
('loinc_org', '8335-2', 'Body weight Estimated', 40,'weight','{"label": "Weight","mask":"999.9"}', 1,'Kg'),
('loinc_org', '69000-8','Heart rate --sitting', 50,'pulse','{"label": "Pulse","mask": "99"}', 1,'PRA'),
('loinc_org', '8310-5', 'Body temperature', 60,'temperature','{"label": "Fever","mask": "99.9"}', 1,'C'),
('loinc_org', '8327-9', 'Body temperature measurement site', 70,'temp_method','', 1,''),
('loinc_org', '20564-1', 'Oxygen saturation in Blood', 80,'oxygen_saturation','{"label": "Saturation","mask": "999%"}', 1,'%'),
('loinc_org', '39156-5', 'Body mass index (BMI) [Ratio]', 90,'BMI','', 1,'kg/m2'),
('loinc_org', '59574-4', 'Body mass index (BMI) [Percentile]', 100,'BMI_status','', 1,''),
('loinc_org', '8280-0', 'Waist Circumference at umbilicus by Tape measure', 110,'waist_circ','', 1,'cm'),
('loinc_org', '8287-5', 'Head Occipital-frontal circumference by Tape measure', 120,'head_circ','', 1,'cm'),
('loinc_org', '9303-9', 'Respiratory rate --resting', 130,'respiration','{"label": "Breaths per minute","mask": "99"}', 1,'BPM'),
('loinc_org', '72514-3', 'Pain severity - 0-10 verbal numeric rating [Score] - Reported', 140,'pain_severity','{"label": "Pain level","mask": "99"}', 1,''),
('loinc_org', '74774-1', 'Glucose [Mass/volume] in Serum, Plasma or Blood', 150,'glucose','{"label": "Blood sugar","mask": "999"}', 1,'mg/dL');
#EndIf


#IfNotRow fhir_rest_elements name Observation
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES ('Observation', 1);
#EndIf

#IfMissingColumn form_vitals glucose
ALTER TABLE `form_vitals`  ADD `glucose` INT NULL AFTER `external_id`;
#EndIf

#IfMissingColumn form_vitals pain_severity
ALTER TABLE `form_vitals` ADD `pain_severity` INT NULL AFTER `glucose`;
#EndIf

#IfMissingColumn form_vitals eid
ALTER TABLE `form_vitals` ADD `eid` INT NULL AFTER `pain_severity`;
#EndIf

#IfMissingColumn form_vitals category
ALTER TABLE `form_vitals` ADD `category` VARCHAR(255) NULL AFTER `eid`;
#EndIf

#IfNotRow2D list_options list_id lists option_id observation-category
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `toggle_setting_1`, `toggle_setting_2`, `activity`, `subtype`, `edit_options`)
VALUES
('lists', 'observation-category', 'Observation category', 0, 0, 0, '', '', '', 0, 0, 1, '', 1),
('observation-category', 'social-history', 'Social History', 10, 0, 0, '', '', '', 0, 0, 1, '', 1),
('observation-category', 'vital-signs', 'Vital Signs', 20, 0, 0, '', '', '', 0, 0, 1, '', 1),
('observation-category', 'imaging', 'Imaging', 30, 0, 0, '', '', '', 0, 0, 1, '', 1),
('observation-category', 'laboratory', 'Laboratory', 40, 0, 0, '', '', '', 0, 0, 1, '', 1),
('observation-category', 'procedure', 'Procedure', 50, 0, 0, '', '', '', 0, 0, 1, '', 1),
('observation-category', 'survey', 'Survey', 60, 0, 0, '', '', '', 0, 0, 1, '', 1),
('observation-category', 'exam', 'Exam', 70, 0, 0, '', '', '', 0, 0, 1, '', 1),
('observation-category', 'therapy', 'Therapy', 80, 0, 0, '', '', '', 0, 0, 1, '', 1),
('observation-category', 'activity', 'Activity', 90, 0, 0, '', '', '', 0, 0, 1, '', 1);
#EndIf

#IfNotRow fhir_rest_elements name MedicationRequest
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('MedicationRequest', 1);
#EndIf

#IfNotRow2D list_options list_id lists option_id medicationrequest_status
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `toggle_setting_1`, `toggle_setting_2`, `activity`, `subtype`, `edit_options`)
VALUES
('lists', 'medicationrequest_status', 'medicationrequest status', 0, 0, 0, '', '', '', 0, 0, 1, '', 1),
('medicationrequest_status', '1', 'active', 10, 0, 0, '', '', '', 0, 0, 1, '', 1),
('medicationrequest_status', '2', 'on-hold', 20, 0, 0, '', '', '', 0, 0, 1, '', 1),
('medicationrequest_status', '0', 'cancelled', 30, 0, 0, '', '', '', 0, 0, 1, '', 1),
('medicationrequest_status', '3', 'completed', 40, 0, 0, '', '', '', 0, 0, 1, '', 1),
('medicationrequest_status', '4', 'entered-in-error', 50, 0, 0, '', '', '', 0, 0, 1, '', 1),
('medicationrequest_status', '5', 'stopped', 60, 0, 0, '', '', '', 0, 0, 1, '', 1),
('medicationrequest_status', '6', 'draft', 70, 0, 0, '', '', '', 0, 0, 1, '', 1),
('medicationrequest_status', '7', 'unknown', 80, 0, 0, '', '', '', 0, 0, 1, '', 1);
#EndIf

#IfNotRow2D list_options list_id lists option_id clinikal_service_categories
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`, `codes`, `toggle_setting_1`, `toggle_setting_2`, `activity`, `subtype`, `edit_options`) VALUES
('lists', 'clinikal_service_categories', 'Clinikal Service Categories', 0, 0, 0, '', '', '', 0, 0, 1, '', 1),
('clinikal_service_categories', '14', 'Emergency Department', 10, 0, 0, '', '', '', 0, 0, 1, '', 1),
('clinikal_service_categories', '30', 'Specialist Radiology/Imaging', 10, 0, 0, '', '', '', 0, 0, 1, '', 1);
#EndIf

#IfNotTable fhir_service_request
CREATE TABLE `fhir_service_request` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) DEFAULT NULL,
  `encounter` int(11) DEFAULT NULL,
  `reason_code` varchar(255) DEFAULT NULL,
  `patient` int(11) DEFAULT NULL,
  `instruction_code` varchar(255) DEFAULT NULL,
  `order_detail_code` varchar(255) DEFAULT NULL,
  `order_detail_system` varchar(255) DEFAULT NULL,
  `patient_instruction` text DEFAULT NULL,
  `requester` int(11) DEFAULT NULL,
  `authored_on` datetime DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `intent` varchar(30) NOT NULL,
  `note` text DEFAULT NULL,
  `performer` int(11) DEFAULT NULL,
  `occurrence_datetime` datetime DEFAULT NULL,
  `reason_reference_doc_id` int(11) DEFAULT NULL,
   PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
#EndIf

#IfNotRow fhir_rest_elements name ServiceRequest
INSERT INTO `fhir_rest_elements` (`name`, `active`) VALUES
('ServiceRequest', 1);
#EndIf

#IfNotRow fhir_value_sets id drug_interval
INSERT INTO `fhir_value_sets` (`id`, `title`) VALUES
('drug_interval', 'Drug Interval');
INSERT INTO `fhir_value_set_systems` (`vs_id`, `system`, `type`) VALUES
('drug_interval', 'drug_interval', 'All');
#EndIf

#IfNotRow fhir_value_sets id drug_form
INSERT INTO `fhir_value_sets` (`id`, `title`) VALUES
('drug_form', 'Drug Form');
INSERT INTO `fhir_value_set_systems` (`vs_id`, `system`, `type`) VALUES
('drug_form', 'drug_form', 'All');
#EndIf

#IfNotRow fhir_value_sets id drug_route
INSERT INTO `fhir_value_sets` (`id`, `title`) VALUES
('drug_route', 'Drug Route');
INSERT INTO `fhir_value_set_systems` (`vs_id`, `system`, `type`) VALUES
('drug_route', 'drug_route', 'All');
#EndIf

#IfNotColumnType fhir_service_request category varchar(255)
ALTER TABLE fhir_service_request MODIFY `category`  varchar(255) DEFAULT NULL;
#EndIf

#IfNotColumnType fhir_service_request reason_code varchar(255)
ALTER TABLE fhir_service_request MODIFY `reason_code`  varchar(255) DEFAULT NULL;
#EndIf

#IfNotColumnType fhir_service_request instruction_code varchar(255)
ALTER TABLE fhir_service_request MODIFY `instruction_code`  varchar(255) DEFAULT NULL;
#EndIf

#IfNotRow fhir_value_sets id condition_statuses
INSERT INTO `fhir_value_sets` (`id`, `title`) VALUES
('condition_statuses', 'Condition Clinical Statuses');
INSERT INTO `fhir_value_set_systems` (`vs_id`, `system`, `type`) VALUES
('condition_statuses', 'outcome', 'All');
#EndIf

#IfNotRow fhir_value_sets id medication_statement_statuses
INSERT INTO `fhir_value_sets` (`id`, `title`) VALUES
('medication_statement_statuses', 'Medication Statement Statuses');
INSERT INTO `fhir_value_set_systems` (`vs_id`, `system`, `type`) VALUES
('medication_statement_statuses', 'outcome', 'All');
#EndIf

#IfNotRow fhir_value_sets id reason_codes
INSERT INTO `fhir_value_sets` (`id`, `title`)
VALUES ('reason_codes', 'All Reason Codes');
INSERT INTO `fhir_value_set_systems` (`vs_id`, `system`, `type`)
VALUES ('reason_codes', 'clinikal_reason_codes', 'All');
#EndIf

#IfNotRow fhir_value_sets id observation_statuses
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `activity`,`notes`) VALUES
('lists', 'observation_statuses', 'Observation Statuses', 0, 1,''),
('observation_statuses', 'registered', 'Registered', 10, 1,''),
('observation_statuses', 'preliminary', 'Preliminary', 20, 1,''),
('observation_statuses', 'final', 'Final', 30, 1,''),
('observation_statuses', 'amended', 'Amended', 40, 1,''),
('observation_statuses', 'corrected', 'Corrected', 60, 1,''),
('observation_statuses', 'entered-in-error', 'Entered In Error',70, 1,''),
('observation_statuses', 'unknown', 'Unknown', 80, 1,''),
('observation_statuses', 'cancelled', 'Cancelled', 50, 1,'');

INSERT INTO `fhir_value_sets` (`id`, `title`) VALUES
('observation_statuses', 'Observation Statuses');
INSERT INTO `fhir_value_set_systems` (`vs_id`, `system`, `type`) VALUES
('observation_statuses', 'observation_statuses', 'All');
#EndIf


#IfNotTable fhir_validation_settings
CREATE TABLE `fhir_validation_settings` (
`id` int(11) NOT NULL AUTO_INCREMENT,
`fhir_element` VARCHAR(255) NOT NULL ,
`filed_name` VARCHAR(255) NOT NULL ,
`request_action` ENUM('ALL','WRITE','UPDATE','POST','PUT','PATCH','DELETE','GET') NOT NULL ,
`validation` VARCHAR(255) NOT NULL ,
`validation_param` VARCHAR(255) NOT NULL ,
`type` ENUM('FHIR','DB') NOT NULL,
`active` BOOLEAN NOT NULL DEFAULT 0,
 PRIMARY KEY(`id`)
)  ENGINE = InnoDB;
#EndIf


#IfNotRow fhir_validation_settings fhir_element Encounter
INSERT INTO `fhir_validation_settings` (`fhir_element`, `filed_name`, `request_action`, `validation`, `validation_param`, `type`, `active`) VALUES
('Encounter', 'status', 'UPDATE', 'blockedIfValue', 'finished', 'DB', 1),
('Encounter', 'status', 'WRITE', 'required', '', 'DB', 1),
('Encounter', 'pid', 'WRITE', 'required', '', 'DB', 1),
('Encounter', 'date', 'WRITE', 'required', '', 'DB', 1),
('Encounter', 'status', 'WRITE', 'required', '', 'DB', 1),
('Encounter', 'service_type', 'WRITE', 'valuesetNotRequired', 'service_types', 'DB', 1);
#EndIf


#IfNotRow fhir_validation_settings fhir_element Appointment
INSERT INTO `fhir_validation_settings` (`fhir_element`, `filed_name`, `request_action`, `validation`, `validation_param`, `type`, `active`) VALUES
('Appointment', 'pc_service_type', 'WRITE', 'valueset', 'service_types', 'DB', 1),
('Appointment', 'event_codeReason_map', 'WRITE', 'aptReasonCodes', 'reason_codes_', 'DB', 1),
('Appointment', 'pc_apptstatus', 'WRITE', 'valueset', 'appointment_statuses', 'DB', 1),
('Appointment', '', 'WRITE', 'aptDateRangeCheck', '', 'DB', 1),
('Appointment', 'pc_healthcare_service_id', 'WRITE', 'required', '', 'DB', 1),
('Appointment', 'pc_pid', 'WRITE', 'ifExist', 'patient_data', 'DB', 1);
#EndIf


#IfNotRow fhir_validation_settings fhir_element Patient
INSERT INTO `fhir_validation_settings` (`fhir_element`, `filed_name`, `request_action`, `validation`, `validation_param`, `type`, `active`) VALUES
('Patient', 'lname', 'WRITE', 'required', '', 'DB', 1),
('Patient', 'fname', 'WRITE', 'required', '', 'DB', 1),
('Patient', 'sex', 'WRITE', 'required', '', 'DB', 1),
('Patient', 'DOB', 'WRITE', 'required', '', 'DB', 1);
#EndIf


#IfNotRow fhir_validation_settings fhir_element RelatedPerson
INSERT INTO `fhir_validation_settings` (`fhir_element`, `filed_name`, `request_action`, `validation`, `validation_param`, `type`, `active`) VALUES
('RelatedPerson', 'pid', 'WRITE', 'ifExist', 'patient_data', 'DB', 1),
('RelatedPerson', 'full_name', 'WRITE', 'required', '', 'DB', 1);
#EndIf


#IfNotRow fhir_validation_settings fhir_element Condition
INSERT INTO `fhir_validation_settings` (`fhir_element`, `filed_name`, `request_action`, `validation`, `validation_param`, `type`, `active`) VALUES
('Condition', 'type', 'WRITE', 'required', '', 'DB', 1),
('Condition', 'date', 'WRITE', 'required', '', 'DB', 1),
('Condition', 'diagnosis', 'WRITE', 'required', '', 'DB', 1),
('Condition', 'pid', 'WRITE', 'ifExist', 'patient_data', 'DB', 1),
('Condition', 'user', 'WRITE', 'ifExist', 'users', 'DB', 1);
#EndIf


#IfNotRow fhir_validation_settings fhir_element MedicationStatement
INSERT INTO `fhir_validation_settings` (`fhir_element`, `filed_name`, `request_action`, `validation`, `validation_param`, `type`, `active`) VALUES
('MedicationStatement', 'diagnosis', 'WRITE', 'required', '', 'DB', 1),
('MedicationStatement', 'pid', 'WRITE', 'ifExist', 'patient_data', 'DB', 1);
#EndIf

#IfNotRow fhir_validation_settings fhir_element Observation
INSERT INTO `fhir_validation_settings` (`fhir_element`, `filed_name`, `request_action`, `validation`, `validation_param`, `type`, `active`) VALUES
('Observation', 'activity', 'WRITE', 'valueset', 'observation_statuses', 'DB', 1),
('Observation', 'activity', 'UPDATE', 'blockedIfValue', 'final', 'DB', 1),
('Observation', 'date', 'WRITE', 'required', '', 'DB', 1),
('Observation', 'pid', 'WRITE', 'ifExist', 'patient_data', 'DB', 1);
#EndIf

#IfNotRow fhir_validation_settings fhir_element MedicationRequest
INSERT INTO `fhir_validation_settings` (`fhir_element`, `filed_name`, `request_action`, `validation`, `validation_param`, `type`, `active`) VALUES
('MedicationRequest', 'drug', 'WRITE', 'required', '', 'DB', 1),
('MedicationRequest', 'datetime', 'WRITE', 'required', '', 'DB', 1),
('MedicationRequest', 'drug_id', 'WRITE', 'valueset', 'drugs_list', 'DB', 1),
('MedicationRequest', 'form', 'WRITE', 'valueset', 'drug_form', 'DB', 1),
('MedicationRequest', 'route', 'WRITE', 'valueset', 'drug_route', 'DB', 1),
('MedicationRequest', 'interval', 'WRITE', 'valueset', 'drug_interval', 'DB', 1),
('MedicationRequest', 'active', 'WRITE', 'valueset', 'medicationrequest_status', 'DB', 1),
('MedicationRequest', 'patient_id', 'WRITE', 'ifExist', 'patient_data', 'DB', 1),
('MedicationRequest', 'user', 'WRITE', 'ifExist', 'users', 'DB', 1);
#EndIf


#IfNotRow fhir_validation_settings fhir_element ServiceRequest
INSERT INTO `fhir_validation_settings` (`fhir_element`, `filed_name`, `request_action`, `validation`, `validation_param`, `type`, `active`) VALUES
('ServiceRequest', 'encounter', 'WRITE', 'required', '', 'DB', 1),
('ServiceRequest', 'instruction_code', 'WRITE', 'valueset', 'tests_and_treatments', 'DB', 1),
('ServiceRequest', 'status', 'WRITE', 'valueset', 'servicerequest_statuses', 'DB', 1),
('ServiceRequest', 'status', 'UPDATE', 'blockedIfValue', 'completed', 'DB', 1),
('ServiceRequest', 'intent', 'WRITE', 'valueset', 'servicerequest_intent', 'DB', 1),
('ServiceRequest', 'patient', 'WRITE', 'ifExist', 'patient_data', 'DB', 1);
#EndIf

#IfNotRow fhir_value_sets id medicationrequest_status
INSERT INTO `fhir_value_sets` (`id`, `title`) VALUES
('medicationrequest_status', 'Medication Request Statuses');
INSERT INTO `fhir_value_set_systems` (`vs_id`, `system`, `type`) VALUES
('medicationrequest_status', 'medicationrequest_status', 'All');
#EndIf

#IfNotRow fhir_value_sets id servicerequest_statuses
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `activity`,`notes`) VALUES
('lists', 'servicerequest_statuses', 'Service Request Statuses', 0, 1,''),
('servicerequest_statuses', 'draft', 'Draft', 10, 1,''),
('servicerequest_statuses', 'active', 'Active', 20, 1,''),
('servicerequest_statuses', 'on-hold', 'On Hold', 30, 1,''),
('servicerequest_statuses', 'revoked', 'Revoked', 40, 1,''),
('servicerequest_statuses', 'completed', 'Completed', 60, 1,''),
('servicerequest_statuses', 'entered-in-error', 'Entered In Error',70, 1,''),
('servicerequest_statuses', 'unknown', 'Unknown', 80, 1,'');


INSERT INTO `fhir_value_sets` (`id`, `title`) VALUES
('servicerequest_statuses', 'Service Request Statuses');
INSERT INTO `fhir_value_set_systems` (`vs_id`, `system`, `type`) VALUES
('servicerequest_statuses', 'servicerequest_statuses', 'All');
#EndIf

#IfNotRow fhir_value_sets id servicerequest_intent
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`, `activity`,`notes`) VALUES
('lists', 'servicerequest_intent', 'Service Request Intent', 0, 1,''),
('servicerequest_intent', 'proposal', 'Proposal', 10, 1,''),
('servicerequest_intent', 'plan', 'Plan', 20, 1,''),
('servicerequest_intent', 'directive', 'Directive', 30, 1,''),
('servicerequest_intent', 'order', 'Order', 40, 1,''),
('servicerequest_intent', 'original-order', 'Original Order', 60, 1,''),
('servicerequest_intent', 'reflex-order', 'Reflex Order',70, 1,''),
('servicerequest_intent', 'filler-order', 'Filler Order',70, 1,''),
('servicerequest_intent', 'instance-order', 'Instance Order',70, 1,''),
('servicerequest_intent', 'option', 'Option', 80, 1,'');


INSERT INTO `fhir_value_sets` (`id`, `title`) VALUES
('servicerequest_intent', 'Service Request Intent');
INSERT INTO `fhir_value_set_systems` (`vs_id`, `system`, `type`) VALUES
('servicerequest_intent', 'servicerequest_intent', 'All');
#EndIf


#IfMissingColumn lists diagnosis_valueset
ALTER TABLE `lists` ADD `diagnosis_valueset` VARCHAR(255) NULL AFTER `diagnosis`;
#EndIf


#IfNotRow3D fhir_validation_settings fhir_element Encounter filed_name status validation blockedEncounter
UPDATE `fhir_validation_settings` SET `validation` = 'blockedEncounter' WHERE
`fhir_element` = 'Encounter' and `filed_name` = 'status'AND `validation` = 'blockedIfValue';
#EndIf

#IfRow3D fhir_validation_settings fhir_element RelatedPerson filed_name full_name validation required
DELETE FROM `fhir_validation_settings` WHERE
`fhir_element` = 'RelatedPerson' and `filed_name` = 'full_name'AND `validation` = 'required';
#EndIf


ALTER TABLE `related_person` CHANGE `active` `active` TINYINT(1) NOT NULL DEFAULT '1';

#IfRow3D fhir_validation_settings fhir_element MedicationStatement filed_name outcome validation valueset
DELETE FROM fhir_validation_settings WHERE fhir_element = 'MedicationStatement' AND filed_name = 'outcome' AND validation = 'valueset';
#EndIf

#IfMissingColumn form_vitals observation_status
ALTER TABLE `form_vitals` ADD `observation_status` VARCHAR(20) NULL AFTER `category`;
#EndIf

#IfRow3D fhir_validation_settings fhir_element Observation filed_name activity validation valueset
UPDATE fhir_validation_settings SET filed_name = 'observation_status' WHERE fhir_element = 'Observation' AND filed_name = 'activity' AND validation = 'valueset';
#EndIf

#IfRow3D fhir_validation_settings fhir_element Observation filed_name activity validation blockedIfValue
UPDATE fhir_validation_settings SET filed_name = 'observation_status' WHERE fhir_element = 'Observation' AND filed_name = 'activity' AND validation = 'blockedIfValue';
#EndIf
