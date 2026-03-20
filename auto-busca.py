import pandas as pd
import yaml
import os
import requests
import io
from datetime import datetime
from PIL import Image

# --- CONFIGURAÇÃO ---
URL_SHEETS_CSV = "https://docs.google.com/spreadsheets/d/18ipD4FyXPZxYpv89uk56bbfTK1Bp1Qb2jQplDwxAblo/export?format=csv"
ARQUIVO_LOCAL = "assets/produtos_sheets.csv" 
CONTENT_DIR = "content"

def carregar_dados():
    try:
        print(f"--> Tentando baixar dados da nuvem...")
        response = requests.get(URL_SHEETS_CSV, timeout=10)
        response.raise_for_status()
        df = pd.read_csv(io.StringIO(response.content.decode('utf-8')))
        if not os.path.exists("assets"): os.makedirs("assets")
        df.to_csv(ARQUIVO_LOCAL, index=False)
        return df
    except Exception as e:
        print(f"--> Falha ao acessar nuvem: {e}")
        if os.path.exists(ARQUIVO_LOCAL):
            print(f"--> Usando arquivo local: {ARQUIVO_LOCAL}")
            return pd.read_csv(ARQUIVO_LOCAL)
    return None

def otimizar_imagens_bundle(diretorio_bundle):
    """Varre a pasta do bundle e converte PNG/JPG para WebP"""
    for arquivo in os.listdir(diretorio_bundle):
        if arquivo.lower().endswith(('.png', '.jpg', '.jpeg')):
            caminho_original = os.path.join(diretorio_bundle, arquivo)
            nome_sem_ext = os.path.splitext(arquivo)[0]
            caminho_webp = os.path.join(diretorio_bundle, f"{nome_sem_ext}.webp")
            
            try:
                with Image.open(caminho_original) as img:
                    # Converte para RGB/RGBA dependendo da transparência
                    if img.mode in ("RGBA", "P"):
                        img = img.convert("RGBA")
                    else:
                        img = img.convert("RGB")
                    
                    img.save(caminho_webp, "WEBP", quality=85)
                    print(f"    📸 Otimizado: {arquivo} -> {nome_sem_ext}.webp")
                
                # Remove o original após a conversão bem sucedida
                os.remove(caminho_original)
            except Exception as e:
                print(f"    ⚠️ Erro ao converter {arquivo}: {e}")

def create_hugo_bundle(row):
    # 1. Define a seção baseado na planilha (fallback para equipamentos)
    secao = str(row.get('secao', 'equipamentos')).strip().lower()
    slug = str(row['slug']).strip().lower()
    
    # 2. Caminho do BUNDLE: content/secao/slug/
    bundle_dir = os.path.join(CONTENT_DIR, secao, slug)
    if not os.path.exists(bundle_dir):
        os.makedirs(bundle_dir)
    
    filename = os.path.join(bundle_dir, "index.md")

    # Montagem de Afiliados
    affiliate_links = []
    for store, col in [('Amazon', 'link_afiliado'), ('MercadoLivre', 'link_ml'), ('AliExpress', 'link_ali')]:
        if col in row and pd.notna(row[col]):
            affiliate_links.append({'store': store, 'link': str(row[col]).strip()})

    front_matter = {
        'title': row['nome'],
        'date': datetime.now().strftime('%Y-%m-%dT%H:%M:%S-03:00'),
        'draft': False,
        'slug': slug,
        'type': secao,
        'product': {
            'name': row['nome'],
            'current_price': float(row['preco']),
            'currency': 'BRL',
            'pros': [p.strip() for p in str(row.get('pros', '')).split(',') if p.strip()],
            'cons': [c.strip() for c in str(row.get('cons', '')).split(',') if c.strip()]
        },
        'affiliate': affiliate_links
    }
    
    yaml_block = yaml.dump(front_matter, allow_unicode=True, sort_keys=False)
    content = f"---\n{yaml_block}---\n\n{row.get('review_curto', '')}\n\n{{{{< compra >}}}}"
    
    # 3. Escreve o index.md
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
    
    # 4. Busca e converte imagens na pasta do post
    otimizar_imagens_bundle(bundle_dir)

# Execução Principal
df = carregar_dados()

if df is not None:
    df = df.dropna(subset=['slug'])
    print(f"--> Iniciando processamento de {len(df)} itens...")
    for index, row in df.iterrows():
        create_hugo_bundle(row)
    print(f"✓ Finalizado com sucesso.")
else:
    print("❌ Erro: Nenhuma fonte de dados encontrada.")