---
title: "SOP-01: Framework de Engenharia e Publicação Bizumática"
author: "Julio Prata"
version: "3.3.1 (Full Automation)"
last_mod: 2026-03-26
status: "OPERACIONAL / CRÍTICO"
description: "Documentação técnica de arquitetura, pipeline de dados Sheets-to-Hugo e padronização de ativos."
# Configurações de Documentação Interna (Draft impede publicação no feed público)
draft: true
type: "docs"
toc: true
---

# 📖 SOP-01: Framework de Engenharia e Publicação (v3.3)

Este documento rege a arquitetura técnica do portal Bizumática. Ele serve como o "Manual de Voo" para garantir a integridade do sistema de automação, a otimização de performance (Lighthouse 100) e a consistência da interface de terminal.

---

## 1. Arquitetura de Dados e "Single Source of Truth"

O projeto opera sob o princípio de **Dados Desacoplados**. O Google Sheets funciona como o Banco de Dados (DB), enquanto o Hugo funciona apenas como a camada de apresentação.

### 1.1. Categorias de Conteúdo
* **Manual (Matemática/Blog):** Arquivos criados via CLI `hugo new`. O controle de metadados é local no arquivo `.md`.
* **Automatizado (Equipamentos/Produtos):** Geridos exclusivamente pelo script `auto-busca.py`. 
    * **⚠️ PROIBIÇÃO:** Alterações manuais em `content/equipamentos/*/index.md` serão sobrescritas no próximo deploy. A edição deve ocorrer na Planilha Mestra.

### 1.2. Page Bundles (Obrigatoriedade)
Todo novo post **DEVE** ser uma pasta contendo um arquivo `index.md`. Arquivos soltos na raiz de `/content` quebram a lógica de processamento de imagens do Hugo (`.Page.Resources`).

---

## 2. Pipeline de Automação (Sheets -> Python)

O script `scripts/auto-busca.py` é o motor de sincronização. Ele realiza as seguintes operações críticas de ETL (Extract, Transform, Load):

### 2.1. Tratamento de Strings e Preços
O script limpa a formatação brasileira (PT-BR) para garantir que o Hugo receba floats válidos:
* **Input:** `1.250,90` (String na Sheet)
* **Processamento:** `replace('.', '').replace(',', '.')`
* **Output:** `1250.90` (Float no YAML)

### 2.2. Lógica de Pros e Cons
O script aceita o prefixo `PROS:` ou `CONS:` (comum em saídas de IA) e o remove via regex/replace, garantindo que o array no Frontmatter contenha apenas os itens limpos e capitalizados.

---

## 3. Gestão de Ativos e Imagens (WebP Engine)

O portal utiliza o formato **Next-Gen WebP** com processamento automatizado para garantir carregamento sub-1s.

### 3.1. Imagens de Produtos (Automático)
1.  O script baixa a imagem do link fornecido na coluna `foto`.
2.  Renomeia para `prod-[slug].webp`.
3.  Converte para WebP (Quality 80) e redimensiona via Pillow.
4.  **Fallback:** Se o link na sheet falhar, o script mantém a imagem existente na pasta para evitar links quebrados (404).

### 3.2. Imagens Manuais (Manual)
Ao adicionar diagramas ou fotos em posts de matemática:
* Salve o arquivo bruto (`.png` ou `.jpg`) na pasta do post.
* O Shortcode `{{< compra >}}` ou o Hugo Image Processing cuidará da conversão em tempo de build.

---

## 4. Shortcodes: Especificações Técnicas

### 4.1. `{{< compra >}}` - Card de Engenharia
Este é o componente mais complexo do sistema. Ele possui lógica condicional:
* **Atributo `img`:** Se definido, busca o arquivo exato. Se omitido, utiliza o primeiro `.webp` encontrado no Bundle.
* **Atributo `price`:** Se o preço for `0` ou `null`, exibe o status "Consultar".
* **Máscara BRL:** Utiliza `lang.FormatNumberCustom 2 $price "- . ,"` para renderizar `1250.90` como `R$ 1.250,90`.

### 4.2. `{{< box >}}` - Containers de Metadados
Utilizado para destacar conceitos semânticos.
* **`tipo="bizu"`:** Borda amarela, ícone de lâmpada simulado via terminal.
* **`tipo="teorema"`:** Fundo escuro, borda cyan, focado em fórmulas LaTeX.
* **`tipo="warning"`:** Borda vermelha, focado em limitações de hardware.

---

## 5. Protocolo de Deploy (Lifecycle v3.3)

O comando `./scripts/deploy.sh` dispara uma sequência de eventos que deve ser monitorada via log:

1.  **Sincronização Cloud:** O Python valida o CSV e reconstrói os Bundles de equipamentos.
2.  **Limpeza de Cache (Faxina):** * Remove `static/css/extended.css` (redundante).
    * Remove imagens temporárias `featured_raw`.
    * Limpa `resources/_gen` para forçar a regeneração de thumbnails.
3.  **Build Hugo:** O binário gera os arquivos estáticos em `/docs` com minificação ativa (`--minify`).
4.  **Indexação Pagefind:** Varre a pasta `/docs` e gera o índice de busca `pagefind.js`.
5.  **Git Sync:** Realiza o Atomic Commit e Push para a Main.

---

## 6. Troubleshooting e Manutenção

### 6.1. Erros Comuns no Deploy
* **`ValueError: could not convert string`**: Caractere inválido na coluna de preço da Sheet.
* **`SyntaxError: '{' was never closed`**: Erro de indentação no `auto-busca.py` ao manipular o dicionário `front_matter`.
* **Imagens não aparecem:** Verifique se o arquivo está na pasta correta e se a extensão é `.webp`.

### 6.2. Comandos de Verificação
* **Testar Sincronização:** `python3 scripts/auto-busca.py` (antes de subir pro Git).
* **Testar Site Local:** `hugo server -D` (para ver rascunhos).
* **Verificar Busca:** Abrir `localhost:1313` e testar a barra de busca após o build local.

---

## 7. Melhores Práticas de SEO e Afiliados
* **Links de Afiliados:** Sempre utilize o parâmetro `rel="sponsored nofollow"` (já automatizado no shortcode).
* **Slugs:** Devem ser curtos, sem acentos e separados por hífens (ex: `calculadora-hp-50g`).
* **Transparência:** O shortcode `{{< links >}}` deve preceder qualquer lista de produtos para cumprir normas de publicidade.

---
**FIM DA DOCUMENTAÇÃO - OPERE COM CAUTELA.**