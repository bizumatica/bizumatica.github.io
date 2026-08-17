#!/usr/bin/env bash
#
# audit_content.sh - Diagnosticador de Thin Content e Incoerências
#

set -euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

if [[ $# -lt 1 ]]; then
    echo "Erro: caminho para o diretório 'content' não informado." >&2
    echo "Uso: $0 /caminho/para/content [threshold_palavras]" >&2
    exit 1
fi

CONTENT_DIR="$1"
THRESHOLD="${2:-800}"

if [[ ! -d "$CONTENT_DIR" ]]; then
    echo "Erro: diretório '$CONTENT_DIR' não existe." >&2
    exit 1
fi

# Resolução dinâmica da pasta reports/ na raiz do repositório
WORKSPACE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"
REPORTS_DIR="${WORKSPACE_ROOT}/reports"
mkdir -p "${REPORTS_DIR}"

OUT_CSV="${REPORTS_DIR}/audit_report_$(date +%Y%m%d_%H%M%S).csv"
trap 'echo "Relatório parcialmente salvo em: $OUT_CSV" >&2' EXIT

echo "secao,slug,data,palavras,thin,afiliado_fora_curadoria,slug_problematico" > "$OUT_CSV"

while IFS= read -r -d '' post; do
    filename="$(basename "$post")"
    [[ "$filename" == "_index.md" ]] && continue

    dir="$(dirname "$post")"
    
    if [[ "$filename" == "index.md" ]]; then
        slug="$(basename "$dir")"
    else
        slug="${filename%.md}"
    fi

    secao_relativa="${dir#$CONTENT_DIR}"
    secao="$(echo "$secao_relativa" | sed 's|^/||' | cut -d/ -f1)"
    [[ -z "$secao" ]] && secao="raiz"

    local_data=""
    local_data="$(grep -m1 -E '^(date|Date):' "$post" 2>/dev/null | sed -E 's/^(date|Date):\s*//; s/["'"'"']//g' || true)"
    [[ -z "$local_data" ]] && local_data="SEM_DATA"

    corpo=""
    corpo="$(awk '
        BEGIN { in_fm=0; fm_delim="" }
        /^---$/ || /^\+\+\+$/ {
            if (in_fm == 0) {
                in_fm = 1;
                fm_delim = $0;
                next;
            } else if ($0 == fm_delim) {
                in_fm = 2;
                next;
            }
        }
        in_fm == 2 || in_fm == 0 { print }
    ' "$post")"

    palavras="$(echo "$corpo" | wc -w | tr -d ' ')"

    thin="OK"
    [[ "$palavras" -lt "$THRESHOLD" ]] && thin="THIN"

    afiliado_flag="-"
    if [[ "$secao" != "curadoria" ]]; then
        if echo "$corpo" | grep -qiE 'transpar[êe]ncia.*afiliad|ko-fi\.com|link de afiliad|comprar (o|a) (item|produto)'; then
            afiliado_flag="SIM_FORA_DE_CONTEXTO"
        fi
    fi

    slug_flag="-"
    if [[ "$slug" =~ [[:space:]] ]]; then
        slug_flag="ESPACO_NO_SLUG"
    elif [[ "$slug" =~ [^a-z0-9\-] ]]; then
        slug_flag="CARACTERE_SUSPEITO"
    fi

    echo "\"$secao\",\"$slug\",\"$local_data\",\"$palavras\",\"$thin\",\"$afiliado_flag\",\"$slug_flag\"" >> "$OUT_CSV"

done < <(find "$CONTENT_DIR" -type f -name "*.md" -print0)

trap - EXIT

echo "=== RESUMO DA AUDITORIA ==="
echo "Relatório completo salvo em: $OUT_CSV"