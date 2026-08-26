---
title: "XFCE: Indicador de Caps Lock via Terminal"
date: 2026-03-26T10:00:00-03:00
last_check: '2026-05-20T15:20:00-03:00'
draft: false
author: "Julio Prata"
description: "Script em Bash que monitora o estado do Caps Lock e envia notificações via notify-send."
categories: ["Shell Scripting"]
tags: ["linux", "xfce", "bash", "produtividade", "foss"]
slug: xfce-indicador-caps-lock-terminal
type: posts
---

> **LOG_LEVEL:** INFO  
> **AMBIENTE:** XFCE Desktop / Window Managers Autónomos

Se você usa um teclado mecânico minimalista (60% ou 65%) ou uma interface ultra-leve como o XFCE no Debian ou Arch Linux, certamente sente falta de um aviso visual claro quando o **Caps Lock** é ativado acidentamente. Este script resolve o problema em nível de usuário, monitorando o estado do hardware em loop e disparando um OSD (*On-Screen Display*).

---

## Engenharia do Monitoramento

Abaixo estão descritos os pilares de funcionamento da ferramenta. O bloco foi estruturado para rápida auditoria das dependências do sistema.

{{% grid-regras %}}

  {{% card-regra numero="01" titulo="Leitura de Hardware" cor="#00ffff" %}}
O script utiliza o utilitário `xset q` para interrogar o servidor gráfico X11 diretamente sobre o estado dos LEDs do teclado, filtrando a resposta via `awk`.
  {{% /card-regra %}}

  {{% card-regra numero="02" titulo="Mecanismo de Despacho" cor="#bb9af3" %}}
A biblioteca `libnotify` (via comando `notify-send`) é encarregada de injetar o alerta visual no daemon de notificações do XFCE de forma assíncrona.
  {{% /card-regra %}}

  {{% card-regra numero="03" titulo="Otimização de CPU" cor="#9ece6a" %}}
O polling possui uma trava temporal de segurança (`sleep 0.5`). O consumo de processamento é virtualmente nulo ($< 0.1\%$ de uma CPU moderna).
  {{% /card-regra %}}

{{% /grid-regras %}}

---

### O Script: `caps_monitor.sh`

O algoritmo opera sob uma máquina de estados simples: ele armazena o último status conhecido em uma variável interna e **só dispara a chamada de sistema do banner se detectar uma alternância** no binário da flag.

```bash
#!/usr/bin/env bash

# ==============================================================================
# Script: caps_monitor.sh
# Descrição: Monitor leve de Caps Lock para ambientes X11
# ==============================================================================

# Estado inicial (Nulo para forçar a primeira validação)
ULTIMO_ESTADO=""

while true; do
    # Extrai o status do Caps Lock (on ou off) decodificando a saída do xset
    ESTADO_ATUAL=$(xset q | grep "Caps Lock" | awk '{print $4}')

    # Só dispara a notificação se houver transição de estado
    if [ "$ESTADO_ATUAL" != "$ULTIMO_ESTADO" ]; then
        if [ "$ESTADO_ATUAL" == "on" ]; then
            notify-send "CAPS LOCK: ATIVADO" "Cuidado, você está gritando!" \
                -i keyboard -t 2000 -u critical
        else
            notify-send "CAPS LOCK: DESATIVADO" "De volta ao normal." \
                -i keyboard -t 2000
        fi
        ULTIMO_ESTADO="$ESTADO_ATUAL"
    fi
    
    # Delay de 0.5s garante resiliência e previne race conditions
    sleep 0.5
done

```

---

## Implementação no Sistema

Para instalar a rotina no seu perfil de usuário e garantir a execução persistente a cada boot, execute o procedimento operacional padrão abaixo:

### 1. Permissões de Execução

Salve o arquivo de código em uma pasta local estruturada para scripts pessoais (recomenda-se criar um diretório centralizado para automações):

```bash
mkdir -p ~/scripts
# Salve o código em ~/scripts/caps_monitor.sh
chmod +x ~/scripts/caps_monitor.sh

```

### 2. Autostart no XFCE

Para emular o comportamento de um serviço de sistema do Systemd sem a complexidade de gerenciar arquivos `.service`, configure o gatilho na própria sessão gráfica:

{{% grid-regras %}}

{{% card-regra numero="I" titulo="Painel de Controle" cor="#e0af68" %}}

* Acesse o menu principal do sistema e navegue até **Configurações** $\rightarrow$ **Sessão e Inicialização**.
* Selecione a aba **Início automático de aplicativos**.
{{% /card-regra %}}
{{% card-regra numero="II" titulo="Gatilho de Boot" cor="#ff9e64" %}}
* Clique no botão **+ Adicionar** e defina os parâmetros:
* **Nome:** `Caps Lock Indicator`
* **Comando:** `/home/seu_usuario/scripts/caps_monitor.sh` *(Sempre declare o caminho absoluto)*.
{{% /card-regra %}}



{{% /grid-regras %}}

---

## Resultado Esperado e Customização

Ao alternar o estado do Caps Lock, um banner minimalista será renderizado no corner configurado do seu monitor. Se você utiliza uma folha de estilos integrada ao tema **Tokyo Night** nas suas janelas, a notificação herdará o esquema de cores escuro com bordas cirúrgicas automaticamente.

> 💡 **Bizu de Terminal:** Se você trabalha em ambientes de monitoramento contínuo e prefere que o aviso visual seja persistente (exigindo um clique manual para fechar), altere a flag temporal de milissegundos `-t 2000` para `-t 0` dentro das condicionais do script.