-- Tabela que armazena informações das lojas
CREATE TABLE Loja (
    Numero_Loja CHAR(3) NOT NULL,    -- Número identificador da loja (3 caracteres)
    Endereco VARCHAR(255) NOT NULL,  -- Endereço da loja
    Cidade VARCHAR(100) NOT NULL,    -- Cidade da loja
    Estado CHAR(2) NOT NULL,         -- Estado da loja (2 caracteres, ex: 'MG', 'RJ')
    CONSTRAINT PK_Numero_Loja PRIMARY KEY(Numero_Loja)  -- Chave primária: identifica unicamente cada loja
) DEFAULT CHARSET=utf8mb4;

-- Tabela que armazena informações dos empregados
CREATE TABLE Empregado (
    CPF_Empregado CHAR(14) NOT NULL, -- CPF do empregado (inclui pontos e traços)
    Nome VARCHAR(50) NOT NULL,       -- Nome do empregado
    Sexo ENUM ('Masculino', 'Feminino') NOT NULL,  -- Sexo do empregado (apenas masculino ou feminino)
    Data_nascimento DATE NOT NULL,   -- Data de nascimento do empregado
    Funcao VARCHAR(12) NOT NULL,     -- Função do empregado (ex: 'Gerente', 'Caixa', etc.)
    Loja_de_trabalho CHAR(3) NOT NULL, -- Loja em que o empregado trabalha (ligado à tabela Loja)
    CONSTRAINT PK_CPF_Empregado PRIMARY KEY(CPF_Empregado),  -- Chave primária: CPF identifica unicamente cada empregado
    CONSTRAINT FK_Loja_de_trabalho FOREIGN KEY(Loja_de_trabalho) REFERENCES Loja(Numero_Loja)  -- Chave estrangeira: relaciona o empregado à loja
) DEFAULT CHARSET=utf8mb4;

-- Tabela que armazena informações dos produtos
CREATE TABLE Produto (
    Codigo_produto CHAR(6) NOT NULL, -- Código identificador do produto (6 caracteres)
    Nome_Produto VARCHAR(150) NOT NULL,  -- Nome do produto
    Unidade_de_medida VARCHAR(20) NOT NULL,  -- Unidade de medida do produto (ex: 'kg', 'litro', etc.)
    CONSTRAINT PK_Codigo_Produto PRIMARY KEY(Codigo_produto)  -- Chave primária: código identifica unicamente cada produto
) DEFAULT CHARSET=utf8mb4;

-- Tabela que armazena o estoque das lojas (quantidade e valor dos produtos em estoque)
CREATE TABLE Estoque (
    Loja_Estoque CHAR(3) NOT NULL,   -- Loja onde o produto está em estoque (relacionado à tabela Loja)
    Codigo_Produto CHAR(6) NOT NULL, -- Código do produto em estoque (relacionado à tabela Produto)
    Quantidade_Em_Estoque INT,       -- Quantidade de produtos em estoque
    Valor_Unitario DECIMAL(10, 2),            -- Valor unitário do produto no estoque
    CONSTRAINT PK_Loja_Estoque_cod_Produto PRIMARY KEY (Loja_Estoque, Codigo_Produto),  -- Chave primária composta: loja + produto
    CONSTRAINT FK_Loja_Estoque FOREIGN KEY(Loja_Estoque) REFERENCES Loja(Numero_Loja),  -- Chave estrangeira: liga à tabela Loja
    CONSTRAINT FK_Codigo_Produto FOREIGN KEY(Codigo_Produto) REFERENCES Produto(Codigo_produto)  -- Chave estrangeira: liga à tabela Produto
) DEFAULT CHARSET=utf8mb4;

-- Tabela que armazena as vendas e notas fiscais
CREATE TABLE Venda_Nota_Fiscal (
    Numero_Nota_Fiscal CHAR(10) NOT NULL,  -- Número da nota fiscal
    Loja CHAR(3) NOT NULL,                 -- Loja onde a venda foi realizada (ligada à tabela Loja)
    Data_Venda DATE NOT NULL,              -- Data em que a venda foi realizada
    Codigo_Produto CHAR(6) NOT NULL,       -- Código do produto vendido (ligado à tabela Produto)
    Quantidade INT,                        -- Quantidade de produtos vendidos
    Valor_Unitario DECIMAL(10, 2),                  -- Valor unitário do produto na venda
    CONSTRAINT PK_Venda_Nota_Fiscal PRIMARY KEY (Numero_Nota_Fiscal, Loja, Data_Venda, Codigo_Produto),  -- Chave primária composta: identifica unicamente a venda
    CONSTRAINT FK_Loja_Venda FOREIGN KEY(Loja) REFERENCES Loja(Numero_Loja),  -- Chave estrangeira: liga a venda à loja
    CONSTRAINT FK_Codigo_Produto_Venda FOREIGN KEY(Codigo_Produto) REFERENCES Produto(Codigo_produto)  -- Chave estrangeira: liga à tabela Produto
) DEFAULT CHARSET=utf8mb4;


-- Adiciona restrições extras de integridade nas tabelas

-- Limita os estados das lojas para apenas 'MG', 'GO', 'DF' e 'RJ'
ALTER TABLE Loja 
ADD CONSTRAINT CK_Estado CHECK (Estado IN('MG', 'GO', 'DF', 'RJ'));

