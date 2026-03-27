---
title: "XFCE: Indicador de Caps Lock via Terminal"
date: 2026-03-26T10:00:00-03:00
draft: false
author: "Julio Prata"
description: "Script em Bash que monitora o estado do Caps Lock e envia notificações via notify-send."
categories: ["Shell Scripting"]
tags: ["linux", "xfce", "bash", "produtividade", "foss"]
---

> **LOG_LEVEL:** INFO  
> **DEPENDÊNCIAS:** `xset` (leitura de hardware) e `libnotify` (alertas visuais).

Se você usa um teclado minimalista ou o XFCE em uma distro como o Debian ou Arch, às vezes sente falta de um aviso visual quando o **Caps Lock** é ativado acidentalmente. Este script resolve isso monitorando o estado da tecla em loop e disparando um OSD (On-Screen Display).

### O Script: `caps_monitor.sh`

Este script roda em segundo plano, consumindo o mínimo de CPU, e só envia a notificação quando detecta uma mudança de estado.

```bash
#!/bin/bash

# Estado inicial
ULTIMO_ESTADO=""

while true; do
    # Extrai o status do Caps Lock (on ou off) usando xset
    ESTADO_ATUAL=$(xset q | grep "Caps Lock" | awk '{print $4}')

    # Só dispara a notificação se o estado mudou
    if [ "$ESTADO_ATUAL" != "$ULTIMO_ESTADO" ]; then
        if [ "$ESTADO_ATUAL" == "on" ]; then
            notify-send "CAPS LOCK: ATIVADO" "Cuidado, você está gritando!" -i keyboard -t 2000 -u critical
        else
            notify-send "CAPS LOCK: DESATIVADO" "De volta ao normal." -i keyboard -t 2000
        fi
        ULTIMO_ESTADO=$ESTADO_ATUAL
    fi
    
    # Delay de 0.5s para não sobrecarregar o processador
    sleep 0.5
done
```

### Implementação no Sistema

Para que o indicador funcione sempre que você ligar o computador, siga estes passos:

1.  **Dar permissão de execução:**
    Salve o código acima em uma pasta de sua preferência (ex: `~/scripts/caps_monitor.sh`) e execute:
    ```bash
    chmod +x ~/scripts/caps_monitor.sh
    ```

2.  **Adicionar ao Início de Sessão do XFCE:**
    * Abra o menu e vá em **Configurações** > **Sessão e Inicialização**.
    * Clique na aba **Início automático de aplicativos**.
    * Clique no botão **+ Adicionar**.
    * Preencha os campos:
        * **Nome:** `Caps Lock Indicator`
        * **Comando:** `/home/seu_usuario/scripts/caps_monitor.sh` (use o caminho completo).
    * Clique em OK.

### Resultado Esperado

Ao pressionar a tecla, um banner elegante aparecerá no canto da tela (seguindo o tema do seu sistema). Se estiver usando o tema **Tokyo Night**, a notificação terá o brilho ciano/azul característico do seu terminal.

---
**Bizu de Terminal:** Se quiser que a notificação seja persistente (não suma sozinha), altere o parâmetro `-t 2000` para `-t 0`. 😎
