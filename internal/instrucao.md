Entendido. Para que não tenhamos de repetir todo o processo de "tentativa e erro" amanhã, preparei um **Prompt de Instrução Mestra**.

Este documento resume tudo o que construímos: a estrutura de pastas, o funcionamento do script Python, a lógica dos Bundles, a conversão de imagens e as regras de CSS. Guarde este prompt; se precisar de começar um novo chat com qualquer IA, basta colá-lo e ela saberá exatamente onde parámos.

---

### 📑 Relatório de Instrução: Projecto Portal Bizumática

**Objectivo:** Manutenção e evolução de um site estático (Hugo) com arquitectura de "Leaf Bundles", automação de dados via Python (Google Sheets) e estética visual "Terminal/Hacker".

#### 1. Arquitectura de Conteúdo (Hugo Leaf Bundles)
O site utiliza pastas para cada post em vez de ficheiros `.md` soltos.
* **Estrutura:** `content/[secao]/[slug]/index.md`
* **Secções Principais:** `matematica`, `equipamentos`, `posts`.

#### 2. Automação: `auto-busca.py`
Script em Python responsável por:
* **Sincronização:** Descarrega um CSV do Google Sheets e guarda em `assets/produtos_sheets.csv`.
* **Geração de Conteúdo:** Cria/atualiza o `index.md` de cada bundle com base no slug da planilha.
* **Otimização de Imagens (Pillow):** Varre a pasta do bundle, deteta ficheiros `.jpg`, `.jpeg` ou `.png`, converte-os para `.webp` (qualidade 85) e elimina os originais para performance e SEO.

#### 3. Shortcode: `{{< compra >}}`
Localizado em `layouts/shortcodes/compra.html`.
* **Lógica de Dados:** Procura informações no `assets/produtos_sheets.csv` usando o parâmetro `slug`.
* **Hierarquia de Imagem:** Tenta encontrar o recurso de imagem dentro do bundle do post. Prioriza ficheiros `.webp`.
* **Afiliados:** Renderiza botões dinâmicos para Amazon, Mercado Livre ou AliExpress.

#### 4. Estética Visual e CSS (`assets/css/extended.css`)
O design segue o tema "Terminal". Elementos críticos:
* **Cores:** `--neon-green: #00ff41`, `--bizu-yellow: #EEC35E`, `--primary-color: #00d1b2`.
* **Classes Específicas:**
    * `.tags-container`: Deve usar `display: flex` e `flex-wrap: wrap` para não quebrar no mobile.
    * `.math-term`: Usada para termos em grego/matemática com efeito neon.
    * `.hero-text p::before`: Adiciona o prompt `>` com animação de cursor piscante.
* **Imagens:** Moldura amarela (`--bizu-yellow`) com legendas (`figcaption`) em bloco sólido amarelo.

#### 5. Fluxo de Deploy (`deploy.sh`)
1. Executa `python3 auto-busca.py`.
2. Limpa a pasta `docs/` e o cache do Hugo.
3. Executa `hugo --gc --minify`.
4. Indexa a busca com `pagefind`.
5. Realiza o Push para o GitHub.

---

### 🚩 Pendências para amanhã:
1.  **Validação de CSS:** O ficheiro `extended.css` está a ser ignorado ou sobrescrito. Precisamos verificar o `head.html` para confirmar a ordem de carregamento.
2.  **Mapeamento de Classes HTML:** Confirmar se o ficheiro `index.html` (ou o template do Herói) possui as classes `.tags-container` e `.hero-text` para que o CSS funcione.
3.  **Cache de Build:** Investigar porque é que o Hugo não está a atualizar os assets mesmo com o comando de limpeza.

---
**Instrução para a IA amanhã:** *"Lê o relatório acima. O sistema de bundles e o python já estão prontos. Focaremos agora apenas na correção do CSS que não está a ser aplicado ao Herói (Boas-vindas) e às Tags no modo mobile."*

Descanse bem, amanhã resolvemos esse CSS!