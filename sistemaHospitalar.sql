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

CREATE TABLE tbl_especialidade(
    id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE,
    descricao TEXT
)

CREATE TABLE tbl_medico (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    data_nascimento DATE NOT NULL,
    crm VARCHAR(255) NOT NULL UNIQUE,
    cpf CHAR(11) NOT NULL UNIQUE,
    posicao VARCHAR(255)
);

CREATE TABLE tbl_medico_especialidade (
    id_medico_esp INT AUTO_INCREMENT PRIMARY KEY,
    fk_medico INT,
    fk_especialidade INT,
    FOREIGN KEY (fk_medico) REFERENCES tbl_medico(id_medico),
    FOREIGN KEY (fk_especialidade) REFERENCES tbl_especialidade(id_especialidade)
);

CREATE TABLE tbl_convenio (
    id_convenio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cnpj CHAR(14) NOT NULL UNIQUE,
    tempo_carencia DATETIME NOT NULL
);

CREATE TABLE tbl_medico_convenio (
    id_medico_conv INT AUTO_INCREMENT PRIMARY KEY,
    fk_medico INT,
    fk_convenio INT,
    FOREIGN KEY (fk_medico) REFERENCES tbl_medico(id_medico),
    FOREIGN KEY (fk_convenio) REFERENCES tbl_convenio(id_convenio)
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
    coren VARCHAR(255) NOT NULL
);

CREATE TABLE tbl_internacao_enfermeiro (
    id_internacao_enfermeiro INT AUTO_INCREMENT PRIMARY KEY,
    fk_internacao INT,
    fk_enfermeiro INT,
    data_inicio DATETIME,
    data_fim DATETIME,
    FOREIGN KEY (fk_internacao) REFERENCES tbl_internacao(id_internacao),
    FOREIGN KEY (fk_enfermeiro) REFERENCES tbl_enfermeiro(id_enfermeiro)
);

CREATE TABLE tbl_consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    valor DECIMAL(10, 2) NOT NULL,
    data_hora DATETIME NOT NULL,
    numero_carteira INT NOT NULL,
    fk_paciente INT,
    fk_medico INT,
    fk_especialidade INT,
    FOREIGN KEY (fk_especialidade) REFERENCES tbl_especialidade(id_especialidade),
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
('Rua das Flores, 123', '01234567', 123, 'Centro', 'São Paulo', 'SP'),
('Av. Paulista, 456', '04567890', 456, 'Bela Vista', 'São Paulo', 'SP'),
('Rua Augusta, 789', '01234890', 789, 'Consolação', 'São Paulo', 'SP'),
('Rua Oscar Freire, 321', '01456789', 321, 'Jardins', 'São Paulo', 'SP'),
('Av. Rebouças, 654', '05432167', 654, 'Pinheiros', 'São Paulo', 'SP'),
('Rua Barão de Itapetininga, 987', '01234123', 987, 'República', 'São Paulo', 'SP'),
('Av. Faria Lima, 111', '04567123', 111, 'Itaim Bibi', 'São Paulo', 'SP'),
('Rua da Consolação, 222', '01234456', 222, 'Consolação', 'São Paulo', 'SP'),
('Av. Brasil, 333', '04567456', 333, 'Jardim América', 'São Paulo', 'SP'),
('Rua Estados Unidos, 444', '01234789', 444, 'Jardins', 'São Paulo', 'SP'),
('Av. Ibirapuera, 555', '04567789', 555, 'Ibirapuera', 'São Paulo', 'SP'),
('Rua Haddock Lobo, 666', '05432890', 666, 'Cerqueira César', 'São Paulo', 'SP'),
('Av. Nove de Julho, 777', '01234321', 777, 'Bela Vista', 'São Paulo', 'SP'),
('Rua Amauri, 888', '04567321', 888, 'Itaim Bibi', 'São Paulo', 'SP'),
('Av. Brigadeiro Faria Lima, 999', '05432321', 999, 'Jardim Paulistano', 'São Paulo', 'SP');

