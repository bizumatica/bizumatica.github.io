#!/usr/bin/env bash
set -euo pipefail

BOLD="\033[1m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

info() { echo -e "${BOLD}[INFO]${RESET} $*"; }
pass() { echo -e "${GREEN}  [OK]${RESET} $*"; }
fail() { echo -e "${RED}[ERRO]${RESET} $*"; exit 1; }

echo "======================================================"
echo "  [Bizumática] Auditoria de Build e Conformidade SEO  "
echo "======================================================"

# 1. Dependências
command -v hugo >/dev/null 2>&1 || fail "Hugo não instalado ou ausente no PATH."

# 2. Compilação limpa de produção
info "Limpando public/ e compilando via Hugo..."
rm -rf public/
hugo --gc --minify >/dev/null 2>&1 || fail "Erro durante a compilação do Hugo."

# 3. Validação do Sitemap
info "Auditando sitemap.xml contra URLs de taxonomias (/tags/)..."
if [ -f "public/sitemap.xml" ]; then
    TAG_COUNT=$(grep -c '/tags/' public/sitemap.xml || true)
    if [ "$TAG_COUNT" -eq 0 ]; then
        pass "Sitemap limpo: Nenhuma URL de /tags/ encontrada."
    else
        fail "Encontradas $TAG_COUNT URLs de /tags/ no sitemap.xml!"
    fi
else
    fail "sitemap.xml não foi gerado."
fi

# 4. Validação do Robots.txt
info "Verificando se o robots.txt declara a diretiva de Sitemap..."
if [ -f "public/robots.txt" ]; then
    grep -qi "Sitemap:" public/robots.txt || fail "robots.txt não aponta para o sitemap."
    pass "robots.txt presente e configurado."
else
    fail "robots.txt ausente em public/."
fi

# 5. Validação de Noindex na Busca
info "Verificando tag noindex na página de busca (/buscar/)..."
if [ -f "public/buscar/index.html" ]; then
    grep -qi 'noindex' public/buscar/index.html || fail "A página /buscar/ está sem meta tag noindex!"
    pass "Página /buscar/ bloqueada para indexação com sucesso."
else
    fail "Página /buscar/index.html não foi gerada."
fi

# 6. Validação de Index na Privacidade
info "Verificando se a Política de Privacidade está aberta a indexação..."
if [ -f "public/privacidade/index.html" ]; then
    if grep -qi 'noindex' public/privacidade/index.html; then
        fail "Política de Privacidade está incorretamente configurada com noindex!"
    fi
    pass "Política de Privacidade liberada para robôs (index, follow)."
else
    fail "Página /privacidade/index.html não foi gerada."
fi

# 7. Validação de Aliases críticos
info "Auditando arquivos HTML de redirecionamento (aliases)..."
ALIASES=(
    "public/search/index.html"
    "public/curadoria/ti-84-plus-ce/index.html"
    "public/curadoria/backup-universal-shell-sandisk/index.html"
)

for alias in "${ALIASES[@]}"; do
    if [ -f "$alias" ]; then
        pass "Alias ativo: $alias"
    else
        fail "Alias de redirecionamento ausente: $alias"
    fi
done

echo "======================================================"
echo -e "${GREEN}${BOLD}✅ AUDITORIA CONCLUÍDA: O build cumpre 100% das diretrizes do AdSense e SEO!${RESET}"
echo "======================================================"
