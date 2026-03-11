#!/bin/bash

# Author: Julio Prata
# Version: 2.2 (Deploy Blindado)
# Description: Deploy com verificação de erros e gestão de cache

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- Iniciando Deploy: Bizumática ---${NC}"

# 1. Limpeza Preventiva
echo -e "${YELLOW}--> Limpando builds anteriores...${NC}"
rm -rf docs resources/_gen

# 2. Build Hugo com Verificação de Erros
echo -e "${GREEN}--> Gerando build otimizado...${NC}"
# --gc: remove arquivos não utilizados
# --minify: reduz tamanho de HTML/CSS/JS
# --enableGitInfo: útil se você usa datas de última modificação
if hugo --gc --minify -d docs; then
    echo -e "${GREEN}--> Build Hugo: OK!${NC}"
else
    echo -e "${RED}--> ERRO CRÍTICO: Falha no build. Verifique os logs acima.${NC}"
    exit 1
fi

# 3. Indexação com Pagefind (Apenas se a pasta existir)
if [ -d "docs" ]; then
    echo -e "${YELLOW}--> Indexando busca com Pagefind...${NC}"
    npx pagefind --site docs --output-path docs/pagefind
    
    # Prevenção contra Jekyll no GitHub Pages
    touch docs/.nojekyll
fi

# 4. Gestão de Commit Inteligente
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
if [ $# -eq 1 ]; then msg="$1"; fi

# Verifica se houve mudanças reais antes de tentar o push
if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Sem alterações para comitar. Saindo...${NC}"
    exit 0
fi

# 5. Push Seguro
echo -e "${GREEN}--> Sincronizando com GitHub...${NC}"
git add .
git commit -m "$msg"
if git push origin main; then
    echo -e "${CYAN}--- 🚀 Portal Bizumática Online e Atualizado! ---${NC}"
else
    echo -e "${RED}--> ERRO: Falha no Push. Verifique sua conexão ou permissões.${NC}"
    exit 1
fi