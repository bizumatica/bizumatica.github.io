#!/bin/bash
# Author: Julio Prata | Version: 1.0
# Uso: ./add-product.sh slug "Nome" "Preco" "Link" "Pros" "Cons" "Foto"

CSV="produtos_sheets.csv"

# Verifica se o slug já existe para não duplicar
if grep -q "$1" "$CSV"; then
    echo "Erro: Produto $1 já existe no CSV."
else
    echo "$1,$2,$3,$4,,$5,$6,Review via Terminal,$7" >> $CSV
    echo "✓ Produto $2 adicionado ao CSV!"
fi