-- CRIAÇÃO DE BANCO DE DADOS

CREATE DATABASE freelaSMN;

USE freelaSMN;


-- CRIAÇÃO DAS TABELAS QUE NÃO POSSUEM FOREIGN KEY


CREATE TABLE freelancer (
    id INT PRIMARY KEY IDENTITY,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(255) NOT NULL,
    dataNascimento DATE NOT NULL,
    email VARCHAR(100) NOT NULL,
    senha VARCHAR(64) NOT NULL,
    experiencia VARCHAR(5000) NOT NULL,
    portfolio VARCHAR(5000) NOT NULL,
    dataCadastro DATE NOT NULL
);


CREATE TABLE equipeSuporte (
    id INT PRIMARY KEY IDENTITY,
    responsavel VARCHAR(100) NOT NULL
);


CREATE TABLE habilidade (
    id INT PRIMARY KEY IDENTITY,
    nome VARCHAR(255) NOT NULL
);


-- CRIAÇÃO DE TABELAS QUE POSSUEM FOREIGN KEY


CREATE TABLE habilidadeFreelancer (
    habilidadeId INT NOT NULL,
    freelancerId INT NOT NULL,
    PRIMARY KEY (habilidadeId, freelancerId),
    CONSTRAINT FK_habilidadeFreelancer_habilidade FOREIGN KEY(habilidadeId) REFERENCES habilidade (id),
    CONSTRAINT FK_habilidadeFreelancer_freelancer FOREIGN KEY(freelancerId) REFERENCES freelancer (id)
);


CREATE TABLE avaliacao (
    id INT PRIMARY KEY IDENTITY,
    freelancerId INT NOT NULL,
    nota TINYINT NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    data DATE NOT NULL,
    CONSTRAINT FK_avaliacao_freelancer FOREIGN KEY (freelancerId) REFERENCES freelancer (id)
);


CREATE TABLE empresa (
    id INT PRIMARY KEY IDENTITY,
    equipeSuporteId INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    senha VARCHAR(64) NOT NULL,
    dataCadastro DATE NOT NULL,
    CONSTRAINT FK_empresa_equipeSuporte FOREIGN KEY (equipeSuporteId) REFERENCES equipeSuporte (id)
);


CREATE TABLE projeto (
    id INT PRIMARY KEY IDENTITY,
    empresaId INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    descricao VARCHAR(5000) NOT NULL,
    dataPublicacao DATE NOT NULL,
    prazo DATE NOT NULL,
    orcamento DECIMAL(18, 2) NOT NULL,
    CONSTRAINT FK_projeto_empresa FOREIGN KEY (empresaId) REFERENCES empresa (id)
);


CREATE TABLE statusProjeto (
    id INT PRIMARY KEY IDENTITY,
    projetoId INT NOT NULL,
    nome VARCHAR(45) NOT NULL,
    CONSTRAINT FK_statusProjeto_projeto FOREIGN KEY (projetoId) REFERENCES projeto (id)
);


CREATE TABLE candidatura (
    id INT PRIMARY KEY IDENTITY,
    freelancerId INT NOT NULL,
    projetoId INT NOT NULL,
    data DATE NOT NULL,
    CONSTRAINT FK_candidatura_freelancer FOREIGN KEY (freelancerId) REFERENCES freelancer (id),
    CONSTRAINT FK_candidatura_projeto FOREIGN KEY (projetoId) REFERENCES projeto (id)
);


CREATE TABLE contato (
    id INT PRIMARY KEY IDENTITY,
    freelancerId INT,
    empresaId INT,
    equipeSuporteId INT,
    telefone VARCHAR(11) NOT NULL,
    whatsapp TINYINT NULL,
    email VARCHAR(100) NOT NULL,
    CONSTRAINT FK_contato_freelancer FOREIGN KEY (freelancerId) REFERENCES freelancer (id),
    CONSTRAINT FK_contato_empresa FOREIGN KEY (empresaId) REFERENCES empresa (id),
    CONSTRAINT FK_contato_equipeSuporte FOREIGN KEY (equipeSuporteId) REFERENCES equipeSuporte (id)
);

-- INSERTs


-- Inserir um freelancer
INSERT INTO freelancer (nome, sobrenome, dataNascimento, email, senha, experiencia, portfolio, dataCadastro) VALUES 
	('João', 'Silva', '1990-05-15', 'joao@email.com', 'senha123', 'Experiência em desenvolvimento web', 'www.portfolio.com', GETDATE()),
	('Mayla', 'Minelli', '1995-08-15', 'mayla@smn.com.br', 'senha123', 'Experiência em encher o saco dos outros', 'www.maylaemo.com', GETDATE()),
	('Gustavo', 'Brandão', '1996-05-15', 'gustas@smn.com', 'senha1234568*/*/', 'Experiência em andar de moto', 'www.gustasomotoqueirofantasma.com', GETDATE()),
	('Guilherme', 'Neves', '2002-05-15', 'guigas@smn.com', 'senha123A48475.+-', 'Experiência em orar', 'www.guigas.com', GETDATE());

