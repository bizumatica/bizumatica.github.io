#!/bin/bash

# Author: Julio Prata
# Version: 3.6 (Standard Fast Deploy + Audit Reminder)
# Description: Deploy com limpeza inteligente e alerta de manutenção de links.

# GARANTIR QUE O SCRIPT EXECUTE NA RAIZ DO PROJETO
cd "$(dirname "$0")/.."

# Cores para o terminal
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- [START] Deploy: Bizumática v3.6 ---${NC}"

# 0. Sincronização de Dados e Imagens
echo -e "${YELLOW}--> Rodando automação Python (Sincronização)...${NC}"
if python3 scripts/auto-busca.py; then
    echo -e "${GREEN}--> Sincronização: SUCESSO!${NC}"
else
    echo -e "${RED}--> ALERTA: Falha no Python. Prosseguindo com dados locais...${NC}"
fi

# 1. Limpeza Inteligente de Migração
echo -e "${YELLOW}--> Verificando migrações de arquivos para pastas (Bundles)...${NC}"
rm -rf resources/_gen

for section in content/equipamentos content/matematica content/posts; do
    if [ -d "$section" ]; then
        for dir in "$section"/*/; do
            [ -d "$dir" ] || continue
            base_name=$(basename "$dir")
            old_file="${section}/${base_name}.md"
            if [ -f "$old_file" ]; then
                echo -e "${RED}--> Migração detectada: Removendo arquivo legado: $old_file${NC}"
                rm "$old_file"
            fi
        done
    fi
done

# 2. Build Hugo
export HUGO_ENV="production"
echo -e "${YELLOW}--> Gerando build otimizado em /docs...${NC}"
if hugo --gc --minify --cleanDestinationDir -d docs; then
    echo -e "${GREEN}--> Build Hugo: OK!${NC}"
else
    echo -e "${RED}--> ERRO CRÍTICO: Falha no build.${NC}"
    exit 1
fi

# 3. Indexação de Busca
if npx pagefind --site docs --output-path docs/pagefind --quiet; then
    echo -e "${GREEN}--> Pagefind: Índice atualizado!${NC}"
    touch docs/.nojekyll
fi

# 4. Gestão de Commit
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
if [ $# -eq 1 ]; then msg="$1"; fi

if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Status: Tudo atualizado. Nada a enviar.${NC}"
    exit 0
fi

# 5. Sincronização GitHub
echo -e "${GREEN}--> Sincronizando com GitHub...${NC}"
git add . 
git commit -m "$msg"
git pull origin main --rebase --no-edit

if git push origin main; then
    echo -e "${CYAN}--- 🚀 [DONE] Bizumática v3.6 está online! ---${NC}"
    echo -e "${YELLOW}Dica: Faz tempo que não checa os links? Rode: ./scripts/check-links.sh${NC}"
else
    echo -e "${RED}--> ERRO: Falha no Push. Verifique conflitos manuais.${NC}"
    exit 1
fi