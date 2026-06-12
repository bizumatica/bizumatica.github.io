#!/bin/bash
# ==============================================================================
# Author: Julio Prata (BackInBash)
# Version: 5.2 (Shielded Source Automator - Ultra-Clean Edition)
# ==============================================================================

# GARANTIR QUE O SCRIPT EXECUTE NA RAIZ DO PROJETO
cd "$(dirname "$0")/.."

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- [START] Fluxo Local QA & Deploy: Bizumática v5.2 ---${NC}"

# 0. Processamento de Agendados Locais
if [ -d "venv" ] && [ -f "scripts/schedule-release.py" ]; then
    echo -e "${YELLOW}--> [0] Executando rotina de agendamento local...${NC}"
    source venv/bin/activate
    python3 scripts/schedule-release.py || echo -e "${RED}--> AVISO: Falha no agendamento. Prosseguindo...${NC}"
    deactivate
fi

# 1. Higienização Atômica de Bundles
echo -e "${YELLOW}--> [1] Auditando Page Bundles e convertendo arquivos soltos...${NC}"
for section in content/curadoria content/foss content/linux content/matematica content/shell-scripting; do
    [ -d "$section" ] || continue
    while IFS= read -r old_file; do
        [ -f "$old_file" ] || continue
        base=$(basename "$old_file" .md)
        target_dir="$section/$base"
        target_index="$target_dir/index.md"
        
        if [ -f "$target_index" ]; then
            echo -e "${RED}--> [Limpeza] Removendo duplicata redundante: $old_file${NC}"
            rm "$old_file"
        else
            echo -e "${GREEN}--> [Bundle] Convertendo para Leaf Bundle: $base${NC}"
            mkdir -p "$target_dir"
            mv "$old_file" "$target_index"
        fi
    done < <(find "$section" -maxdepth 1 -name "*.md" ! -name "index.md" ! -name "_index.md")
done

# 2. QA Local: Compilação e Indexação de Teste (Failsafe)
echo -e "${YELLOW}--> [2] Rodando Build de QA Local (Dry Run)...${NC}"
rm -rf resources/_gen docs/ public/ .hugo_build.lock

if hugo --gc --minify --cleanDestinationDir -d docs > /dev/null; then
    npx --yes pagefind --site docs --quiet
    echo -e "${GREEN}--> Build e Pagefind locais validados com sucesso!${NC}"
else
    echo -e "${RED}--> ERRO: Falha na compilação do Hugo. Abortando deploy!${NC}" && exit 1
fi

# 3. Auditoria AdSense e AdTech Local (Silenciosa)
echo -e "${YELLOW}--> [3] Auditando inventário de AdSense pré-build...${NC}"
[ -f "docs/ads.txt" ] || { echo -e "${RED}--> ERRO CRÍTICO: ads.txt ausente!${NC}" && exit 1; }

if [ -f "./scripts/audit-ads.sh" ]; then
    total_miss=$(./scripts/audit-ads.sh | grep -c "MISS")
    if [ "$total_miss" -gt 0 ]; then
        echo -e "${YELLOW}--> AVISO: Existem $total_miss páginas sem blocos de AdSense configurados.${NC}"
    else
        echo -e "${GREEN}--> Conteúdo 100% Monetizado!${NC}"
    fi
fi

# 4. Pipeline Git Seguro (Apenas Código-Fonte - v5.2 Rígido)
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
[ $# -eq 1 ] && msg="$1"

# Adiciona estritamente as pastas de desenvolvimento, ignorando resíduos e binários
git add content/ static/ archetypes/ data/ layouts/ assets/ config.toml hugo.toml .github/ scripts/ deploy.sh 2>/dev/null

if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Nenhuma alteração pendente. Infraestrutura síncrona.${NC}"
else
    echo -e "${GREEN}--> [4] Comitando alterações da fonte...${NC}"
    git commit -m "$msg"
    
    echo -e "${YELLOW}--> Enviando direto para o GitHub Actions...${NC}"
    if git push origin main; then
        echo -e "${CYAN}--- 🚀 [DONE] Código enviado! O GitHub Actions assumiu o build. ---${NC}"
    else
        echo -e "${RED}--> Erro ao enviar. Rodando sincronia de emergência...${NC}"
        git pull origin main --rebase -X theirs --no-edit
        git push origin main
    fi
fi