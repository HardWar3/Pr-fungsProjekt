-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema test_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema test_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `test_db` DEFAULT CHARACTER SET latin1 ;
USE `test_db` ;

-- -----------------------------------------------------
-- Table `test_db`.`etagen`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`etagen` (
  `etagenID_ID` INT(11) NOT NULL AUTO_INCREMENT,
  `etagenID` VARCHAR(45) NULL DEFAULT NULL,
  `etagenName` VARCHAR(45) NULL DEFAULT NULL,
  `raeumeID` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`etagenID_ID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `test_db`.`plaetze`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`plaetze` (
  `platzID` INT(11) NOT NULL AUTO_INCREMENT,
  `platzNummer` INT(11) NULL DEFAULT NULL,
  `teilnehmerName` VARCHAR(45) NULL DEFAULT NULL,
  `datumVon` VARCHAR(45) NULL DEFAULT NULL,
  `datumBis` VARCHAR(45) NULL DEFAULT NULL,
  `positionLeft` VARCHAR(45) NULL DEFAULT NULL,
  `positionTop` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`platzID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `test_db`.`raeume`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`raeume` (
  `raumID` INT(11) NOT NULL AUTO_INCREMENT,
  `raumName` VARCHAR(45) NULL DEFAULT NULL,
  `view` TINYINT(4) NULL DEFAULT NULL,
  `plaetzeID` INT(11) NULL DEFAULT NULL,
  `tuerPositionLeft` INT(11) NULL DEFAULT NULL,
  `tuerPositionTop` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`raumID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `test_db`.`raummanagementsystem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`raummanagementsystem` (
  `firma` VARCHAR(90) NULL,
  `firmaID` INT NOT NULL,
  PRIMARY KEY (`firmaID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `test_db`.`etagenID`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`etagenID` (
  `firmaID` INT NOT NULL,
  `etagenID` INT NOT NULL,
  PRIMARY KEY (`firmaID`, `etagenID`),
  INDEX `etagenID_idx` (`etagenID` ASC) VISIBLE,
  CONSTRAINT `firmaID`
    FOREIGN KEY (`firmaID`)
    REFERENCES `test_db`.`raummanagementsystem` (`firmaID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `etagenID`
    FOREIGN KEY (`etagenID`)
    REFERENCES `test_db`.`etagen` (`etagenID_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `test_db`.`raeumeID`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`raeumeID` (
  `etagenID` INT NOT NULL,
  `raumID` INT NOT NULL,
  PRIMARY KEY (`etagenID`, `raumID`),
  INDEX `raumID_idx` (`raumID` ASC) VISIBLE,
  CONSTRAINT `etagenID`
    FOREIGN KEY (`etagenID`)
    REFERENCES `test_db`.`etagen` (`etagenID_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `raumID`
    FOREIGN KEY (`raumID`)
    REFERENCES `test_db`.`raeume` (`raumID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `test_db`.`plaetzeID`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `test_db`.`plaetzeID` (
  `raumID` INT NOT NULL,
  `platzID` INT NOT NULL,
  PRIMARY KEY (`raumID`, `platzID`),
  INDEX `platzID_idx` (`platzID` ASC) VISIBLE,
  CONSTRAINT `raumID`
    FOREIGN KEY (`raumID`)
    REFERENCES `test_db`.`raeume` (`raumID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `platzID`
    FOREIGN KEY (`platzID`)
    REFERENCES `test_db`.`plaetze` (`platzID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE USER 'user1';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
