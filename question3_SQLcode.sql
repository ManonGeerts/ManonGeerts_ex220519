-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema bioinf_exam
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema bioinf_exam
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bioinf_exam` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `bioinf_exam` ;

-- -----------------------------------------------------
-- Table `bioinf_exam`.`exon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bioinf_exam`.`exon` (
  `exon_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `seq_region_start` INT(10) UNSIGNED NOT NULL,
  `seq_region_end` INT(10) UNSIGNED NOT NULL,
  `seq_region_strand` TINYINT(2) NOT NULL,
  `phase` TINYINT(2) NOT NULL,
  `end_phase` TINYINT(2) NOT NULL,
  PRIMARY KEY (`exon_id`),
  INDEX `seq_region_idx` (`seq_region_start` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 1561865
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `bioinf_exam`.`gene`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bioinf_exam`.`gene` (
  `gene_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `biotype` VARCHAR(40) NOT NULL,
  `chromosome` VARCHAR(40) NULL DEFAULT NULL,
  `seq_region_start` INT(10) UNSIGNED NOT NULL,
  `seq_region_end` INT(10) UNSIGNED NOT NULL,
  `seq_region_strand` TINYINT(2) NOT NULL,
  `gene_name` VARCHAR(128) NULL DEFAULT NULL,
  `source` VARCHAR(20) NOT NULL,
  `status` ENUM('KNOWN', 'NOVEL', 'PUTATIVE', 'PREDICTED', 'KNOWN_BY_PROJECTION', 'UNKNOWN') NULL DEFAULT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`gene_id`),
  INDEX `seq_region_idx` (`seq_region_start` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 139294
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `bioinf_exam`.`transcript`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bioinf_exam`.`transcript` (
  `transcript_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `gene_id` INT(10) UNSIGNED NOT NULL,
  `seq_region_start` INT(10) UNSIGNED NOT NULL,
  `seq_region_end` INT(10) UNSIGNED NOT NULL,
  `seq_region_strand` TINYINT(2) NOT NULL,
  `biotype` VARCHAR(40) NOT NULL,
  `status` ENUM('KNOWN', 'NOVEL', 'PUTATIVE', 'PREDICTED', 'KNOWN_BY_PROJECTION', 'UNKNOWN') NULL DEFAULT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`transcript_id`),
  INDEX `gene_index` (`gene_id` ASC) VISIBLE,
  INDEX `seq_region_idx` (`seq_region_start` ASC) VISIBLE,
  INDEX `gene` (`gene_id` ASC) VISIBLE,
  INDEX `fk_gene` (`gene_id` ASC) VISIBLE,
  INDEX `genez` (`gene_id` ASC) VISIBLE,
  CONSTRAINT `genez`
    FOREIGN KEY (`gene_id`)
    REFERENCES `bioinf_exam`.`gene` (`gene_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 408506
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `bioinf_exam`.`exon_transcript`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bioinf_exam`.`exon_transcript` (
  `exon_id` INT(10) UNSIGNED NOT NULL,
  `transcript_id` INT(10) UNSIGNED NOT NULL,
  `rank` INT(10) NOT NULL,
  PRIMARY KEY (`exon_id`, `transcript_id`, `rank`),
  INDEX `transcript` (`transcript_id` ASC) VISIBLE,
  INDEX `exon` (`exon_id` ASC) VISIBLE,
  INDEX `fk_exon` (`exon_id` ASC) VISIBLE,
  INDEX `transcriptz` (`transcript_id` ASC) VISIBLE,
  INDEX `exonz` (`exon_id` ASC) VISIBLE,
  CONSTRAINT `exonz`
    FOREIGN KEY (`exon_id`)
    REFERENCES `bioinf_exam`.`exon` (`exon_id`),
  CONSTRAINT `transcriptz`
    FOREIGN KEY (`transcript_id`)
    REFERENCES `bioinf_exam`.`transcript` (`transcript_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `bioinf_exam`.`SYNDROME`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bioinf_exam`.`SYNDROME` (
  `ID_syndrome` INT UNSIGNED NOT NULL,
  `syndrome` INT UNSIGNED NOT NULL COMMENT 'syndrome should be VARCHAR\ndescription should be TEXT',
  `description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID_syndrome`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bioinf_exam`.`GENE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bioinf_exam`.`GENE` (
  `ID_gene` INT UNSIGNED NOT NULL,
  `gene_name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`ID_gene`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bioinf_exam`.`MUTATION`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bioinf_exam`.`MUTATION` (
  `ID_mutation` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ID_syndrome` INT UNSIGNED NOT NULL,
  `ID_gene` INT UNSIGNED NOT NULL,
  `seq_region_start` INT NOT NULL,
  `seq_region_end` INT NOT NULL,
  `chromosome` INT NULL,
  PRIMARY KEY (`ID_mutation`),
  UNIQUE INDEX `ID_mutation_UNIQUE` (`ID_mutation` ASC) VISIBLE,
  INDEX `fk_syndrome_idx` (`ID_syndrome` ASC) VISIBLE,
  INDEX `fk_gene_idx` (`ID_gene` ASC) VISIBLE,
  CONSTRAINT `fk_syndrome`
    FOREIGN KEY (`ID_syndrome`)
    REFERENCES `bioinf_exam`.`SYNDROME` (`ID_syndrome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gene`
    FOREIGN KEY (`ID_gene`)
    REFERENCES `bioinf_exam`.`GENE` (`ID_gene`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bioinf_exam`.`PATIENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `bioinf_exam`.`PATIENT` (
  `ID_patient` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `gender` VARCHAR(45) NULL COMMENT 'datatype of gender should by ENUM but it doesn\'t work',
  `age_at_diagnose` INT UNSIGNED NOT NULL,
  `ID_syndrome` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`ID_patient`),
  INDEX `fk_syndrome_idx` (`ID_syndrome` ASC) VISIBLE,
  CONSTRAINT `fk_syndrome`
    FOREIGN KEY (`ID_syndrome`)
    REFERENCES `bioinf_exam`.`SYNDROME` (`ID_syndrome`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
