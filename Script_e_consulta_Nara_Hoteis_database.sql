CREATE TABLE Nara_Hoteis

USE DATABASE Nara_Hoteis

CREATE TABLE UNIDADES (
    id_unidade INT PRIMARY KEY,
    nome_unidade VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    regiao VARCHAR(50) NOT NULL,
    categoria_hotel VARCHAR(50) NOT NULL,
    num_quartos_total INT NOT NULL);

CREATE TABLE FUNCIONARIOS (
    id_funcionario INT PRIMARY KEY,
    id_unidade INT NOT NULL,
    nome VARCHAR(150) NOT NULL,
    cargo VARCHAR(80) NOT NULL,
    departamento VARCHAR(80) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    data_admissao DATE NOT NULL,
    FOREIGN KEY (id_unidade)
    REFERENCES UNIDADES(id_unidade));

CREATE TABLE QUARTOS (
    id_tipo_quarto INT PRIMARY KEY,
    descricao VARCHAR(150) NOT NULL,
    capacidade_max INT NOT NULL,
    valor_diaria_base DECIMAL(10,2) NOT NULL);

CREATE TABLE CLIENTES (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cidade_origem VARCHAR(100),
    estado_origem VARCHAR(2),
    faixa_etaria VARCHAR(20),
    tipo_cliente VARCHAR(30) NOT NULL);

CREATE TABLE CANAIS (
    id_canal INT PRIMARY KEY,
    nome_canal VARCHAR(80) NOT NULL,
    comissao_pct DECIMAL(5,2) NOT NULL);

CREATE TABLE RESERVAS (
    id_reserva INT PRIMARY KEY,
    id_unidade INT NOT NULL,
    id_tipo_quarto INT NOT NULL,
    id_cliente INT NOT NULL,
    id_canal INT NOT NULL,
    data_checkin DATE NOT NULL,
    data_checkout DATE NOT NULL,
    qtd_diarias INT NOT NULL,
    num_hospedes INT NOT NULL,
    avaliacao_hospede DECIMAL(4,2),
    status_reserva VARCHAR(30) NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_unidade)
    REFERENCES UNIDADES(id_unidade),
    FOREIGN KEY (id_tipo_quarto)
    REFERENCES QUARTOS(id_tipo_quarto),
    FOREIGN KEY (id_cliente)
    REFERENCES CLIENTES(id_cliente),
    FOREIGN KEY (id_canal)
    REFERENCES CANAIS(id_canal));

SET GLOBAL local_infile = 1;

LOAD DATA INFILE '/tmp/unidades_tratada.csv'
INTO TABLE UNIDADES
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_unidade, nome_unidade, cidade, 
regiao, categoria_hotel, num_quartos_total);

LOAD DATA INFILE '/tmp/quartos_tratada.csv'
INTO TABLE QUARTOS
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_tipo_quarto, descricao, capacidade_max, valor_diaria_base);

LOAD DATA INFILE '/tmp/clientes_tratada.csv'
INTO TABLE CLIENTES
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_cliente, nome, cidade_origem, 
estado_origem, faixa_etaria, tipo_cliente);

LOAD DATA INFILE '/tmp/canais_tratada.csv'
INTO TABLE CANAIS
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_canal, nome_canal, comissao_pct);

LOAD DATA INFILE '/tmp/funcionarios_tratada.csv'
INTO TABLE FUNCIONARIOS
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_funcionario, id_unidade, nome, 
cargo, departamento, salario, data_admissao);

LOAD DATA INFILE '/tmp/reservas_tratada.csv'
INTO TABLE RESERVAS
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_reserva, 
id_unidade, 
id_tipo_quarto, 
id_cliente, 
id_canal, 
data_checkin, data_checkout, qtd_diarias, 
num_hospedes, avaliacao_hospede, 
status_reserva, forma_pagamento);

SELECT 
    u.nome_unidade,
    COUNT(r.id_reserva) AS total_cancelamentos
FROM RESERVAS r
JOIN UNIDADES u ON r.id_unidade = u.id_unidade
WHERE r.status_reserva = 'CANCELADA'
GROUP BY 
    u.nome_unidade
ORDER BY 
    total_cancelamentos DESC;

SELECT r.id_cliente, c.nome, r.status_reserva AS cancelamentos
FROM `RESERVAS` r
JOIN `CLIENTES` c ON r.id_cliente = c.id_cliente
WHERE r.status_reserva = 'CANCELADA'
ORDER BY c.nome;

SELECT 
    c.id_cliente, 
    c.nome,
    u.nome_unidade,
    COUNT(r.id_reserva) AS total_cancelamentos
FROM `RESERVAS` r
JOIN `CLIENTES` c ON r.id_cliente = c.id_cliente
JOIN `UNIDADES` u ON r.id_unidade = u.id_unidade
WHERE r.status_reserva = 'CANCELADA'
GROUP BY 
    c.id_cliente, 
    c.nome,
    u.nome_unidade
ORDER BY 
    total_cancelamentos DESC, 
    c.nome;

SELECT r.id_cliente, c.nome, r.status_reserva, c.cidade_origem AS cancelamentos
FROM `RESERVAS` r
JOIN `CLIENTES` c ON r.id_cliente = c.id_cliente
WHERE c.nome = 'CARLA MENDES'
ORDER BY c.nome;

SELECT 
    c.id_cliente, 
    c.nome,
    u.nome_unidade,
    COUNT(r.id_reserva) AS total_cancelamentos
FROM `RESERVAS` r
JOIN `CLIENTES` c ON r.id_cliente = c.id_cliente
JOIN `UNIDADES` u ON r.id_unidade = u.id_unidade
WHERE r.status_reserva = 'NO-SHOW'
GROUP BY 
    c.id_cliente, 
    c.nome,
    u.nome_unidade
HAVING COUNT(r.id_reserva) >= 2
ORDER BY 
    total_cancelamentos DESC, 
    c.nome;

SELECT 
    c.id_cliente, 
    c.nome, 
    COUNT(c.id_cliente) AS total_cadastrados
FROM CLIENTES c
GROUP BY 
    c.id_cliente, 
    c.nome
ORDER BY 
    c.nome;