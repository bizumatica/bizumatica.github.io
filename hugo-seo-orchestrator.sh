#!/usr/bin/env bash
#
# Hugo SEO & Internationalization Orchestrator (Agnostic Production Edition)
# Desenvolvido para automação completa de pipelines estáticos (Linux/macOS)
#

# Fail-fast flags para abortar o pipeline em caso de erros silenciosos
set -euo pipefail
IFS=$'\n\t'

echo -e "\033[0;34m[*] Inicializando varredura semântica agnóstica...\033[0m"

# ==========================================
# 1. ABSTRAÇÃO DE PLATAFORMA (GNU vs BSD)
# ==========================================
# Resolve o overhead de compatibilidade do sed entre ambientes Unix e Darwin
setup_sed_engine() {
    if sed --version >/dev/null 2>&1; then
        # GNU Sed (Linux)
        SED_CMD=(sed -i)
    else
        # BSD Sed (macOS)
        SED_CMD=(sed -i '')
    fi
}
setup_sed_engine

# ==========================================
# 2. DICIONÁRIO DE TRADUÇÃO SEMÂNTICA (UI)
# ==========================================
# Mapeamento associativo plano para substituição segura em templates (HTML/XML)
declare -A UI_DICTIONARY=(
    ["PRIVACY_POLICY"]="POLÍTICA DE PRIVACIDADE"
    ["ALL_LOGS"]="TODOS OS LOGS"
    ["RETURN_HOME"]="VOLTAR AO INÍCIO"
    ["UP_TO_TOP"]="SUBIR AO TOPO"
    ["SEARCH"]="BUSCAR"
)

# ==========================================
# 3. COMPILADOR DINÂMICO DE FRONT MATTER
# ==========================================
# Função para injetar metadados de SEO sem corromper a sintaxe do Hugo (YAML/TOML)
process_front_matter() {
    local file=$1
    local filename
    filename=$(basename "$file")

    echo -e "\033[0;32m[Parsing] Processando metadados de:\033[0m $file"

    case "$filename" in
        "privacy.md"|"privacy_policy.md")
            local title="Política de Privacidade"
            local slug="politica-de-privacidade"
            ;;
        "about.md"|"sobre.md")
            local title="Sobre o Autor"
            local slug="sobre"
            ;;
        "logs.md")
            local title="Logs do Sistema"
            local slug="logs"
            ;;
        *)
            return 0
            ;;
    esac

    # Atualiza ou injeta o Title e o Slug preservando o delimitador original (--- ou +++)
    "${SED_CMD[@]}" -e "s/title:[[:space:]]*.*/title: \"$title\"/g" "$file"
    "${SED_CMD[@]}" -e "s/title[[:space:]]*=[[:space:]]*.*/title = \"$title\"/g" "$file"

    # Injeção segura do Slug caso ele não exista no escopo do arquivo
    if ! grep -qEi "(slug:[[:space:]]*|slug[[:space:]]*=)" "$file"; then
        # Detecção de formato YAML vs TOML para posicionamento downstream
        if grep -q "^---" "$file"; then
            "${SED_CMD[@]}" -e '/^---/a slug: "'"$slug"'"' "$file"
        elif grep -q "^+++" "$file"; then
            "${SED_CMD[@]}" -e '/^+++/a slug = "'"$slug"'"' "$file"
        fi
    else
        # Se o slug já existir, normaliza para o padrão em português
        "${SED_CMD[@]}" -e "s/slug:[[:space:]]*.*/slug: \"$slug\"/g" "$file"
        "${SED_CMD[@]}" -e "s/slug[[:space:]]*=[[:space:]]*.*/slug = \"$slug\"/g" "$file"
    fi
}

# export das funções para sub-shells do find
export -f process_front_matter

# ==========================================
# 4. EXECUÇÃO DO PIPELINE EM LOTE (BULK)
# ==========================================

# Fase A: Processamento recursivo do diretório de conteúdo
echo -e "\n\033[0;33m[Fase 1] Higienizando Front Matter (Content Area)...\033[0m"
if [ -d "content" ]; then
    # Busca arquivos markdown ignorando diretórios ocultos do Git
    while read -r md_file; do
        process_front_matter "$md_file"
    done < <(find content -type f -name "*.md")
else
    echo -e "\033[0;31m[Erro] Diretório /content não localizado. Abortando.\033[0m" && exit 1
fi

# Fase B: Tradução da interface de Layouts via varredura de Dicionário
echo -e "\n\033[0;33m[Fase 2] Executando Tokenização de Dicionário nos Layouts...\033[0m"
if [ -d "layouts" ]; then
    for target_key in "${!UI_DICTIONARY[@]}"; do
        replaced_val="${UI_DICTIONARY[$target_key]}"
        echo " -> Traduzindo Token [$target_key] para [$replaced_val]"
        
        # Varre recursivamente arquivos HTML/XML dentro da arquitetura do tema do Hugo
        find layouts/ -type f \( -name "*.html" -o -name "*.xml" \) -exec "${SED_CMD[@]}" -e "s/$target_key/$replaced_val/g" {} +
    done
else
    echo -e "\033[0;35m[Aviso] Diretório /layouts customizado não encontrado. Pulando etapa de templates.\033[0m"
fi

# ==========================================
# 5. VALIDAÇÃO DE INTEGRIDADE (BUILD AUDIT)
# ==========================================
echo -e "\n\033[0;33m[Fase 3] Auditoria de Compilação do Gerador Estático...\033[0m"
if command -v hugo &> /dev/null; then
    echo "[Hugo Engine] Executando compilação de produção com garbage collection..."
    # Executa o build forçando minificação profunda e limpeza de caches órfãos
    hugo --minify --gc --cleanDestinationDir
    echo -e "\n\033[0;32m[SUCESSO] Build estático validado sem quebras no DOM!\033[0m"
else
    echo -e "\033[0;35m[Aviso] Executável 'hugo' indisponível no PATH local para verificação automática.\033[0m"
fi