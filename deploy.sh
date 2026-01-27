#!/bin/bash

# Author: Julio Prata
# Created: 01 dez 2025
# Last Modified: 08 dez 2025
# Version: 1.2
# Description: Script de deploy híbrido (Sites Hugo e Repositórios comuns)

# Cores
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_NAME=$(basename "$PWD")

echo -e "${CYAN}--- Iniciando Deploy para: $PROJECT_NAME ---${NC}"

msg="Update $(date)"
if [ $# -eq 1 ]
  then msg="$1"
fi

# VERIFICAÇÃO
# Procura por hugo.toml ou config.toml para saber se é um site Hugo
if [ -f "hugo.toml" ] || [ -f "config.toml" ]; then
    echo -e "${GREEN}--> Site Hugo detectado. Iniciando build...${NC}"
    
    # Tenta construir o site
    if hugo --minify --cleanDestinationDir -d docs; then
        echo -e "${GREEN}--> Build OK! Preparando Git...${NC}"
    else
        echo -e "${RED}--> ERRO: Falha no Hugo. Deploy cancelado.${NC}"
        exit 1
    fi
else
    # Se não for site Hugo (caso da pasta bizumatica-tools)
    echo -e "${YELLOW}--> Nenhum arquivo Hugo detectado. Pulando build (modo repositório simples).${NC}"
fi

# PARTE DO GIT (Comum para todos)
if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Nada para commitar. O diretório está limpo.${NC}"
    exit 0
fi

echo -e "${GREEN}--> Enviando para o GitHub...${NC}"
git add .
git commit -m "$msg ($PROJECT_NAME)"
git push origin main

echo -e "${CYAN}--- Deploy do $PROJECT_NAME concluído com sucesso! ---${NC}"