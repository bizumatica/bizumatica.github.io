#!/usr/bin/env python3
# ==============================================================================
# Author: Julio Prata
# Version: 3.12 (Isolated Global Backup + Multi-Format Front Matter Engine)
# ==============================================================================
import os
import re
import shutil
from datetime import datetime

# Configuração dos Diretórios Base do Hugo
FILA_DIR = "content/agendados"
BACKUP_GLOBAL_DIR = ".deploy_backups"  # Isola os backups fora de content/

SECOES = {
    "posts": "content/posts",
    "matematica": "content/matematica",
    "equipamentos": "content/equipamentos"
}

# Garante a existência das pastas estruturais localmente
os.makedirs(FILA_DIR, exist_ok=True)
os.makedirs(BACKUP_GLOBAL_DIR, exist_ok=True)

# Data atual do sistema para a esteira de CI/CD (Ambiente 2026)
hoje = datetime.now()

print(f"--> [Cron] Analisando Leaf Bundles e Ativos de Mídia (foto.html)...")
print(f"--> [Cron] Data Atual de Verificação: {hoje.strftime('%d/%m/%Y')}\n")

# Processa cada pasta (Leaf Bundle) na fila de agendamento
for nome_pasta in os.listdir(FILA_DIR):
    caminho_pasta = os.path.join(FILA_DIR, nome_pasta)
    
    # Ignora arquivos soltos na raiz de agendados, processa apenas diretórios (Bundles)
    if not os.path.isdir(caminho_pasta):
        continue
        
    arquivo_index = os.path.join(caminho_pasta, "index.md")
    
    if not os.path.exists(arquivo_index):
        print(f"  [AVISO] Ignorando '{nome_pasta}': arquivo 'index.md' não encontrado.")
        continue
        
    with open(arquivo_index, "r", encoding="utf-8") as f:
        conteudo = f.read()

    # Isolar o Front Matter para validação estrita (Prevenção de mutação no corpo do post)
    front_matter = ""
    is_toml = False
    is_yaml = False
    
    partes_toml = conteudo.split("+++", 2)
    partes_yaml = conteudo.split("---", 2)
    
    if len(partes_toml) >= 3:
        front_matter = partes_toml[1]
        is_toml = True
    elif len(partes_yaml) >= 3:
        front_matter = partes_yaml[1]
        is_yaml = True
    else:
        front_matter = conteudo  # Fallback tolerante

    # Regex híbrida: Captura 'key: value' (YAML) e 'key = value' (TOML) limpando ruídos
    match_date = re.search(r"date\s*[:=]\s*['\"]?([^'\"]+)", front_matter)
    match_type = re.search(r"type\s*[:=]\s*['\"]?([^'\"\s]+)", front_matter)
    
    if not match_date:
        print(f"  [ERRO] Impossível agendar '{nome_pasta}': ausência da chave 'date' no Front Matter.")
        continue
        
    try:
        # Isola ano-mês-dia e expurga caracteres residuais de fusos horários
        data_limpa = match_date.group(1).split("T")[0].strip("'\" ")
        data_post = datetime.strptime(data_limpa, "%Y-%m-%d")
        
        if data_post <= hoje:
            # 1. Contabiliza ativos de mídia vinculados ao shortcode customizado foto.html
            arquivos_pasta = os.listdir(caminho_pasta)
            ativos_midia = [arq for arq in arquivos_pasta if arq.lower().endswith(('.webp', '.png', '.jpg', '.jpeg', '.gif'))]
            qtd_midia = len(ativos_midia)
            
            print(f"  [+] Liberando: {nome_pasta} | Data: {data_limpa}")
            print(f"      └─ Ativos para foto.html detectados: {qtd_midia} arquivo(s) de imagem.")
            
            # 2. Altera o estado do rascunho de 'true' para 'false' injetando o dialeto correto
            if is_toml:
                front_matter_modificado = re.sub(r"draft\s*=\s*true", "draft = false", front_matter)
                conteudo_modificado = f"+++{front_matter_modificado}+++{partes_toml[2]}"
            elif is_yaml:
                front_matter_modificado = re.sub(r"draft\s*:\s*true", "draft: false", front_matter)
                conteudo_modificado = f"---{front_matter_modificado}---{partes_yaml[2]}"
            else:
                conteudo_modificado = re.sub(r"draft\s*[:=]\s*true", "draft: false", conteudo, count=1)
                
            with open(arquivo_index, "w", encoding="utf-8") as f:
                f.write(conteudo_modificado)
            
            # 3. Roteamento inteligente tolerante a múltiplos formatos de metadados
            destino_secao = SECOES["posts"]  # Destino padrão seguro
            
            if match_type:
                tipo = match_type.group(1).lower().strip("'\" ")
                if tipo in SECOES:
                    destino_secao = SECOES[tipo]
            else:
                # Fallback analítico baseado no bloco do Front Matter completo
                front_matter_lower = front_matter.lower()
                if "matematica" in front_matter_lower or "matemática" in front_matter_lower:
                    destino_secao = SECOES["matematica"]
                elif "equipamentos" in front_matter_lower:
                    destino_secao = SECOES["equipamentos"]
            
            caminho_destino = os.path.join(destino_secao, nome_pasta)
            
            # 4. Isolamento Total do Escopo Git: Encaminha colisões para .deploy_backups/
            if os.path.exists(caminho_destino):
                backup_dir = os.path.join(BACKUP_GLOBAL_DIR, f"{nome_pasta}_backup")
                
                # Destrói rotações obsoletas anteriores antes de criar o backup novo
                if os.path.exists(backup_dir):
                    shutil.rmtree(backup_dir)
                    
                # Move o item antigo do Hugo diretamente para a zona neutra fora de content/
                shutil.move(caminho_destino, backup_dir)
                print(f"      [!] Colisão detectada! Versão anterior movida para: {backup_dir}")
                
            # 5. Escrita limpa do Bundle e expurgo da esteira de entrada
            shutil.copytree(caminho_pasta, caminho_destino, dirs_exist_ok=True)
            shutil.rmtree(caminho_pasta)
            print(f"      └─ Bundle distribuído com sucesso para: {caminho_destino}\n")
            
        else:
            print(f"  [-] Retido em cache: {nome_pasta} (Agendado para: {data_limpa})")
            
    except Exception as e:
        print(f"  [ERRO] Falha crítica ao processar o bundle '{nome_pasta}': {e}")