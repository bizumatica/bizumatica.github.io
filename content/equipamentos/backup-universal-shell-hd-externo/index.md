---
title: "Backup Universal Shell Hd Externo"
date: 2026-03-18T18:15:07-03:00
draft: false
slug: ""

product:
  name: ""
  current_price: 0
  currency: "BRL"
  pros: []
  cons: []

# Aqui entra a lista de afiliados que o Shortcode vai percorrer
affiliate:
  - store: "Amazon"
    link: ""
  - store: "MercadoLivre"
    link: ""
---

No Bizumática, seguimos a regra: **"quem tem um, não tem nenhum"**. Se seus dados sensíveis estão apenas no SSD do seu notebook, você está a uma pane elétrica do desastre. 

Abaixo, entrego um script universal e a estratégia de hardware para profissionais que não podem perder prazos ou contratos.

## 01. O Script: Backup Tarball Automatizado

Este script empacota seus documentos em um arquivo `.tar.gz` datado. É a forma mais limpa de garantir integridade via terminal.

```bash
#!/bin/bash
# Backup Universal - Bizumática
ORIGEM="$HOME/documentos"
DESTINO="/media/$USER/BACKUP_EXTERNO" # <-- Mantenha fora do PC
DATA=$(date +"%Y-%m-%d_%H-%M")
ARQUIVO="backup_$DATA.tar.gz"

mkdir -p "$DESTINO"
tar -czvf "$DESTINO/$ARQUIVO" "$ORIGEM" > /dev/null 2>&1 && \
echo "✅ Sucesso: $DESTINO/$ARQUIVO" || echo "❌ Erro no backup"
```

{{< bizu >}}
> **Dica Windows:** Se usa WSL2, seu HD externo estará em `/mnt/d/`. No PowerShell nativo, use: `Compress-Archive -Path $HOME\Documents -DestinationPath D:\backup.zip`.
{{< /bizu >}}

## 02. Curadoria Bizumática: Onde salvar?

### 🛡️ 1. Seagate Expansion 2TB
O clássico para backups frios.
## Onde adquirir
<!-- Insiro o links.html aqui -->{{< links />}}
{{< compra name="Seagate Expansion" price="459.0" img="seagate.webp" link="https://amzn.to/link-seagate" >}}

### ⚡ 2. Samsung T7 SSD
Velocidade extrema para backups diários.
<!-- Insiro o links.html aqui -->{{< links />}}
{{< compra name="Samsung T7 SSD" price="890.0" img="samsung.webp" link="https://amzn.to/link-samsung" >}}

{{< compra >}}

## 03. O Gargalo e a Automação
Ao gerar backups diários, seu SSD interno lotaria em semanas. O **HD Externo** resolve o espaço e a segurança física (contra furtos ou panes).

**Dica Pro:** Automatize. Digite `crontab -e` e adicione a linha abaixo para rodar o script todo dia às 20h:
```bash
00 20 * * * /caminho/do/seu/script.sh
```

{{< links >}}Apoie o site comprando aqui 😊{{< /links >}}
```