CREATE DATABASE turmaA1Procedure;

USE turmaA1Procedure;

CREATE TABLE sacola
(
 cor_bola VARCHAR(10),
 quantidade INT
);

INSERT INTO sacola (cor_bola, quantidade) VALUES ("Preta", 2);
INSERT INTO sacola (cor_bola, quantidade) VALUES ("Branca", 3);
INSERT INTO sacola (cor_bola, quantidade) VALUES ("Amarela", 4);
INSERT INTO sacola (cor_bola, quantidade) VALUES ("Vermelha", 5);
INSERT INTO sacola (cor_bola, quantidade) VALUES ("Verde", 6);

SELECT * FROM sacola;

## Definição Procedure: 
# O Procedure tem a função de tornar uma consulta (SELECT) estática em uma consulta dinâmica que possa ser utilizada no futuro e executar procedimentos, como o próprio nome já diz.
DELIMITER $$  # O Delimiter tem a função de modificar o delimitador padrão do MySql (;)

# Procedure sem parâmetro
CREATE PROCEDURE retorna_cor_bola()
BEGIN 
  SELECT * FROM sacola;
END
$$ DELIMITER ; 

CALL retorna_cor_bola;

DROP PROCEDURE retorna_cor_bola;

# Procedure com parâmetro
DELIMITER $$
CREATE PROCEDURE retorna_cor_bola_com_parametro(IN cor_bola VARCHAR(10))
BEGIN 
  SELECT * FROM sacola WHERE tipo_bola = cor_bola;
END
$$ DELIMITER ;

CALL retorna_cor_bola_com_parametro("Preta");



USE sakila;

DELIMITER $$
CREATE PROCEDURE retorna_categoria_filme(IN categoria VARCHAR(15))
BEGIN 
 SELECT f.title AS "Filme", c.name AS "Categoria" FROM category c 
 INNER JOIN film_category fc USING (category_id)
 INNER JOIN film f USING (film_id)
 WHERE c.name = categoria;
END
$$ DELIMITER ;


DELIMITER $$
CREATE PROCEDURE EXCLUIR_BOLA_DA_SACOLA(IN COLOR VARCHAR(10), IN QUANTITY INT)
BEGIN
 DECLARE CAPACIDADE_SACOLA INT DEFAULT 100; -- CAPACIDADE DE BOLA DENTRO DA SACOLA
 DECLARE QUANTIDADE_EXISTENTE INT DEFAULT 0; -- QUANTIDADE DE BOLAS EXISTENTES 
 DECLARE QUANTIDADE_BOLA INT DEFAULT 0;
 DECLARE BOLA_EXISTE INT DEFAULT 0;
 
 /* Identifica a existência da bola na sacola */
 SELECT 
  IFNULL(QUANTIDADE, 0)
  INTO BOLA_EXISTE
 FROM
  SACOLA
 WHERE
  COR_BOLA = COLOR;
  
  /* IDENTIFICA A QUANTIDADE DE BOLAS A SEREM ATUALIZADAS  */
  SET QUANTIDADE_BOLA = BOLA_EXISTE - QUANTITY;
  
  -- VALIDA A EXISTÊNCIA DA BOLA 
  IF (BOLA_EXISTE <> 0)
   THEN
   -- VALIDA SE VAI OU NÃO EXCEDER A CAPACIDADE DA SACOLA
    IF (QUANTIDADE_EXISTENTE + QUANTITY) <= CAPACIDADE_SACOLA
     THEN
      UPDATE SACOLA SET QUANTIDADE = QUANTIDADE_EXISTENTE - QUANTITY
	   WHERE COR_BOLA = COLOR;
	ELSE
     SELECT '** Você ultrapassou a capacidade da sacola, por favor, insira outro valor! **' AS RESULT;
    END IF;
    
   ELSE
	SELECT '** O valor inserido é invalido, por favor, tente novamente!' AS RESULT;
   END IF;
END
$$ DELIMITER ;

DROP PROCEDURE EXCLUIR_BOLA_DA_SACOLA;

