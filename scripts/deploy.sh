#!/bin/bash

# ==============================================================================
# Author: Julio Prata (BackInBash)
# Version: 4.1 (Validated & Refined - Leaf Bundle Automator)
# ==============================================================================

# GARANTIR QUE O SCRIPT EXECUTE NA RAIZ DO PROJETO
cd "$(dirname "$0")/.."

# Cores Tokyo Night
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- [START] Deploy Simplificado: Bizumática v4.1 ---${NC}"

# 0. Processamento de Agendados Locais (Apenas se a venv e o script existirem)
if [ -d "venv" ] && [ -f "scripts/schedule-release.py" ]; then
    echo -e "${YELLOW}--> [0] Executando rotina de agendamento local...${NC}"
    source venv/bin/activate
    python3 scripts/schedule-release.py || echo -e "${RED}--> AVISO: Falha no script de agendamento. Prosseguindo...${NC}"
fi

# 1. Verificação de Integridade e Higienização de Bundles (Failsafe Re-engineered)
echo -e "${YELLOW}--> [1] Auditando Page Bundles e convertendo arquivos soltos...${NC}"
rm -rf resources/_gen

for section in content/curadoria content/foss content/linux content/matematica content/shell-scripting; do
    [ -d "$section" ] || continue
    
    while IFS= read -r old_file; do
        [ -f "$old_file" ] || continue
        base=$(basename "$old_file" .md)
        target_dir="$section/$base"
        target_index="$target_dir/index.md"
        
        if [ -f "$target_index" ]; then
            echo -e "${RED}--> [Limpeza] Removendo duplicata redundante na raiz: $old_file${NC}"
            rm "$old_file"
        else
            echo -e "${GREEN}--> [Bundle] Convertendo arquivo solto em Leaf Bundle: $base${NC}"
            mkdir -p "$target_dir"
            mv "$old_file" "$target_index"
        fi
    done < <(find "$section" -maxdepth 1 -name "*.md")
done

# 2. Auditoria AdSense e AdTech
echo -e "${YELLOW}--> [2] Auditando inventário de AdSense...${NC}"
if [ -f "./scripts/audit-ads.sh" ]; then
    ./scripts/audit-ads.sh | grep "MISS" || echo -e "${GREEN}--> Conteúdo 100% Monetizado!${NC}"
fi

# 3. Compilação do Hugo (Output em /docs para GitHub Pages)
echo -e "${YELLOW}--> [3] Gerando build otimizado em /docs...${NC}"
if hugo --gc --minify --cleanDestinationDir -d docs; then
    echo -e "${GREEN}--> Build Hugo: OK!${NC}"
else
    echo -e "${RED}--> ERRO: Falha na compilação do Hugo.${NC}" && exit 1
fi

# 4. Verificação de Ativos Críticos (SEO & Compliance)
echo -e "${YELLOW}--> [4] Verificando ativos críticos de AdTech...${NC}"
[ -f "docs/ads.txt" ] && echo -e "${GREEN}--> ads.txt: Detectado e Ativo.${NC}" || echo -e "${RED}--> ERRO CRÍTICO: ads.txt AUSENTE!${NC}"

if grep -q "Allow: /" docs/robots.txt; then
    echo -e "${GREEN}--> robots.txt: Válido para Crawlers do Google.${NC}"
else
    echo -e "${RED}--> AVISO: robots.txt inválido ou bloqueando indexação.${NC}"
fi

# 5. Motor de Busca Interno (Pagefind Indexing)
echo -e "${YELLOW}--> [5] Atualizando índice de busca Pagefind...${NC}"
if npx --yes pagefind --site docs --quiet; then
    echo -e "${GREEN}--> Pagefind: Indexação Concluída!${NC}"
    touch docs/.nojekyll
fi

# 6. Pipeline Git Seguro
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
[ $# -eq 1 ] && msg="$1"

if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Repositório limpo. Nenhuma alteração pendente para envio.${NC}"
else
    echo -e "${GREEN}--> [6] Salvando alterações no estágio do Git...${NC}"
    git add .
    git commit -m "$msg"
    
    echo -e "${YELLOW}--> Sincronizando com a branch main remota (--rebase)...${NC}"
    if git pull origin main --rebase --no-edit; then
        git push origin main && echo -e "${CYAN}--- 🚀 [DONE] Bizumática Online e Atualizado! ---${NC}"
    else
        echo -e "${RED}--> ERRO CRÍTICO: Conflito detectado no Git Pull Rebase. Resolva manualmente.${NC}"
        exit 1
    fi
fi