-- 2. INSERINDO ESPECIALIDADES (incluindo as obrigatórias)
INSERT INTO tbl_especialidade (nome, descricao) VALUES
('Pediatria', 'Especialidade médica dedicada ao cuidado de bebês, crianças e adolescentes'),
('Clínica Geral', 'Atendimento médico geral e preventivo para todas as idades'),
('Gastroenterologia', 'Especialidade focada no sistema digestivo e suas doenças'),
('Dermatologia', 'Especialidade dedicada ao diagnóstico e tratamento de doenças da pele'),
('Cardiologia', 'Especialidade médica que cuida do coração e sistema cardiovascular'),
('Neurologia', 'Especialidade que trata doenças do sistema nervoso'),
('Ortopedia', 'Especialidade focada no sistema musculoesquelético'),
('Ginecologia', 'Especialidade dedicada à saúde da mulher'),
('Psiquiatria', 'Especialidade que trata transtornos mentais e comportamentais');

-- 3. INSERINDO CONVÊNIOS MÉDICOS
INSERT INTO tbl_convenio (nome, cnpj, tempo_carencia) VALUES
('Unimed São Paulo', '12345678000123', '2023-01-01 00:00:00'),
('SulAmérica Saúde', '98765432000198', '2023-01-01 00:00:00'),
('Bradesco Saúde', '11122233000144', '2023-01-01 00:00:00'),
('Amil', '55566677000155', '2023-01-01 00:00:00');

-- 4. INSERINDO MÉDICOS (10 médicos de diferentes especialidades)
INSERT INTO tbl_medico (nome, data_nascimento, crm, cpf, posicao) VALUES
('Dr. João Silva Santos', '1975-03-15', 'CRM123456', '12345678901', 'Médico Titular'),
('Dra. Maria Oliveira Costa', '1980-07-22', 'CRM234567', '23456789012', 'Médico Titular'),
('Dr. Carlos Eduardo Lima', '1978-11-10', 'CRM345678', '34567890123', 'Médico Assistente'),
('Dra. Ana Paula Ferreira', '1982-05-18', 'CRM456789', '45678901234', 'Médico Titular'),
('Dr. Roberto Cardoso', '1976-09-25', 'CRM567890', '56789012345', 'Chefe de Departamento'),
('Dra. Fernanda Rodrigues', '1979-12-08', 'CRM678901', '67890123456', 'Médico Titular'),
('Dr. Paulo Henrique Alves', '1981-04-03', 'CRM789012', '78901234567', 'Médico Assistente'),
('Dra. Juliana Martins', '1983-08-14', 'CRM890123', '89012345678', 'Médico Titular'),
('Dr. Ricardo Pereira', '1977-01-29', 'CRM901234', '90123456789', 'Médico Titular'),
('Dra. Camila Santos', '1984-06-11', 'CRM012345', '01234567890', 'Médico Assistente');

-- 5. ASSOCIANDO MÉDICOS ÀS ESPECIALIDADES
INSERT INTO tbl_medico_especialidade (fk_medico, fk_especialidade) VALUES
(1, 1), -- Dr. João - Pediatria
(2, 2), -- Dra. Maria - Clínica Geral
(3, 3), -- Dr. Carlos - Gastroenterologia
(4, 4), -- Dra. Ana - Dermatologia
(5, 5), -- Dr. Roberto - Cardiologia
(6, 6), -- Dra. Fernanda - Neurologia
(7, 7), -- Dr. Paulo - Ortopedia
(8, 8), -- Dra. Juliana - Ginecologia
(9, 9), -- Dr. Ricardo - Psiquiatria
(10, 2), -- Dra. Camila - Clínica Geral
(2, 4), -- Dra. Maria também atende Dermatologia
(5, 2); -- Dr. Roberto também atende Clínica Geral