DELIMITER $$
 CREATE PROCEDURE INSERIR_BOLA_NA_SACOLA (IN COLOR VARCHAR(10), IN QUANTITY INT)
 BEGIN
  DECLARE CAPACIDADE_SACOLA INT DEFAULT 100;
  DECLARE QUANTIDADE_EXISTENTE INT DEFAULT 0;
  DECLARE BOLA_EXISTE INT DEFAULT 0; -- ZERO = FALSE
  
  SELECT SUM(QUANTIDADE)
   INTO QUANTIDADE_EXISTENTE
  FROM
   SACOLA;
   
   SELECT
    ifnull(COR_BOLA, 0)
   FROM
	SACOLA 
   WHERE
    COR_BOLA = COLOR;
   
   IF QUANTITY >= 1
    THEN 
   
   IF ((QUANTIDADE_EXISTENTE + QUANTITY) <= CAPACIDADE_SACOLA) AND (BOLA_EXISTE = 0) 
    THEN
     INSERT INTO SACOLA (COR_BOLA, QUANTIDADE) VALUES (COLOR, QUANTITY);
   ELSE
    SELECT '** Você ultrapassou a capacidade da sacola, por favor, insira outro valor! **' AS RESULT;
   END IF;
   
   ELSE
	SELECT '** O valor inserido é invalido, por favor, tente novamente!' AS RESULT;
   END IF;
 END
$$ DELIMITER ;

$$ DELIMITER 
CREATE PROCEDURE ALTERAR_QUANTIDADE_DE_BOLAS_NA_SACOLA (IN COLOR VARCHAR(10), IN QUANTITY INT)
BEGIN
 DECLARE CAPACIDADE_SACOLA INT DEFAULT 100; -- CAPACIDADE DE BOLA DENTRO DA SACOLA
 DECLARE QUANTIDADE_EXISTENTE INT DEFAULT 0; -- QUANTIDADE DE BOLAS EXISTENTES 
 DECLARE QUANTIDADE_BOLA INT DEFAULT 0;
 DECLARE BOLA_EXISTE INT DEFAULT 0;
 
 /* Identifica a existência da bola na sacola */
 SELECT 
  IFNULL(QUANTIDADE, 0)
  INTO BOLA_EXISTE
 FROM
  SACOLA
 WHERE
  COR_BOLA = COLOR;
  
  /* IDENTIFICA A QUANTIDADE DE BOLAS A SEREM ATUALIZADAS  */
  SET QUANTIDADE_BOLA = BOLA_EXISTE + QUANTITY;
  
  -- VALIDA A EXISTÊNCIA DA BOLA 
  IF (BOLA_EXISTE <> 0)
   THEN
   -- VALIDA SE VAI OU NÃO EXCEDER A CAPACIDADE DA SACOLA
    IF (QUANTIDADE_EXISTENTE + QUANTITY) <= CAPACIDADE_SACOLA)
     THEN
      UPDATE SACOLA SET QUANTIDADE = QUANTIDADE_SACOLA
	   WHERE COR_BOLA = COLOR;
	ELSE
     SELECT '** Você ultrapassou a capacidade da sacola, por favor, insira outro valor! **' AS RESULT;
     END IF;
  ELSE
  -- CHAMAR A PROCEDURE DE INSERIR BOLA NA SACOLA
   CALL INSERIR_BOLA_NA_SACOLA(COLOR, QUANTITY);
  END IF;
  ELSE
   CALL EXCLUIR_BOLA_DA_SACOLA(COLOR)
  END IF;
END
$$ DELIMITER ;

SELECT * FROM sacola;

SELECT SUM(QUANTIDADE) FROM sacola;

CALL INSERIR_BOLA_NA_SACOLA("Rosa", 20);

CALL EXCLUIR_BOLA_DA_SACOLA("Preta", 1);

CALL retorna_categoria_filme("Animation");

USE sakila;

DELIMITER // 
CREATE PROCEDURE teste_delimitador()
BEGIN
 SELECT * FROM Film;
END
// DELIMITER ;

CALL teste_delimitador();


DELIMITER //
CREATE PROCEDURE retorna_filme_categoria(IN categoria VARCHAR(20), IN duracao INT)
BEGIN
 SELECT 
 f.title, f.rental_duration
FROM
 category c 
 INNER JOIN film_category fc USING (category_id)
 INNER JOIN film f  USING (film_id)
WHERE c.name = categoria AND f.rental_duration = duracao;
END
// DELIMITER ;

DROP PROCEDURE retorna_filme_categoria;


CALL retorna_filme_categoria("Action", 3);

# Procedure com um parâmetro de saída
DELIMITER $$
CREATE PROCEDURE retorna_quantidade_filmes_por_categoria(IN categoria VARCHAR(25), OUT quantidade INT)
BEGIN 
 SELECT COUNT(f.title) INTO quantidade FROM category c 
  INNER JOIN film_category fc USING (category_id)
  INNER JOIN film f USING (film_id)
 WHERE c.name = categoria;
