#!/bin/bash

# Cores para o terminal (Estética Tokyo Night)
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${CYAN}--- AUDITORIA DE ADSENSE: BIZUMÁTICA ---${NC}"
echo -e "Alvo: ./content/\n"

# Contadores
TOTAL=0
WITH_ADS=0
MISSING_ADS=0

# Busca por todos os arquivos .md, ignorando arquivos de sistema ou ocultos
# Foca em index.md (bundles) e arquivos avulsos
while read -r file; do
    # Ignora arquivos de configuração de seção (opcional)
    if [[ $file == *"_index.md"* ]]; then
        continue
    fi

    ((TOTAL++))
    
    # Verifica a existência do shortcode (case-insensitive)
    if grep -qi "{{< adsense" "$file"; then
        echo -e "[${GREEN} OK ${NC}] $file"
        ((WITH_ADS++))
    else
        echo -e "[${RED}MISS${NC}] $file"
        ((MISSING_ADS++))
    fi
done < <(find content -name "*.md")

echo -e "\n${CYAN}--- RESUMO DO INVENTÁRIO ---${NC}"
echo -e "Total de posts analisados: ${YELLOW}$TOTAL${NC}"
echo -e "Posts com AdSense:         ${GREEN}$WITH_ADS${NC}"
echo -e "Posts SEM AdSense:         ${RED}$MISSING_ADS${NC}"

if [ $MISSING_ADS -eq 0 ]; then
    echo -e "\n${GREEN}🎯 Missão cumprida! Todos os posts estão monetizados.${NC}"
else
    echo -e "\n${YELLOW}⚠️  Ainda existem $MISSING_ADS posts sem blocos de anúncio.${NC}"
fi