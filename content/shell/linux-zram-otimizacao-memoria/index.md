---
title: "Linux Travando com Muita Aba Aberta? Como Resolver com ZRAM e Otimização de Kernel"
date: 2026-08-18T18:00:00-03:00
last_check: "2026-08-18T18:50:00-03:00"
draft: false
math: true
slug: "linux-travando-abas-navegador-zram-swap"
type: "posts"
categories: ["linux", "performance", "foss"]
tags: ["zram", "swappiness", "sysctl", "kernel", "ubuntu", "fedora"]
image: "cover-zram-optimization.webp"
---

## O Paradoxo da Memória Moderna e o Colapso do Disk I/O

A arquitetura dos navegadores web contemporâneos evoluiu para ecossistemas de alta densidade computacional. Cada aba aberta em navegadores baseados em Chromium, Firefox ou Brave não representa um simples documento HTML renderizado em tela. Pelo contrário, consiste em uma aplicação isolada operando em um processo independente. Esses processos englobam máquinas virtuais JavaScript (motores V8 ou SpiderMonkey), pipelines de renderização gráfica acelerada por hardware, alocadores de memória dedicados e sandboxes estritas de segurança. Com efeito, o consumo de memória RAM derivado dessa arquitetura escala de forma vertiginosa, ultrapassando com facilidade a capacidade física instalada em estações de trabalho de 8 GB ou 16 GB de RAM.

Quando a demanda total por alocação de memória ultrapassa o limite físico dos módulos RAM instalados, o Gerenciador de Memória Virtual (VMM - *Virtual Memory Manager*) do Kernel Linux é acionado para evitar o colapso imediato do sistema. A salvaguarda nativa padrão do Kernel consiste na ativação da paginação de memória e na movimentação de páginas anônimas para o espaço de *Swap*. Contudo, quando o espaço de Swap reside em unidades de armazenamento secundário convencionais — como SSDs SATA, SSDs NVMe de entrada ou HDDs mecânicos —, o sistema é submetido a uma penalidade devastadora de latência de leitura e escrita.

{{< foto src="ram-disk-io-bottleneck.webp" alt="Gráfico analítico comparando tempos de latência da memória RAM primária contra milissegundos de SSDs e HDDs no barramento de I/O." legenda="O tempo de acesso do barramento de armazenamento secundário é até ordens de grandeza mais lento do que os canais de memória RAM, gerando o fenômeno de thrashing." >}}

Esse gargalo estrutural manifesta-se visualmente no ambiente de desktop como o congelamento da interface gráfica (*desktop freeze*). Durante esse estado de paralisia, o cursor do mouse trava, as janelas param de responder aos eventos do servidor de exibição (Wayland ou Xorg) e o indicador de atividade de disco permanece em uso máximo contínuo. 

Esse fenômeno é tecnicamente denominado *Thrashing* do subsistema de I/O: o Kernel gasta mais ciclos de CPU tentando gerenciar a troca contínua de páginas de $4\text{ KiB}$ entre a RAM e o disco do que efetivamente executando as instruções das aplicações ativas. Por conseguinte, antes mesmo que o mecanismo automático de mitigação por exaustão extrema — o *Out-of-Memory (OOM) Killer* — seja invocado para finalizar o processo ofensor, o usuário se vê forçado a efetuar a reinicialização bruta da máquina.

---

## A Mecânica Interna da ZRAM: Compressão Atômica no Pipeline do Kernel

A solução definitiva para esse dilema infraestrutural não prescinde da substituição física de componentes de hardware ou do investimento financeiro na aquisição de novos módulos de memória. A engenharia do Kernel Linux oferece um recurso algorítmico integrado de altíssima eficiência: o subsistema **ZRAM**.

Originalmente conhecido como *compcache*, o ZRAM é um módulo oficial do Kernel Linux que cria um dispositivo de bloco virtual residente na própria memória RAM primária. Diferente do Swap tradicional gravado em disco, o dispositivo `/dev/zram0` atua como uma fita de armazenamento comprimido em tempo real. As páginas de memória descartadas pelo gerenciador virtual não são enviadas para um dispositivo de armazenamento secundário lento; em vez disso, são submetidas a algoritmos de compressão sem perdas diretamente na CPU e mantidas em um bloco reservado da própria memória física.

{{< box tipo="teorema" titulo="ARQUITETURA DE ALOCAÇÃO VIA ZSMALLOC E DENSIDADE ZSTD" >}}
Para evitar a fragmentação severa da memória física ao armazenar páginas compactadas de tamanhos variáveis, o Kernel utiliza o alocador de memória especializado **zsmalloc**.