END
$$ DELIMITER ;

# Definição de variáveis
SET @valor = 0;

CALL retorna_quantidade_filmes_por_categoria("Action", @valor);
SELECT @valor as "Quantidade de filmes";

USE classicmodels;

DELIMITER $$
CREATE PROCEDURE retorna_valor_vendas_escritorio(IN escritorio VARCHAR(10), IN ano INT, OUT valor DECIMAL(10,2))
BEGIN
 SELECT SUM(p.amount) INTO valor
 FROM customers c
  INNER JOIN payments p USING (customerNumber)
  INNER JOIN employees e ON (SALESREPEMPLOYEENUMBER = employeeNumber)
  INNER JOIN offices o USING (officeCode)
 WHERE YEAR(paymentDate) = ano AND o.city = escritorio;
END
$$ DELIMITER ;

SET @valor = 0;

CALL retorna_valor_vendas_escritorio("Paris", 2005,  @valor);
SELECT @valor AS "Total vendido";

# Procedure com dois parâmetros de saída
DELIMITER $$
CREATE PROCEDURE retorna_filme_duracao_qtde(IN categoria VARCHAR(20), IN duracao INT, OUT soma_duracao FLOAT, OUT qtde_filme INT)
BEGIN
 SELECT SUM(f.rental_duration) INTO soma_duracao
 FROM category c 
 INNER JOIN film_category fc USING (category_id)
 INNER JOIN film f USING (film_id)
WHERE c.name = categoria AND f.rental_duration > duracao;

SELECT COUNT(f.title) INTO qtde_filme
 FROM category c 
 INNER JOIN film_category fc USING (category_id)
 INNER JOIN film f USING (film_id)
WHERE c.name = categoria AND f.rental_duration > duracao;
END
$$ DELIMITER ;

SET @soma_duracao = 0;
SET @qtde_filme = 0;

CALL retorna_filme_duracao_qtde("Action", 2, @somaduracao, @qtde_filme);
SELECT @somaduracao AS "Soma_Duracao", @qtde_filme AS "Quantidade_Filmes";

# Procedure utilizando o INOUT (geralmente utilizado para atualizar as informações no banco de dados)
USE classicmodels;
DELIMITER $$
CREATE PROCEDURE retorna_valor_venda (IN ano INT, INOUT valor_venda FLOAT)
BEGIN
 SELECT FORMAT(SUM(payments.amount), 2) AS valor
 FROM products
  INNER JOIN orderdetails USING (productCode)
  INNER JOIN orders USING (orderNumber)
  INNER JOIN customer USING (customerNumber)
  INNER JOIN payments USING (customerNumber)
 WHERE YEAR(paymentDate) = ano;
END 
$$ DELIMITER ;

SET @valor_venda = 0.00;

CALL retorna_valor_venda (2004, @valor_venda);

SELECT @valor_venda;

# Estruturas de repetição

# While

CREATE TABLE food 
(
 id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
 tipo_comida VARCHAR(20) 
) engine = InnoDB;

DELIMITER $$
CREATE PROCEDURE repeticao_com_while()
BEGIN
 DECLARE v_max INT UNSIGNED DEFAULT 100;
 DECLARE v_counter INT UNSIGNED DEFAULT 0;
 WHILE v_counter < v_max DO
  INSERT INTO food (tipo_comida) VALUES (CONCAT('COMIDA', v_counter));
  SET v_counter = v_counter + 1;
 END WHILE;
END	$$
$$ DELIMITER ;

CALL repeticao_com_while;

SELECT * FROM food;

TRUNCATE TABLE food;


# Repeat 

USE aula_loop;

DELIMITER $$
CREATE PROCEDURE repeticao_com_repeat()
BEGIN
 DECLARE x INT;
 DECLARE str VARCHAR(200);
 SET str = '';
 SET x = 10;
 
 REPEAT
  SET str = CONCAT(str, x, ',');
  SET x = x - 1;
   until x <= 0
 END REPEAT;
 
 SELECT str; -- Apresentação do resultado
END $$
$$ DELIMITER ;

DROP PROCEDURE repeticao_com_repeat;

CALL repeticao_com_repeat;

USE classicmodels;

CREATE TABLE vendedores_janeiro
(
 nome_vendedor VARCHAR(80),
 valor_vendido DECIMAL(10,2),
 qtde_clientes INT
);

