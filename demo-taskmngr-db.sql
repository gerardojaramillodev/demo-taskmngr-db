-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema demo-taskmngr-db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `demo-taskmngr-db` ;

-- -----------------------------------------------------
-- Schema demo-taskmngr-db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `demo-taskmngr-db` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `demo-taskmngr-db` ;

-- -----------------------------------------------------
-- Table `task`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `task` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `task` (
  `taskid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(72) NOT NULL,
  `descr` VARCHAR(45) NULL,
  `createdat` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `updatedat` TIMESTAMP NOT NULL DEFAULT current_timestamp on update current_timestamp,
  `projectid` INT NOT NULL,
  `status` ENUM('Not started', 'In Progress', 'Blocked', 'Done') NOT NULL DEFAULT 'Not started',
  `uuid` BINARY(16) NOT NULL DEFAULT (uuid_to_bin(uuid())),
  PRIMARY KEY (`taskid`, `uuid`),
  UNIQUE INDEX `taskid_UNIQUE` (`taskid` ASC) VISIBLE,
  UNIQUE INDEX `uuid_UNIQUE` (`uuid` ASC) VISIBLE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `project`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `project` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `project` (
  `projectid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `descr` VARCHAR(92) NULL,
  `createdat` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `updatedat` TIMESTAMP NOT NULL DEFAULT current_timestamp on update current_timestamp,
  `status` VARCHAR(45) NULL,
  `uuid` BINARY(16) NOT NULL DEFAULT (uuid_to_bin(uuid())),
  PRIMARY KEY (`projectid`, `uuid`),
  UNIQUE INDEX `projectid_UNIQUE` (`projectid` ASC) VISIBLE,
  UNIQUE INDEX `uuid_UNIQUE` (`uuid` ASC) VISIBLE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `user` (
  `userid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `email` VARCHAR(64) NOT NULL,
  `createdat` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `updatedat` TIMESTAMP NOT NULL DEFAULT current_timestamp on update current_timestamp,
  `status` ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
  `uuid` BINARY(16) NOT NULL DEFAULT (uuid_to_bin(uuid())),
  PRIMARY KEY (`userid`, `uuid`),
  UNIQUE INDEX `userid_UNIQUE` (`userid` ASC) VISIBLE,
  UNIQUE INDEX `uuid_UNIQUE` (`uuid` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `user_picture`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user_picture` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `user_picture` (
  `userid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `filename` VARCHAR(72) NOT NULL,
  `contentType` VARCHAR(24) NULL,
  `picture` BLOB NULL,
  `createdat` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `updatedat` TIMESTAMP NOT NULL DEFAULT current_timestamp on update current_timestamp,
  `status` ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`userid`),
  UNIQUE INDEX `profileid_UNIQUE` (`userid` ASC) VISIBLE)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `task_assign`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `task_assign` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `task_assign` (
  `taskid` INT UNSIGNED NOT NULL,
  `userid` INT UNSIGNED NOT NULL)
ENGINE = InnoDB;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


drop procedure if exists sp_task_list;
delimiter //
create definer=`root`@`%` procedure `sp_task_list`()
begin
   select json_object('taskid', t.taskid, 'name', t.name, 'descr', t.descr, 'projectid', t.projectid, 'status', t.status, 'assigns', json_arrayagg(a.assigns)) json
	 from task t
left join (select a.taskid, json_object('userid', a.userid, 'name', u.name, 'email', u.email) assigns
			 from task_assign a
             join user u
			   on a.userid = u.userid) a
	   on t.taskid = a.taskid
 group by t.taskid
 order by t.taskid;
 end //
delimiter ;

insert into project (name, descr) values
    ('Piloto', 'Piloto'),
    ('Diversity Day', 'Diversity Day'),
    ('Health Care', 'Health Care'),
    ('The Alliance', 'The Alliance'),
    ('Basketball', 'Basketball'),
    ('Hot Girl', 'Hot Girl')
    ;

insert into task (name, descr, projectid) values
    ('task #1', 'task #1', 1),
    ('task #2', 'task #2', 2),
    ('task #3', 'task #3', 3);
    
insert into task_assign (taskid, userid)
	values
		(1, 1),
        (1, 2),
        (1, 3),
        (2, 4),
        (3, 5);