-- Impede que empregados nascidos depois de 2005 sejam inseridos e força funções pré-definidas
ALTER TABLE Empregado 
ADD CONSTRAINT CK_Data_Nascimento CHECK (Data_nascimento <= '2005-01-01'),  -- Verifica que o empregado deve ter nascido antes de 2005
ADD CONSTRAINT CK_Funcao CHECK (Funcao IN('Gerente', 'Estoquista', 'Caixa', 'Padeiro', 'Açougueiro', 'Atendente'));  -- Verifica que a função deve ser uma das especificadas

-- Adiciona restrição para que a data da venda seja posterior a 2 de janeiro de 2024
ALTER TABLE Venda_Nota_Fiscal
ADD CONSTRAINT CK_Data_Venda CHECK(Data_Venda >= '2024-01-02'),
ADD Total_a_pagar DECIMAL(10, 2) GENERATED ALWAYS AS (Quantidade * Valor_Unitario) STORED;

-- ------------------------------------------------------------------------------------

select * from venda_nota_fiscal;

-- Inserindo dados na tabela Loja
INSERT INTO Loja (Numero_Loja, Endereco, Cidade, Estado) VALUES
('001', 'Rua A, 123', 'Belo Horizonte', 'MG'),
('002', 'Av. B, 456', 'Goiânia', 'GO'),
('003', 'Rua C, 789', 'Brasília', 'DF'),
('004', 'Rua D, 101', 'Rio de Janeiro', 'RJ');



INSERT INTO Loja (Numero_Loja, Endereco, Cidade, Estado) VALUES
('005', 'Av. E, 202', 'São Paulo', 'SP'),  -- loja com estado inválido, mas para mostrar erro
('006', 'Rua F, 303', 'Curitiba', 'PR');   -- loja com estado inválido, mas para mostrar erro

-- Inserindo dados na tabela Empregado
INSERT INTO Empregado (CPF_Empregado, Nome, Sexo, Data_nascimento, Funcao, Loja_de_trabalho) VALUES
('123.456.789-00', 'Carlos Silva', 'Masculino', '1985-06-15', 'Gerente', '001'),
('987.654.321-00', 'Maria Souza', 'Feminino', '1990-02-20', 'Caixa', '001'),
('456.789.123-00', 'Ana Pereira', 'Feminino', '1995-09-10', 'Estoquista', '002'),
('321.654.987-00', 'João Oliveira', 'Masculino', '2000-11-25', 'Padeiro', '003'),
('741.852.963-00', 'Fernanda Lima', 'Feminino', '1992-03-12', 'Atendente', '001'),
('159.753.486-00', 'Roberto Costa', 'Masculino', '1988-08-30', 'Estoquista', '004'),
('963.258.741-00', 'Patrícia Alves', 'Feminino', '1996-12-05', 'Gerente', '005'),
('852.369.741-00', 'Ricardo Martins', 'Masculino', '1975-01-15', 'Caixa', '006');

-- Inserindo dados na tabela Produto
INSERT INTO Produto (Codigo_produto, Nome_Produto, Unidade_de_medida) VALUES
('P001', 'Arroz Tipo 1', 'kg'),
('P002', 'Feijão Preto', 'kg'),
('P003', 'Açúcar Cristal', 'kg'),
('P004', 'Leite Integral', 'L'),
('P005', 'Café Torrado', 'kg'),
('P006', 'Óleo de Soja', 'L'),
('P007', 'Farinha de Trigo', 'kg'),
('P008', 'Sal Refinado', 'kg'),
('P009', 'Biscoito Doce', 'g'),
('P010', 'Refrigerante 2L', 'L');

-- Inserindo dados na tabela Estoque
INSERT INTO Estoque (Loja_Estoque, Codigo_Produto, Quantidade_Em_Estoque, Valor_Unitario) VALUES
('001', 'P001', 100, 4.50),
('001', 'P002', 50, 5.20),
('001', 'P004', 200, 2.50),
('002', 'P003', 75, 3.80),
('002', 'P005', 30, 8.00),
('003', 'P006', 90, 6.00),
('003', 'P007', 120, 2.30),
('004', 'P001', 60, 4.70),
('004', 'P008', 150, 1.50),
('005', 'P009', 80, 2.20),
('006', 'P010', 100, 5.00);

-- Inserindo dados na tabela Venda_Nota_Fiscal
INSERT INTO Venda_Nota_Fiscal (Numero_Nota_Fiscal, Loja, Data_Venda, Codigo_Produto, Quantidade, Valor_Unitario) VALUES
('NF001', '001', '2024-01-10', 'P001', 2, 4.50),
('NF002', '001', '2024-01-11', 'P002', 1, 5.20),
('NF003', '002', '2024-01-12', 'P003', 3, 3.80),
('NF004', '003', '2024-01-13', 'P004', 5, 2.50),
('NF005', '001', '2024-01-14', 'P005', 1, 8.00),
('NF006', '002', '2024-01-15', 'P006', 2, 6.00),
('NF007', '004', '2024-01-16', 'P007', 10, 2.30),
('NF008', '005', '2024-01-17', 'P008', 15, 1.50),
('NF009', '006', '2024-01-18', 'P009', 5, 2.20),
('NF010', '001', '2024-01-19', 'P010', 7, 5.00);



