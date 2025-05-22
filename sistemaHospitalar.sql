CREATE DATABASE IF NOT EXISTS sistema_hospitalar;
USE sistema_hospitalar;

CREATE TABLE tbl_endereco (
    id_endereco INT AUTO_INCREMENT PRIMARY KEY,
    rua VARCHAR(255) NOT NULL,
    cep CHAR(8) NOT NULL,
    numero INT NOT NULL,
    bairro VARCHAR(255) NOT NULL,
    municipio VARCHAR(255) NOT NULL,
    estado VARCHAR(255) NOT NULL
);

CREATE TABLE tbl_tipo_quarto (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    descricao TEXT NOT NULL,
    valor_diario DECIMAL(10, 2) NOT NULL
);

CREATE TABLE tbl_quarto (
    id_quarto INT AUTO_INCREMENT PRIMARY KEY,
    numeracao INT NOT NULL,
    fk_tipo INT,
    FOREIGN KEY (fk_tipo) REFERENCES tbl_tipo_quarto(id_tipo)
);

CREATE TABLE tbl_medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    data_nascimento DATE NOT NULL,
    crm VARCHAR(255) NOT NULL UNIQUE,
    cpf CHAR(11) NOT NULL UNIQUE,
    especialidade VARCHAR(255) NOT NULL,
    posicao VARCHAR(255)
);

CREATE TABLE tbl_convenio (
    id_convenio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cnpj CHAR(14) NOT NULL UNIQUE,
    tempo_carencia DATETIME NOT NULL
);

CREATE TABLE tbl_paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(255),
    email VARCHAR(255),
    cpf CHAR(11) NOT NULL UNIQUE,
    rg VARCHAR(255) UNIQUE,
    fk_convenio INT,
    fk_endereco INT,
    FOREIGN KEY (fk_convenio) REFERENCES tbl_convenio(id_convenio),
    FOREIGN KEY (fk_endereco) REFERENCES tbl_endereco(id_endereco)
);

CREATE TABLE tbl_internacao (
    id_internacao INT AUTO_INCREMENT PRIMARY KEY,
    data_entrada DATETIME NOT NULL,
    previsao_alta DATETIME,
    data_efetiva_alta DATETIME,
    descricao_procedimentos TEXT NOT NULL,
    fk_paciente INT,
    fk_medico INT,
    fk_quarto INT,
    FOREIGN KEY (fk_paciente) REFERENCES tbl_paciente(id_paciente),
    FOREIGN KEY (fk_medico) REFERENCES tbl_medico(id_medico),
    FOREIGN KEY (fk_quarto) REFERENCES tbl_quarto(id_quarto)
);

CREATE TABLE tbl_enfermeiro (
    id_enfermeiro INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf CHAR(11) NOT NULL,
    coren VARCHAR(255) NOT NULL,
    fk_internacao INT,
    FOREIGN KEY (fk_internacao) REFERENCES tbl_internacao(id_internacao)
);

CREATE TABLE tbl_consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    especialidade VARCHAR(255) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    data_hora DATETIME NOT NULL,
    numero_carteira INT NOT NULL,
    fk_paciente INT,
    fk_medico INT,
    FOREIGN KEY (fk_paciente) REFERENCES tbl_paciente(id_paciente),
    FOREIGN KEY (fk_medico) REFERENCES tbl_medico(id_medico)
);

CREATE TABLE tbl_receita (
    id_receita INT AUTO_INCREMENT PRIMARY KEY,
    medicamento VARCHAR(2550) NOT NULL,
    quantidade VARCHAR(255) NOT NULL,
    instrucoes TEXT NOT NULL,
    fk_paciente INT,
    fk_consulta INT,
    fk_medico INT,
    FOREIGN KEY (fk_medico) REFERENCES tbl_medico(id_medico),
    FOREIGN KEY (fk_paciente) REFERENCES tbl_paciente(id_paciente),
    FOREIGN KEY (fk_consulta) REFERENCES tbl_consulta(id_consulta)
);

-- ----------------------------------------- semeando ------------------------------------------------------------------

