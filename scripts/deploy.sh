#!/bin/bash

# Author: Julio Prata
# Version: 3.2 (Consolidada - Bizumática)
# Description: Deploy com gestão de destino, busca (Pagefind) e sincronização de dados.

# GARANTIR QUE O SCRIPT EXECUTE NA RAIZ DO PROJETO (Independente de onde for chamado)
cd "$(dirname "$0")/.."

# Definição de Cores para o Terminal
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- [START] Deploy: Bizumática v3.2 (Full Automation) ---${NC}"

# 0. Sincronização de Dados (Planilha/Sheets)
echo -e "${YELLOW}--> Executando automação Python (Sincronização)...${NC}"
if python3 scripts/auto-busca.py; then
    echo -e "${GREEN}--> Sincronização: SUCESSO!${NC}"
else
    echo -e "${RED}--> ALERTA: Falha no Python. Prosseguindo com dados locais...${NC}"
fi

# 1. Preparação do Ambiente de Produção
export HUGO_ENV="production"

# 2. Build Hugo (Nativo e Limpo)
echo -e "${YELLOW}--> Gerando build otimizado em /docs...${NC}"
# --cleanDestinationDir: Garante que arquivos deletados no content sumam da docs
# --gc: Garbage Collection para limpar recursos não utilizados
if hugo --gc --minify --cleanDestinationDir -d docs; then
    echo -e "${GREEN}--> Build Hugo: OK!${NC}"
else
    echo -e "${RED}--> ERRO CRÍTICO: Falha no build. Abortando deploy.${NC}"
    exit 1
fi

# 3. Indexação de Busca (Pagefind)
if [ -d "docs" ]; then
    echo -e "${YELLOW}--> Atualizando índice de busca (Pagefind)...${NC}"
    npx pagefind --site docs --output-path docs/pagefind --quiet
    touch docs/.nojekyll
fi

# 4. Gestão de Commit Inteligente
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
if [ $# -eq 1 ]; then msg="$1"; fi

# Verifica se houve mudanças reais para evitar commits de "vento"
if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Status: Nada para atualizar. O site já está sincronizado.${NC}"
    exit 0
fi

# 5. Push Seletivo (Inclusão de scripts e produtos_sheets)
echo -e "${GREEN}--> Sincronizando com GitHub (Main)...${NC}"
# Adicionamos as pastas estruturais, os novos produtos e as ferramentas de automação
git add docs/ content/ assets/ static/ layouts/ archetypes/ scripts/ config.toml hugo.toml 2>/dev/null
git commit -m "$msg"

if git push origin main; then
    echo -e "${CYAN}--- 🚀 [DONE] Bizumática v3.2 está online e performante! ---${NC}"
else
    echo -e "${RED}--> ERRO: Falha no Push. Verifique chaves SSH ou conexão.${NC}"
    exit 1
fi