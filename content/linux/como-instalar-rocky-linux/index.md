---
title: "Como Instalar o Rocky Linux 10.2: Guia Passo a Passo e Pós-Instalação"
slug: "como-instalar-rocky-linux"
date: 2026-10-21T16:00:00-03:00
lastmod: 2026-10-22T10:00:00-03:00
draft: false
description: "Instale o Rocky Linux 10.2 passo a passo: requisitos (x86-64-v3), ISO, gravação do pendrive, Anaconda e script de pós-instalação com SSH, firewall e SELinux."
categories: ["linux", "SysAdmin"]
tags: ["rocky-linux", "instalação", "sysadmin", "red-hat", "servidores"]
image: "cover.webp"
---

Se você precisa da estabilidade corporativa do Red Hat Enterprise Linux (RHEL) sem pagar licença, o Rocky Linux 10.2 é uma escolha sólida. Neste guia você vê como verificar se o seu hardware é compatível, gravar a mídia com segurança, configurar o Anaconda Installer e deixar o sistema pronto para uso em servidor ou workstation.

{{< foto src="cover.webp" alt="Instalação do Rocky Linux 10.2" legenda="Rocky Linux 10.2 - Anaconda Installer" class="thumb-frame thumb-right" >}}

O Rocky Linux foi concebido como um substituto direto para o CentOS tradicional, com compatibilidade binária 1:1 com o RHEL. Acertar a escolha da ISO, o esquema de disco e a configuração inicial de rede no instalador evita retrabalho e entrega uma base mais segura para cargas críticas.

{{< adsense slot="4043462063" >}}

---

### 📌 Guia de Navegação