INSERT INTO tbl_endereco (rua, cep, numero, bairro, municipio, estado) VALUES
('Rua A', '12345678', 100, 'Bairro Centro', 'São Paulo', 'SP'),
('Rua B', '87654321', 200, 'Bairro Jardim', 'Rio de Janeiro', 'RJ');

-- Inserir tipos de quarto
INSERT INTO tbl_tipo_quarto (descricao, valor_diario) VALUES
('Quarto Simples', 150.00),
('Quarto Luxo', 500.00);

-- Inserir quartos
INSERT INTO tbl_quarto (numeracao, fk_tipo) VALUES
(101, 1),
(202, 2);

-- Inserir convênios
INSERT INTO tbl_convenio (nome, cnpj, tempo_carencia) VALUES
('Convênio Saúde+', '12345678000199', '2025-12-31 00:00:00'),
('Convênio BemEstar', '98765432000188', '2024-06-30 00:00:00');

-- Inserir pacientes
INSERT INTO tbl_paciente (nome, data_nascimento, telefone, email, cpf, rg, fk_convenio, fk_endereco) VALUES
('João Silva', '1985-03-20', '11999999999', 'joao@email.com', '12345678901', 'MG123456', 1, 1),
('Maria Souza', '1990-07-15', '21988888888', 'maria@email.com', '10987654321', 'RJ987654', 2, 2);

-- Inserir médicos (já inserido por você, mas vamos repetir pra ficar tudo junto)
INSERT INTO tbl_medico (nome, data_nascimento, crm, cpf, especialidade, posicao, em_atividade) VALUES
("Adriana", "1980-10-10", "670.795.044.380", "72664635050", "Clínica Geral", "Generalistas", "Inativo"),
("Andrey", "2005-05-10", "620.743.779.071", "61437236057", "Clínica Geral", "Residentes", "Inativo"),
("Livia", "2006-05-15", "121.153.075.424", "73304617094", "Pediatria", "Especialista", "Ativo"),
("Gabriel", "1997-02-02", "832.573.918.060", "75205385081", "Dermatologia", "Especialista", "Ativo");

-- Inserir internações
INSERT INTO tbl_internacao (data_entrada, previsao_alta, data_efetiva_alta, descricao_procedimentos, fk_paciente, fk_medico, fk_quarto) VALUES
('2025-05-20 10:00:00', '2025-05-25 10:00:00', NULL, 'Tratamento para pneumonia', 1, 1, 1),
('2025-05-21 14:00:00', '2025-05-26 14:00:00', NULL, 'Cirurgia dermatológica', 2, 4, 2);

-- Inserir enfermeiros
INSERT INTO tbl_enfermeiro (nome, cpf, coren, fk_internacao) VALUES
('Carlos Almeida', '12345678900', 'COREN12345', 1),
('Ana Beatriz', '09876543211', 'COREN54321', 2);

-- Inserir consultas
INSERT INTO tbl_consulta (especialidade, valor, data_hora, numero_carteira, fk_paciente, fk_medico) VALUES
('Clínica Geral', 200.00, '2025-05-22 09:00:00', 12345, 1, 1),
('Dermatologia', 300.00, '2025-05-23 11:00:00', 67890, 2, 4);

-- Inserir receitas
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Paracetamol 500mg', '20 comprimidos', 'Tomar 1 comprimido a cada 8 horas', 1, 1, 1),
('Pomada Dermatológica', '1 tubo', 'Aplicar 2 vezes ao dia na área afetada', 2, 2, 4);

-- -------------------------------------------------------------------------------------------------

ALTER TABLE tbl_medico ADD em_atividade VARCHAR(100) NOT NULL;

INSERT INTO tbl_medico (nome, data_nascimento, crm, cpf, especialidade, posicao, em_atividade)
VALUES("Adriana", "1980-10-10", "670.795.044.380", "72664635050", "Clínica Geral", "Generalistas", "Inativo"),
	  ("Andrey", "2005-5-10", "620.743.779.071", "61437236057", "Clínica Geral", "Residentes", "Inativo"),
      ("Livia", "2006-5-15", "121.153.075.424", "73304617094", "Pediatria", "Especialista", "Ativo"),
      ("Gabriel", "1997-2-2", "832.573.918.060", "75205385081", "Dermatologia", "Especialista", "Ativo");
      

