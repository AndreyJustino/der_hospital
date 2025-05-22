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

ALTER TABLE tbl_medico ADD em_atividade VARCHAR(100) NOT NULL;

INSERT INTO tbl_medico (nome, data_nascimento, crm, cpf, especialidade, posicao, em_atividade)
VALUES("Adriana", "1980-10-10", "670.795.044.380", "72664635050", "Clínica Geral", "Generalistas", "Inativo"),
	  ("Andrey", "2005-5-10", "620.743.779.071", "61437236057", "Clínica Geral", "Residentes", "Inativo"),
      ("Livia", "2006-5-15", "121.153.075.424", "73304617094", "Pediatria", "Especialista", "Ativo"),
      ("Gabriel", "1997-2-2", "832.573.918.060", "75205385081", "Dermatologia", "Especialista", "Ativo");
