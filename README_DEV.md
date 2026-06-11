# 🛠️ Bizumática - Developer & Architecture Docs

![Architecture](https://img.shields.io/badge/Architecture-Leaf_Bundles_v4.3-BA1650?logo=hugo&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?logo=githubactions&logoColor=white)
![Shell Script](https://img.shields.io/badge/Shell_Script-Bash_v4.3_Shielded-4EAA25?logo=gnu-bash&logoColor=white)
![Environment](https://img.shields.io/badge/Python-3.10%2B_Venv-3776AB?logo=python&logoColor=white)

Este documento detalha as especificações de engenharia de software, o pipeline de dados automatizado e as travas de segurança implementadas a partir da **versão 4.3** do ciclo de automação do portal.

---

## 📐 Especificação de Arquitetura de Conteúdo `[v4.3]`

O Bizumática utiliza estritamente o padrão de **Leaf Bundles** do Hugo para garantir o isolamento e a portabilidade de ativos (imagens, diagramas e códigos) de cada artigo.

### Regras de Ouro do Diretório `content/`

1.  **Proibição Absoluta de Arquivos Soltos:** Nenhum artigo deve existir como `.md` solto diretamente nas pastas de seções. Cada artigo possui sua própria pasta.
2.  **Leaf Bundles Atômicos:** O ponto de entrada de um artigo dentro de sua subpasta é obrigatoriamente chamado `index.md`.
3.  **Branch Bundles Puros:** Arquivos `_index.md` pertencem exclusivamente à raiz das seções para fins de listagem nativa de categorias do Hugo. 

```text
content/
├── curadoria/
│   ├── _index.md                    <-- Correto (Branch Bundle)
│   └── steam-deck/
│       ├── index.md                 <-- Correto (Leaf Bundle)
│       └── cover.webp               <-- Ativo isolado
└── _index.md                        <-- Capa do Portal

```

> ⚠️ **TRAVA ANTIFALHA:** É expressamente proibida a criação da estrutura `pasta/_index/index.md`. Esse comportamento legado quebrava o encadeamento de links internos e foi mitigado na versão 4.3.

---

## 🔄 O Pipeline de CI/CD em Nuvem `[deploy.yml v4.3]`

O Bizumática opera sob um modelo de **Automação Total em Nuvem** via GitHub Actions. O desenvolvedor local foca exclusivamente na escrita do conteúdo, enquanto a infraestrutura do GitHub gerencia a integridade, compilação e publicação.

### Fluxo de Execução da Esteira Remota

Ao receber um `git push` na branch `main` ou atingir o gatilho do `cron` diário (06:00 UTC), o servidor executa sequencialmente:

1. **📥 Checkout:** Clonagem completa do histórico de commits para alimentar as variáveis temporais do Hugo.
2. **🥋 Higienização Automática (v4.3):** Aplica a trava de busca dupla via `find` para ignorar `index.md` e `_index.md`, movendo apenas arquivos novos/soltos para suas respectivas subpastas em formato Leaf Bundle.
3. **🛠️ Setup Engine:** Instalação sob demanda do Hugo Extended e Node.js (v20).
4. **🏗️ Hugo Build:** Compilação com otimização, minificação agressiva e limpeza de destinos antigos diretamente na pasta `/docs`.
5. **⚙️ SEO Compliance:** Validação via scripts de barreira dos ativos `ads.txt` e `robots.txt` antes de prosseguir.
6. **🔍 Pagefind Indexing:** Geração automatizada do índice em WebAssembly para busca interna.
7. **🚀 Git Commit Back:** O `GitHub Action Bot` consolida os arquivos gerados pela máquina e faz o push de volta para a branch remota utilizando a flag `[skip ci]` para prevenir loops de execução.

---

## 📋 Requisitos do Ambiente de Desenvolvimento

Para rodar o ecossistema completo de desenvolvimento e geração de dados localmente:

* **Hugo Extended** (`>= 0.140.0`) para testes locais em `hugo server`.
* **Python 3.10+** instalado com ambiente virtual em `./venv` (necessário apenas para a operação do script `auto-busca.py` e rotinas de ingestão de tabelas).

### Inicializando Dependências do Python

```bash
python3 -m venv venv
source venv/bin/activate
pip install pandas pyyaml requests

```

---

## 🚨 Troubleshooting Local & Resolução de Conflitos

Como a esteira em nuvem reconstrói a pasta `/docs` e o índice do Pagefind a cada execução, podem ocorrer pequenos descompassos de histórico local caso o seu repositório local fique desatualizado.

**Protocolo de Sincronização Homologado:**
Antes de iniciar um novo lote de postagens, garanta que sua máquina está espelhando a nuvem executando:

```bash
# Limpa rastros locais gerados por builds antigos
rm -rf docs/ resources/_gen/

# Traz as atualizações higienizadas que a GitHub Action consolidou
git pull origin main --rebase

```

---

**Versão da Arquitetura Interna:** 4.3

![Static Badge](https://img.shields.io/badge/pipeline-status-%23FF9F7A?logo=githubactions&logoColor=white) ![Static Badge](https://img.shields.io/badge/serverless-100%25-%23056C5C?logo=serverless&logoColor=white) ![Static Badge](https://img.shields.io/badge/cloud-protected-orange?logo=icloud&logoColor=white)