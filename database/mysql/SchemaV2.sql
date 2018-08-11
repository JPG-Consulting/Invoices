ALTER TABLE user_roles DROP FOREIGN KEY user_roles_roles_fk;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS user_roles;

CREATE TABLE IF NOT EXISTS users (
	user_id INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'The identifier of the user',
	user_name VARCHAR(255) NOT NULL COMMENT 'The name of the user',
	user_password CHAR(41) NOT NULL COMMENT 'The password of the user',
	active BOOL DEFAULT 1 NOT NULL COMMENT 'Flag indicating if the user is active',
	created_at DATETIME NOT NULL COMMENT 'The date and time when the record was first created',
	created_by VARCHAR(100) NOT NULL COMMENT 'The username of whom created this record',
	modified_at DATETIME NULL COMMENT 'The date and time when this record was lat modified',
	modified_by VARCHAR(100) NULL COMMENT 'The username of whom last modified this record',
	CONSTRAINT users_pk PRIMARY KEY (user_id),
	CONSTRAINT companies_un UNIQUE KEY (user_name)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci ;

CREATE TABLE IF NOT EXISTS roles (
	role_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'The role identifier',
	role_name VARCHAR(50) NOT NULL COMMENT 'The role name',
	created_at DATETIME NOT NULL COMMENT 'The date and time when the record was first created',
	created_by VARCHAR(100) NOT NULL COMMENT 'The username of whom created this record',
	modified_at DATETIME NULL COMMENT 'The date and time when this record was lat modified',
	modified_by VARCHAR(100) NULL COMMENT 'The username of whom last modified this record',
	CONSTRAINT roles_pk PRIMARY KEY (role_id),
	CONSTRAINT roles_un UNIQUE KEY (role_name)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci ;

-- Insert the default roles
INSERT INTO roles (role_name, created_at, created_by) VALUES('Administrators', NOW(), 'System');

-- Triggers to avoid messing default roles
DROP TRIGGER trigger_before_delete_role;
DROP TRIGGER trigger_before_update_role;

DELIMITER //

CREATE TRIGGER trigger_before_delete_role BEFORE DELETE ON roles
FOR EACH ROW
BEGIN
    IF(OLD.role_name = 'Administrators') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'The role can not be deleted';
    END IF;
END//

CREATE TRIGGER trigger_before_update_role BEFORE UPDATE ON roles
FOR EACH ROW
BEGIN
    IF(OLD.role_name = 'Administrators') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'The role can not be deleted';
    END IF;
END//

DELIMITER ;

CREATE TABLE IF NOT EXISTS user_roles(
	role_id TINYINT UNSIGNED NOT NULL COMMENT 'The role identifier',
	user_id INT UNSIGNED NOT NULL COMMENT 'The identifier of the user',
	CONSTRAINT user_roles_pk PRIMARY KEY (role_id,user_id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci ;



--
-- Foreign Keys
--

ALTER TABLE user_roles ADD CONSTRAINT user_roles_roles_fk FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE CASCADE ON UPDATE CASCADE ;


--
-- Stored Procedures
--
DROP PROCEDURE IF EXISTS CreateUser;

DELIMITER //

CREATE PROCEDURE CreateUser(IN UserName VARCHAR(255), IN UserPassword VARCHAR(64), IN AdminUserName VARCHAR(255) )
BEGIN
	INSERT INTO
		USERS
	(
		user_name,
		user_password,
		created_at,
		created_by
	)
	VALUES
	(
		UserName,
		PASSWORD(CONCAT(SHA1(UserName), ':', UserPassword)),
		NOW(),
		AdminUserName
	);
END //
 
DELIMITER ;

--
-- Change password
--

DROP PROCEDURE IF EXISTS ChangePassword;

DELIMITER //

CREATE PROCEDURE ChangePassword(IN UserName VARCHAR(255), in OldPassword VARCHAR(64), IN NewPassword VARCHAR(64))
BEGIN
	DECLARE MyCounter INT UNSIGNED;

	SELECT COUNT(user_name) INTO MyCounter FROM users WHERE user_name=UserName;
	IF(MyCounter <> 1) THEN 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'User not found';
	END IF;
	
	SELECT COUNT(user_name) INTO MyCounter FROM users WHERE user_name=UserName AND user_password=PASSWORD(CONCAT(SHA1(UserName), ':', OldPassword));
	IF(MyCounter <> 1) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Bad username or password';
	END IF;
	
	UPDATE
		USERS
	SET
		user_password=PASSWORD(CONCAT(SHA1(UserName), ':', NewPassword)),
		modified_at=NOW(),
		modified_by=UserName
	WHERE
		user_name=UserName;
END //
 
DELIMITER ;
