#!/bin/bash

# Author: Julio Prata
# Version: 1.0
# Description: Auditoria de links com Lychee e geração de relatório Markdown.

# Configurações
REPORT_PATH="internal/report-links.md"
CHECK_DIR="content"
TIMESTAMP=$(date +'%d/%m/%Y %H:%M:%S')

# Cores para o terminal
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}--- [AUDIT] Iniciando Verificação de Links ---${NC}"

# 1. Verificar se o Lychee está instalado
if ! command -v lychee &> /dev/null; then
    echo -e "${RED}Erro: Lychee não encontrado. Instale com: sudo apt install lychee${NC}"
    exit 1
fi

# 2. Criar cabeçalho do relatório
cat << EOF > $REPORT_PATH
# 🔗 Relatório de Integridade de Links - Bizumática
> **Gerado em:** $TIMESTAMP

## 📊 Resumo da Auditoria
Este relatório lista o status de todos os links (afiliados e externos) encontrados na pasta \`$CHECK_DIR\`.

EOF

# 3. Rodar o Lychee e anexar ao relatório
echo -e "${YELLOW}--> Analisando Markdown e testando conexões...${NC}"

lychee "$CHECK_DIR/**/*.md" \
    --format markdown \
    --accept 200,403,429 \
    --exclude "^/" \
    --timeout 10 \
    --max-concurrency 10 >> $REPORT_PATH

# 4. Finalização
if [ $? -eq 0 ]; then
    echo -e "${GREEN}--> Auditoria concluída! Relatório salvo em: $REPORT_PATH${NC}"
else
    echo -e "${YELLOW}--> Auditoria finalizada com alguns alertas. Veja: $REPORT_PATH${NC}"
fi

echo -e "${CYAN}--- [DONE] ---${NC}"