- 🧩 [O que você vai precisar](#requisitos)
- 📀 [1. Escolha a ISO ideal: Minimal vs. Live GNOME](#iso)
- 💾 [2. Download, verificação e gravação da mídia bootável](#gravacao)
- 🖥️ [3. Passo a passo no Anaconda Installer](#anaconda)
- 🚀 [4. Automação: script de pós-instalação e hardening](#pos-instalacao)
- 🛠️ [Problemas comuns e como resolver](#problemas)
- 🧭 [Resumo das etapas da instalação](#resumo)
- ❓ [Perguntas Frequentes (FAQ)](#faq)
- 📖 [Material recomendado e fontes](#fontes)

---

## 🧩 O que você vai precisar {#requisitos}

- **ISO do Rocky Linux 10.2** (Minimal ou Live GNOME).
- Pendrive de pelo menos **8 GB**.
- Computador ou servidor com CPU **x86_64-v3** (Intel Haswell ou posterior, AMD Excavator ou posterior) ou **aarch64**. O Rocky 10 também tem builds para ppc64le, s390x e riscv64.
- Mínimo de 2 GB de RAM em instalação em modo texto (4 GB recomendados para uso com GNOME).
- Armazenamento: 10 GB é o mínimo; o recomendado é 20 GB ou mais, e 40 GB ou mais com interface gráfica.
- Acesso à internet para sincronização de repositórios pós-instalação.

{{< matrix-prompt prompt="[sys.warn] :: CPU_X86_64_V3_REQUIRED" icone="⚠️" cor="#ffbd2e" >}}
**Confira a CPU antes de baixar a ISO.** O Rocky Linux 10 exige a microarquitetura x86-64-v3 (instruções AVX, AVX2, BMI1/2 e FMA). Processadores mais antigos, e VMs configuradas com um modelo de CPU genérico, não conseguem rodar o Rocky 10. Em qualquer Linux já instalado na máquina (ou numa Live), rode:

`/lib64/ld-linux-x86-64.so.2 --help | grep "x86-64-v3"`

Se a linha aparecer com *supported*, a CPU atende. Se não, use o Rocky Linux 9 ou 8, que ainda rodam em CPUs x86-64-v2. Em VMs (KVM/Proxmox), escolha o tipo de CPU `host` em vez de `kvm64`.
{{< /matrix-prompt >}}

---

## 📀 1. Escolha a ISO ideal: Minimal vs. Live GNOME {#iso}

O site oficial do Rocky Linux disponibiliza diferentes imagens de instalação. Para evitar downloads desnecessários, selecione a versão correspondente ao destino da sua infraestrutura.

{{% grid-regras %}}
{{% card-regra numero="01" titulo="Minimal ISO (~2.5 GB)" cor="#00d26a" %}}
Imagem enxuta sem interface gráfica, contendo apenas a base do sistema e pacotes OpenSSH.

**Indicação:** Servidores headless, hosts de containers (Docker/Podman), bancos de dados e instâncias em nuvem.
{{% /card-regra %}}

{{% card-regra numero="02" titulo="Live ISO GNOME (~4.0 GB)" cor="#05d9e8" %}}
Ambiente desktop completo rodando direto da memória, permitindo testar compatibilidade de drivers antes da escrita em disco.

**Indicação:** Workstations de desenvolvimento, estações de trabalho locais e administradores que exigem GUI.
{{% /card-regra %}}
{{% /grid-regras %}}

---

## 💾 2. Download, verificação e gravação da mídia bootável {#gravacao}

Faça o download da ISO diretamente do [site oficial do Rocky Linux](https://rockylinux.org/pt-BR), junto com o arquivo de checksum publicado na mesma página.

### Verifique a integridade da ISO

Uma ISO corrompida no download é uma causa comum de erro de "media check failed". Confira o hash antes de gravar:

{{< box tipo="code" lang="bash" titulo="Verificando o checksum" >}}
# Na pasta onde estão a ISO e o arquivo de checksum (ex.: CHECKSUM)
sha256sum -c --ignore-missing CHECKSUM

# Resultado esperado:
# Rocky-10.2-x86_64-minimal.iso: OK
{{< /box >}}

### No Linux: gravação com `dd`

A maior parte das falhas de mídia vem de gravação incompleta. Para uma cópia bit a bit (raw) mais segura, use o `dd` com as flags de sincronização:

{{< matrix-prompt prompt="[sys.warn] :: DD_APAGA_O_DISCO" icone="⚠️" cor="#ffbd2e" >}}
**O `dd` não pede confirmação.** Se você apontar `of=` para o disco errado, ele apaga tudo. Confira o dispositivo pelo tamanho e pelo modelo antes de executar.
{{< /matrix-prompt >}}

{{< box tipo="code" lang="bash" titulo="Gravando o Pendrive" >}}
# 1. Identifique o pendrive (confira tamanho e modelo)
lsblk -o NAME,SIZE,MODEL,TRAN,MOUNTPOINTS

# 2. Desmonte as partições do pendrive, se estiverem montadas
sudo umount /dev/sdX* 2>/dev/null || true

# 3. Grave a ISO (substitua /dev/sdX pelo dispositivo correto, SEM número de partição)
sudo dd if=Rocky-10.2-x86_64-minimal.iso of=/dev/sdX bs=4M oflag=direct status=progress conv=fsync

# 4. Garanta que tudo foi escrito antes de remover o pendrive
sync
{{< /box >}}

{{< matrix-prompt prompt="[sys.info] :: GRAVACAO_BLOCO_DD" icone="💡" cor="#7dcfff" >}}
**Por que funciona:** A flag `oflag=direct` ignora o cache de página do kernel e escreve direto no dispositivo. Já o `conv=fsync` força a descarga dos buffers ao final do processo, garantindo que você não remova o pendrive enquanto os últimos bytes ainda estão na memória volátil.
{{< /matrix-prompt >}}

### No Windows

O `dd` é uma ferramenta de Linux. No Windows, use o **Rufus** (escolha o modo *DD Image* quando perguntado), o **Ventoy** ou o **balenaEtcher**.

---

## 🖥️ 3. Passo a passo no Anaconda Installer {#anaconda}

Insira o pendrive gravado, ligue a máquina e acesse o menu de boot da BIOS/UEFI (F12, F11 ou Del). Selecione **Install Rocky Linux 10.2**.

<!-- TODO: inserir capturas de tela do Anaconda (idioma, destino, rede, usuários) com o shortcode foto -->

No menu principal do Anaconda, siga a matriz de configuração:

1. **Idioma:** Escolha **Português (Brasil)** para ajustar o mapa de teclado e fuso horário.
2. **Seleção de software:** Para servidores, mantenha a instalação mínima (**Minimal Install**) e instale só o que for necessário depois.
3. **Rede e Nome do Host:** Ligue a interface de rede (posição **ON**) e defina o *hostname* FQDN (ex.: `srv-app-01.dominio.local`).
4. **Destino da Instalação:** Selecione o disco. Para servidores, mantenha o particionamento em **Automático** com o esquema **LVM** e sistema de arquivos **XFS**, o padrão da família RHEL, bem testado com arquivos grandes e I/O paralelo.
5. **Contas de Usuário:** Defina uma senha forte para `root` (ou bloqueie a conta root). Em seguida, crie seu usuário comum marcando **Tornar este usuário administrador**, que adiciona a conta ao grupo `wheel` para acesso `sudo`.

O modo automático do Anaconda já dimensiona o swap. Se precisar ajustá-lo manualmente, a referência da Red Hat para o RHEL segue esta lógica (confira a documentação da Red Hat para a sua versão, principalmente se for usar hibernação):

{{< bizu-tabela caption="Swap sugerido em relação à RAM" cor="#05d9e8" >}}

| Memória RAM | Swap sugerido |
| --- | --- |
| Até 2 GB | 2× a RAM |
| Mais de 2 GB até 8 GB | Igual à RAM |
| Mais de 8 GB | No mínimo 4 GB |

{{< /bizu-tabela >}}

{{< matrix-prompt prompt="[sys.warn] :: REDE_DESATIVADA_ANACONDA" icone="⚠️" cor="#ffbd2e" >}}
**Atenção no Anaconda:** Se você não ativar a placa de rede durante a instalação, a interface pode ficar desconectada após o primeiro boot. Sem rede, o acesso SSH remoto não funciona e você precisará de acesso físico ou via console para corrigir.
{{< /matrix-prompt >}}

---

## 🚀 4. Automação: script de pós-instalação e hardening {#pos-instalacao}

Sistemas Enterprise não devem ser expostos à rede com configurações padrão. Após o primeiro boot, execute este script para atualizar os pacotes, habilitar o **EPEL** (com o repositório CRB), bloquear o login direto do root via SSH e restringir o firewall.

Antes de rodar, confirme que existe pelo menos um usuário no grupo `wheel` e que você consegue entrar com ele. O script aborta se não encontrar nenhum, para você não se trancar fora do servidor.

{{< terminal lang="bash" titulo="rocky-postinstall.sh" >}}
#!/usr/bin/env bash
# ==============================================================================
# BIZUMÁTICA LABS - PÓS-INSTALAÇÃO E HARDENING ROCKY LINUX 10.2
# ==============================================================================

set -euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

if [[ $EUID -ne 0 ]]; then
  echo "ERRO: Este script deve ser executado com privilégios de root (sudo)." >&2
  exit 1
fi

# Segurança: só desabilita o login do root se houver um administrador alternativo
if [[ -z "$(getent group wheel | cut -d: -f4)" ]]; then
  echo "ERRO: nenhum usuário no grupo wheel. Crie um administrador antes de continuar." >&2
  exit 1
fi

echo "[*] Atualizando a base do sistema..."
dnf update -y

echo "[*] Instalando EPEL, habilitando o CRB e ferramentas de SysAdmin..."
dnf install -y epel-release
crb enable || dnf config-manager --set-enabled crb
dnf install -y curl wget vim-enhanced htop tar bind-utils

echo "[*] Hardening básico do SSH (desabilitando login direto via root)..."
# O sshd usa o PRIMEIRO valor encontrado; o prefixo 00- garante prioridade
cat > /etc/ssh/sshd_config.d/00-hardening.conf <<'EOF'
PermitRootLogin no
EOF
sshd -t && systemctl reload sshd

echo "[*] Configurando o Firewall (zona drop, liberando apenas SSH)..."
systemctl enable --now firewalld
# Libera o SSH ANTES de trocar a zona padrão, para não derrubar a sessão atual
firewall-cmd --permanent --zone=drop --add-service=ssh
firewall-cmd --set-default-zone=drop
firewall-cmd --reload

echo "[*] Validando o SELinux..."
sestatus | grep "Current mode" || true

echo "[*] Conferindo o SSH efetivo..."
sshd -T | grep -i "^permitrootlogin" || true

echo "✅ Rocky Linux 10.2 atualizado e com a primeira camada de hardening aplicada!"
{{< /terminal >}}

{{< matrix-prompt prompt="[sys.info] :: ZONA_DROP_FIREWALLD" icone="💡" cor="#7dcfff" >}}
**O que a zona `drop` faz:** descarta silenciosamente todo tráfego de entrada que não esteja liberado, inclusive ping (ICMP). Isso é intencional em servidores expostos, mas pode confundir quem tenta diagnosticar a rede. Para liberar outros serviços, use `firewall-cmd --permanent --zone=drop --add-service=<serviço>` e depois `firewall-cmd --reload`.
{{< /matrix-prompt >}}

---

## 🛠️ Problemas comuns e como resolver {#problemas}

{{< matrix-prompt prompt="[sys.debug] :: CPU_NAO_SUPORTADA" icone="⚠️" cor="#ffbd2e" >}}
**A ISO trava no início do boot ou reclama da CPU?**
Provavelmente o processador não atende ao x86-64-v3. Confira com o comando da seção de requisitos. Se não atender, use o Rocky Linux 9 ou 8. Em máquina virtual, troque o tipo de CPU para `host`.
{{< /matrix-prompt >}}

{{< matrix-prompt prompt="[sys.debug] :: NET_INTERFACE_DOWN" icone="⚠️" cor="#ffbd2e" >}}
**A interface de rede não conectou no boot?**
Descubra o nome real da conexão (varia: `ens18`, `enp1s0`, etc.) e marque-a para conectar automaticamente:
`nmcli connection show`
`sudo nmcli connection up id "NOME_DA_CONEXAO"`
`sudo nmcli connection modify "NOME_DA_CONEXAO" connection.autoconnect yes`
{{< /matrix-prompt >}}

{{< matrix-prompt prompt="[sys.debug] :: SELINUX_PORT_BLOCK" icone="⚠️" cor="#ffbd2e" >}}
**Serviço não sobe ou porta bloqueada (mesmo com o firewall liberado)?**
O SELinux em modo `enforcing` bloqueia serviços em portas não mapeadas para aquele tipo de serviço. Primeiro confirme que é o SELinux e veja se a porta já tem um tipo (exemplo com a porta 8080):
`sudo ausearch -m avc -ts recent`
`sudo semanage port -l | grep 8080`
Se a porta **não** estiver definida, adicione-a. Se já estiver definida com outro tipo, modifique-a:
`sudo dnf install policycoreutils-python-utils`
`sudo semanage port -a -t http_port_t -p tcp 8080`
`sudo semanage port -m -t http_port_t -p tcp 8080`
{{< /matrix-prompt >}}

---

## 🧭 Resumo das etapas da instalação {#resumo}

A tabela abaixo compila a arquitetura recomendada para a preparação do servidor:

{{< bizu-tabela caption="Arquitetura de Instalação Corporativa" cor="#05d9e8" >}}

| Etapa | Ferramenta / Recurso | Ação Recomendada | Impacto Prático |
| --- | --- | --- | --- |
| **CPU** | `ld-linux` + x86-64-v3 | Verificar antes de baixar | Evita baixar uma ISO que não inicia |
| **Mídia** | `sha256sum` | Conferir o checksum | Detecta ISO corrompida |
| **I/O** | `dd` + flags avançadas | Gravação `oflag=direct` | Evita corrupção de blocos na ISO bootável |
| **Disco** | LVM + XFS | Particionamento estruturado | Permite redimensionamento de volumes a quente |
| **Acesso** | SSHD Config | `PermitRootLogin no` em drop-in | Reduz a superfície de ataque do superusuário |
| **Rede** | `firewalld` + SELinux | Zona restrita (drop) | Camada dupla de proteção no kernel e rede |

{{< /bizu-tabela >}}

---

## ❓ FAQ {#faq}

{{< faq >}}

#### O Rocky Linux 10.2 é totalmente gratuito para uso comercial?

Sim. O Rocky Linux é mantido pela Rocky Enterprise Software Foundation, de código aberto e livre de custos de licença ou assinaturas para uso em servidores comerciais.

#### Meu computador é antigo. Consigo instalar o Rocky Linux 10.2?

Depende da CPU. O Rocky Linux 10 exige a microarquitetura x86-64-v3, presente em processadores Intel a partir da Haswell e AMD a partir da Excavator. Em CPUs mais antigas, use o Rocky Linux 9 ou 8, que ainda funcionam em x86-64-v2.

#### Por que o particionamento automático escolhe XFS em vez de Ext4?

O XFS é o sistema de arquivos padrão do ecossistema RHEL: é bem testado, tem bom desempenho em I/O paralelo e suporta arquivos e volumes muito grandes. O Ext4 continua sendo uma opção válida, mas o padrão da distribuição tem a vantagem de ser o caminho mais usado e documentado.

#### O Rocky Linux possui suporte a pacotes Flatpak?

Sim. O Flatpak pode ser instalado a partir dos repositórios do sistema, independentemente da ISO escolhida, e integrado ao Flathub para aplicações de desktop isoladas em sandbox.

#### Qual a diferença entre o Rocky Linux e o CentOS Stream?

O CentOS Stream é o *upstream* (ambiente de desenvolvimento dos próximos lançamentos) do RHEL, enquanto o Rocky Linux é o *downstream* (compilado a partir do código já lançado pela Red Hat), o que garante estabilidade corporativa.
{{< /faq >}}

---

## 📖 Material recomendado e fontes {#fontes}

{{< recomenda id="rocky-docs" >}}
Guias de instalação e administração, notas de lançamento e orientações de segurança, escritos e mantidos pela comunidade do projeto. Comece pelo guia oficial de instalação.
{{< /recomenda >}}

{{< recomenda id="rocky-livros" >}}
Livros gratuitos mantidos pela comunidade: administração de sistemas, Bash, Ansible, LAMP/LEMP e mais. Cada um tem PDF para leitura offline.
{{< /recomenda >}}

{{< fontes >}}

* **Rocky Linux Project:** [rockylinux.org](https://rockylinux.org/pt-BR) — Portal oficial do projeto e imagens de instalação.
* **Guia de instalação do Rocky Linux 10:** [docs.rockylinux.org](https://docs.rockylinux.org/10/guides/installation/) — Instalação passo a passo na documentação oficial.
* **Requisitos mínimos de hardware:** [docs.rockylinux.org](https://docs.rockylinux.org/10/guides/minimum_hardware_requirements/) — CPU (x86-64-v3), memória e disco para o Rocky Linux 10.
* **firewalld para iniciantes:** [docs.rockylinux.org](https://docs.rockylinux.org/10/guides/security/firewalld-beginners/) — Zonas e serviços do firewall.
* **SELinux:** [docs.rockylinux.org](https://docs.rockylinux.org/10/guides/security/learning_selinux/) — Introdução ao SELinux no Rocky Linux.
* **Chaves SSH:** [docs.rockylinux.org](https://docs.rockylinux.org/10/guides/security/ssh_public_private_keys/) — Autenticação por chave pública e privada.
* **Atualizações automáticas:** [docs.rockylinux.org](https://docs.rockylinux.org/10/guides/security/dnf_automatic/) — Patching com dnf-automatic.
* **Red Hat Enterprise Linux Docs:** [docs.redhat.com](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux) — Documentação de referência técnica da base RHEL (a Red Hat não é afiliada ao Rocky).
* **EPEL (Fedora Project):** [docs.fedoraproject.org/en-US/epel](https://docs.fedoraproject.org/en-US/epel/) — Pacotes adicionais para distribuições Enterprise Linux.
{{< /fontes >}}

---