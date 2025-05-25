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

-- INSERTS PARA tbl_endereco
INSERT INTO tbl_endereco (rua, cep, numero, bairro, municipio, estado) VALUES
('Rua das Flores, 123', '01234567', 123, 'Centro', 'São Paulo', 'SP'),
('Av. Paulista', '01310100', 1000, 'Bela Vista', 'São Paulo', 'SP'),
('Rua Augusta', '01305000', 456, 'Consolação', 'São Paulo', 'SP'),
('Rua Oscar Freire', '01426001', 789, 'Jardins', 'São Paulo', 'SP'),
('Av. Rebouças', '05401000', 2500, 'Pinheiros', 'São Paulo', 'SP'),
('Rua XV de Novembro', '01013001', 300, 'Centro', 'São Paulo', 'SP'),
('Av. Ibirapuera', '04029200', 1500, 'Moema', 'São Paulo', 'SP');

-- INSERTS PARA tbl_tipo_quarto
INSERT INTO tbl_tipo_quarto (descricao, valor_diario) VALUES
('Apartamento Luxo - Quarto individual com banheiro privativo, TV LCD, ar condicionado e frigobar', 450.00),
('Apartamento Standard - Quarto individual com banheiro, TV e ar condicionado', 280.00),
('Enfermaria - Quarto coletivo com 4 leitos, banheiro compartilhado', 120.00),
('UTI - Unidade de Terapia Intensiva com monitoramento 24h', 800.00),
('Semi-intensivo - Quarto com monitoramento intermediário', 350.00),
('Suíte Master - Quarto luxuoso com sala de estar e acompanhante', 650.00),
('Berçário - Quarto especializado para recém-nascidos', 200.00);

-- INSERTS PARA tbl_quarto
INSERT INTO tbl_quarto (numeracao, fk_tipo) VALUES
(101, 1), (102, 1), (103, 2), (104, 2), (105, 2),
(201, 3), (202, 3), (203, 4), (204, 4), (205, 5),
(301, 6), (302, 1), (303, 2), (304, 3), (305, 7);

-- INSERTS PARA tbl_medico
INSERT INTO tbl_medico (nome, data_nascimento, crm, cpf, especialidade, posicao) VALUES
('Dr. João Silva Santos', '1975-03-15', 'CRM123456', '12345678901', 'Cardiologia', 'Médico Titular'),
('Dra. Maria Oliveira Costa', '1980-07-22', 'CRM234567', '23456789012', 'Pediatria', 'Médica Chefe'),
('Dr. Carlos Eduardo Lima', '1972-11-08', 'CRM345678', '34567890123', 'Ortopedia', 'Médico Senior'),
('Dra. Ana Paula Ferreira', '1985-04-30', 'CRM456789', '45678901234', 'Ginecologia', 'Médica Assistente'),
('Dr. Roberto Machado', '1978-09-12', 'CRM567890', '56789012345', 'Neurologia', 'Médico Titular'),
('Dra. Fernanda Rocha', '1983-01-25', 'CRM678901', '67890123456', 'Dermatologia', 'Médica Júnior'),
('Dr. Pedro Henrique Alves', '1976-06-18', 'CRM789012', '78901234567', 'Urologia', 'Médico Senior');

-- INSERTS PARA tbl_convenio
INSERT INTO tbl_convenio (nome, cnpj, tempo_carencia) VALUES
('Unimed São Paulo', '12345678901234', '2024-01-01 00:00:00'),
('Bradesco Saúde', '23456789012345', '2024-02-15 00:00:00'),
('SulAmérica Saúde', '34567890123456', '2024-03-10 00:00:00'),
('Amil Assistência Médica', '45678901234567', '2024-01-20 00:00:00'),
('NotreDame Intermédica', '56789012345678', '2024-04-05 00:00:00'),
('Prevent Senior', '67890123456789', '2024-02-28 00:00:00'),
('Golden Cross', '78901234567890', '2024-03-15 00:00:00');

-- INSERTS PARA tbl_paciente
INSERT INTO tbl_paciente (nome, data_nascimento, telefone, email, cpf, rg, fk_convenio, fk_endereco) VALUES
('José da Silva Pereira', '1990-05-10', '11987654321', 'jose.pereira@email.com', '11122233344', '123456789', 1, 1),
('Maria Aparecida Santos', '1985-12-25', '11976543210', 'maria.santos@email.com', '22233344455', '234567890', 2, 2),
('Carlos Roberto Oliveira', '1978-08-15', '11965432109', 'carlos.oliveira@email.com', '33344455566', '345678901', 3, 3),
('Ana Beatriz Costa', '1992-03-20', '11954321098', 'ana.costa@email.com', '44455566677', '456789012', 1, 4),
('Fernando Augusto Lima', '1980-11-02', '11943210987', 'fernando.lima@email.com', '55566677788', '567890123', 4, 5),
('Juliana Fernandes Rocha', '1995-07-18', '11932109876', 'juliana.rocha@email.com', '66677788899', '678901234', 2, 6),
('Roberto Carlos Silva', '1973-04-12', '11921098765', 'roberto.silva@email.com', '77788899900', '789012345', 5, 7);

