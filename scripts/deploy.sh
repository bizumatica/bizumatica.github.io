#!/bin/bash

# ==============================================================================
# Author: Julio Prata
# Version: 3.9 (AdTech + Performance + Scheduler Resilient)
# ==============================================================================

# GARANTIR QUE O SCRIPT EXECUTE NA RAIZ DO PROJETO
cd "$(dirname "$0")/.."

# Cores Tokyo Night
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- [START] Deploy: Bizumática v3.9 ---${NC}"

# 0. Sincronização, Agendamento e venv
echo -e "${YELLOW}--> [0] Rodando automações Python...${NC}"
# Ativa venv se existir
[ -d "venv" ] && source venv/bin/activate

# Executa primeiro o agendador de Leaf Bundles (Cron Local)
if python3 scripts/schedule-release.py; then
    echo -e "${GREEN}--> Cron de Agendados: PROCCESSADO!${NC}"
else
    echo -e "${RED}--> AVISO: Falha no script de agendamento. Prosseguindo...${NC}"
fi

# Executa a sincronização do Google Sheets
if python3 scripts/auto-busca.py; then
    echo -e "${GREEN}--> Sincronização API: SUCESSO!${NC}"
else
    echo -e "${RED}--> ALERTA: Falha no Python (Pandas instalado?). Prosseguindo local...${NC}"
fi

# 1. Limpeza de Bundles (Prevenção de Duplicatas com Failsafe)
echo -e "${YELLOW}--> [1] Verificando integridade de Page Bundles...${NC}"
rm -rf resources/_gen
for section in content/equipamentos content/matematica content/posts; do
    [ -d "$section" ] || continue
    find "$section" -maxdepth 1 -name "*.md" | while read -r old_file; do
        base=$(basename "$old_file" .md)
        # SÓ remove o .md avulso se a pasta existir E contiver um index.md legítimo dentro
        if [ -d "$section/$base" ] && [ -f "$section/$base/index.md" ]; then
            echo -e "${RED}--> Removendo conflito: $old_file (Mantendo o Leaf Bundle)${NC}"
            rm "$old_file"
        elif [ -d "$section/$base" ]; then
            echo -e "${YELLOW}--> [Aviso] Pasta vazia detectada para '$base'. Convertendo arquivo para index.md...${NC}"
            mv "$old_file" "$section/$base/index.md"
        fi
    done
done

# 2. Auditoria AdSense
echo -e "${YELLOW}--> [2] Auditando inventário de AdSense...${NC}"
if [ -f "./scripts/audit-ads.sh" ]; then
    ./scripts/audit-ads.sh | grep "MISS" || echo -e "${GREEN}--> Conteúdo 100% Monetizado!${NC}"
fi

# 3. Build Hugo (Output em /docs para GitHub Pages)
echo -e "${YELLOW}--> [3] Gerando build otimizado em /docs...${NC}"
if hugo --gc --minify --cleanDestinationDir -d docs; then
    echo -e "${GREEN}--> Build Hugo: OK!${NC}"
else
    echo -e "${RED}--> ERRO: Falha no Hugo.${NC}" && exit 1
fi

# 4. Verificação de Ativos (SEO & AdTech)
echo -e "${YELLOW}--> [4] Verificando ativos críticos...${NC}"
[ -f "docs/ads.txt" ] && echo -e "${GREEN}--> ads.txt: OK.${NC}" || echo -e "${RED}--> ERRO: ads.txt MISSING!${NC}"
# Validação de quebra de linha no robots.txt
if grep -q "Allow: /" docs/robots.txt; then
    echo -e "${GREEN}--> robots.txt: Válido.${NC}"
else
    echo -e "${RED}--> AVISO: robots.txt inválido para crawlers.${NC}"
fi

# 5. Busca (Pagefind)
echo -e "${YELLOW}--> [5] Atualizando índice Pagefind...${NC}"
if npx --yes pagefind --site docs --quiet; then
    echo -e "${GREEN}--> Pagefind: OK!${NC}"
    touch docs/.nojekyll
fi

# 6. Git Push
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
[ $# -eq 1 ] && msg="$1"

if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Nada para commitar.${NC}"
else
    echo -e "${GREEN}--> [6] Enviando para GitHub...${NC}"
    git add . && git commit -m "$msg"
    git pull origin main --rebase --no-edit
    git push origin main && echo -e "${CYAN}--- 🚀 [DONE] Bizumática Online! ---${NC}"
fi