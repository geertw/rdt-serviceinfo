SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

CREATE TABLE `changes` (
  `station` varchar(6) CHARACTER SET utf8 DEFAULT NULL,
  `fromservice` int(11) NOT NULL,
  `toservice` int(11) NOT NULL,
  `possiblechange` smallint(6) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `company` (
  `company` int(11) NOT NULL,
  `code` varchar(9) CHARACTER SET utf8 NOT NULL,
  `name` varchar(29) CHARACTER SET utf8 NOT NULL,
  `timeturn` time DEFAULT NULL,
  PRIMARY KEY (`company`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `company` (`company`, `code`, `name`, `timeturn`) VALUES
(1,	'utts',	'Unit testing transport',	NULL);

CREATE TABLE `connmode` (
  `code` varchar(4) CHARACTER SET utf8 NOT NULL,
  `connectiontype` smallint(6) NOT NULL,
  `description` varchar(29) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `contconn` (
  `fromstation` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `tostation` varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `connectiontime` int(11) NOT NULL,
  `connectionmode` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`fromstation`,`tostation`,`connectionmode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `country` (
  `code` varchar(4) CHARACTER SET utf8 NOT NULL,
  `inland` tinyint(1) NOT NULL,
  `name` varchar(29) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `country` (`code`, `inland`, `name`) VALUES
('NL',	0,	'Nederland');

CREATE TABLE `delivery` (
  `company` int(11) DEFAULT NULL,
  `firstday` date DEFAULT NULL,
  `lastday` date DEFAULT NULL,
  `versionnumber` int(11) DEFAULT NULL,
  `description` varchar(29) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `footnote` (
  `footnote` int(11) NOT NULL DEFAULT '0',
  `servicedate` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`footnote`,`servicedate`),
  KEY `servicedate` (`servicedate`),
  KEY `footnote` (`footnote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `footnote` (`footnote`, `servicedate`) VALUES
(0,	'2015-04-01'),
(15,	'2016-04-01');

CREATE TABLE `station` (
  `shortname` varchar(6) NOT NULL,
  `trainchanges` smallint(6) DEFAULT NULL,
  `layovertime` int(11) DEFAULT NULL,
  `country` varchar(4) DEFAULT NULL,
  `timezone` int(11) DEFAULT NULL,
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL,
  `name` varchar(29) DEFAULT NULL,
  PRIMARY KEY (`shortname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `station` (`shortname`, `trainchanges`, `layovertime`, `country`, `timezone`, `x`, `y`, `name`) VALUES
('asd',	1,	300,	'NL',	0,	121860,	487980,	'Amsterdam Centraal'),
('gvc',	1,	300,	'NL',	0,	82120,	455310,	'Den Haag Centraal'),
('ledn',	1,	300,	'NL',	0,	93140,	464650,	'Leiden Centraal'),
('rtd',	1,	300,	'NL',	0,	91870,	437800,	'Rotterdam Centraal'),
('shl',	1,	240,	'NL',	0,	112380,	480220,	'Schiphol'),
('ut',	1,	300,	'NL',	0,	136070,	455760,	'Utrecht Centraal');

CREATE TABLE `timetable_attribute` (
  `serviceid` int(11) NOT NULL,
  `code` varchar(4) CHARACTER SET utf8 DEFAULT NULL,
  `firststop` int(1) DEFAULT NULL,
  `laststop` int(11) DEFAULT NULL,
  KEY `serviceid` (`serviceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `timetable_attribute` (`serviceid`, `code`, `firststop`, `laststop`) VALUES
(1,	'NIIN',	4,	5);

CREATE TABLE `timetable_platform` (
  `serviceid` int(11) NOT NULL DEFAULT '0',
  `idx` int(11) NOT NULL DEFAULT '0',
  `station` varchar(6) CHARACTER SET utf8 DEFAULT NULL,
  `arrival` varchar(4) CHARACTER SET utf8 DEFAULT NULL,
  `departure` varchar(4) CHARACTER SET utf8 DEFAULT NULL,
  `footnote` int(11) DEFAULT NULL,
  PRIMARY KEY (`serviceid`,`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `timetable_platform` (`serviceid`, `idx`, `station`, `arrival`, `departure`, `footnote`) VALUES
(1,	1,	'ut',	NULL,	'14b',	0),
(1,	2,	'asd',	'5a',	'5b',	0),
(1,	3,	'shl',	'1',	'1',	0),
(1,	4,	'gvc',	'5',	'5',	0),
(1,	5,	'rtd',	'9',	NULL,	0);

CREATE TABLE `timetable_service` (
  `serviceid` int(11) NOT NULL,
  `companynumber` int(11) DEFAULT NULL,
  `servicenumber` int(11) DEFAULT NULL,
  `variant` varchar(6) CHARACTER SET utf8 DEFAULT NULL,
  `firststop` int(11) DEFAULT NULL,
  `laststop` int(11) DEFAULT NULL,
  `servicename` varchar(29) CHARACTER SET utf8 DEFAULT NULL,
  KEY `serviceid` (`serviceid`),
  KEY `serviceid_firststop_laststop` (`serviceid`,`firststop`,`laststop`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `timetable_service` (`serviceid`, `companynumber`, `servicenumber`, `variant`, `firststop`, `laststop`, `servicename`) VALUES
(1,	1,	1234,	'',	1,	5,	'Midnight Express'),
(2,	1,	5678,	'',	1,	3,	''),
(3,	1,	0,	'',	1,	2,	''),
(2,	1,	6678,	'',	3,	5,	''),
(5,	1,	0,	'12345',	1,	2,	'');

CREATE TABLE `timetable_stop` (
  `serviceid` int(11) NOT NULL DEFAULT '0',
  `idx` int(11) NOT NULL DEFAULT '0',
  `station` varchar(6) CHARACTER SET utf8 DEFAULT NULL,
  `arrivaltime` time DEFAULT NULL,
  `departuretime` time DEFAULT NULL,
  PRIMARY KEY (`serviceid`,`idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `timetable_stop` (`serviceid`, `idx`, `station`, `arrivaltime`, `departuretime`) VALUES
(1,	1,	'ut',	NULL,	'02:07:00'),
(1,	2,	'asd',	'02:43:00',	'02:45:00'),
(1,	3,	'shl',	'03:15:00',	'03:20:00'),
(1,	4,	'gvc',	'03:34:00',	'03:37:00'),
(1,	5,	'rtd',	'03:56:00',	NULL),
(2,	1,	'rtd',	NULL,	'12:34:00'),
(2,	2,	'gvc',	'12:51:00',	'12:55:00'),
(2,	3,	'ledn',	'13:05:00',	'13:10:00'),
(2,	4,	'shl',	'13:35:00',	'13:35:00'),
(2,	5,	'asd',	'13:45:00',	NULL),
(3,	1,	'rtd',	NULL,	'12:34:00'),
(3,	2,	'shl',	NULL,	'13:04:00'),
(5,	1,	'rtd',	NULL,	'12:34:00'),
(5,	2,	'shl',	NULL,	'13:04:00');

CREATE TABLE `timetable_transport` (
  `serviceid` int(11) NOT NULL,
  `transmode` varchar(4) CHARACTER SET utf8 DEFAULT NULL,
  `firststop` int(11) DEFAULT NULL,
  `laststop` int(11) DEFAULT NULL,
  KEY `serviceid` (`serviceid`),
  KEY `transmode` (`transmode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `timetable_transport` (`serviceid`, `transmode`, `firststop`, `laststop`) VALUES
(1,	'IC',	1,	5),
(3,	'NSB',	1,	2),
(2,	'S',	1,	5);

CREATE TABLE `timetable_validity` (
  `serviceid` int(11) NOT NULL,
  `footnote` int(11) DEFAULT NULL,
  `firststop` int(11) DEFAULT NULL,
  `laststop` int(11) DEFAULT NULL,
  UNIQUE KEY `serviceid_2` (`serviceid`,`footnote`),
  KEY `serviceid` (`serviceid`),
  KEY `footnote` (`footnote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `timetable_validity` (`serviceid`, `footnote`, `firststop`, `laststop`) VALUES
(1,	0,	0,	999),
(3,	0,	0,	999),
(2,	0,	0,	999),
(5,	0,	0,	999),
(1,	15,	0,	999);

CREATE TABLE `timezone` (
  `tznumber` int(11) NOT NULL,
  `difference` int(11) DEFAULT NULL,
  `firstday` date NOT NULL,
  `lastday` date NOT NULL,
  PRIMARY KEY (`tznumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `trnsaqst` (
  `code` varchar(3) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `inclusive` tinyint(1) DEFAULT NULL,
  `question` varchar(29) CHARACTER SET utf8 NOT NULL,
  `transattr` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`code`,`transattr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `trnsattr` (
  `code` varchar(4) CHARACTER SET utf8 NOT NULL,
  `processingcode` smallint(6) NOT NULL,
  `description` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `trnsattr` (`code`, `processingcode`, `description`) VALUES
('NIIN',	7,	'Niet instappen voor reizigers'),
('NUIT',	6,	'Niet uitstappen voor reizigers');

CREATE TABLE `trnsmode` (
  `code` varchar(4) CHARACTER SET utf8 NOT NULL,
  `description` varchar(29) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `trnsmode` (`code`, `description`) VALUES
('IC',	'Intercity'),
('NSB',	'Stopbus i.p.v. trein'),
('NSS',	'Snelbus i.p.v. trein'),
('S',	'Sneltrein'),
('SPR',	'Sprinter'),
('ST',	'stoptrein');