-- CRIAR A TABELA VENDEDOR_JANEIRO PARA ARMAZENAR CADA VENDEDOR, O VALORVENDIDO EM JANEIRO (2003) E A QUANTIDADE DE CLIENTES ATENDIDAS.
-- CRIAR UMA PROCEDURE PARA ALIMENTAR A TABELA VENDEDOR_JANEIRO, UTILIZANDO UMA DAS ESTRUTURAS DE REPETIÇÃO APRENDIDAS EM AULA.
-- DICA: UTILIZE LIMIT E OFFSET;
-- UTILIZE O BANCO DE DADOS CLASSICMODELS;


DELIMITER //
CREATE PROCEDURE AlimentarTabelaVendedoresJaneiro()
BEGIN
 DECLARE v_max INT UNSIGNED DEFAULT 5;
 DECLARE v_counter INT UNSIGNED DEFAULT 0;
 DECLARE nome_vendedor VARCHAR(80);
 DECLARE valor_vendido DECIMAL(10,2);
 DECLARE qtd_cliente INT; 

 SELECT
  CONCAT(FIRSTNAME, ' ', LASTNAME) AS EMPREGADO, 
  SUM(AMOUNT) VALOR_VENDIDO,
  COUNT(CUSTOMERNUMBER) QTDE_CLIENTES
  INTO
      nome_vendedor,
      valor_vendido,
      qtd_cliente
FROM
  CUSTOMERS  
  INNER JOIN PAYMENTS USING (CUSTOMERNUMBER)  
  INNER JOIN EMPLOYEES ON (SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER)
WHERE 
    YEAR(PAYMENTDATE) = 2003
AND MONTH(PAYMENTDATE) = 1
GROUP BY EMPREGADO
LIMIT 1 OFFSET 0;

 WHILE v_counter < v_max DO
  INSERT INTO vendedores_janeiro VALUES (nome_vendedor, valor_vendido, qtd_cliente);
  SET v_counter = v_counter + 1;
 END WHILE; 
 
 SELECT * FROM vendedores_janeiro;
END //
// DELIMITER ;


DROP PROCEDURE retorna_vendas_janeiro;
DROP PROCEDURE AlimentarTabelaVendedoresJaneiro;

CALL AlimentarTabelaVendedoresJaneiro;


DELIMITER $$

CREATE PROCEDURE retorna_vendas_janeiro()
BEGIN
  -- Declaração de variáveis
  DECLARE done INT DEFAULT 0;
  DECLARE nome_vendedor VARCHAR(80);
  DECLARE valor_vendido DECIMAL(10, 2);
  DECLARE qtd_cliente INT;

  -- Contador
  DECLARE counter INT DEFAULT 0;

  -- Crie uma tabela temporária para armazenar os resultados
  CREATE TEMPORARY TABLE TempResultTable (
    nome_vendedor VARCHAR(80),
    valor_vendido DECIMAL(10, 2),
    qtd_cliente INT
  );

  -- Loop WHILE
  WHILE counter < 5 DO
    -- Selecione os dados desejados
    SELECT
      CONCAT(employees.firstName, ' ', employees.lastName),
      SUM(payments.amount),
      COUNT(customers.customerNumber)
    INTO
      nome_vendedor,
      valor_vendido,
      qtd_cliente
    FROM CUSTOMERS
    INNER JOIN PAYMENTS USING (CUSTOMERNUMBER)
    INNER JOIN EMPLOYEES ON (SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER)
    WHERE YEAR(PAYMENTDATE) = 2003
          AND MONTH(PAYMENTDATE) = 1
    GROUP BY nome_vendedor
    LIMIT 1 OFFSET counter;

    -- Insira os dados na tabela temporária
    INSERT INTO TempResultTable (nome_vendedor, valor_vendido, qtd_cliente)
    VALUES (nome_vendedor, valor_vendido, qtd_cliente);

    -- Atualize o contador
    SET counter = counter + 1;
  END WHILE;

  -- Insira os resultados na tabela vendedores_janeiro
  INSERT INTO vendedores_janeiro (nome_vendedor, valor_vendido, qtd_cliente)
  SELECT * FROM TempResultTable;

  -- Limpe a tabela temporária
  DROP TEMPORARY TABLE IF EXISTS TempResultTable;
END $$
$$ DELIMITER ;

DROP TABLE TempResultTable;

DROP PROCEDURE retorna_vendas_janeiro;

CALL retorna_vendas_janeiro;