-- INSERTS PARA tbl_internacao
INSERT INTO tbl_internacao (data_entrada, previsao_alta, data_efetiva_alta, descricao_procedimentos, fk_paciente, fk_medico, fk_quarto) VALUES
('2024-11-01 08:30:00', '2024-11-05 10:00:00', NULL, 'Cirurgia cardíaca - Angioplastia coronariana com implante de stent', 1, 1, 1),
('2024-11-02 14:15:00', '2024-11-04 09:00:00', '2024-11-04 11:30:00', 'Apendicectomia laparoscópica - procedimento minimamente invasivo', 2, 3, 3),
('2024-11-03 20:45:00', '2024-11-10 12:00:00', NULL, 'Tratamento de pneumonia bacteriana - antibioticoterapia endovenosa', 3, 2, 6),
('2024-10-28 16:20:00', '2024-11-02 08:00:00', '2024-11-01 15:45:00', 'Parto cesáreo eletivo - nascimento sem complicações', 4, 4, 7),
('2024-11-04 07:10:00', '2024-11-12 14:00:00', NULL, 'Tratamento de AVC isquêmico - terapia trombolítica e reabilitação', 5, 5, 4),
('2024-10-30 11:25:00', '2024-11-03 16:00:00', '2024-11-03 14:20:00', 'Cirurgia ortopédica - redução de fratura de fêmur com fixação interna', 6, 3, 2),
('2024-11-05 13:40:00', '2024-11-08 10:00:00', NULL, 'Ressecção de tumor de bexiga - procedimento endoscópico', 7, 7, 5);

-- INSERTS PARA tbl_enfermeiro
INSERT INTO tbl_enfermeiro (nome, cpf, coren, fk_internacao) VALUES
('Enfermeira Carla Mendes', '12312312312', 'COREN123456', 1),
('Enfermeiro Paulo Roberto', '23423423423', 'COREN234567', 1),
('Enfermeira Sandra Lima', '34534534534', 'COREN345678', 2),
('Enfermeiro Marcos Silva', '45645645645', 'COREN456789', 3),
('Enfermeira Luciana Costa', '56756756756', 'COREN567890', 3),
('Enfermeira Patrícia Alves', '67867867867', 'COREN678901', 4),
('Enfermeiro Ricardo Santos', '78978978978', 'COREN789012', 5),
('Enfermeira Débora Ferreira', '89089089089', 'COREN890123', 6),
('Enfermeiro João Carlos', '90190190190', 'COREN901234', 7);

-- INSERTS PARA tbl_consulta
INSERT INTO tbl_consulta (especialidade, valor, data_hora, numero_carteira, fk_paciente, fk_medico) VALUES
('Cardiologia', 350.00, '2024-10-25 09:00:00', 1001, 1, 1),
('Pediatria', 280.00, '2024-10-26 14:30:00', 2002, 2, 2),
('Ortopedia', 320.00, '2024-10-27 10:15:00', 3003, 3, 3),
('Ginecologia', 300.00, '2024-10-28 11:45:00', 4004, 4, 4),
('Neurologia', 400.00, '2024-10-29 08:30:00', 5005, 5, 5),
('Dermatologia', 250.00, '2024-10-30 15:20:00', 6006, 6, 6),
('Urologia', 380.00, '2024-10-31 16:00:00', 7007, 7, 7),
('Cardiologia', 350.00, '2024-11-01 07:45:00', 2002, 2, 1),
('Ortopedia', 320.00, '2024-11-02 13:15:00', 1001, 1, 3);

