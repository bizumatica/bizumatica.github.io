import pandas as pd
import yaml
import os
import requests
import io
from datetime import datetime
from PIL import Image

# --- CONFIGURAÇÃO ---
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
URL_SHEETS_CSV = "https://docs.google.com/spreadsheets/d/18ipD4FyXPZxYpv89uk56bbfTK1Bp1Qb2jQplDwxAblo/export?format=csv"
ARQUIVO_LOCAL = os.path.join(BASE_DIR, "assets/produtos_sheets.csv")
CONTENT_DIR = os.path.join(BASE_DIR, "content")

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    'Accept': 'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8'
}

def carregar_dados():
    try:
        print(f"--> [Nuvem] Sincronizando com Google Sheets...")
        response = requests.get(URL_SHEETS_CSV, timeout=15)
        response.raise_for_status()
        df = pd.read_csv(io.StringIO(response.content.decode('utf-8')))
        
        # BLINDAGEM 1: Remove espaços invisíveis dos nomes das colunas (Ex: "link_afiliado ")
        df.columns = df.columns.str.strip() 
        
        os.makedirs(os.path.dirname(ARQUIVO_LOCAL), exist_ok=True)
        df.to_csv(ARQUIVO_LOCAL, index=False)
        return df
    except Exception as e:
        print(f"--> [Aviso] Usando cache local: {e}")
        return pd.read_csv(ARQUIVO_LOCAL) if os.path.exists(ARQUIVO_LOCAL) else None

def baixar_imagem(url, diretorio, slug):
    if not url or pd.isna(url) or not str(url).startswith('http'):
        return None
    nome_base = f"prod-{slug}"
    caminho_webp = os.path.join(diretorio, f"{nome_base}.webp")
    if os.path.exists(caminho_webp):
        return nome_base
    ext = ".jpg"
    clean_url = url.split('?')[0].lower()
    for e in ['.png', '.webp', '.jpeg', '.jpg']:
        if clean_url.endswith(e):
            ext = e
            break
    caminho_temp = os.path.join(diretorio, nome_base + ext)
    try:
        res = requests.get(url, headers=HEADERS, timeout=20, allow_redirects=True)
        res.raise_for_status()
        with open(caminho_temp, 'wb') as f:
            f.write(res.content)
        return nome_base, caminho_temp
    except Exception:
        return None

def processar_e_limpar(diretorio, info_imagem):
    if not info_imagem or not isinstance(info_imagem, tuple):
        return
    nome_base, caminho_temp = info_imagem
    caminho_webp = os.path.join(diretorio, f"{nome_base}.webp")
    try:
        with Image.open(caminho_temp) as img:
            formato_saida = "RGB" if img.mode != "RGBA" else "RGBA"
            img.convert(formato_saida).save(caminho_webp, "WEBP", quality=85, method=6)
        if os.path.exists(caminho_temp):
            os.remove(caminho_temp)
    except: pass
    for f in os.listdir(diretorio):
        if "featured_raw" in f:
            try: os.remove(os.path.join(diretorio, f))
            except: pass

def create_hugo_bundle(row):
    secao = str(row.get('secao', 'equipamentos')).strip().lower()
    slug = str(row.get('slug', '')).strip().lower()
    bundle_dir = os.path.join(CONTENT_DIR, secao, slug)
    arquivo_path = os.path.join(bundle_dir, "index.md")
    os.makedirs(bundle_dir, exist_ok=True)
    
    agora = datetime.now().strftime('%Y-%m-%dT%H:%M:%S-03:00')
    data_final = agora

    # PRESERVAÇÃO DE DATA (Não sobe pro topo da Home)
    if os.path.exists(arquivo_path):
        try:
            with open(arquivo_path, 'r', encoding='utf-8') as f:
                for line in f:
                    if line.startswith('date:'):
                        data_final = line.replace('date:', '').strip().strip("'").strip('"')
                        break
        except: pass

    # IMAGEM
    dados_img = baixar_imagem(row.get('foto'), bundle_dir, slug)
    if isinstance(dados_img, tuple):
        processar_e_limpar(bundle_dir, dados_img)
        nome_img_final = dados_img[0]
    else:
        nome_img_final = f"prod-{slug}" if os.path.exists(os.path.join(bundle_dir, f"prod-{slug}.webp")) else ""

    # --- BLINDAGEM 2: LÓGICA DE AFILIADOS EXTREMA ---
    links = []
    melhor_loja = str(row.get('melhor_loja', '')).strip().lower()
    lojas = [('Amazon', 'link_afiliado'), ('MercadoLivre', 'link_ml'), ('AliExpress', 'link_ali'), ('Hotmart', 'link_hotmart')]

    for nome_loja, coluna in lojas:
        if coluna in row.index:
            valor_celula = row[coluna]
            if pd.notna(valor_celula):
                url = str(valor_celula).strip()
                if url and url.lower() not in ['nan', 'none', 'null', '']:
                    links.append({
                        'store': nome_loja,
                        'link': url,
                        'best_deal': (nome_loja.lower() == melhor_loja)
                    })
                    print(f"      [+] Link {nome_loja} extraído!")

    if not links:
        print(f"      [!] AVISO: Nenhum link válido achado para {slug}.")

    try:
        preco_raw = str(row.get('preco', '0')).replace('.', '').replace(',', '.')
        preco_float = float(preco_raw)
    except:
        preco_float = 0.0

    front_matter = {
        'title': str(row.get('nome', '')),
        'date': data_final,
        'last_check': agora,
        'draft': False,
        'slug': slug,
        'type': secao,
        'product': {
            'name': str(row.get('nome', '')),
            'current_price': preco_float,
            'pros': [p.strip().capitalize() for p in str(row.get('pros', '')).replace('PROS:', '').split(',') if p.strip() and p.lower() != 'nan'],
            'cons': [c.strip().capitalize() for c in str(row.get('cons', '')).replace('CONS:', '').split(',') if c.strip() and c.lower() != 'nan']
        },
        'affiliate': links
    }

    img_attr = f' img="{nome_img_final}"' if nome_img_final else ""
    review = row.get('review_curto', '') if pd.notna(row.get('review_curto')) else ""
    
    content = f"---\n{yaml.dump(front_matter, allow_unicode=True, sort_keys=False)}---\n\n{review}\n\n{{{{< compra{img_attr} >}}}}"
    
    with open(arquivo_path, 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == "__main__":
    df = carregar_dados()
    if df is not None:
        df = df.dropna(subset=['slug'])
        for _, row in df.iterrows():
            slug = str(row['slug']).strip()
            if not slug or slug.startswith('#'): continue
            print(f"--> Processando: {slug}")
            create_hugo_bundle(row)
        print("\n✓ Finalizado. Verifique os logs de '[+] Link' acima.")