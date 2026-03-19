#!/bin/bash
# Author: Julio Prata | Version: 1.1
# Optimize-Images - Bizumática
# Description: Converte imagens para WebP via cwebp ou ffmpeg e limpa originais.

# Detectar qual conversor usar
if command -v cwebp &> /dev/null; then
    CONVERTER="cwebp"
elif command -v ffmpeg &> /dev/null; then
    CONVERTER="ffmpeg"
else
    echo "❌ Erro: Nem cwebp nem ffmpeg foram encontrados. Instale um deles."
    exit 1
fi

# Pasta onde ficam os posts (ajuste se usar outras pastas como 'content/matematica')
POSTS_DIR="content"

echo "🚀 Iniciando otimização em [$POSTS_DIR] usando [$CONVERTER]..."

# Busca por .jpg, .jpeg e .png recursivamente
find "$POSTS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r img; do
    
    webp_img="${img%.*}.webp"
    echo "Converting: $img -> $webp_img"
    
    if [ "$CONVERTER" == "cwebp" ]; then
        cwebp -q 80 "$img" -o "$webp_img" -quiet
    else
        # Comando equivalente no ffmpeg
        ffmpeg -i "$img" -compression_level 4 -q:v 80 "$webp_img" -loglevel quiet -y
    fi
    
    # Se a conversão deu certo (exit code 0), remove o original
    if [ $? -eq 0 ]; then
        rm "$img"
    else
        echo "⚠️ Falha ao converter: $img"
    fi
done

echo "✅ Concluído! Imagens otimizadas com sucesso."