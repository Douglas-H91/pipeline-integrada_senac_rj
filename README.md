# 🏨 Auditoria e Análise de Dados: Python e SQL

Este projeto aplica a uma rede hoteleira fictícia (NaraHoteis) o ciclo completo de um pipeline de dados, em duas fases principais: 1) auditoria inicial, limpeza e tratamento; 2) carga em banco relacional e análise de negócio. Desenvolvido como projeto de conclusão de curso do SENAC/RJ (Análise de Dados — Big Data), em setembro de 2026.

## 📋 Índice

- [Contexto](#contexto)
- [Objetivo](#objetivo)
- [Perguntas de negócio respondidas](#perguntas-de-negócio-respondidas)
- [Tecnologias utilizadas](#tecnologias-utilizadas)
- [Pipeline do projeto](#pipeline-do-projeto)
- [Como executar](#como-executar)
- [Principais aprendizados](#principais-aprendizados)
- [Autor](#autor)

## 📍 Contexto

A NaraHoteis é uma rede fictícia de 13 unidades espalhadas por diferentes regiões do Rio de Janeiro (Capital, Costa Verde, Serra e Baixada Fluminense). O projeto parte de seis bases brutas (funcionários, reservas, clientes, unidades, tipos de quarto e canais de venda), com inconsistências propositais de qualidade de dados, e busca responder perguntas de negócio para a diretoria da rede.

## 🎯 Objetivo

- Auditar cada base antes da limpeza, identificando inconsistências (tipos de dado incorretos, nulos, duplicatas, grafias divergentes).
- Realizar tratamento e padronização dos dados, documentando cada decisão tomada.
- Carregar os dados tratados em um banco relacional (MySQL), respeitando a integridade referencial entre tabela fato e dimensões, e realizar consultas via MySQL Workbench.
- Responder, com evidências extraídas dos dados, perguntas de negócio sobre desempenho financeiro e operacional da rede.

## ❓ Perguntas de negócio respondidas

1. Qual o comportamento das diárias praticadas e a distribuição do faturamento entre as unidades?
2. Existem unidades operando além de sua capacidade? Quais os impactos disso para o negócio?
3. Existem unidades com performance de receita discrepante em relação às demais? Como identificar, medir e comprovar isso?
4. Há relação entre o RevPAR das unidades e a avaliação média dos hóspedes?
5. É possível estimar o RevPAR esperado de uma unidade a partir da sua avaliação média?
6. Qual região apresenta maior variabilidade no faturamento? O que isso indica para a gestão comercial?

## 🛠️ Tecnologias utilizadas

- **Python 3.11**
- **pandas** e **numpy** — tratamento e análise de dados
- **matplotlib** — visualização exploratória no notebook
- **MySQL** e **MySQL Workbench** — modelagem relacional, carga dos dados tratados e consultas
- **Jupyter Notebook**

## 🔄 Pipeline do projeto

1. **Leitura das bases** — seis CSVs base + bases complementares, concatenados com `pd.concat`.
2. **Auditoria inicial** — função `relatorio_inicial()` aplicada a cada base (tipos de dado, nulos, duplicatas).
3. **Limpeza e tratamento** — por base, incluindo:
   - Correção de tipos de dado (`salario`, `comissao_pct`, `valor_diaria_base`, datas)
   - Padronização de categorias via `map()` (departamentos, status de reserva, formas de pagamento, categorias de hotel)
   - Resolução de duplicidades (`id_reserva`, `id_cliente`)
   - Correção de correspondência cidade → estado
4. **Auditoria final** — função `relatorio_final()` comparando o estado da base antes e depois do tratamento.
5. **Exportação** — CSVs tratados exportados para carga no MySQL.
6. **Modelagem e carga no banco** — script SQL com `CREATE TABLE`, `DELETE FROM` (respeitando a ordem de integridade referencial) e `LOAD DATA INFILE`.
7. **Análise de negócio** — cálculo de faturamento, RevPAR, taxa de ocupação e detecção de outliers (IQR); avaliação da correlação (Pearson) entre a avaliação média dos hóspedes e dois indicadores de desempenho por unidade: RevPAR e volume de hóspedes excedentes (overbooking).

### ▶️ Como executar

```bash
git clone <link-do-repositorio>
cd projeto-nara-hoteis
pip install -r requirements.txt
jupyter notebook notebooks/auditoria_tratamento.ipynb
```

Para a carga no MySQL, execute o script `Script_e_consulta_Nara_Hoteis_database.sql` após gerar os CSVs tratados (etapa 5 do pipeline).

## 💡 Principais aprendizados

- Leitura crítica dos indicadores: a formação em Ciências Sociais reforçou o cuidado em não confundir correlação com causalidade (caso RevPAR × avaliação) e em interpretar a variabilidade regional de faturamento como possível reflexo de desigualdades territoriais na distribuição da demanda, e não apenas como ruído estatístico.
- Diferença entre inconsistência de formato (ex: separador decimal) e inconsistência de dado real (ex: check-out anterior ao check-in).
- Importância de auditar antes de tratar, sem aplicar conversões que possam mascarar problemas na origem.
- Uso de métricas de negócio do setor hoteleiro (RevPAR, taxa de ocupação) e de estatística descritiva (IQR, coeficiente de variação, correlação de Pearson) aplicadas a um caso real.
- Identificação de correlação muito forte negativa entre volume de hóspedes excedentes (overbooking) e avaliação média dos hóspedes por unidade, com suporte estatístico para uma hipótese operacional levantada a partir da inspeção inicial dos dados.

## 👤 Autor
[Douglas Horvath] — [www.linkedin.com/in/douglas-h91]
