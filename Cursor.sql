select * from retorna_vendedores_mes_ano;

## Definição Cursor
# O cursor tem a função de realmente apontar e percorrer linhas de uma consulta (SELECT) através de um loop.

Delimiter //
Create Procedure Aprendendo_usar_Cursor(in ano_param int, in mes_param int)
Begin
  
  Declare finished int; -- Controle de Cursor.
  Declare Vendedor_Registro varchar(100);
  Declare Venda_Registro float;
  Declare Quantidade_Cliente_Registro int;
  
  /* 1º Passo Declaração do cursor. 
  Sintaxe e a ordem deve ser mantido conforme abaixo */
  Declare Vendedor_Analise_Mes
    Cursor For
       Select Vendedor, Venda, Qtde_cliente
	   from retorna_vendedores_mes_ano	
       where 
           ano = ano_param
	   and 
           mes = mes_param;
  
  /*2º Passo declaração do controle do Cursor */
    DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1; -- VARIAVEL INTERNA DE CONTROLE DO CURSOR


  /* 3º Abertura do cursor */	
  OPEN Vendedor_Analise_Mes; 
  
  /* 4º Definição e declaração do loop para o cursor. */
  Loop_Vendedor: LOOP
    /* 5º Capturar os valores de cada linha do cursor. */
    Fetch Vendedor_Analise_Mes into Vendedor_Registro,Venda_Registro, Quantidade_Cliente_Registro;
    
    select Vendedor_Registro,Venda_Registro, Quantidade_Cliente_Registro;
    
	IF finished = 1 THEN -- VERIFICAÇÃO SE O CURSOR JÁ FINALIZOU OU NÃO
       LEAVE Loop_Vendedor; -- SAIR DO LOOP
    END IF; 
  END LOOP Loop_Vendedor;	
  
  /* 6º Fechar o cursor. */		
  Close Vendedor_Analise_Mes;
end //
Delimiter ;

Drop procedure Aprendendo_usar_Cursor;
Call Aprendendo_usar_Cursor(2004,1);	