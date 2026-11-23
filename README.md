# Técnicas Computacionais de Análise de Eletroencefalograma (EEG) para a Classificação de Idosos em Diferentes Estágios da Doença de Alzheimer

Projeto desenvolvido para a disciplina **Ferramentas Computacionais de Modelagem** do Programa de Pós-Graduação em Biometria da **Universidade Estadual Paulista (UNESP) – Botucatu (2026)**.

## 👥 Integrantes do Grupo
* Felipe Melo Silva
* Lucas Nobre Fiori
* Marceline Esperança Gomes
* Sofia Feierabend Munhoz

---

## 📋 Sobre o Projeto
A Doença de Alzheimer (DA) é uma demência neurodegenerativa progressiva cujo diagnóstico precoce — especialmente na fase de transição conhecida como **Declínio Cognitivo Leve (DCL)** — é fundamental para retardar a evolução dos sintomas. 

Este projeto utiliza sinais de eletroencefalograma (EEG) e técnicas de análise de séries temporais aliadas a aprendizado de máquina para:
1. Distinguir o envelhecimento sadio (grupo controle) do Declínio Cognitivo Leve (DCL);
2. Classificar os estágios da Doença de Alzheimer (DA);
3. Identificar as regiões cerebrais mais sensíveis e afetadas pela doença;
4. Comparar o desempenho do método de **Grafos de Quantis (GQ)** frente a técnicas clássicas da literatura (**Dimensão Fractal**, **Entropia Quadrática** e **Análise Espectral de Wavelet**).

---

## 🧠 Conjunto de Dados
Os dados referem-se a registros de EEG de **105 pacientes**, diagnosticados e classificados segundo o DSM-5:
* **Controle (Envelhecimento sadio):** 20 pacientes
* **Declínio Cognitivo Leve (DCL):** 37 pacientes
* **Doença de Alzheimer (DA):** 48 pacientes

**Especificações técnicas dos sinais:**
* **Aquisição:** 19 eletrodos posicionados no escalpo conforme o sistema internacional 10-20 (`Fp1`, `Fp2`, `F7`, `F3`, `Fz`, `F4`, `F8`, `T3`, `C3`, `Cz`, `C4`, `T4`, `T5`, `P3`, `Pz`, `P4`, `T6`, `O1`, `O2`);
* **Frequência de amostragem:** 256 Hz;
* **Recorte utilizado:** Segmento central de 46.000 pontos (aproximadamente 3 minutos de registro) por eletrodo, totalizando **1.995 arquivos individuais** ($105 \times 19$).

---

## 🛠️ Tecnologias e Decisões de Arquitetura

* **Linguagens de Programação (Python e MATLAB):** Escolhidas por preferência e domínio técnico dos integrantes do grupo.
  * **Python:** Utilizado no pré-processamento dos sinais, decomposição em bandas de frequência (`PyWavelets`), construção das redes de quantis (`NetworkX`), extração de métricas e classificação via Máquina de Vetores de Suporte (`scikit-learn`).
  * **MATLAB:** Utilizado para geração de gráficos comparativos e desenvolvimento da interface gráfica (`uifigure`) para visualização interativa dos resultados.
* **Armazenamento de Dados (`.txt` e `.csv`):** Inicialmente, o grupo cogitou utilizar banco de dados **SQL** integrado ao Python para registrar e gerenciar os sinais. Contudo, optou-se por manter os dados estruturados em arquivos **`.txt`** (com exportação complementar dos caracterizadores em **`.csv`**), devido à familiaridade da equipe com o formato e à praticidade de leitura direta tanto nos scripts em Python quanto na interface em MATLAB.
* **Versionamento:** Controle de versão realizado com **Git** (via Git Bash) e hospedagem no GitHub.

---

## ⚙️ Metodologia

1. **Pré-processamento (`.txt`):** Leitura dos arquivos brutos, remoção de valores ausentes, recorte central de 46.000 pontos e separação de um arquivo `.txt` por paciente e eletrodo.
2. **Decomposição em Ondas:** Aplicação da transformada de wavelet (onda-mãe *Coiflets 1*) para separar cada sinal original nas bandas **Alfa, Beta, Teta e Delta**.
3. **Extração de Características:**
   * **Grafos de Quantis (GQ):** Mapeamento das séries temporais em redes ($k = 1 \dots 150$) e extração de 5 medidas topológicas, com destaque para o **Coeficiente de Agrupamento ($C$)**.
   * **Dimensão Fractal ($\mathcal{F}$):** Calculada via algoritmo de Katz.
   * **Entropia Quadrática ($Q$):** Avaliação da previsibilidade e repetitividade do sinal.
4. **Classificação:** Treinamento e teste de uma Máquina de Vetores de Suporte (**SVM**) utilizando validação cruzada estratificada de 5 partições (*5-fold cross-validation*).

---

## 📊 Principais Resultados

A maior acurácia global foi obtida pelo **Coeficiente de Agrupamento ($C$) dos Grafos de Quantis** no sinal original, destacando a **região frontal do hemisfério direito** (`Fp2` e `F8`) como a mais sensível na discriminação dos grupos:

| Técnica | Banda / Sinal | Eletrodo | Acurácia Máxima |
| :--- | :---: | :---: | :---: |
| **GQ – Coef. de Agrupamento ($C$)** | Sinal original | **F8** | **0,7619 (76,19%)** |
| **Entropia Quadrática ($Q$)** | Sinal original | **T4** | **0,5333 (53,33%)** |
| **Dimensão Fractal ($\mathcal{F}$)** | Alfa | **T5** | **0,4762 (47,62%)** |

---

## 📂 Estrutura do Repositório

* `Codigos_em_python_FCM.ipynb`: Notebook contendo o pipeline de leitura e limpeza dos arquivos `.txt`, decomposição por wavelets, cálculo dos Grafos de Quantis, Dimensão Fractal, Entropia Quadrática e classificação com SVM.
* `InterfaceAlzheimerApp.m`: Aplicação desenvolvida em MATLAB (`uifigure`) que permite carregar arquivos `.txt` e `.csv`, visualizar segmentos de sinais e bandas de frequência, e comparar as acurácias obtidas pelas três técnicas.
* `README.md`: Documentação geral do projeto.
