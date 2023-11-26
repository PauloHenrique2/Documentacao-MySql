## Definição Roles
# Os roles são basicamente cargos que permitem ao usuários realizar ou não certas ações no banco de dados.alter
# As permissões e proibições são definidas através dos comandos GRANT e REVOKE.

# Exemplo:

CREATE DATABASE CRM;

USE CRM; 

CREATE TABLE customers
(
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL, 
    last_name VARCHAR(255) NOT NULL, 
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(255)
);

INSERT INTO customers(first_name,last_name,phone,email)
VALUES('John','Doe','(408)-987-7654','john.doe@mysqltutorial.org'),
      ('Lily','Bush','(408)-987-7985','lily.bush@mysqltutorial.org');
      
SELECT * FROM customers;

# Criando roles

CREATE ROLE crm_dev, crm_read, crm_write;

# Garantindo as permissões aos devidos cargos

GRANT ALL ON crm .* TO crm_dev; # Os caracteres: ".*" garantem as permissões à todas as tabelas do banco de dados 

GRANT SELECT ON crm .* TO crm_read;

GRANT INSERT, UPDATE, DELETE ON crm .* TO crm_write;


# Criando usuários

CREATE USER crm_dev1@localhost IDENTIFIED BY 'devbala1616'; # O conteúdo da cláusula IDENTIFIED BY é a senha do usuário

CREATE USER crm_read1@localhost IDENTIFIED BY 'Secure$5432';    

CREATE USER crm_write1@localhost IDENTIFIED BY 'Secure$9075';

CREATE USER crm_write2@localhost IDENTIFIED BY 'Secure$3452';


# Garantindo os cargos ao devidos usuários

GRANT crm_dev TO crm_dev1@localhost;

GRANT crm_read TO crm_read1@localhost;

GRANT crm_write, crm_read TO crm_write1@localhost, crm_write2@localhost;


# Mostrando os cargos associados aos usuários

SHOW GRANTS FOR crm_read1@localhost;


# Mostrando as permissões associadas aos cargos

SHOW GRANTS FOR crm_read1@localhost USING crm_read;

SHOW GRANTS FOR crm_dev1@localhost USING crm_dev;


# Definindo os cargos padrão

# Verifica o cargo atual

SELECT CURRENT_ROLE();

# Define o cargo especificado como default para todos os usuários que o possuem

SET DEFAULT ROLE ALL TO crm_read1@localhost;

SELECT CURRENT_ROLE();


# Para ativar todos os cargos:

SET ROLE ALL;


# Para desativar todos os cargos:

SET ROLE NONE;


# Retirando as permissões dos cargos

REVOKE INSERT, UPDATE, DELETE
ON crm .*
FROM crm_write;


# Deletando cargos

DROP ROLE crm_dev;

DROP ROLE crm_write;

DROP ROLE crm_read;


# Clonando permissões de um usuário a outro

GRANT crm_dev1@localhost
TO crm_dev2@localhost;