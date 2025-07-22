CREATE DATABASE ecommerce;
USE ecommerce;

-- Cliente (Pessoa Física ou Jurídica)
CREATE TABLE Cliente (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo_cliente ENUM('PF', 'PJ') NOT NULL,
    cpf VARCHAR(14) DEFAULT NULL,
    cnpj VARCHAR(18) DEFAULT NULL,
    CHECK (
        (tipo_cliente = 'PF' AND cpf IS NOT NULL AND cnpj IS NULL) OR
        (tipo_cliente = 'PJ' AND cnpj IS NOT NULL AND cpf IS NULL)
    )
);

-- Vendedor
CREATE TABLE Vendedor (
    vendedor_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Fornecedor
CREATE TABLE Fornecedor (
    fornecedor_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- VendedorFornecedor: para responder se algum vendedor também é fornecedor (relação muitos para muitos)
CREATE TABLE VendedorFornecedor (
    vendedor_id INT,
    fornecedor_id INT,
    PRIMARY KEY(vendedor_id, fornecedor_id),
    FOREIGN KEY(vendedor_id) REFERENCES Vendedor(vendedor_id),
    FOREIGN KEY(fornecedor_id) REFERENCES Fornecedor(fornecedor_id)
);

-- Produto
CREATE TABLE Produto (
    produto_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    fornecedor_id INT,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT DEFAULT 0,
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedor(fornecedor_id)
);

-- Forma de Pagamento (um cliente pode ter várias formas)
CREATE TABLE FormaPagamento (
    pagamento_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    tipo_pagamento VARCHAR(50) NOT NULL,
    detalhes VARCHAR(255),
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id)
);

-- Pedido
CREATE TABLE Pedido (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    vendedor_id INT,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(10,2) GENERATED ALWAYS AS (
        (SELECT IFNULL(SUM(quantidade * preco_unitario), 0) FROM ItemPedido WHERE ItemPedido.pedido_id = Pedido.pedido_id)
    ) STORED,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
    FOREIGN KEY (vendedor_id) REFERENCES Vendedor(vendedor_id)
);

-- Item do Pedido (produtos por pedido)
CREATE TABLE ItemPedido (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT,
    produto_id INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES Produto(produto_id)
);

-- Entrega
CREATE TABLE Entrega (
    entrega_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT,
    status ENUM('pendente', 'em_transito', 'entregue', 'cancelado') DEFAULT 'pendente',
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id)
);

-- Clientes
INSERT INTO Cliente (nome, tipo_cliente, cpf) VALUES ('João Silva', 'PF', '123.456.789-00');
INSERT INTO Cliente (nome, tipo_cliente, cnpj) VALUES ('Empresa XYZ', 'PJ', '12.345.678/0001-99');

-- Vendedores
INSERT INTO Vendedor (nome) VALUES ('Carlos');

-- Fornecedores
INSERT INTO Fornecedor (nome) VALUES ('Fornecedor A');

-- Relação vendedor-fornecedor
INSERT INTO VendedorFornecedor (vendedor_id, fornecedor_id) VALUES (1, 1);

-- Produtos
INSERT INTO Produto (nome, fornecedor_id, preco, estoque) VALUES ('Produto 1', 1, 10.00, 100);

-- Formas de pagamento
INSERT INTO FormaPagamento (cliente_id, tipo_pagamento, detalhes) VALUES (1, 'Cartão de Crédito', 'Visa ****1234');

-- Pedido
INSERT INTO Pedido (cliente_id, vendedor_id) VALUES (1, 1);

-- ItemPedido
INSERT INTO ItemPedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES (1, 1, 2, 10.00);

-- Entrega
INSERT INTO Entrega (pedido_id, status, codigo_rastreio) VALUES (1, 'em_transito', 'TRACK123456');
