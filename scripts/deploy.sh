#!/bin/bash

# ==============================================================================
# Author: Julio Prata
# Version: 3.11 (Failsafe Git Pipeline + Multi-Format Bundle Guard)
# ==============================================================================

# GARANTIR QUE O SCRIPT EXECUTE NA RAIZ DO PROJETO
cd "$(dirname "$0")/.."

# Cores Tokyo Night
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- [START] Deploy: Bizumática v3.11 ---${NC}"

# 0. Sincronização, Agendamento e venv
echo -e "${YELLOW}--> [0] Rodando automações Python...${NC}"
[ -d "venv" ] && source venv/bin/activate

# Executa primeiro o agendador de Leaf Bundles
if python3 scripts/schedule-release.py; then
    echo -e "${GREEN}--> Cron de Agendados: PROCESSADO!${NC}"
else
    echo -e "${RED}--> AVISO: Falha no script de agendamento. Prosseguindo...${NC}"
fi

# Executa a sincronização do Google Sheets
if python3 scripts/auto-busca.py; then
    echo -e "${GREEN}--> Sincronização API: SUCESSO!${NC}"
else
    echo -e "${RED}--> ALERTA: Falha no Python. Prosseguindo local...${NC}"
fi

# 1. Verificação de Integridade Segura (SEM DELETAR OU SOBRESCREVER POSTS BONS)
echo -e "${YELLOW}--> [1] Auditando Page Bundles e evitando colisões...${NC}"
rm -rf resources/_gen

for section in content/equipamentos content/matematica content/posts; do
    [ -d "$section" ] || continue
    
    while IFS= read -r old_file; do
        [ -f "$old_file" ] || continue
        base=$(basename "$old_file" .md)
        target_dir="$section/$base"
        target_index="$target_dir/index.md"
        
        # CASO 1: Existe a pasta E ela já tem um index.md (O arquivo .md antigo da raiz é duplicado)
        if [ -f "$target_index" ]; then
            echo -e "${RED}--> [Limpeza] Removendo arquivo duplicado da raiz: $old_file (Leaf Bundle preservado)${NC}"
            rm "$old_file"
            
        # CASO 2: Existe a pasta, mas ela NÃO tem index.md dentro (Vazia ou apenas com mídias órfãs)
        elif [ -d "$target_dir" ]; then
            if [ -z "$(ls -A "$target_dir")" ]; then
                echo -e "${YELLOW}--> Pasta vazia detectada para '$base'. Convertendo arquivo solto...${NC}"
                mv "$old_file" "$target_index"
            else
                echo -e "${YELLOW}--> [Aviso] Pasta '$base' contém mídias sem index.md. Injetando arquivo com segurança...${NC}"
                mv -n "$old_file" "$target_index"
            fi
        fi
    done < <(find "$section" -maxdepth 1 -name "*.md")
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

# 6. Git Push Seguro (Fluxo de Rebase Corrigido)
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
[ $# -eq 1 ] && msg="$1"

if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Nada para commitar no repositório.${NC}"
else
    echo -e "${GREEN}--> [6] Salvando alterações locais e preparando envio...${NC}"
    git add .
    git commit -m "$msg"
    
    echo -e "${YELLOW}--> Sincronizando com o repositório remoto (--rebase)...${NC}"
    if git pull origin main --rebase --no-edit; then
        git push origin main && echo -e "${CYAN}--- 🚀 [DONE] Bizumática Online! ---${NC}"
    else
        echo -e "${RED}--> ERRO CRÍTICO: Conflito detectado no Git Rebase. Resolva manualmente com 'git rebase --continue'.${NC}"
        exit 1
    fi
fi