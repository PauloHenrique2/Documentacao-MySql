## Definição View
# A view é uma visualização de uma tabela e também pode ser chamada de tabela virtual.
# Ela tem como principal função armazenar consultas, assim como proteger os dados de uma tabela base (origem dos dados).

USE classicmodels;

CREATE OR REPLACE VIEW retorna_clientes_2005 as
 SELECT 
  c.customerName as Nome_Cliente
 FROM
  customers c
  INNER JOIN employees e ON (c.salesRepEmployeeNumber = e.employeeNumber)
  INNER JOIN payments p USING (customerNumber)
 WHERE
  YEAR(p.paymentDate) = '2004';
  
SELECT * FROM retorna_clientes_2005 LIMIT 10;

CREATE TABLE CountryPop 
(
 nome VARCHAR(80),
 populacao INT,
 continente VARCHAR(50)
);

SELECT * FROM CountryPop;

INSERT INTO CountryPop (nome, populacao, continente) VALUES ('Brasil', 250000000, 'América do Sul'), ('India', 1000000000, 'Ásia'), ('China', 1000000000, 'Ásia'), ('Estados Unidos', 332000000, 'América do Norte'), ('México', 127000000, 'América do Norte');

CREATE OR REPLACE VIEW retorna_paises_america_norte
AS
SELECT * FROM CountryPop WHERE continente = 'América do Norte';

SELECT * FROM retorna_paises_america_norte;

CREATE OR REPLACE VIEW retorna_paises_maior_pop
AS 
SELECT nome, populacao FROM CountryPop WHERE populacao >= 1000000000 WITH CHECK OPTION;

## O 'WITH CHECK OPTION' restringe as alterações na view ao valor definido na cláusula WHERE.

SELECT * FROM retorna_paises_maior_pop;

UPDATE retorna_paises_maior_pop
SET populacao = 10000000
WHERE nome = 'Brasil';