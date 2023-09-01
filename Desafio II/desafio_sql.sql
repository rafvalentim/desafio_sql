-- Criação do Banco de Dados --
CREATE DATABASE desafio_sql;

-- Selecionando Database criada --
USE desafio_sql;

-- Criação de Tabelas --
CREATE TABLE cliente(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	nome VARCHAR(100) NOT NULL,
	email VARCHAR(100) NOT NULL,
	senha VARCHAR(64) NOT NULL,
	dataRegistro DATE NOT NULL
);

CREATE TABLE pedido(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	cliente_id INT NOT NULL,
	precoTotal DECIMAL(10,2) NOT NULL,
	dataPedido DATE NOT NULL,
	FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE tipoProduto(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	nome VARCHAR(100) NOT NULL
);

CREATE TABLE produto(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	tipoProduto_id INT NOT NULL,
	nome VARCHAR(100) NOT NULL,
	precoUnitario DECIMAL(10,2) NOT NULL,
	FOREIGN KEY (tipoProduto_id) REFERENCES tipoProduto(id)
);

CREATE TABLE itemPedido(
	id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	pedido_id INT NOT NULL,
	produto_id INT NOT NULL,
	FOREIGN KEY (pedido_id) REFERENCES pedido(id),
	FOREIGN KEY (produto_id) REFERENCES produto(id)
);

-- CRIAÇÃO DE INSERTS --

-- Inserts para a tabela 'cliente'
INSERT INTO cliente (nome, email, senha, dataRegistro) VALUES
('João Silva', 'joao@example.com', 'senha123', '2023-08-30'),
('Maria Santos', 'maria@example.com', 'senha456', '2023-08-30'),
('Carlos Oliveira', 'carlos@example.com', 'senha789', '2023-08-29'),
('Ana Rodrigues', 'ana@example.com', 'senhaabc', '2023-08-29'),
('Pedro Alves', 'pedro@example.com', 'senhaxyz', '2023-08-28');

-- Inserts para a tabela 'pedido'
INSERT INTO pedido (cliente_id, precoTotal, dataPedido) VALUES
(1, 150.00, '2023-08-30'),
(2, 200.50, '2023-08-30'),
(3, 50.25, '2023-08-29'),
(4, 75.80, '2023-08-29'),
(5, 120.00, '2023-08-28');


-- Inserts para a tabela 'tipoProduto'
INSERT INTO tipoProduto (nome) VALUES
('Eletrônicos'),
('Roupas'),
('Alimentos'),
('Acessórios'),
('Móveis');

-- Inserts para a tabela 'produto'
INSERT INTO produto (tipoProduto_id, nome, precoUnitario) VALUES
(1, 'Smartphone', 800.00),
(1, 'Notebook', 1200.00),
(2, 'Camiseta', 25.00),
(2, 'Calça Jeans', 50.00),
(3, 'Arroz', 10.00);

INSERT INTO itemPedido (pedido_id, produto_id) VALUES
(3,2),
(4,3),
(5,4),
(6,5),
(7,6);

-- Encontrar nome dos clientes que fizeram pedidos nos últimos 30 dias --

SELECT cliente.nome
	FROM cliente
		INNER JOIN pedido ON cliente.id = pedido.cliente_id
	WHERE pedido.dataPedido >= DATEADD(DAY, -30, GETDATE());

--  Listar produtos que foram incluídos em pedidos com um preço total superior a R$ 200 --

SELECT DISTINCT produto.nome
	FROM produto
		INNER JOIN itemPedido 
			ON produto.id = itemPedido.produto_id
		INNER JOIN pedido
			ON itemPedido.pedido_id = pedido.id
	WHERE pedido.precoTotal > 200;

-- Descobrir valor médio gasto por cliente --

SELECT cliente.nome, AVG(pedido.precoTotal) AS valorMedioGasto
	FROM cliente
		LEFT JOIN pedido 
			ON cliente.id = pedido.cliente_id
	GROUP BY cliente.nome;

-- Encontrar os clientes que ainda não fizeram nenhum pedido --

SELECT nome
	FROM cliente
	WHERE id NOT IN (SELECT DISTINCT cliente_id FROM pedido);

-- Listar os produtos mais vendidos juntamente com a contagem de pedidos em que cada um aparece --

SELECT produto.nome, COUNT(itemPedido.id) AS contagemPedidos
	FROM produto
		JOIN itemPedido ON produto.id = itemPedido.produto_id
	GROUP BY produto.nome
ORDER BY contagemPedidos DESC;

-- Retornar o nome dos clientes e a data do primeiro pedido de cada um, e ordenar pelo nome do cliente --

SELECT cliente.nome, MIN(pedido.dataPedido) AS dataPrimeiroPedido
	FROM cliente
		JOIN pedido ON cliente.id = pedido.cliente_id
	GROUP BY cliente.nome
ORDER BY cliente.nome;

-- Procedure para inserir novos clientes na tabela "Cliente" -- 

CREATE PROCEDURE InserirCliente
    @nome VARCHAR(100),
    @email VARCHAR(100),
    @senha VARCHAR(64),
    @dataRegistro DATE
AS
BEGIN
    INSERT INTO cliente (nome, email, senha, dataRegistro)
    VALUES (@nome, @email, @senha, @dataRegistro);
END;

-- Procedure para atualizar preço do produto na tabela Produto --

CREATE PROCEDURE AtualizarPrecoProduto
    @produto_id INT,
    @novoPreco DECIMAL(10,2)
AS
BEGIN
    UPDATE produto
    SET precoUnitario = @novoPreco
    WHERE id = @produto_id;
END;

-- Procedure para inserir pedido na tabela Pedido --

CREATE PROCEDURE InserirPedido
    @cliente_id INT,
    @precoTotal DECIMAL(10,2),
    @dataPedido DATE
AS
BEGIN
    INSERT INTO pedido (cliente_id, precoTotal, dataPedido)
    VALUES (@cliente_id, @precoTotal, @dataPedido);
END;

-- Procedure para deletar pedidos na tabela Pedido -- 

CREATE PROCEDURE DeletarPedido
    @pedido_id INT
AS
BEGIN
    DELETE FROM pedido
    WHERE id = @pedido_id;
END;

-- Procedure para listar todos os produtos agrupados por tipo --

CREATE PROCEDURE ListarProdutosPorTipo
AS
BEGIN
    SELECT tipoProduto.nome, produto.nome AS nomeProduto
    FROM tipoProduto
		INNER JOIN produto ON tipoProduto.id = produto.tipoProduto_id
    ORDER BY tipoProduto.nome, produto.nome;
END;

-- Retornar o nome dos clientes que fizeram pedidos nos últimos 30 dias e o total gasto por cada cliente --

SELECT cliente.nome, SUM(pedido.precoTotal) AS totalGasto
	FROM cliente
		INNER JOIN pedido ON cliente.id = pedido.cliente_id
	WHERE pedido.dataPedido >= DATEADD(DAY, -30, GETDATE())
GROUP BY cliente.nome;

-- Listar produtos que foram incluídos em pedidos com um preço total superior à média dos preços totais de todos os pedidos -- 

SELECT DISTINCT produto.nome
	FROM produto
		INNER JOIN itemPedido ON produto.id = itemPedido.produto_id
		INNER JOIN pedido ON itemPedido.pedido_id = pedido.id
	WHERE pedido.precoTotal > (SELECT AVG(precoTotal) FROM pedido);

	SELECT * FROM produto
-- Retornar o nome e o e-mail dos clientes que ainda não fizeram nenhum pedido --

SELECT cliente.nome, cliente.email
	FROM cliente
		WHERE NOT EXISTS (SELECT 1 FROM pedido WHERE pedido.cliente_id = cliente.id);


-- Miscellaneous -- 


EXEC InserirCliente 'Gustavo Brandão', 'gustavo.bombado@smn.com.br', 'trembolonanaveia', '2023-07-01';
EXEC InserirCliente 'Guilherme Neves', 'guigas.double.biceps@smn.com.br', 'meushapefalapormim', '2023-05-25';

SELECT * FROM cliente;