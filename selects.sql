-- Aqui você deve colocar os códigos SQL referentes às
-- Seleções de dados

-- 1)
--Consulte por todos os pedidos juntamente com todas as informações dos produtos que estão em cada um dos pedidos
 
SELECT 
	ped.id,
	ped.status,
	ped.cliente_id,
	prod.id,
	prod.nome,
	prod.tipo,
	ROUND(prod.preco::NUMERIC , 2),
	prod.pts_de_lealdade
FROM 
	pedidos AS ped
JOIN  
	produtos_pedidos AS prodp ON ped.id = prodp.pedido_id
JOIN 
	produtos AS prod ON prod.id = prodp.produto_id
ORDER BY ped.id;

-- 2)
--Consulte pelo ID de todos os pedidos que incluam 'Fritas'.

SELECT
	ped.id
FROM
	pedidos AS ped
JOIN
	produtos_pedidos AS prodp ON ped.id = prodp.pedido_id
JOIN
	produtos AS prod ON prod.id = prodp.produto_id
WHERE prod.nome ILIKE 'FRITAS';

-- 3)
--Consulte novamente por pedidos que incluam 'Fritas', porém agora, retorne apenas uma coluna (gostam_de_fritas) com o nome dos Clientes que fizeram os pedidos.

SELECT
	cli.nome
FROM 
	pedidos AS ped
JOIN 
	produtos_pedidos AS prodp ON ped.id = prodp.pedido_id
JOIN 
	produtos AS prod ON prod.id = prodp.produto_id
JOIN 
	clientes AS cli ON cli.id = ped.cliente_id
WHERE 
	prod.nome ILIKE 'FRITAS'; 

-- 4)
--Crie uma query que retorne o custo total dos pedidos da 'Laura'.

SELECT
	SUM(ROUND(prod.preco::NUMERIC,2))
FROM 
	pedidos AS ped
JOIN 
	produtos_pedidos AS prodp ON ped.id = prodp.pedido_id
JOIN 
	produtos AS prod ON prod.id = prodp.produto_id
JOIN 
	clientes AS cli ON cli.id = ped.cliente_id
WHERE 
	cli.nome ILIKE 'Laura'; 


-- 5)
--Crie uma query que retorne em uma coluna o nome do produto, e na outra, o número de vezes que ele foi pedido. 
-- Dica: a função built-in COUNT pode somar o número de ocorrências de um id em uma coluna. 

SELECT 
	prod.nome, COUNT(prodp.id)
FROM 
	pedidos AS ped
JOIN 
	produtos_pedidos AS prodp ON ped.id = prodp.pedido_id
JOIN 
	produtos AS prod ON prod.id = prodp.produto_id
JOIN 
	clientes AS cli ON cli.id = ped.cliente_id
GROUP BY prod.nome;