-- 6. ASSOCIANDO MÉDICOS AOS CONVÊNIOS
INSERT INTO tbl_medico_convenio (fk_medico, fk_convenio) VALUES
(1, 1), (1, 2), -- Dr. João aceita Unimed e SulAmérica
(2, 1), (2, 3), -- Dra. Maria aceita Unimed e Bradesco
(3, 2), (3, 4), -- Dr. Carlos aceita SulAmérica e Amil
(4, 1), (4, 3), (4, 4), -- Dra. Ana aceita Unimed, Bradesco e Amil
(5, 1), (5, 2), (5, 3), -- Dr. Roberto aceita Unimed, SulAmérica e Bradesco
(6, 2), (6, 4), -- Dra. Fernanda aceita SulAmérica e Amil
(7, 1), (7, 3), -- Dr. Paulo aceita Unimed e Bradesco
(8, 1), (8, 2), (8, 4), -- Dra. Juliana aceita Unimed, SulAmérica e Amil
(9, 3), (9, 4), -- Dr. Ricardo aceita Bradesco e Amil
(10, 1), (10, 2); -- Dra. Camila aceita Unimed e SulAmérica

-- 7. INSERINDO PACIENTES (15 pacientes)
INSERT INTO tbl_paciente (nome, data_nascimento, telefone, email, cpf, rg, fk_convenio, fk_endereco) VALUES
('Pedro Henrique Souza', '1990-05-15', '11987654321', 'pedro.souza@email.com', '11111111111', '123456789', 1, 1),
('Mariana Costa Silva', '1985-12-20', '11876543210', 'mariana.silva@email.com', '22222222222', '234567890', 2, 2),
('José Carlos Oliveira', '1978-03-10', '11765432109', 'jose.oliveira@email.com', '33333333333', '345678901', NULL, 3),
('Ana Beatriz Santos', '2010-08-25', '11654321098', 'ana.santos@email.com', '44444444444', '456789012', 1, 4),
('Roberto Silva Lima', '1965-11-30', '11543210987', 'roberto.lima@email.com', '55555555555', '567890123', 3, 5),
('Fernanda Alves Costa', '1992-07-18', '11432109876', 'fernanda.costa@email.com', '66666666666', '678901234', 2, 6),
('Lucas Pereira Santos', '2005-04-12', '11321098765', 'lucas.santos@email.com', '77777777777', '789012345', NULL, 7),
('Isabella Rodrigues', '1988-09-22', '11210987654', 'isabella.rodrigues@email.com', '88888888888', '890123456', 4, 8),
('Gabriel Martins', '1995-01-08', '11109876543', 'gabriel.martins@email.com', '99999999999', '901234567', 1, 9),
('Sofia Oliveira', '2015-06-14', '11098765432', 'sofia.oliveira@email.com', '10101010101', '012345678', 3, 10),
('Miguel Santos', '1982-10-05', '11987654322', 'miguel.santos@email.com', '20202020202', '123456780', NULL, 11),
('Laura Costa', '1975-02-28', '11876543211', 'laura.costa@email.com', '30303030303', '234567891', 2, 12),
('Davi Silva', '2008-12-16', '11765432110', 'davi.silva@email.com', '40404040404', '345678902', 4, 13),
('Alice Ferreira', '1987-05-09', '11654321099', 'alice.ferreira@email.com', '50505050505', '456789013', 1, 14),
('Arthur Pereira', '1993-08-31', '11543210988', 'arthur.pereira@email.com', '60606060606', '567890124', NULL, 15);

