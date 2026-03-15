# 🚀 Bizumática - Portal de Conteúdo & Curadoria

O **Bizumática** é um ecossistema estático baseado em Hugo, focado em educação tecnológica e curadoria de equipamentos. O projeto utiliza uma arquitetura de **SEO Programático** para gerar páginas de afiliados automaticamente a partir de dados externos.

## 🛠️ Arquitetura do Sistema

### 1. Fluxo de Dados (Data Pipeline)

1. **Fonte:** Google Sheets (camada de gerenciamento de produtos).
2. **Processamento:** `auto-busca.py` (Script Python com `pandas` e `pyyaml`).
3. **Geração:** O script consome o CSV (Nuvem ou Local) e gera arquivos Markdown em `content/equipamentos/`.
4. **Build:** O Hugo processa os arquivos usando o shortcode `{{< compra >}}` e metadados do Front Matter.

### 2. Estrutura de Diretórios Chave

* `archetypes/`: Moldes para `equipamentos.md` e `matematica.md`.
* `content/`: Conteúdo bruto (Equipamentos, Matemática e Posts).
* `layouts/shortcodes/`: Componentes funcionais (`compra.html`, `bizu.html`).
* `static/`: Ativos estáticos e o arquivo `CNAME` para o domínio `bizumatica.com.br`.
* `docs/`: Pasta de saída para o deploy (GitHub Pages).

---

## 🏗️ Operação & Deploy

### Pré-requisitos

* Hugo (versão Extended recomendada)
* Python 3.x + `pandas`, `pyyaml`, `requests`
* Node.js (para o `pagefind`)

### Ciclo de Atualização

Para adicionar produtos ou atualizar o site, basta rodar o script de deploy blindado:

```bash
chmod +x deploy.sh
./deploy.sh "Mensagem do commit"

```

O `deploy.sh` executa automaticamente:

1. Sincronização via `auto-busca.py`.
2. Limpeza de builds antigos.
3. Minificação e Build do Hugo em `/docs`.
4. Indexação de busca via Pagefind.
5. Push para o repositório remoto.

---

## 📊 Estrutura da Planilha (CSV)

Para a automação funcionar, a fonte de dados deve conter as seguintes colunas:
`slug`, `nome`, `preco`, `link_afiliado`, `pros`, `cons`, `review_curto`.

---

## 🎨 Identidade Visual

* **Tema:** Terminal (Retro-hacker).
* **Customizações:** Localizadas em `assets/css/extended.css`.
* **Componente de Conversão:** O card de compra utiliza estética neon com efeito de profundidade para maximizar o CTR (Click-Through Rate).

---

## 📈 Estratégia de Dividendos

O site foi projetado para:

1. **Baixo Custo Fixo:** Hospedagem gratuita no GitHub Pages + DNS Cloudflare.
2. **Alta Performance:** SSG (Static Site Generation) para atingir nota máxima no Google PageSpeed.
3. **Google Ads Ready:** Páginas de destino ultra-específicas geradas programaticamente para reduzir o CPC.

---

**Mantenedor:** Julio Prata
**Versão da Automação:** 2.3

---