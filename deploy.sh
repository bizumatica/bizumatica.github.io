#!/bin/bash

# Author: Julio Prata
# Created: 01 dez 2025
# Last Modified: 01 dez 2025

# Description:
# Deploy para a SSG bizumatica-blog

# Cores
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}--- Deploy para bizumatica-blog (Staging) ---${NC}"

msg="Update `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi

# 1. Constrói o site (gera a pasta docs)
echo -e "${GREEN}--> Gerando HTML na pasta docs...${NC}"
hugo --minify

# 2. Git
echo -e "${GREEN}--> Enviando para o GitHub...${NC}"
git add .
git commit -m "$msg"
git push origin main

echo -e "${CYAN}--- Feito! ---${NC}"