-- 8. INSERINDO CONSULTAS (20 consultas entre 2015 e 2022)
INSERT INTO tbl_consulta (valor, data_hora, numero_carteira, fk_paciente, fk_medico, fk_especialidade) VALUES
(150.00, '2015-03-15 09:00:00', 12345, 4, 1, 1), -- Ana Beatriz - Pediatria
(200.00, '2015-06-20 14:30:00', 23456, 1, 2, 2), -- Pedro - Clínica Geral
(180.00, '2016-01-10 10:15:00', 34567, 2, 3, 3), -- Mariana - Gastroenterologia
(220.00, '2016-05-25 16:45:00', 45678, 6, 4, 4), -- Fernanda - Dermatologia
(300.00, '2016-09-12 08:30:00', 56789, 5, 5, 5), -- Roberto - Cardiologia
(250.00, '2017-02-18 11:20:00', 67890, 8, 6, 6), -- Isabella - Neurologia
(180.00, '2017-07-30 15:10:00', 78901, 7, 7, 7), -- Lucas - Ortopedia
(200.00, '2017-11-14 09:45:00', 89012, 8, 8, 8), -- Isabella - Ginecologia
(350.00, '2018-04-22 13:15:00', 90123, 3, 9, 9), -- José - Psiquiatria
(160.00, '2018-08-05 10:30:00', 12346, 9, 10, 2), -- Gabriel - Clínica Geral
(170.00, '2019-01-20 14:00:00', 23457, 10, 1, 1), -- Sofia - Pediatria
(190.00, '2019-06-08 16:30:00', 34568, 11, 2, 2), -- Miguel - Clínica Geral
(280.00, '2019-12-15 11:45:00', 45679, 12, 5, 5), -- Laura - Cardiologia
(220.00, '2020-03-28 08:15:00', 56780, 13, 1, 1), -- Davi - Pediatria
(195.00, '2020-09-10 15:20:00', 67891, 14, 4, 4), -- Alice - Dermatologia
(175.00, '2021-02-14 09:30:00', 78902, 15, 2, 2), -- Arthur - Clínica Geral
(210.00, '2021-07-19 13:40:00', 89013, 1, 3, 3), -- Pedro - Gastroenterologia (2ª consulta)
(240.00, '2021-11-25 10:50:00', 90124, 2, 6, 6), -- Mariana - Neurologia (2ª consulta)
(180.00, '2021-12-30 14:25:00', 12347, 4, 1, 1), -- Ana Beatriz - Pediatria (2ª consulta)
(320.00, '2021-12-31 16:00:00', 23458, 5, 5, 5); -- Roberto - Cardiologia (2ª consulta)

-- 9. INSERINDO RECEITAS (10 consultas com 2+ medicamentos)
-- Receitas da consulta 1 (Ana Beatriz - Pediatria)
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Paracetamol Infantil 160mg/5ml', '1 frasco', 'Tomar 5ml de 6 em 6 horas se febre', 4, 1, 1),
('Soro Fisiológico 0,9%', '5 ampolas', 'Pingar 2 gotas em cada narina 3x ao dia', 4, 1, 1);

-- Receitas da consulta 2 (Pedro - Clínica Geral)
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Losartana 50mg', '30 comprimidos', 'Tomar 1 comprimido pela manhã em jejum', 1, 2, 2),
('Sinvastatina 20mg', '30 comprimidos', 'Tomar 1 comprimido à noite após jantar', 1, 2, 2),
('Ácido Acetilsalicílico 100mg', '30 comprimidos', 'Tomar 1 comprimido pela manhã após café', 1, 2, 2);

-- Receitas da consulta 3 (Mariana - Gastroenterologia)
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Omeprazol 20mg', '30 cápsulas', 'Tomar 1 cápsula em jejum pela manhã', 2, 3, 3),
('Domperidona 10mg', '20 comprimidos', 'Tomar 1 comprimido 30min antes das refeições', 2, 3, 3);

-- Receitas da consulta 4 (Fernanda - Dermatologia)
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Cetoconazol Creme 2%', '1 tubo 30g', 'Aplicar nas lesões 2x ao dia por 14 dias', 6, 4, 4),
('Loratadina 10mg', '10 comprimidos', 'Tomar 1 comprimido à noite por 10 dias', 6, 4, 4);

-- Receitas da consulta 5 (Roberto - Cardiologia)
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Atenolol 25mg', '30 comprimidos', 'Tomar 1 comprimido pela manhã', 5, 5, 5),
('Enalapril 10mg', '30 comprimidos', 'Tomar 1 comprimido de 12 em 12 horas', 5, 5, 5),
('Furosemida 40mg', '20 comprimidos', 'Tomar 1 comprimido pela manhã', 5, 5, 5);

-- Receitas da consulta 6 (Isabella - Neurologia)
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Carbamazepina 200mg', '60 comprimidos', 'Tomar 1 comprimido de 12 em 12 horas', 8, 6, 6),
('Ácido Fólico 5mg', '30 comprimidos', 'Tomar 1 comprimido ao dia', 8, 6, 6);

-- Receitas da consulta 9 (José - Psiquiatria)
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Sertralina 50mg', '30 comprimidos', 'Tomar 1 comprimido pela manhã', 3, 9, 9),
('Clonazepam 2mg', '30 comprimidos', 'Tomar 1 comprimido à noite antes de dormir', 3, 9, 9);

