# 🛠️ Bizumática - Developer & Architecture Docs

![Architecture](https://img.shields.io/badge/Architecture-Leaf_Bundles_v6.0-BA1650?logo=hugo&logoColor=white)
![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub_Actions_%26_Cloudflare-2088FF?logo=cloudflare&logoColor=orange)
![Shell Script](https://img.shields.io/badge/Shell_Script-Bash_v6.0_Shielded-4EAA25?logo=gnu-bash&logoColor=white)
![Environment](https://img.shields.io/badge/Python-3.10%2B_Venv-3776AB?logo=python&logoColor=white)

Este documento detalha as especificações de engenharia de software, o pipeline de dados automatizado e as travas de segurança implementadas a partir da **versão 6.0** do ciclo de automação do portal.

---

## 📐 Especificação de Arquitetura de Conteúdo `[v6.0]`

O Bizumática utiliza estritamente o padrão de **Leaf Bundles** do Hugo para garantir o isolamento e a portabilidade de ativos (imagens, diagramas e códigos) de cada artigo.

### Regras de Ouro do Diretório `content/`

1. **Proibição Absoluta de Arquivos Soltos:** Nenhum artigo deve existir como `.md` solto diretamente nas pastas de seções. Cada artigo possui sua própria pasta.
2. **Leaf Bundles Atômicos:** O ponto de entrada de um artigo dentro de sua subpasta é obrigatoriamente chamado `index.md`.
3. **Branch Bundles Puros:** Arquivos `_index.md` pertencem exclusivamente à raiz das seções para fins de listagem nativa de categorias do Hugo. 

```text
content/
├── curadoria/
│   ├── _index.md                    <-- Correto (Branch Bundle)
│   └── steam-deck/
│       ├── index.md                 <-- Correto (Leaf Bundle)
│       └── cover.webp               <-- Ativo isolado
└── _index.md                        <-- Capa do Portal

```

> ⚠️ **TRAVA ANTIFALHA:** É expressamente proibida a criação da estrutura `pasta/_index/index.md`. Esse comportamento legado quebrava o encadeamento de links internos e foi permanentemente mitigado.

---

## 🔄 O Pipeline de CI/CD no Edge `[deploy.yml v6.0]`

O Bizumática opera sob um modelo de **Automação Híbrida de Alta Performance**. O GitHub Actions atua como o motor de compilação e compliance, enquanto a Cloudflare Pages atua como a rede global de distribuição (Edge CDN) via Direct Upload.

### Fluxo de Execução da Esteira Remota

Ao receber um `git push` na branch `main` ou ser disparado manualmente via `workflow_dispatch`, o servidor executa sequencialmente:

1. **📥 Checkout:** Clonagem completa do histórico de commits para alimentar as variáveis temporais do Hugo.
2. **🛠️ Setup Engine Extended:** Instalação travada do Hugo Extended (`v0.161.1`) e inicialização do ambiente Node.js (`v22`).
3. **🏗️ Hugo Compiler:** Compilação com otimização, minificação agressiva e higienização nativa de destinos antigos direcionados para a pasta temporária `./public`.
4. **⚙️ Compliance Check Final:** Validação via scripts de barreira estritos dos ativos `ads.txt` e `robots.txt`. O pipeline aborta imediatamente com código de erro se o arquivo de anúncios do AdSense for perdido.
5. **🔍 Pagefind Indexing:** Injeção automatizada do motor de busca otimizado em WebAssembly baseado na pasta de build atual.
6. **🚀 Direct Upload Serverless (Zero Commit-Back):** O pipeline utiliza a action oficial da Cloudflare para transmitir a pasta `./public` gerada diretamente para mais de 300 data centers globais de forma atômica. **Não há mais poluição de histórico ou commits de bots** na branch `main`, eliminando riscos de loops de execução e mantendo o repositório 100% limpo.

---

## 📋 Requisitos do Ambiente de Desenvolvimento

Para rodar o ecossistema completo de desenvolvimento e geração de dados localmente:

* **Hugo Extended** (`v0.161.1`) para testes locais e paridade estrita com o compilador da nuvem via `hugo server`.
* **Python 3.10+** instalado com ambiente virtual em `./venv` (necessário para scripts auxiliares de automação de busca e tratamento de dados).

### Inicializando Dependências do Python

```bash
python3 -m venv venv
source venv/bin/activate
pip install pandas pyyaml requests

```

---

## 🚨 Troubleshooting Local & Resolução de Conflitos

Como a esteira agora envia os arquivos diretamente para a infraestrutura serverless da Cloudflare sem gerar novos commits de volta para o GitHub, o seu ambiente local tornou-se incrivelmente estável e livre de conflitos de histórico (`diverged branches`).

**Protocolo de Sincronização Homologado:**
Se você realizar testes de build locais e quiser limpar os arquivos temporários gerados pela sua máquina para garantir que eles não entrem no controle de versão por engano, execute:

```bash
# Remove pastas de compilação local e hashes de cache do Hugo
rm -rf public/ resources/_gen/

# Garante paridade limpa antes de iniciar um novo artigo
git pull origin main

```
---

**Versão da Arquitetura Interna:** 6.0 

![Static Badge](https://img.shields.io/badge/pipeline-status-%23FF9F7A?logo=githubactions&logoColor=white) ![Static Badge](https://img.shields.io/badge/serverless-100%25-%23056C5C?logo=serverless&logoColor=white) ![Static Badge](https://img.shields.io/badge/cloud-protected-orange?logo=icloud&logoColor=white)

```
