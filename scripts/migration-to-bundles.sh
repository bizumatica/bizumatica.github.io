#!/bin/bash
# Author: Julio Prata
# Version: 1.0

# Configurações de alvos
CONTENT_DIRS=("content/posts" "content/matematica" "content/equipamentos" "content/shell-scripting")

echo "🧪 Iniciando auditoria e migração para Leaf Bundles..."

for DIR in "${CONTENT_DIRS[@]}"; do
    if [ ! -d "$DIR" ]; then
        echo "⚠️  Diretório $DIR não encontrado. Pulando..."
        continue
    fi

    echo "📂 Processando seção: $DIR"

    # Busca arquivos .md que NÃO sejam index.md nem _index.md
    # O -maxdepth 1 garante que não tentaremos re-processar o que já é bundle
    find "$DIR" -maxdepth 1 -name "*.md" ! -name "index.md" ! -name "_index.md" -type f | while read -r FILE; do
        
        # Extrai o nome base sem extensão (o slug)
        FILENAME=$(basename "$FILE" .md)
        DIRNAME=$(dirname "$FILE")
        TARGET_DIR="$DIRNAME/$FILENAME"

        echo "📦 Convertendo: $FILENAME"

        # 1. Cria o diretório do bundle
        mkdir -p "$TARGET_DIR"

        # 2. Move via GIT para preservar o histórico (SEO de código)
        # Se o arquivo não estiver no git, faz o mv normal
        if git ls-files --error-unmatch "$FILE" > /dev/null 2>&1; then
            git mv "$FILE" "$TARGET_DIR/index.md"
        else
            mv "$FILE" "$TARGET_DIR/index.md"
        fi

        # 3. Verificação de integridade pós-movimentação
        if [ -f "$TARGET_DIR/index.md" ]; then
            echo "✅ Sucesso: $TARGET_DIR/index.md"
        else
            echo "❌ ERRO ao processar $FILE"
        fi
    done
done

echo "✨ Migração concluída. Execute 'hugo server' para validar as rotas."