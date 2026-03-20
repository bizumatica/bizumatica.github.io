#!/bin/bash

# Author: Julio Prata
# Version: 2.4 (Deploy Blindado + Cache Killer)
# Description: Deploy com limpeza profunda de assets e integração Python

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- Iniciando Deploy: Bizumática ---${NC}"

# 0. Sincronização de Dados
echo -e "${YELLOW}--> Rodando automação de dados (Nuvem/Local)...${NC}"
# Removendo pastas fantasmas/lixo antes de rodar o python
rm -rf "content/equipamentos/#"* 2>/dev/null

if python3 auto-busca.py; then
    echo -e "${GREEN}--> Sincronização: OK!${NC}"
else
    echo -e "${RED}--> AVISO: Falha na automação. Prosseguindo com dados locais...${NC}"
fi

# 1. Limpeza Preventiva Profunda (Cache Killer)
echo -e "${YELLOW}--> Limpando builds, caches e recursos antigos...${NC}"
# Apagamos a pasta resources inteira para forçar o Hugo a reprocessar o CSS/JS
rm -rf docs resources/_gen resources public
hugo mod clean 2>/dev/null

# 2. Build Hugo com Verificação de Erros
echo -e "${GREEN}--> Gerando build otimizado (-d docs)...${NC}"
# Usamos --gc (Garbage Collection) para garantir um build limpo
if hugo --gc --minify -d docs; then
    echo -e "${GREEN}--> Build Hugo: OK!${NC}"
else
    echo -e "${RED}--> ERRO CRÍTICO: Falha no build. Verifique os logs acima.${NC}"
    exit 1
fi

# 3. Indexação com Pagefind
if [ -d "docs" ]; then
    echo -e "${YELLOW}--> Indexando busca com Pagefind...${NC}"
    npx pagefind --site docs --output-path docs/pagefind
    touch docs/.nojekyll
fi

# 4. Gestão de Commit Inteligente
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
if [ $# -eq 1 ]; then msg="$1"; fi

# Verifica se houve mudanças reais antes de tentar o push
if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Sem alterações detectadas. O site já está atualizado.${NC}"
    exit 0
fi

# 5. Push Seguro
echo -e "${GREEN}--> Enviando alterações para o GitHub...${NC}"
git add .
git commit -m "$msg"
if git push origin main; then
    echo -e "${CYAN}--- 🚀 Portal Bizumática Online e Atualizado! ---${NC}"
else
    echo -e "${RED}--> ERRO: Falha no Push. Verifique sua conexão ou permissões.${NC}"
    exit 1
fi