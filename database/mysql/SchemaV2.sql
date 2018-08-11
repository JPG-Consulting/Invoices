DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS user_roles;

CREATE TABLE IF NOT EXISTS users (
	user_id INT UNSIGNED NOT NULL COMMENT 'The identifier of the user',
	user_name VARCHAR(255) NOT NULL COMMENT 'The name of the user',
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
	role_id TINYINT UNSIGNED NOT NULL COMMENT 'The role identifier',
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

