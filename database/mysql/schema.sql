DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS user_roles;

CREATE TABLE IF NOT EXISTS users (
	user_id INT UNSIGNED NOT NULL COMMENT 'The identifier of the user',
	user_name VARCHAR(255) NOT NULL COMMENT 'The name of the user',
	active BOOL NOT NULL COMMENT 'Flag indicating if the user is active',
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

CREATE TABLE IF NOT EXISTS companies (
	company_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'The company identifier',
	company_name VARCHAR(255) NOT NULL COMMENT 'The company name',
	active BOOL NOT NULL COMMENT 'Flag indicating if the company is active',
	created_at DATETIME NOT NULL COMMENT 'The date and time when the record was first created',
	created_by VARCHAR(100) NOT NULL COMMENT 'The username of whom created this record',
	modified_at DATETIME NULL COMMENT 'The date and time when this record was lat modified',
	modified_by VARCHAR(100) NULL COMMENT 'The username of whom last modified this record',
	CONSTRAINT companies_pk PRIMARY KEY (company_id),
	CONSTRAINT companies_un UNIQUE KEY (company_name)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci ;

CREATE TABLE IF NOT EXISTS roles (
	company_id TINYINT UNSIGNED NOT NULL COMMENT 'The company identifier',
	role_id TINYINT UNSIGNED NOT NULL COMMENT 'The role identifier',
	role_name VARCHAR(50) NOT NULL COMMENT 'The role name',
	created_at DATETIME NOT NULL COMMENT 'The date and time when the record was first created',
	created_by VARCHAR(100) NOT NULL COMMENT 'The username of whom created this record',
	modified_at DATETIME NULL COMMENT 'The date and time when this record was lat modified',
	modified_by VARCHAR(100) NULL COMMENT 'The username of whom last modified this record',
	CONSTRAINT roles_pk PRIMARY KEY (company_id,role_id),
	CONSTRAINT companies_un UNIQUE KEY (company_id,role_name)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci ;

CREATE TABLE IF NOT EXISTS user_roles(
	company_id TINYINT UNSIGNED NOT NULL COMMENT 'The company identifier',
	role_id TINYINT UNSIGNED NOT NULL COMMENT 'The role identifier',
	user_id INT UNSIGNED NOT NULL COMMENT 'The identifier of the user',
	CONSTRAINT user_roles_pk PRIMARY KEY (company_id,role_id,user_id)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COLLATE=utf8_general_ci ;

--
-- Foreign Keys
--

ALTER TABLE roles ADD CONSTRAINT roles_companies_fk FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE ON UPDATE CASCADE ;

ALTER TABLE user_roles ADD CONSTRAINT user_roles_companies_fk FOREIGN KEY (company_id) REFERENCES companies(company_id) ON DELETE CASCADE ON UPDATE CASCADE ;
ALTER TABLE user_roles ADD CONSTRAINT user_roles_roles_fk FOREIGN KEY (company_id,role_id) REFERENCES roles(company_id,role_id) ON DELETE CASCADE ON UPDATE CASCADE ;

