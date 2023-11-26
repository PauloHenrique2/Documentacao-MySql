## Definição
## A função sempre retorna alguma informação (como as funções matemáticas), se diferencia da procedure (que pode ou não retornar algum valor) e depende da regra de negócio.

DELIMITER $
 CREATE FUNCTION funcao() returns INT
  BEGIN
   DECLARE QUANTIDADE INT;
   SELECT COUNT(film_id) INTO QUANTIDADE FROM film;
  END $
DELIMITER ;

DELIMITER //
CREATE PROCEDURE inserir_dados_venda_comissao(IN ano_param INT, IN mes_param INT)
BEGIN
 DECLARE finished INT DEFAULT 0; -- Controle do cursor
 DECLARE vendedor_registro VARCHAR(200);
 DECLARE qtde_vendas_registro INT;
 DECLARE comissao_registro FLOAT;
 DECLARE ano INT;
 DECLARE mes INT;
 
DECLARE cursor_vendedor
 CURSOR FOR 
  SELECT Vendedor, qtde_vendas, Mes, Ano
   FROM retorna_vendas
  WHERE Ano = ano_param AND Mes = mes_param;
  
  DECLARE CONTINUE HANDLER 
   FOR NOT FOUND SET finished = 1; -- Variável do cursor
   
   OPEN cursor_vendedor;
   
   Loop_Vendedor : LOOP	
    FETCH cursor_vendedor INTO vendedor_registro, qtde_vendas_registro, ano, mes;
  
    SET comissao = determinar_comissao(qtde_vendas_registro);
  
    SELECT vendedor_registro, comissao, ano, mes;
    
    IF finished = 1 THEN
	 LEAVE Loop_Vendedor;
	END IF;
  END LOOP;
  
  CLOSE cursor_vendedor;
 END //
 DELIMITER ;