-- Receitas da consulta 13 (Laura - Cardiologia)
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Propranolol 40mg', '60 comprimidos', 'Tomar 1 comprimido de 12 em 12 horas', 12, 13, 5),
('Isossorbida 20mg', '30 comprimidos', 'Tomar 1 comprimido de 8 em 8 horas', 12, 13, 5);

-- Receitas da consulta 17 (Pedro - Gastroenterologia - 2ª consulta)
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Lansoprazol 30mg', '30 cápsulas', 'Tomar 1 cápsula em jejum', 1, 17, 3),
('Bromoprida 10mg', '20 comprimidos', 'Tomar 1 comprimido antes das refeições', 1, 17, 3);

-- Receitas da consulta 20 (Roberto - Cardiologia - 2ª consulta)
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Metoprolol 50mg', '30 comprimidos', 'Tomar 1 comprimido de 12 em 12 horas', 5, 20, 5),
('Hidroclorotiazida 25mg', '30 comprimidos', 'Tomar 1 comprimido pela manhã', 5, 20, 5),
('Anlodipino 5mg', '30 comprimidos', 'Tomar 1 comprimido à noite', 5, 20, 5);

-- 10. INSERINDO TIPOS DE QUARTO
INSERT INTO tbl_tipo_quarto (descricao, valor_diario) VALUES
('Apartamento', 450.00),
('Quarto Duplo', 280.00),
('Enfermaria', 180.00),
('UTI', 850.00),
('Suíte Premium', 650.00);

-- 11. INSERINDO QUARTOS (ao menos 3 quartos)
INSERT INTO tbl_quarto (numeracao, fk_tipo) VALUES
(101, 1), -- Apartamento
(102, 1), -- Apartamento
(201, 2), -- Quarto Duplo
(202, 2), -- Quarto Duplo
(301, 3), -- Enfermaria
(302, 3), -- Enfermaria
(401, 4), -- UTI
(501, 5); -- Suíte Premium

-- 12. INSERINDO ENFERMEIROS (10 profissionais)
INSERT INTO tbl_enfermeiro (nome, cpf, coren) VALUES
('Enfª. Silvia Rodrigues', '11111111112', 'COREN123456'),
('Enfº. Carlos Mendes', '22222222223', 'COREN234567'),
('Enfª. Patricia Lima', '33333333334', 'COREN345678'),
('Enfª. Roberta Santos', '44444444445', 'COREN456789'),
('Enfº. Anderson Silva', '55555555556', 'COREN567890'),
('Enfª. Juliana Costa', '66666666667', 'COREN678901'),
('Enfª. Monica Alves', '77777777778', 'COREN789012'),
('Enfº. Ricardo Pereira', '88888888889', 'COREN890123'),
('Enfª. Fernanda Oliveira', '99999999990', 'COREN901234'),
('Enfª. Cristina Martins', '10101010102', 'COREN012345');

-- 13. INSERINDO INTERNAÇÕES (7 internações entre 2015-2022)
INSERT INTO tbl_internacao (data_entrada, previsao_alta, data_efetiva_alta, descricao_procedimentos, fk_paciente, fk_medico, fk_quarto) VALUES
-- Internação 1: Pedro (1ª internação)
('2016-02-10 14:30:00', '2016-02-15 10:00:00', '2016-02-14 09:30:00', 'Cirurgia de apendicite. Procedimento realizado sem complicações. Antibioticoterapia profilática administrada.', 1, 2, 1),

-- Internação 2: Mariana 
('2017-05-20 08:15:00', '2017-05-28 12:00:00', '2017-05-27 11:30:00', 'Tratamento de úlcera péptica complicada. Endoscopia terapêutica realizada. Medicação via parenteral.', 2, 3, 2),

-- Internação 3: Roberto (1ª internação)
('2018-03-12 16:45:00', '2018-03-18 10:00:00', '2018-03-17 14:20:00', 'Infarto agudo do miocárdio. Cateterismo cardíaco de urgência. Angioplastia com implante de stent.', 5, 5, 7),

-- Internação 4: Isabella
('2019-07-08 20:30:00', '2019-07-15 08:00:00', '2019-07-14 16:45:00', 'Parto cesariana eletiva. Procedimento realizado sem intercorrências. Puerpério fisiológico.', 8, 8, 5),

