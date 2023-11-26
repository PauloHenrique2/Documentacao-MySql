## Definição Loops
# Os loops, assim como na programação são estruturas de repetição que podem ser utilizadas de diversas maneiras.
# No MySql, temos três tipos de loops, sendo eles: Loop, Repeat e While.
# Veja a sintaxe de cada um deles abaixo:

DELIMITER $$
Create Procedure Teste_loop(IN id_param INT)
 Begin
 Declare finished INT DEFAULT 0;
 
 Loop_Id : Loop
  if (id_param > 0) then
    SELECT "Hello World!" as Mensagem;
    SET finished = finished + 1;
    if (finished = id_param) then
     Leave Loop_id;
	end if;
  else
   SELECT "Insira um número maior que zero!";
  end if;
 end loop Loop_Id;	
 End $$
DELIMITER ;

DROP PROCEDURE Teste_Loop;

CALL Teste_Loop(2);

DELIMITER //
Create Procedure Teste_Repeat()
Begin
  DECLARE counter INT DEFAULT 1;
  DECLARE result VARCHAR(100) DEFAULT '';
    
  REPEAT
	SET result = CONCAT(result,counter,',');
	SET counter = counter + 1;
    UNTIL counter = 10
  END REPEAT;
    
  SELECT result;
End //
DELIMITER ;

DROP PROCEDURE Teste_Repeat;

CALL Teste_Repeat;

SHOW  FULL TABLES;