# 🏥 Hospital Fundamental

## 📖 Uma história para começar

O **Hospital Fundamental** é um pequeno hospital local que busca evoluir tecnologicamente, desenvolvendo um novo sistema que atenda melhor às suas necessidades operacionais e clínicas. Atualmente, muitos processos ainda são feitos com o auxílio de planilhas e arquivos físicos, mas a expectativa é de que esses dados sejam totalmente migrados para o novo sistema assim que ele estiver funcional.

## 🎯 Objetivo

O principal objetivo deste projeto é analisar as necessidades clínicas do hospital e propor uma estrutura de banco de dados adequada, representada por um **Diagrama Entidade-Relacionamento (DER)**.

---
## ⚡ Parte 1

### 👩‍⚕️ Médicos

- Tipos: generalistas, especialistas ou residentes.
- Um médico pode ter **uma ou mais especialidades**:
  - Pediatria
  - Clínica Geral
  - Gastroenterologia
  - Dermatologia

### 🧑‍🦱 Pacientes

- Dados pessoais:
  - Nome
  - Data de nascimento
  - Endereço
  - Telefone
  - E-mail
  - CPF
  - RG

- Convênio:
  - Nome do convênio
  - CNPJ
  - Tempo de carência

### 🗓️ Consultas

- Registradas com:
  - Data e hora
  - Médico responsável
  - Paciente atendido
  - Valor da consulta ou nome do convênio utilizado
  - Número da carteirinha do convênio (se houver)
  - Especialidade buscada pelo paciente

### 💊 Receitas Médicas

- Emitidas ao final da consulta.
- Devem conter:
  - Medicamentos receitados
  - Quantidade
  - Instruções de uso

![Diagrama ER](derHospitalParte1.png)

---

