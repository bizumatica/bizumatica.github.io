#!/bin/bash

# Author: Julio Prata
# Version: 2.1 (Indexação Pagefind)
# Description: Deploy otimizado para Portal Bizumática

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_NAME=$(basename "$PWD")

echo -e "${CYAN}--- Iniciando Deploy: $PROJECT_NAME ---${NC}"

# 1. Mensagem de Commit
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
if [ $# -eq 1 ]; then msg="$1"; fi

# 2. Sincronização de Temas
if [ -d ".git" ]; then
    echo -e "${YELLOW}--> Sincronizando temas e submódulos...${NC}"
    git submodule update --init --recursive --quiet
fi

# 3. Build com Limpeza Total
if [ -f "hugo.toml" ] || [ -f "config.toml" ]; then
    echo -e "${GREEN}--> Site Hugo detectado.${NC}"
    
    # Remove e recria a pasta docs
    rm -rf docs
    mkdir docs
    
    echo -e "${GREEN}--> Gerando build otimizado...${NC}"
    if hugo --gc --minify -d docs; then
        
        # --- Indexação da Busca ---
        echo -e "${YELLOW}--> Indexando busca com Pagefind...${NC}"
        npx pagefind --site docs
        
        # Garante que o GitHub Pages não tenta usar Jekyll
        touch docs/.nojekyll
        echo -e "${GREEN}--> Build e Indexação OK!${NC}"
    else
        echo -e "${RED}--> ERRO: Falha no build do Hugo.${NC}"
        exit 1
    fi
fi

# 4. Git Push
if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Nada para atualizar no momento.${NC}"
    exit 0
fi

echo -e "${GREEN}--> Subindo alterações para o GitHub...${NC}"
git add .
git commit -m "$msg"
if git push origin main; then
    echo -e "${CYAN}--- Portal unificado atualizado com sucesso! 🚀 ---${NC}"
else
    echo -e "${RED}--> ERRO: Falha ao subir para o GitHub.${NC}"
    exit 1
fi