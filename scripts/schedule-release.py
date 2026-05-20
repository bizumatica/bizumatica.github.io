#!/usr/bin/env python3
import os
import re
import shutil
from datetime import datetime

# Configuração dos Diretórios Base do Hugo
FILA_DIR = "content/agendados"
SECOES = {
    "posts": "content/posts",
    "matematica": "content/matematica",
    "equipamentos": "content/equipamentos"
}

# Garante a existência da pasta de rascunhos localmente
os.makedirs(FILA_DIR, exist_ok=True)

# Data atual do sistema para a esteira de CI/CD (2026)
hoje = datetime.now()

print(f"--> [Cron] Analisando Leaf Bundles e Ativos de Mídia (foto.html)...")
print(f"--> [Cron] Data Atual de Verificação: {hoje.strftime('%d/%m/%Y')}\n")

# Processa cada pasta (Leaf Bundle) na fila de agendamento
for nome_pasta in os.listdir(FILA_DIR):
    caminho_pasta = os.path.join(FILA_DIR, nome_pasta)
    
    if not os.path.isdir(caminho_pasta):
        continue
        
    arquivo_index = os.path.join(caminho_pasta, "index.md")
    
    if not os.path.exists(arquivo_index):
        print(f"  [AVISO] Ignorando '{nome_pasta}': arquivo 'index.md' não encontrado.")
        continue
        
    with open(arquivo_index, "r", encoding="utf-8") as f:
        conteudo = f.read()
        
    # Extração de Metadados do Front Matter via Regex
    match_date = re.search(r"date:\s*['\"]?([^'\"]+)", conteudo)
    match_type = re.search(r"type:\s*['\"]?([^'\"\s]+)", conteudo)
    match_cat = re.search(r"categories:\s*\[\"([^\"]+)\"\]", conteudo)
    
    if not match_date:
        print(f"  [ERRO] Impossível agendar '{nome_pasta}': ausência da chave 'date' no Front Matter.")
        continue
        
    try:
        # Isola o ano, mês e dia para comparação objetiva
        data_limpa = match_date.group(1).split("T")[0]
        data_post = datetime.strptime(data_limpa, "%Y-%m-%d")
        
        if data_post <= hoje:
            # 1. Contabiliza ativos de mídia associados ao shortcode foto.html
            arquivos_pasta = os.listdir(caminho_pasta)
            ativos_midia = [arq for arq in arquivos_pasta if arq.lower().endswith(('.webp', '.png', '.jpg', '.jpeg', '.gif'))]
            qtd_midia = len(ativos_midia)
            
            print(f"  [+] Liberando: {nome_pasta} | Data: {data_limpa}")
            print(f"      └─ Ativos para foto.html detectados: {qtd_midia} arquivo(s) de imagem.")
            
            # 2. Altera o estado do rascunho de 'true' para 'false'
            conteudo_modificado = re.sub(r"draft:\s*true", "draft: false", conteudo)
            with open(arquivo_index, "w", encoding="utf-8") as f:
                f.write(conteudo_modificado)
            
            # 3. Roteamento inteligente de seção (Type > Category > Padrão posts)
            destino_secao = SECOES["posts"] # Fallback padrão
            
            if match_type:
                tipo = match_type.group(1).lower()
                if tipo in SECOES:
                    destino_secao = SECOES[tipo]
            elif match_cat:
                categoria = match_cat.group(1).lower()
                if "matematica" in categoria or "matemática" in categoria:
                    destino_secao = SECOES["matematica"]
                elif "equipamentos" in categoria:
                    destino_secao = SECOES["equipamentos"]
            
            caminho_destino = os.path.join(destino_secao, nome_pasta)
            
            # 4. Movimentação atômica do bloco completo (Prevenção de colisões)
            if os.path.exists(caminho_destino):
                shutil.rmtree(caminho_destino)
                
            shutil.move(caminho_pasta, destino_secao)
            print(f"      └─ Bundle movido com sucesso para: {destino_secao}/{nome_pasta}\n")
            
        else:
            print(f"  [-] Retido em cache: {nome_pasta} (Agendado para: {data_limpa})")
            
    except Exception as e:
        print(f"  [ERRO] Falha crítica ao processar o bundle '{nome_pasta}': {e}")