-- Internação 5: José
('2020-11-25 10:20:00', '2020-12-05 14:00:00', '2020-12-03 12:15:00', 'Crise psicótica aguda. Estabilização clínica. Ajuste de medicação psicotrópica. Acompanhamento psicológico.', 3, 9, 3),

-- Internação 6: Pedro (2ª internação)
('2021-08-14 12:40:00', '2021-08-20 09:00:00', '2021-08-19 15:30:00', 'Pneumonia bilateral. Antibioticoterapia endovenosa. Fisioterapia respiratória. Evolução favorável.', 1, 2, 4),

-- Internação 7: Roberto (2ª internação)
('2021-10-30 18:15:00', '2021-11-08 10:00:00', '2021-11-06 13:45:00', 'Insuficiência cardíaca descompensada. Otimização de medicação cardiológica. Controle de volemia.', 5, 5, 1);

-- 14. ASSOCIANDO ENFERMEIROS ÀS INTERNAÇÕES (cada internação com ao menos 2 enfermeiros)
INSERT INTO tbl_internacao_enfermeiro (fk_internacao, fk_enfermeiro, data_inicio, data_fim) VALUES
-- Internação 1 (Pedro - Apendicite)
(1, 1, '2016-02-10 14:30:00', '2016-02-14 09:30:00'),
(1, 2, '2016-02-10 14:30:00', '2016-02-14 09:30:00'),
(1, 3, '2016-02-12 07:00:00', '2016-02-14 09:30:00'),

-- Internação 2 (Mariana - Úlcera)
(2, 4, '2017-05-20 08:15:00', '2017-05-27 11:30:00'),
(2, 5, '2017-05-20 08:15:00', '2017-05-27 11:30:00'),
(2, 6, '2017-05-22 19:00:00', '2017-05-27 11:30:00'),

-- Internação 3 (Roberto - IAM)
(3, 7, '2018-03-12 16:45:00', '2018-03-17 14:20:00'),
(3, 8, '2018-03-12 16:45:00', '2018-03-17 14:20:00'),
(3, 1, '2018-03-14 07:00:00', '2018-03-17 14:20:00'),

-- Internação 4 (Isabella - Parto)
(4, 9, '2019-07-08 20:30:00', '2019-07-14 16:45:00'),
(4, 10, '2019-07-08 20:30:00', '2019-07-14 16:45:00'),
(4, 2, '2019-07-10 07:00:00', '2019-07-14 16:45:00'),

-- Internação 5 (José - Psiquiatria)
(5, 3, '2020-11-25 10:20:00', '2020-12-03 12:15:00'),
(5, 4, '2020-11-25 10:20:00', '2020-12-03 12:15:00'),
(5, 5, '2020-11-27 19:00:00', '2020-12-03 12:15:00'),

-- Internação 6 (Pedro - Pneumonia - 2ª internação)
(6, 6, '2021-08-14 12:40:00', '2021-08-19 15:30:00'),
(6, 7, '2021-08-14 12:40:00', '2021-08-19 15:30:00'),
(6, 8, '2021-08-16 07:00:00', '2021-08-19 15:30:00'),

-- Internação 7 (Roberto - ICC - 2ª internação)
(7, 9, '2021-10-30 18:15:00', '2021-11-06 13:45:00'),
(7, 10, '2021-10-30 18:15:00', '2021-11-06 13:45:00'),
(7, 1, '2021-11-01 07:00:00', '2021-11-06 13:45:00');


-- -------------------------------------------------------------------------------------------------

ALTER TABLE tbl_medico ADD em_atividade VARCHAR(100) NOT NULL;

INSERT INTO tbl_medico (nome, data_nascimento, crm, cpf, especialidade, posicao, em_atividade)
VALUES("Adriana", "1980-10-10", "670.795.044.380", "72664635050", "Clínica Geral", "Generalistas", "Inativo"),
	  ("Andrey", "2005-5-10", "620.743.779.071", "61437236057", "Clínica Geral", "Residentes", "Inativo"),
      ("Livia", "2006-5-15", "121.153.075.424", "73304617094", "Pediatria", "Especialista", "Ativo"),
      ("Gabriel", "1997-2-2", "832.573.918.060", "75205385081", "Dermatologia", "Especialista", "Ativo");
      
