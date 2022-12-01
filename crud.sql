-- Aqui você deve colocar os códigos SQL referentes às
-- Simulações de um CRUD

-- Criação

-- 1)
INSERT INTO clientes
  (nome, lealdade)
VALUES
  ('Paula', 64),
  ('Francisco', 168),
  ('Elise', 24),
  ('Marcelo', 48),
  ('Laura', 36);

INSERT INTO enderecos
  (cep, rua, numero, bairro, complemento, cliente_id)
VALUES
  ('09092-909', 'Rua 1', 121, 'Bairro 1', 'apto. 302', 1),
  ('12345-995', 'Rua 2', 254, 'Bairro 2', null, 2),
  ('54625-845', 'Rua 3', 1050, 'Bairro 3', null, 3),
  ('65655-321', 'Rua 4', 79, 'Bairro 4', 'APTO. 505', 4),
  ('15484-565', 'Rua 5', 32, 'Bairro 5', null, 5);

INSERT INTO produtos
  (nome, tipo, preco, pts_de_lealdade)
VALUES
  ('Big Serial', 'Burguer', 24.99, 12),
  ('Varchapa', 'Burguer', 32.99, 16),
  ('Update sem WHERE', 'Burguer', 42.99, 20),
  ('Um pra Dois', 'Burguer', 49.99, 24),
  ('DELETE sem WHERE', 'Burguer', 54.99, 32),
  ('Fritas', 'Acompanhamento', 14.99, 8),
  ('Cebola', 'Acompanhamento', 19.99, 12),
  ('Coca-Cola', 'Bebida', 5.99, 6),
  ('Fanta', 'Bebida', 5.99, 6),
  ('Guaraná', 'Bebida', 5.99, 6);


INSERT INTO pedidos
    (status, cliente_id)
VALUES
  ('Em preparo', 1),
  ('Finalizado', 2),
  ('Recebido', 3),
  ('Entregue', 4),
  ('Recebido', 5);

INSERT INTO produtos_pedidos
  (pedido_id, produto_id)
VALUES
  (1, 4),
  (1, 2),
  (1, 6),
  (2, 2),
  (2, 4),
  (2, 7),
  (2, 9),
  (3, 5),
  (3, 6),
  (3, 9),
  (4, 1),
  (4, 1),
  (4, 6),
  (4, 10),
  (5, 3),
  (5, 2),
  (5, 7),
  (5, 8);


-- 2)

INSERT INTO
	clientes(nome, lealdade)
VALUES
	('Georgia', 0);

-- 3)

INSERT INTO 
	pedidos(status, cliente_id)
VALUES 
	('Recebido', 6);

INSERT INTO produtos_pedidos
  (pedido_id, produto_id)
VALUES
    (7, 1),
    (7, 2),
	(7, 6),
	(7, 8),
	(7, 8);


-- Leitura

-- 1)
--A leitura é traduzida na forma de um SELECT. Verifique se a criação do cliente 
--que foi feita acima deu certo, selecionando os dados da tabela clientes, juntamente 
--com os pedidos e os produtos dos pedidos da cliente Georgia.


SELECT 
	cli.id,
	cli.nome,
	cli.lealdade,
	ped.id,
	ped.status,
	ped.cliente_id,
	prod.id,
	prod.nome,
	prod.tipo,
	ROUND(prod.preco::NUMERIC,2),
	prod.pts_de_lealdade
FROM
	clientes AS cli
JOIN 
	pedidos AS ped ON cli.id = ped.cliente_id
JOIN 
	produtos_pedidos AS prodp ON ped.id = prodp.pedido_id
JOIN 
	produtos AS prod ON prod.id = prodp.produto_id
WHERE 
	cli.nome ILIKE 'Georgia';


-- Atualização

-- 1)
--Nas nossas tabelas de clientes e produtos, temos colunas que guardam os pontos de lealdade dos clientes da SQLanches.
--Você pode notar que nenhum dos clientes possui algum ponto de lealdade, mas vários clientes já fizeram pedidos.
--Vamos usar da atualização para passar os pontos de lealdade dos pedidos da nossa usuária Georgia
--As atualizações podem ser traduzidas em uma cláusula de UPDATE.
--Some os pontos de lealdade da cliente Georgia e faça uma query para atualizar somente os pontos de lealdade dela para o valor somado.

UPDATE 
	clientes AS cli
SET 
	lealdade = (
	SELECT 
		SUM(prod.pts_de_lealdade)
	FROM
		clientes AS cli
	JOIN 
		pedidos AS ped ON cli.id = ped.cliente_id
	JOIN 
		produtos_pedidos AS prodp ON ped.id = prodp.pedido_id
	JOIN 
		produtos AS prod ON prod.id = prodp.produto_id
	WHERE 
		cli.nome ILIKE 'Georgia'
	)
WHERE 
	cli.nome ILIKE 'Georgia'
RETURNING *;

-- Deleção

-- 1)
--A Deleção é traduzida no banco como uma cláusula de DELETE
--Com a deleção, devemos tomar o cuidado de definir como o banco de dados irá tratar as deleções uma vez que temos dados relacionados.
--E foi por isso, que pedimos para usar a cláusula de ON DELETE CASCADE, pois assim um DELETE não estará desrespeitando a integridade 
--referencial das tabelas pois adicionamos a regra ao banco.
--Vá em frente e crie uma query de deleção do usuário Marcelo.
--Você pode olhar nas outras tabelas o que aconteceu com todos os dados que estavam relacionados com este usuário.

DELETE FROM
	clientes AS cli
WHERE cli.nome ILIKE 'Marcelo';