* **Dinâmica do Alocador zsmalloc:** O gerenciador agrupa páginas compactadas de tamanhos similares dentro de quadros de memória físicos (*page frames* de $4\text{ KiB}$), reduzindo a amplificação de gravação interna e otimizando a taxa de preenchimento.
* **Seleção do Algoritmo de Compressão:** O algoritmo **zstd** (*Zstandard*, desenvolvido pela Meta) oferece uma razão de compressão típica de $2,7:1$ para conteúdos anônimos de navegadores, com velocidades de descompressão superiores a $1,5\text{ GB/s}$ por núcleo de CPU.
{{< /box >}}

### Modelo de Expansão Operacional

$$\text{Capacidade Efetiva da RAM} = \text{RAM Física Livre} + \left( V_{\text{zram}} \times C_r \right)$$

Onde $V_{\text{zram}}$ representa o volume atribuído ao ZRAM e $C_r$ corresponde à taxa média de compressão do algoritmo.

A compressão atômica de dados impõe um consumo adicional de ciclos de processamento sobre a CPU. Contudo, sob a ótica da arquitetura de computadores moderna, os processadores multinúcleo contemporâneos dispõem de capacidade de processamento ociosa imensamente superior à largura de banda do barramento PCI Express ou SATA. A troca de ciclos de CPU por latência de I/O representa um ganho astronômico de responsividade computacional.

---

## ZRAM versus ZSWAP: O Mapeamento das Abordagens de Memória

No ecossistema Linux, existe frequentemente uma confusão conceitual entre duas tecnologias parecidas: **ZRAM** e **ZSWAP**. Embora ambas utilizem compressão de memória RAM para suprimir gargalos de I/O, suas arquiteturas operam sob premissas operacionais distintas.

{{< bizu-tabela cor="#05d9e8" caption="Matriz Comparativa de Desempenho e Arquitetura: ZRAM vs ZSWAP" >}}
| Atributo de Arquitetura | ZRAM (Virtual Block Device) | ZSWAP (Compressed Writeback Cache) |
| :--- | :--- | :--- |
| **Natureza do Dispositivo** | Dispositivo de bloco virtual independente (`/dev/zram0`). | Camada de cache em memória posicionada *à frente* de uma Swap em disco. |
| **Dependência de Disco** | **Nenhuma.** Opera perfeitamente em sistemas sem swap física em disco. | **Obrigatória.** Exige a existência de uma partição ou arquivo de Swap no disco. |
| **Mecanismo de Exaustão** | Ao lotar, responde conforme as regras do alocador e dispara o OOM Killer. | Ao lotar a área compactada, evicta as páginas menos utilizadas gravando-as no disco. |
| **Caso de Uso Ideal** | Desktops, notebooks, máquinas de desenvolvimento e sistemas com SSDs rápidos. | Servidores de alta carga com grandes volumes de Swap gravados em armazenamento persistente. |
{{< /bizu-tabela >}}

Dessarte, para estações de trabalho de uso diário, a implementação do ZRAM destaca-se pela simplicidade, ausência de desgaste de escrita (*write wear*) sobre SSDs e eliminação total do ruído de leitura do disco rígido.

---

## Ajuste de Parâmetros de Paginamento: Tuning Fino de `sysctl`

A simples inicialização do módulo ZRAM não esgota o potencial de otimização da máquina. Para que o Kernel utilize o dispositivo virtual comprimido de forma otimizada, é imperativo calibrar os parâmetros de controle de memória do Kernel via `sysctl`.

{{% grid-regras %}}
{{% card-regra numero="01" titulo="Calibração do Swappiness" cor="#ff2a6d" %}}
O parâmetro `vm.swappiness` (que varia de 0 a 200 em kernels modernos, com padrão em 60) define a agressividade da substituição de páginas anônimas. O adjustment `vm.swappiness=10` instrui o Kernel a priorizar a retenção da memória RAM física não compactada para os processos ativos, acionando a paginação no ZRAM apenas quando o limite de conforto for atingido.
{{% /card-regra %}}
{{% card-regra numero="02" titulo="Preservação de Caches VFS" cor="#05d9e8" %}}
O parâmetro `vm.vfs_cache_pressure` governa a tendência do Kernel em desalocar objetos de *dentries* e *inodes* (caches do sistema de arquivos). Definir `vm.vfs_cache_pressure=50` (reduzindo o padrão de 100) garante que o sistema operacional mantendo a árvore de arquivos e metadados de diretórios aquecidos na RAM, agilizando o tempo de resposta em operações de terminal e gerenciadores de arquivos.
{{% /card-regra %}}
{{% card-regra numero="03" titulo="Controle de Páginas Sujas (Dirty Pages)" cor="#f5a623" %}}
Ao redefinir `vm.dirty_background_ratio=5` e `vm.dirty_ratio=10`, reduzimos o volume de páginas alteradas não salvas que o Kernel acumula em memória antes de iniciar a gravação em disco. Isso previne engasgos súbitos do sistema durante operações pesadas de I/O em segundo plano.
{{% /card-regra %}}
{{% /grid-regras %}}