-- Inserir uma equipe de suporte
INSERT INTO equipeSuporte (responsavel) VALUES 
	('Ana'),
	('Emerson'),
	('Jorge'),
	('Fleumas'),
	('Matheus'),
	('Cayo'),
	('Rafael');

-- Inserir uma empresa com equipe de suporte
INSERT INTO empresa (equipeSuporteId, nome, email, senha, dataCadastro) VALUES 
	(1, 'Momentum', 'contato@momentum.com', 'senha456*/*', GETDATE()),
	(2, 'Bombril', 'bombril@bombril.com', 'senha456*/*', GETDATE()),
	(3, 'Gol', 'contato@gol.com', 'senha456*/*', GETDATE()),
	(4, 'DiStefano', 'contato@stefano.com', 'senha456*/*', GETDATE()),
	(5, 'SMN', 'contato@smn.com', 'senha456*/*', GETDATE()),
	(6, 'Policlin', 'contato@policlin.com', 'senha456*/*', GETDATE());

-- Inserir um projeto
INSERT INTO projeto (empresaId, titulo, descricao, dataPublicacao, prazo, orcamento) VALUES 
	(1, 'Desenvolvimento de Website', 'Projeto para criar um site responsivo', GETDATE(), '2024-09-01', 5000.00),
	(2, 'Vendas de produtosde Limpeza', 'Projeto para criar nova Palha de aço', GETDATE(), '2026-09-01', 600000.00),
	(1, 'Venda de Terrenos', 'Projeto para aumentar a vendas de terranos de luxo', GETDATE(), '2023-12-25', 15425.00),
	(5, 'Desenvolvimento de Software', 'Projeto para criar novo aplicativo', GETDATE(), '2024-11-15', 100000.00),
	(3, 'Venda de passagens aéreas', 'Projeto para criar um site para vendas de passagens', GETDATE(), '2025-09-01', 785000.00),
	(6, 'Desenvolvimento de Website', 'Projeto para criar um site responsivo', GETDATE(), '2024-09-01', 5000.00);

-- Inserir uma candidatura
INSERT INTO candidatura (freelancerId, projetoId, data) VALUES 
	(1, 1, GETDATE()),
	(4, 1, GETDATE()),
	(3, 1, GETDATE()),
	(2, 1, GETDATE()),
	(1, 1, GETDATE());

-- Inserir uma avaliação
INSERT INTO avaliacao (freelancerId, nota, descricao, data) VALUES 
	(1, 5, 'Freelancer entregou o projeto no prazo e com alta qualidade.', GETDATE()),
	(2, 1, 'Freelancer não entregou o projeto no prazo e com baixa qualidade.', GETDATE()),
	(3, 4, 'Freelancer entregou o projeto no prazo e com alta qualidade.', GETDATE()),
	(4, 5, 'Freelancer entregou o projeto no prazo e com alta qualidade.', GETDATE());

--Inserir um Status do Projeto
INSERT INTO statusProjeto (projetoId, nome) VALUES
	(2, 'Em andamento'),
	(6, 'Em fase de Orçamento'),
	(3, 'Atrasado'),
	(1, 'Concluído'),
	(4, 'Em andamento'),
	(5, 'Em andamento');

--Inserir um Contato
INSERT INTO contato (freelancerId, empresaId, equipeSuporteId, telefone, whatsapp, email) VALUES
	(1, NULL, NULL, '83996855214', 1, 'contato@freelancer.com'),
	(NULL, 2, NULL, '83996855214', 0, 'contato@empresa.com');



-- EXEMPLOS DE SELECTs:



-- Select Básico:
SELECT * FROM freelancer;

SELECT * FROM empresa;

SELECT * FROM projeto;

-- Select com ordenação descendente
SELECT nome,sobrenome FROM freelancer ORDER BY nome DESC;

--Select com ordenação ascendente
SELECT nome,sobrenome FROM freelancer ORDER BY nome ASC;

-- Selecionar todos os projetos de uma empresa específica
SELECT * FROM projeto WHERE empresaId = 1;

-- Selecionar Freelancers que começam, por exemplo, com a letra M
SELECT nome, sobrenome FROM freelancer
WHERE nome LIKE 'M%';

-- Selecionar Freelancers que, por exemplo, não comecem com a letra A
SELECT nome, sobrenome FROM freelancer
WHERE nome NOT LIKE 'A%';

-- Selecionar resultados sem valores duplicados
SELECT DISTINCT nome,sobrenome
FROM freelancer
SELECT NOME FROM freelancer;

-- Selecionar os freelancers que se candidataram para um projeto específico
SELECT f.nome, f.sobrenome
FROM candidatura c
JOIN freelancer f ON c.freelancerId = f.id
WHERE c.projetoId = 1;

-- Selecionar o nome e a nota das avaliações de um freelancer específico
SELECT f.nome, a.nota
FROM avaliacao a
JOIN freelancer f ON a.freelancerId = f.id
WHERE a.freelancerId = 1;

-- Contar o número de candidaturas em um projeto específico
SELECT COUNT(*) AS NumeroDeCandidaturas
FROM candidatura
WHERE projetoId = 1;