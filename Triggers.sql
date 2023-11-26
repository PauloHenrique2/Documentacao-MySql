## Definição Trigger
# O trigger, como já diz o nome é um gatilho, sendo acionado (antes ou depois) de um evento (Update, Insert e Delete) ocorrer.

USE classicmodels;

CREATE TABLE conta (id_conta  int, valor_atual decimal(10,2));

create trigger tr_ins_conta_soma after insert on conta
for each row set @soma = @soma + new.valor_atual;

SET @soma = 0;

insert into conta values (1, 95.33), (2, 100.27), (3, -45.60);

SELECT @soma;