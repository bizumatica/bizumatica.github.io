#!/usr/bin/env bash
#
# Hugo SEO & Internationalization Orchestrator
#

set -euo pipefail
shopt -s inherit_errexit 2>/dev/null || true
IFS=$'\n\t'

# Validação do Sed Engine (GNU vs BSD)
IS_GNU_SED=false
if sed --version >/dev/null 2>&1; then
    IS_GNU_SED=true
fi

safe_sed_inplace() {
    local script="$1"
    local target_file="$2"
    if [ "$IS_GNU_SED" = true ]; then
        sed -i -e "$script" "$target_file"
    else
        sed -i '' -e "$script" "$target_file"
    fi
}

declare -A UI_DICTIONARY=(
    ["PRIVACY_POLICY"]="POLÍTICA DE PRIVACIDADE"
    ["ALL_LOGS"]="TODOS OS LOGS"
    ["RETURN_HOME"]="VOLTAR AO INÍCIO"
    ["UP_TO_TOP"]="SUBIR AO TOPO"
    ["SEARCH"]="BUSCAR"
)

process_front_matter() {
    local file="$1"
    local filename
    filename=$(basename "$file")

    local title=""
    local slug=""

    case "$filename" in
        "privacy.md"|"privacy_policy.md")
            title="Política de Privacidade"
            slug="politica-de-privacidade"
            ;;
        "about.md"|"sobre.md")
            title="Sobre o Autor"
            slug="sobre"
            ;;
        "logs.md")
            title="Logs do Sistema"
            slug="logs"
            ;;
        *)
            return 0
            ;;
    esac

    echo "[INFO] Ajustando metadados de: $file"

    safe_sed_inplace "s/title:[[:space:]]*.*/title: \"$title\"/g" "$file"
    safe_sed_inplace "s/title[[:space:]]*=[[:space:]]*.*/title = \"$title\"/g" "$file"

    if ! grep -qEi "(slug:[[:space:]]*|slug[[:space:]]*=)" "$file"; then
        if grep -q "^---" "$file"; then
            safe_sed_inplace "s/^---$/---\nslug: \"$slug\"/" "$file"
        elif grep -q "^\+\+\+" "$file"; then
            safe_sed_inplace "s/^\+\+\+$/\+\+\+\nslug = \"$slug\"/" "$file"
        fi
    else
        safe_sed_inplace "s/slug:[[:space:]]*.*/slug: \"$slug\"/g" "$file"
        safe_sed_inplace "s/slug[[:space:]]*=[[:space:]]*.*/slug = \"$slug\"/g" "$file"
    fi
}

# Processamento de conteúdo
if [ -d "content" ]; then
    while IFS= read -r -d '' md_file; do
        process_front_matter "$md_file"
    done < <(find content -type f -name "*.md" -print0)
fi

# Processamento de layouts
if [ -d "layouts" ]; then
    for target_key in "${!UI_DICTIONARY[@]}"; do
        replaced_val="${UI_DICTIONARY[$target_key]}"
        while IFS= read -r -d '' tpl_file; do
            safe_sed_inplace "s/$target_key/$replaced_val/g" "$tpl_file"
        done < <(find layouts/ -type f \( -name "*.html" -o -name "*.xml" \) -print0)
    done
fi

# Auditoria de Build
if command -v hugo &> /dev/null; then
    hugo --minify --gc --cleanDestinationDir
fi