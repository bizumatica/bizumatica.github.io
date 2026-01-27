#!/bin/bash

# Author: Julio Prata
# Created: 01 dez 2025
# Last Modified: 27 jan 2026
# Version: 1.4
# Description: Script de deploy unificado para o Portal Principal

# Cores
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_NAME=$(basename "$PWD")

echo -e "${CYAN}--- Iniciando Deploy para o Portal: $PROJECT_NAME ---${NC}"

# 1. Mensagem de commit
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
if [ $# -eq 1 ]; then
  msg="$1"
fi

# 2. Sincronização de Submódulos (Importante se o tema for submódulo)
if [ -d ".git" ]; then
    echo -e "${YELLOW}--> Sincronizando temas...${NC}"
    git submodule update --init --recursive --quiet
fi

# 3. VERIFICAÇÃO E BUILD
if [ -f "hugo.toml" ] || [ -f "config.toml" ]; then
    echo -e "${GREEN}--> Site Hugo detectado.${NC}"
    
    # Limpeza manual forçada (O "Bizu" contra o erro de diretório)
    echo -e "${YELLOW}--> Limpando docs/ para evitar conflitos...${NC}"
    rm -rf docs/*
    
    echo -e "${GREEN}--> Iniciando build (Minify + Garbage Collection)...${NC}"
    if hugo --gc --minify -d docs; then
        echo -e "${GREEN}--> Build do Portal OK!${NC}"
    else
        echo -e "${RED}--> ERRO: Falha no build do Hugo. Verifique o código.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}--> Modo repositório simples detectado.${NC}"
fi

# 4. GIT PUSH
if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Nada para commitar no portal.${NC}"
    exit 0
fi

echo -e "${GREEN}--> Subindo para o GitHub...${NC}"
git add .
git commit -m "$msg"
if git push origin main; then
    echo -e "${CYAN}--- Portal $PROJECT_NAME atualizado com sucesso! 🚀 ---${NC}"
else
    echo -e "${RED}--> ERRO: Falha no push. Verifique o Git.${NC}"
    exit 1
fi