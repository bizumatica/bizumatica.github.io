import pandas as pd
import yaml
import os
import requests
import io
from datetime import datetime

# --- CONFIGURAÇÃO ---
URL_SHEETS_CSV = "SUA_URL_AQUI" 
ARQUIVO_LOCAL = "produtos_sheets.csv"
OUTPUT_DIR = "content/equipamentos"

if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

def carregar_dados():
    try:
        print(f"--> Tentando baixar dados da nuvem...")
        response = requests.get(URL_SHEETS_CSV, timeout=10)
        response.raise_for_status()
        return pd.read_csv(io.StringIO(response.content.decode('utf-8')))
    except Exception as e:
        print(f"--> Falha ao acessar nuvem: {e}")
        
    if os.path.exists(ARQUIVO_LOCAL):
        print(f"--> Usando arquivo local: {ARQUIVO_LOCAL}")
        return pd.read_csv(ARQUIVO_LOCAL)
    
    return None

def create_hugo_file(row):
    # Slug sanitation
    slug = str(row['slug']).strip().lower()
    filename = os.path.join(OUTPUT_DIR, f"{slug}.md")
    
    # Montagem Dinâmica da Lista de Afiliados
    affiliate_links = []
    
    # Amazon (Link Principal)
    if pd.notna(row.get('link_afiliado')):
        affiliate_links.append({
            'store': 'Amazon',
            'link': str(row['link_afiliado']).strip()
        })
    
    # Mercado Livre (Novo campo)
    if 'link_ml' in row and pd.notna(row['link_ml']):
        affiliate_links.append({
            'store': 'MercadoLivre',
            'link': str(row['link_ml']).strip()
        })

    # AliExpress ou outros (Opcional - segue a mesma lógica)
    if 'link_ali' in row and pd.notna(row['link_ali']):
        affiliate_links.append({
            'store': 'AliExpress',
            'link': str(row['link_ali']).strip()
        })

    front_matter = {
        'title': row['nome'],
        'date': datetime.now().strftime('%Y-%m-%dT%H:%M:%S-03:00'),
        'draft': False,
        'slug': slug,
        'product': {
            'name': row['nome'],
            'current_price': float(row['preco']),
            'currency': 'BRL',
            'pros': [p.strip() for p in str(row['pros']).split(',') if p.strip()],
            'cons': [c.strip() for c in str(row['cons']).split(',') if c.strip()]
        },
        'affiliate': affiliate_links # Agora é uma lista de objetos
    }
    
    # dump com sort_keys=False mantém a ordem que definimos acima
    yaml_block = yaml.dump(front_matter, allow_unicode=True, sort_keys=False)
    content = f"---\n{yaml_block}---\n\n{row['review_curto']}\n\n{{{{< compra >}}}}"
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)

# Execução Principal
df = carregar_dados()

if df is not None:
    # Remove linhas onde o slug está vazio (evita erros)
    df = df.dropna(subset=['slug'])
    for index, row in df.iterrows():
        create_hugo_file(row)
    print(f"✓ Processamento de {len(df)} produtos finalizado.")
else:
    print("❌ Erro: Nenhuma fonte de dados encontrada.")
    exit(1)