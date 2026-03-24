import pandas as pd
import yaml
import os
import requests
import io
from datetime import datetime
from PIL import Image
import re

# --- CONFIGURAÇÃO ---
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
URL_SHEETS_CSV = "https://docs.google.com/spreadsheets/d/18ipD4FyXPZxYpv89uk56bbfTK1Bp1Qb2jQplDwxAblo/export?format=csv"
ARQUIVO_LOCAL = os.path.join(BASE_DIR, "assets/produtos_sheets.csv") 
CONTENT_DIR = os.path.join(BASE_DIR, "content")
HEADERS = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'}

def carregar_dados():
    try:
        print(f"--> [Nuvem] Baixando Google Sheets...")
        response = requests.get(URL_SHEETS_CSV, timeout=15)
        response.raise_for_status()
        df = pd.read_csv(io.StringIO(response.content.decode('utf-8')))
        os.makedirs(os.path.dirname(ARQUIVO_LOCAL), exist_ok=True)
        df.to_csv(ARQUIVO_LOCAL, index=False)
        return df
    except Exception as e:
        print(f"--> [Aviso] Falha na nuvem: {e}")
        return pd.read_csv(ARQUIVO_LOCAL) if os.path.exists(ARQUIVO_LOCAL) else None

def baixar_imagem_externa(url, diretorio_bundle):
    if not url or pd.isna(url) or not str(url).startswith('http'): return None
    nome_arquivo = "featured_raw" + os.path.splitext(url.split('?')[0])[1]
    if len(nome_arquivo) < 5: nome_arquivo = "featured_raw.jpg"
    caminho_destino = os.path.join(diretorio_bundle, nome_arquivo)
    if any(f.startswith("featured_raw") for f in os.listdir(diretorio_bundle)): return None
    try:
        res = requests.get(url, headers=HEADERS, timeout=10)
        res.raise_for_status()
        with open(caminho_destino, 'wb') as f: f.write(res.content)
        return caminho_destino
    except: return None

def otimizar_imagens_bundle(diretorio_bundle):
    for arquivo in os.listdir(diretorio_bundle):
        if arquivo.lower().endswith(('.png', '.jpg', '.jpeg')):
            caminho_original = os.path.join(diretorio_bundle, arquivo)
            caminho_webp = os.path.join(diretorio_bundle, f"{os.path.splitext(arquivo)[0]}.webp")
            if os.path.exists(caminho_webp):
                os.remove(caminho_original)
                continue
            try:
                with Image.open(caminho_original) as img:
                    img = img.convert("RGB") if img.mode != "RGBA" else img.convert("RGBA")
                    img.save(caminho_webp, "WEBP", quality=82, method=6)
                os.remove(caminho_original)
            except: pass

def create_hugo_bundle(row):
    secao = str(row.get('secao', 'equipamentos')).strip().lower()
    slug = str(row['slug']).strip().lower()
    bundle_dir = os.path.join(CONTENT_DIR, secao, slug)
    os.makedirs(bundle_dir, exist_ok=True)
    
    baixar_imagem_externa(row.get('foto'), bundle_dir)

    # Lógica de Afiliados com detecção de Melhor Preço
    affiliate_links = []
    melhor_loja_planilha = str(row.get('melhor_loja', '')).strip().lower()
    
    # Mapeamento de colunas da sua planilha
    stores_map = [
        ('Amazon', 'link_afiliado'),
        ('MercadoLivre', 'link_ml'),
        ('AliExpress', 'link_ali'),
        ('Hotmart', 'link_hotmart')
    ]

    for store_name, col in stores_map:
        link = str(row.get(col, '')).strip()
        if link and link.lower() != 'nan':
            affiliate_links.append({
                'store': store_name,
                'link': link,
                'best_deal': (store_name.lower() == melhor_loja_planilha)
            })

    agora = datetime.now().strftime('%Y-%m-%dT%H:%M:%S-03:00')
    front_matter = {
        'title': row['nome'],
        'date': agora,
        'last_check': agora,
        'draft': False,
        'slug': slug,
        'type': secao,
        'product': {
            'name': row['nome'],
            'current_price': float(row['preco']) if pd.notna(row['preco']) else 0,
            'currency': 'BRL',
            'pros': [p.strip() for p in str(row.get('pros', '')).split(',') if p.strip() and p.lower() != 'nan'],
            'cons': [c.strip() for c in str(row.get('cons', '')).split(',') if c.strip() and c.lower() != 'nan']
        },
        'affiliate': affiliate_links
    }
    
    content = f"---\n{yaml.dump(front_matter, allow_unicode=True, sort_keys=False)}---\n\n{row.get('review_curto', '')}\n\n{{{{< compra >}}}}"
    with open(os.path.join(bundle_dir, "index.md"), 'w', encoding='utf-8') as f: f.write(content)
    otimizar_imagens_bundle(bundle_dir)

if __name__ == "__main__":
    df = carregar_dados()
    if df is not None:
        df = df.dropna(subset=['slug'])
        for _, row in df.iterrows():
            if not str(row['slug']).strip() or str(row['slug']).startswith('#'): continue
            create_hugo_bundle(row)
        print("✓ Bundles processados com Sucesso.")