-- Reliquia de dados

-- Todos os dados e o valor médio das consultas do ano de 2020 e das que foram feitas sob convênio.
SELECT 
    -- INTERNACAO
    i.id_internacao,
    i.data_entrada,
    i.previsao_alta,
    i.data_efetiva_alta,
    i.descricao_procedimentos,

    -- PACIENTE
    p.id_paciente,
    p.nome AS nome_paciente,
    p.data_nascimento AS nascimento_paciente,
    p.telefone,
    p.email,
    p.cpf AS cpf_paciente,
    p.rg AS rg_paciente,

    -- ENDERECO
    e.rua,
    e.cep,
    e.numero AS numero_residencia,
    e.bairro,
    e.municipio,
    e.estado,

    -- CONVENIO
    c.nome AS nome_convenio,
    c.cnpj,
    c.tempo_carencia,

    -- MEDICO
    m.id_medico,
    m.nome AS nome_medico,
    m.crm,
    m.cpf AS cpf_medico,
    m.posicao,
    m.em_atividade,

    -- ESPECIALIDADE DO MÉDICO
    esp.nome AS especialidade_medico,

    -- QUARTO
    q.numeracao AS numero_quarto,

    -- TIPO DE QUARTO
    tq.descricao AS tipo_quarto,
    tq.valor_diario,

    -- ENFERMEIRO
    enf.nome AS nome_enfermeiro,
    enf.cpf AS cpf_enfermeiro,
    enf.coren,

    -- CONSULTA
    cons.id_consulta,
    esp_cons.nome AS especialidade_consulta,
    cons.valor,
    cons.data_hora AS data_consulta,
    cons.numero_carteira,

    -- RECEITA
    r.id_receita,
    r.medicamento,
    r.quantidade,
    r.instrucoes

FROM tbl_internacao i
JOIN tbl_paciente p ON i.fk_paciente = p.id_paciente
LEFT JOIN tbl_endereco e ON p.fk_endereco = e.id_endereco
LEFT JOIN tbl_convenio c ON p.fk_convenio = c.id_convenio
LEFT JOIN tbl_medico m ON i.fk_medico = m.id_medico
LEFT JOIN tbl_medico_especialidade me ON m.id_medico = me.fk_medico
LEFT JOIN tbl_especialidade esp ON me.fk_especialidade = esp.id_especialidade
LEFT JOIN tbl_quarto q ON i.fk_quarto = q.id_quarto
LEFT JOIN tbl_tipo_quarto tq ON q.fk_tipo = tq.id_tipo
LEFT JOIN tbl_internacao_enfermeiro ie ON ie.fk_internacao = i.id_internacao
LEFT JOIN tbl_enfermeiro enf ON enf.id_enfermeiro = ie.fk_enfermeiro
LEFT JOIN tbl_consulta cons ON cons.fk_paciente = p.id_paciente AND cons.fk_medico = m.id_medico
LEFT JOIN tbl_especialidade esp_cons ON cons.fk_especialidade = esp_cons.id_especialidade
LEFT JOIN tbl_receita r ON r.fk_consulta = cons.id_consulta AND r.fk_paciente = p.id_paciente AND r.fk_medico = m.id_medico;

SELECT AVG(valor) AS media_2020 
FROM tbl_consulta 
WHERE data_hora >= '2020-01-01' AND data_hora < '2021-01-01';

SELECT AVG(consul.valor) AS media_convenio
FROM tbl_consulta consul
JOIN tbl_paciente pacien ON consul.fk_paciente = pacien.id_paciente
WHERE pacien.fk_convenio IS NOT NULL;

-- Todos os dados das internações que tiveram data de alta maior que a data prevista para a alta

SELECT * FROM tbl_internacao WHERE data_efetiva_alta > previsao_alta;

-- Receituário completo da primeira consulta registrada com receituário associado.

SELECT * FROM tbl_receita recei 
JOIN tbl_consulta consul ON consul.id_consulta = recei.fk_consulta
WHERE recei.id_receita = 1;