-- INSERTS PARA tbl_receita
INSERT INTO tbl_receita (medicamento, quantidade, instrucoes, fk_paciente, fk_consulta, fk_medico) VALUES
('Atenolol 50mg', '30 comprimidos', 'Tomar 1 comprimido pela manhã, em jejum. Não interromper o uso sem orientação médica.', 1, 1, 1),
('Amoxicilina 500mg', '21 cápsulas', 'Tomar 1 cápsula de 8 em 8 horas por 7 dias. Completar todo o tratamento mesmo se os sintomas melhorarem.', 2, 2, 2),
('Ibuprofeno 600mg', '20 comprimidos', 'Tomar 1 comprimido de 8 em 8 horas após as refeições. Usar apenas se houver dor ou inflamação.', 3, 3, 3),
('Ácido Fólico 5mg', '30 comprimidos', 'Tomar 1 comprimido pela manhã durante toda a gestação. Importante para formação do bebê.', 4, 4, 4),
('Aspirina 100mg', '30 comprimidos', 'Tomar 1 comprimido à noite após o jantar. Medicação de uso contínuo para prevenção.', 5, 5, 5),
('Hidrocortisona creme 1%', '1 tubo de 30g', 'Aplicar fina camada na região afetada 2 vezes ao dia por até 7 dias. Não usar no rosto.', 6, 6, 6),
('Finasterida 5mg', '30 comprimidos', 'Tomar 1 comprimido ao dia, sempre no mesmo horário. Efeitos aparecem após 3-6 meses de uso.', 7, 7, 7),
('Sinvastatina 40mg', '30 comprimidos', 'Tomar 1 comprimido à noite após o jantar. Realizar exames de controle a cada 3 meses.', 1, 8, 1),
('Dipirona 500mg', '10 comprimidos', 'Tomar 1 comprimido de 6 em 6 horas se houver dor ou febre. Máximo 4 comprimidos por dia.', 2, 9, 3);

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
    m.especialidade,
    m.posicao,
    m.em_atividade,

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
    cons.especialidade AS especialidade_consulta,
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
LEFT JOIN tbl_quarto q ON i.fk_quarto = q.id_quarto
LEFT JOIN tbl_tipo_quarto tq ON q.fk_tipo = tq.id_tipo
LEFT JOIN tbl_enfermeiro enf ON enf.fk_internacao = i.id_internacao
LEFT JOIN tbl_consulta cons ON cons.fk_paciente = p.id_paciente AND cons.fk_medico = m.id_medico
LEFT JOIN tbl_receita r ON r.fk_consulta = cons.id_consulta AND r.fk_paciente = p.id_paciente AND r.fk_medico = m.id_medico;

SELECT avg(valor) FROM tbl_consulta WHERE data_hora >= "2020-01-01 00:00:00";

SELECT 
        pacien.nome,
        pacien.cpf,
        
        conven.nome nome_convenio,
        conven.cnpj,
        
        consul.valor,
        consul.data_hora
FROM tbl_consulta consul 
JOIN tbl_paciente pacien ON consul.fk_paciente = pacien.id_paciente 
JOIN tbl_convenio conven ON conven.id_convenio = pacien.fk_convenio;

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

SELECT pacien.nome, consul.data_hora, consul.especialidade FROM tbl_consulta consul
JOIN tbl_paciente pacien ON consul.fk_paciente = pacien.id_paciente 
WHERE TIMESTAMPDIFF(YEAR, pacien.data_nascimento, consul.data_hora) < 18 AND consul.especialidade != "pediatria";

-- Nome do paciente, nome do médico, data da internação e procedimentos das internações 
-- realizadas por médicos da especialidade “gastroenterologia”, que tenham acontecido em “enfermaria”.

SELECT pacien.nome, medico.nome, inter.data_entrada, inter.descricao_procedimentos FROM tbl_internacao inter
JOIN tbl_paciente pacien ON inter.fk_paciente = pacien.id_paciente
JOIN tbl_medico medico ON inter.fk_medico = medico.id_medico
JOIN tbl_quarto quart ON inter.fk_quarto = quart.id_quarto
JOIN tbl_tipo_quarto tipo_quarto ON quart.fk_tipo = tipo_quarto.id_tipo
WHERE tipo_quarto.descricao LIKE "%enfermaria%" AND medico.especialidade = "Cardiologia";

-- Os nomes dos médicos, seus CRMs e a quantidade de consultas que cada um realizou.

SELECT medico.nome, medico.crm, count(*) FROM tbl_medico medico
JOIN tbl_consulta consul ON medico.id_medico = consul.fk_medico
GROUP BY consul.fk_medico;

-- Todos os médicos que tenham "Gabriel" no nome. 

SELECT * FROM tbl_medico WHERE lower(tbl_medico.nome) LIKE "%gabriel%";

-- Os nomes, CREs e número de internações de enfermeiros que participaram de mais de uma internação.

SELECT enfer.nome, enfer.coren, count(*) FROM tbl_enfermeiro enfer
JOIN tbl_internacao inter ON enfer.fk_internacao = inter.id_internacao
GROUP BY enfer.id_enfermeiro
HAVING COUNT(*) > 1;