---

## Automação Resiliente: O Script Shell de Produção

Para aplicar essa reconfiguração técnica de forma automatizada, idempotente e segura em distribuições como Ubuntu, Debian, Linux Mint, Pop!_OS e Fedora, disponibilizamos o script Bash abaixo. O código foi desenvolvido sob rigorosas práticas de segurança de shell scripting, utilizando o *Strict Mode* (`set -euo pipefail`) e alocação dinâmica com prioridade máxima de Swap (`-p 32767`).

{{< terminal lang="bash" titulo="scripts/shell/optimize_linux_desktop.sh" >}}
#!/usr/bin/env bash
# ==============================================================================
# Script: optimize_linux_desktop.sh
# Descrição: Ajusta vm.swappiness e ativa ZRAM para evitar travamentos de RAM
# ==============================================================================

set -euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

log_info()  { printf "[INFO]  %s\n" "$*"; }
log_warn()  { printf "[WARN]  %s\n" "$*" >&2; }
log_error() { printf "[ERROR] %s\n" "$*" >&2; }

cleanup() {
    local exit_code
    exit_code=$?
    if [[ ${exit_code} -ne 0 ]]; then
        log_error "A otimização foi interrompida antes da conclusão."
    fi
    exit "${exit_code}"
}
trap cleanup EXIT INT TERM

check_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        log_error "Este script precisa ser executado como root (use: sudo ./optimize_linux_desktop.sh)"
        exit 1
    fi
}

apply_sysctl_optimizations() {
    log_info "Configurando otimizações de memória em /etc/sysctl.d/99-bizumatica-desktop.conf..."

    local tmp_sysctl
    tmp_sysctl=$(mktemp)

    cat << 'EOF' > "${tmp_sysctl}"
# Reduz a agressividade de uso da Swap em disco (padrão é 60)
vm.swappiness=10
# Melhora a retenção de cache de arquivos e diretórios na RAM
vm.vfs_cache_pressure=50
# Previne congestionamento de I/O bloqueante
vm.dirty_background_ratio=5
vm.dirty_ratio=10
EOF

    mv "${tmp_sysctl}" /etc/sysctl.d/99-bizumatica-desktop.conf
    chown root:root /etc/sysctl.d/99-bizumatica-desktop.conf
    chmod 0644 /etc/sysctl.d/99-bizumatica-desktop.conf

    sysctl -p /etc/sysctl.d/99-bizumatica-desktop.conf > /dev/null
    log_info "Parâmetros do kernel aplicados com sucesso."
}

configure_zram_runtime() {
    log_info "Inicializando e alocando dispositivo ZRAM..."

    if ! modprobe zram num_devices=1 2>/dev/null; then
        log_error "O módulo 'zram' não está disponível no kernel atual."
        return 1
    fi

    local comp_algorithm
    comp_algorithm="zstd"
    if ! grep -q "zstd" /sys/block/zram0/comp_algorithm 2>/dev/null; then
        comp_algorithm="lz4"
        log_warn "Algoritmo 'zstd' indisponível. Utilizando fallback 'lz4'."
    fi

    local total_mem_kb
    local zram_size_bytes
    total_mem_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    zram_size_bytes=$(( (total_mem_kb / 2) * 1024 ))

    if grep -q "/dev/zram0" /proc/swaps; then
        swapoff /dev/zram0 2>/dev/null || true
    fi

    echo 1 > /sys/block/zram0/reset 2>/dev/null || true
    echo "${comp_algorithm}" > /sys/block/zram0/comp_algorithm
    echo "${zram_size_bytes}" > /sys/block/zram0/disksize

    mkswap /dev/zram0 > /dev/null
    swapon /dev/zram0 -p 32767
    
    log_info "ZRAM ativo com sucesso."
}

main() {
    check_root
    apply_sysctl_optimizations
    configure_zram_runtime
    log_info "Otimização concluída! O Linux usará melhor a memória disponível."
}

main "$@"
{{< /terminal >}}

---

## Diagnóstico, Auditoria e Telemetria em Tempo Real

Após a execução do procedimento de otimização, faz-se necessário validar a correta instanciação do dispositivo de bloco e monitorar a taxa de compressão atingida na sessão ativa.

Para inspecionar o status do ZRAM e averiguar os parâmetros operacionais em tempo real, utilize os comandos de diagnóstico no seu terminal:

```bash
# Inspecionar a tabela de dispositivos ZRAM ativos e a razão de compressão
zramctl

# Verificar a hierarquia e as prioridades do subsistema de Swap
cat /proc/swaps

# Monitorar as estatísticas gerais de uso da memória física e virtual
free -h -t

# Acompanhar a movimentação de paginação e interrupções em tempo real (intervalo de 1s)
vmstat 1 10