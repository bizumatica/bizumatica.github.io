#!/bin/bash

# ==============================================================================
# Author: Julio Prata
# Version: 3.7 (AdTech + Performance Optimized)
# Description: Deploy com Auditoria de Ads, Sincronização e Gestão de Bundles.
# ==============================================================================

# GARANTIR QUE O SCRIPT EXECUTE NA RAIZ DO PROJETO
cd "$(dirname "$0")/.."

# Cores para o terminal (Estética Tokyo Night)
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- [START] Deploy: Bizumática v3.7 ---${NC}"

# 0. Sincronização de Dados e Imagens
echo -e "${YELLOW}--> [0] Rodando automação Python (Sincronização)...${NC}"
if python3 scripts/auto-busca.py; then
    echo -e "${GREEN}--> Sincronização: SUCESSO!${NC}"
else
    echo -e "${RED}--> ALERTA: Falha no Python. Prosseguindo com dados locais...${NC}"
fi

# 1. Limpeza Inteligente de Migração (Bundles)
echo -e "${YELLOW}--> [1] Verificando integridade de Page Bundles...${NC}"
rm -rf resources/_gen

for section in content/equipamentos content/matematica content/posts; do
    if [ -d "$section" ]; then
        for dir in "$section"/*/; do
            [ -d "$dir" ] || continue
            base_name=$(basename "$dir")
            old_file="${section}/${base_name}.md"
            if [ -f "$old_file" ]; then
                echo -e "${RED}--> Conflito detectado: Removendo arquivo legado: $old_file${NC}"
                rm "$old_file"
            fi
        done
    fi
done

# 2. Auditoria de Monetização (Pre-build Check)
echo -e "${YELLOW}--> [2] Auditando inventário de AdSense...${NC}"
if [ -f "./scripts/audit-ads.sh" ]; then
    # Executa e filtra apenas os que faltam para manter o log limpo
    ./scripts/audit-ads.sh | grep "MISS" || echo -e "${GREEN}--> Todos os posts auditados possuem Ads!${NC}"
else
    echo -e "${RED}--> ALERTA: Script de auditoria não encontrado em /scripts/audit-ads.sh${NC}"
fi

# 3. Build Hugo (Produção)
export HUGO_ENV="production"
echo -e "${YELLOW}--> [3] Gerando build otimizado em /docs...${NC}"

if hugo --gc --minify --cleanDestinationDir -d docs; then
    echo -e "${GREEN}--> Build Hugo: OK!${NC}"
else
    echo -e "${RED}--> ERRO CRÍTICO: Falha no build do Hugo.${NC}"
    exit 1
fi

# 4. Verificação de Ativos Críticos (Fontes e Ads)
echo -e "${YELLOW}--> [4] Verificando integridade dos ativos estáticos...${NC}"
if [ -f "docs/ads.txt" ]; then
    echo -e "${GREEN}--> ads.txt: Presente e pronto.${NC}"
else
    echo -e "${RED}--> ERRO: ads.txt sumiu do /docs! Verifique a pasta /static.${NC}"
fi

if [ -d "docs/fonts" ]; then
    echo -e "${GREEN}--> Fontes Locais (.woff2): Integradas.${NC}"
else
    echo -e "${YELLOW}--> AVISO: Pasta /fonts não detectada. Verifique se baixou os arquivos.${NC}"
fi

# 5. Indexação de Busca (Pagefind)
echo -e "${YELLOW}--> [5] Atualizando índice de busca (Pagefind)...${NC}"
if npx pagefind --site docs --output-path docs/pagefind --quiet; then
    echo -e "${GREEN}--> Pagefind: Índice atualizado!${NC}"
    touch docs/.nojekyll
else
    echo -e "${RED}--> ALERTA: Falha ao gerar índice Pagefind.${NC}"
fi

# 6. Gestão de Commit e Push
msg="Update Portal $(date +'%d/%m/%Y %H:%M:%S')"
if [ $# -eq 1 ]; then msg="$1"; fi

if [[ -z $(git status -s) ]]; then
    echo -e "${CYAN}--> Status: Tudo atualizado no GitHub. Nada a enviar.${NC}"
    exit 0
fi

echo -e "${GREEN}--> [6] Sincronizando com GitHub...${NC}"
git add . 
git commit -m "$msg"
git pull origin main --rebase --no-edit

if git push origin main; then
    echo -e "${CYAN}--- 🚀 [DONE] Bizumática v3.7 está online! ---${NC}"
    echo -e "${YELLOW}Dica: Confira se as fórmulas KaTeX renderizaram em: https://bizumatica.com.br${NC}"
else
    echo -e "${RED}--> ERRO: Falha no Push. Verifique conflitos manualmente.${NC}"
    exit 1
fi