-- Todos os dados da consulta de maior valor e também da de menor valor (ambas as consultas não foram realizadas sob convênio).

SELECT * 
FROM tbl_consulta
WHERE valor = (SELECT MAX(valor) FROM tbl_consulta)
   OR valor = (SELECT MIN(valor) FROM tbl_consulta);

-- Todos os dados das internações em seus respectivos quartos, calculando o total da 
-- internação a partir do valor de diária do quarto e o número de dias entre a entrada e a alta.

SELECT 
	consul.valor * TIMESTAMPDIFF(DAY, data_entrada, IFNULL(data_efetiva_alta, NOW())) valor_total, 
    TIMESTAMPDIFF(DAY, data_entrada, IFNULL(data_efetiva_alta, NOW())) quantidade_dias
FROM tbl_internacao inter 
JOIN tbl_paciente pacien ON  inter.fk_paciente = pacien.id_paciente
JOIN tbl_consulta consul ON pacien.fk_convenio = consul.id_consulta;

-- Data, procedimento e número de quarto de internações em quartos do tipo “apartamento”

SELECT 
	inter.data_entrada, 
    inter.descricao_procedimentos, 
    quart.numeracao AS numero_quarto 
FROM tbl_internacao inter
JOIN tbl_quarto quart ON inter.fk_quarto = quart.id_quarto
JOIN tbl_tipo_quarto tip_quart ON quart.fk_tipo = tip_quart.id_tipo
WHERE tip_quart.descricao LIKE "%apartamento%";

-- Nome do paciente, data da consulta e especialidade de todas as consultas em que os pacientes
-- eram menores de 18 anos na data da consulta e cuja especialidade não seja “pediatria”,
-- ordenando por data de realização da consulta.

SELECT 
    pacien.nome, 
    consul.data_hora, 
    esp.nome AS especialidade
FROM tbl_consulta consul
JOIN tbl_paciente pacien ON consul.fk_paciente = pacien.id_paciente
JOIN tbl_especialidade esp ON consul.fk_especialidade = esp.id_especialidade
WHERE 
    TIMESTAMPDIFF(YEAR, pacien.data_nascimento, consul.data_hora) < 18
    AND LOWER(esp.nome) != "pediatria";

-- Nome do paciente, nome do médico, data da internação e procedimentos das internações 
-- realizadas por médicos da especialidade “gastroenterologia”, que tenham acontecido em “enfermaria”.

SELECT 
    pacien.nome, 
    medico.nome, 
    inter.data_entrada, 
    inter.descricao_procedimentos 
FROM tbl_internacao inter
JOIN tbl_paciente pacien ON inter.fk_paciente = pacien.id_paciente
JOIN tbl_medico medico ON inter.fk_medico = medico.id_medico
JOIN tbl_medico_especialidade me ON medico.id_medico = me.fk_medico
JOIN tbl_especialidade esp ON me.fk_especialidade = esp.id_especialidade
JOIN tbl_quarto quart ON inter.fk_quarto = quart.id_quarto
JOIN tbl_tipo_quarto tipo_quarto ON quart.fk_tipo = tipo_quarto.id_tipo
WHERE tipo_quarto.descricao LIKE "%enfermaria%"
  AND LOWER(esp.nome) = "gastroenterologia";

-- Os nomes dos médicos, seus CRMs e a quantidade de consultas que cada um realizou.

SELECT medico.nome, medico.crm, count(*) FROM tbl_medico medico
JOIN tbl_consulta consul ON medico.id_medico = consul.fk_medico
GROUP BY consul.fk_medico;

-- Todos os médicos que tenham "Gabriel" no nome. 

SELECT * FROM tbl_medico WHERE lower(tbl_medico.nome) LIKE "%gabriel%";

-- Os nomes, CREs e número de internações de enfermeiros que participaram de mais de uma internação.

SELECT 
    enfer.nome, 
    enfer.coren, 
    COUNT(*) AS qtd_internacoes
FROM tbl_enfermeiro enfer
JOIN tbl_internacao_enfermeiro ie ON enfer.id_enfermeiro = ie.fk_enfermeiro
GROUP BY enfer.id_enfermeiro
HAVING COUNT(*) > 1;

