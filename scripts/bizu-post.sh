#!/bin/bash

# --- CONFIGURAÇÕES DE CAMINHO ---
SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd)"
BASE_DIR="$SCRIPT_PATH/.."
TARGET_DIR="$BASE_DIR/content/produtos_sheets"

mkdir -p "$TARGET_DIR"

echo "--- 📊 GERADOR DE PRODUTO (DATA-DRIVEN) ---"

# 1. Coleta de dados baseada nas suas colunas
read -p "Slug (ex: mouse-logitech-g502): " SLUG
read -p "Nome do Produto: " NOME
read -p "Preço (ex: 299,00): " PRECO
read -p "Link Afiliado (Principal): " LINK_AFI
read -p "Link Mercado Livre: " LINK_ML
read -p "Prós (separe por vírgula): " PROS
read -p "Contras (separe por vírgula): " CONS
read -p "Review Curto: " REVIEW
read -p "Nome do arquivo da foto (ex: g502.png): " FOTO
read -p "Categoria Bizu: " CATEGORIA

FILE_PATH="$TARGET_DIR/$SLUG.md"
DATE=$(date +"%Y-%m-%dT%H:%M:%S-03:00")

# 2. Gerar o Markdown com os parâmetros para o Shortcode
cat <<EOF > "$FILE_PATH"
---
title: "$NOME"
date: $DATE
slug: "$SLUG"
nome: "$NOME"
preco: "$PRECO"
link_afiliado: "$LINK_AFI"
link_ml: "$LINK_ML"
pros: "$PROS"
cons: "$CONS"
review_curto: "$REVIEW"
foto_local: "/$FOTO"
categoria_bizu: "$CATEGORIA"
layout: "sheet"
---

{{< render-produto slug="$SLUG" >}}

---
## Notas Adicionais da Curadoria
*Este espaço é opcional para observações extras que não cabem na tabela.*

{{< apoie >}}
EOF

echo "--------------------------------------"
echo "✅ SUCESSO: Arquivo gerado para o Shortcode em $FILE_PATH"