CREATE SCHEMA `task_manager` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `task_manager`.`user` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `uid` VARCHAR(36) NOT NULL,
  `firstName` VARCHAR(50) NULL DEFAULT NULL,
  `middleName` VARCHAR(50) NULL DEFAULT NULL,
  `lastName` VARCHAR(50) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL,
  `password` VARCHAR(32) NOT NULL,
  `registeredAt` DATETIME NOT NULL,
  `avatar` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_uid` (`uid` ASC),
  UNIQUE INDEX `uq_email` (`email` ASC)
);

CREATE TABLE `task_manager`.`status` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(260) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE INDEX `uq_slug` (`slug` ASC)
);

CREATE TABLE `task_manager`.`task` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `userId` BIGINT UNSIGNED NOT NULL,
  `title` VARCHAR(512) NOT NULL,
  `description` VARCHAR(2048) DEFAULT NULL,
  `hours` FLOAT NOT NULL DEFAULT 0,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `plannedStartDate` DATETIME NULL DEFAULT NULL,
  `plannedEndDate` DATETIME NULL DEFAULT NULL,
  `actualStartDate` DATETIME NULL DEFAULT NULL,
  `actualEndDate` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_task_user` (`userId` ASC),
  CONSTRAINT `fk_task_user`
    FOREIGN KEY (`userId`)
    REFERENCES `task_manager`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

CREATE TABLE `task_manager`.`task_meta` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `taskId` BIGINT UNSIGNED NOT NULL,
  `key` VARCHAR(50) NOT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_meta_task` (`taskId` ASC),
  UNIQUE INDEX `uq_task_meta` (`taskId` ASC, `key` ASC),
  CONSTRAINT `fk_meta_task`
    FOREIGN KEY (`taskId`)
    REFERENCES `task_manager`.`task` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
CREATE TABLE `task_manager`.`tag` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(75) NOT NULL,
  `slug` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE `task_manager`.`task_tag` (
  `taskId` BIGINT UNSIGNED NOT NULL,
  `tagId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`taskId`, `tagId`),
  INDEX `idx_tt_task` (`taskId` ASC),
  INDEX `idx_tt_tag` (`tagId` ASC),
  CONSTRAINT `fk_tt_task`
    FOREIGN KEY (`taskId`)
    REFERENCES `task_manager`.`task` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tt_tag`
    FOREIGN KEY (`tagId`)
    REFERENCES `task_manager`.`tag` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


CREATE TABLE `task_manager`.`activity` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `statusId` BIGINT UNSIGNED NOT NULL,
  `taskId` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_activity_status_id` (`statusId` ASC),
  INDEX `idx_task_id` (`taskId` ASC),

  CONSTRAINT `fk_activity_status`
    FOREIGN KEY (`statusId`)
    REFERENCES `task_manager`.`status` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_activity_task`
    FOREIGN KEY (`taskId`)
    REFERENCES `task_manager`.`task` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);


CREATE TABLE `task_manager`.`comment` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `taskId` BIGINT UNSIGNED NOT NULL,
  `activityId` BIGINT UNSIGNED NULL DEFAULT NULL,
  `title` VARCHAR(100) NOT NULL,
  `createdAt` DATETIME NOT NULL,
  `updatedAt` DATETIME NULL DEFAULT NULL,
  `content` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_comment_task` (`taskId` ASC),
  CONSTRAINT `fk_comment_task`
    FOREIGN KEY (`taskId`)
    REFERENCES `task_manager`.`task` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

ALTER TABLE `task_manager`.`comment` 
ADD INDEX `idx_comment_activity` (`activityId` ASC);
ALTER TABLE `task_manager`.`comment` 
ADD CONSTRAINT `fk_comment_activity`
  FOREIGN KEY (`activityId`)
  REFERENCES `task_manager`.`activity` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;