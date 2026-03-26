#!/bin/bash

# Author: Julio Prata
# Version: 3.3 (Otimizada - Imagens e Cache)
# Description: Deploy com gestão de destino, busca e limpeza de cache.

# GARANTIR QUE O SCRIPT EXECUTE NA RAIZ DO PROJETO
cd "$(dirname "$0")/.."

# Cores
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- [START] Deploy: Bizumática v3.3 (Full Automation) ---${NC}"

# 0. Sincronização de Dados e Imagens
echo -e "${YELLOW}--> Executando automação Python (Sincronização + Imagens)...${NC}"
if python3 scripts/auto-busca.py; then
    echo -e "${GREEN}--> Sincronização: SUCESSO!${NC}"
else
    echo -e "${RED}--> ALERTA: Falha no Python. Prosseguindo com dados locais...${NC}"
fi

# 1. Limpeza de Legado e Cache (O Pulo do Gato)
# Remove o cache de imagens do Hugo para forçar o processamento das novas 'prod-*'
echo -e "${YELLOW}--> Limpando cache de recursos e imagens antigas...${NC}"
rm -rf resources/_gen
# Remove o arquivo duplicado que encontramos no seu tree (se existir)
[ -f "./content/equipamentos/mouse-mx-master-3s.md" ] && rm "./content/equipamentos/mouse-mx-master-3s.md"
[ -f "./static/css/extended.css" ] && rm "./static/css/extended.css"

# 2. Build Hugo (Nativo e Limpo)
export HUGO_ENV="production"
echo -e "${YELLOW}--> Gerando build otimizado em /docs...${NC}"

if hugo --gc --minify --cleanDestinationDir -d docs; then
    echo -e "${GREEN}--> Build Hugo: OK!${NC}"
else
    echo -e "${RED}--> ERRO CRÍTICO: Falha no build. Abortando deploy.${NC}"
    exit 1
fi

# 3. Indexação de Busca (Pagefind)
if command -v npx &> /dev/null && [ -d "docs" ]; then
    echo -e "${YELLOW}--> Atualizando índice de busca (Pagefind)...${NC}"
    npx pagefind --site docs --output-path docs/pagefind --quiet
    touch docs/.nojekyll
else
    echo -e "${YELLOW}--> [Aviso] Pagefind pulado (npx não encontrado).${NC}"
fi

# 4. Gestão de Commit
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
if [ $# -eq 1 ]; then msg="$1"; fi

if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Status: Nada para atualizar.${NC}"
    exit 0
fi

# 5. Push Seletivo
echo -e "${GREEN}--> Sincronizando com GitHub...${NC}"
# Adiciona tudo, respeitando o .gitignore
git add . 
git commit -m "$msg"

if git push origin main; then
    echo -e "${CYAN}--- 🚀 [DONE] Bizumática v3.3 está online! ---${NC}"
else
    echo -e "${RED}--> ERRO: Falha no Push.${NC}"
    exit 1
fi