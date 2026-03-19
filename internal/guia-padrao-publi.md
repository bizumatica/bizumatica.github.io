---
title: "SOP-01: Fluxo de Publicação e Curadoria Bizumática"
author: "Julio"
version: "1.0"
last_mod: 2026-03-19
status: "Ativo"
description: "Guia técnico para padronização de Page Bundles, Imagens WebP e Shortcodes."

# Campos para controle do Hugo (se ficar em content)
draft: true
type: "docs"
toc: true
---

# 📖 Guia de Publicação: Padrão Bizumática (Hugo 2026)

Este guia define como criar posts organizados, com imagens otimizadas e monetização integrada em qualquer uma das três seções (**Matemática, Equipamentos, Posts**).

## 1. Estrutura de Pasta (Page Bundles)
Em vez de arquivos `.md` soltos, cada post agora é uma **pasta**. Isso mantém as imagens grudadas ao texto.

**Como criar:**
No terminal, na raiz do projeto:
```bash
hugo new posts/nome-do-post/index.md
# ou para matemática
hugo new matematica/teorema-xyz/index.md
```

**Organização dos arquivos:**
```text
content/posts/meu-post-exemplo/
├── index.md           <-- O texto do seu post
├── capa.webp          <-- Imagem do produto principal
└── detalhe.webp       <-- Outra imagem de curadoria
```

---

## 2. O Frontmatter (O Cabeçalho)
Use o arquétipo atualizado para garantir que o Shortcode `compra` funcione mesmo sem parâmetros extras.

```yaml
---
title: "Título do Post"
date: 2026-03-19T10:00:00-03:00
product:
  name: "Produto Padrão"
  current_price: 450.0
  currency: "BRL"
  thumbnail: "capa.webp" # Apenas o nome do arquivo na pasta
  pros: ["Pró 1", "Pró 2"]
  cons: ["Contra 1"]
affiliate:
  - store: "Amazon"
    link: "https://amzn.to/..."
---
```

---

## 3. Uso dos Shortcodes no Markdown

### A. O Box de Conteúdo (`box.html`)
Use para destacar Bizus, Teoremas ou Avisos.
```markdown
{{< box tipo="bizu" titulo="DICA DE SHELL" >}}
Use `rsync` em vez de `cp` para backups grandes.
{{< /box >}}

{{< box tipo="teorema" >}}
A² + B² = C²
{{< /box >}}
```

### B. Transparência de Afiliados (`links.html`)
Chame sempre antes de listar os produtos para gerar confiança no leitor.
```markdown
## Onde adquirir
{{< links />}} 
```
*Dica: Você pode colocar texto dentro: `{{< links >}}Apoie o site comprando aqui:{{< /links >}}`.*

### C. O Card de Venda (`compra.html`)
O novo shortcode é inteligente: ele busca a imagem na pasta do post automaticamente.

* **Modo Automático:** Puxa tudo do Frontmatter.
    `{{< compra />}}`
* **Modo Manual (Curadoria de múltiplos itens):**
    `{{< compra name="Samsung T7" price="800" img="ssd-samsung" link="URL_HOTMART" >}}`

---

## 4. Fluxo de Trabalho (Workflow)

1.  **Crie a pasta** do post e o arquivo `index.md`.
2.  **Cole as imagens** (`.jpg` ou `.png`) dentro da pasta do post.
3.  **Rode o script de otimização**:
    ```bash
    ./optimize-images.sh
    ```
    *(Isso transformará tudo em `.webp` e economizará espaço).*
4.  **Escreva o conteúdo** usando os shortcodes acima.
5.  **Teste localmente** com `hugo server` e publique.

---