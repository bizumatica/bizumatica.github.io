---
title: "root@bizumatica:~#"
math: true
---

<div class="terminal-centered-header" style="text-align: center;">

<div class="brand-header">
    <span class="brand-letter">B</span>
    <span class="brand-sigma">Σ</span>
</div>

<div class="tokyonight-wave">
    <span class="wave-pulse"></span>
</div>
<div class="terminal-line" style="opacity: 0.4; font-size: 0.8rem; margin-bottom: 25px;">[ SYSTEM STATUS: ONLINE // IP: <span id="user-ip">0.0.0.0</span> ]</div>

<div class="terminal-command-wrapper" style="text-align: center;">
    <span class="terminal-prompt">guest@bizumatica:~$</span> <span class="terminal-command">cat sobre_nos.md</span>
</div>

</div>

<p class="introduction" style="margin-top: 25px;">
No <strong>Bizumática</strong>, exploramos a intersecção entre o código aberto e a lógica pura. Aqui você encontrará análises técnicas, automação com Shell Script e insights práticos sobre o ecossistema Linux. Nosso foco é desmistificar a tecnologia para que você a domine com autonomia, provando que a 
<span class="math-term">$\mu\alpha\theta\eta\mu\alpha\tau\iota\kappa\alpha$</span> e o terminal falam a mesma língua: a da elegância e da eficiência.
</p>

> **O Manifesto da Elegância:**
>
> $$e^{i\pi} + 1 = 0$$
>
> *A identidade de Euler une os cinco números mais importantes da matemática em uma única igualdade. Uma inspiração!*

---

<div class="terminal-centered-header" style="text-align: center;">
    <div class="terminal-command-wrapper">
        <span class="terminal-prompt">guest@bizumatica:~$</span> <span class="terminal-command">ls -la /conteudos</span>
    </div>
</div>

<h2 style="text-align: center; margin-bottom: 25px;">📖 Diretório do Sistema</h2>

<div class="terminal-directory-grid">
    <div class="dir-item">
        <span class="dir-perm">drwxr-xr-x</span> 
        <a href="/shell-scripting/">./Shell_Scripting_e_Automacao</a>
    </div>
    <div class="dir-item">
        <span class="dir-perm">drwxr-xr-x</span> 
        <a href="/linux/">./Ecossistema_Linux</a>
    </div>
    <div class="dir-item">
        <span class="dir-perm">drwxr-xr-x</span> 
        <a href="/categories/apps/">./Analise_de_Aplicativos</a>
    </div>
    <div class="dir-item">
        <span class="dir-perm">drwxr-xr-x</span> 
        <a href="/categories/noticias/">./Lancamentos_e_Noticias</a>
    </div>
    <div class="dir-item">
        <span class="dir-perm">drwxr-xr-x</span> 
        <a href="/matematica/">./Matematica_Pura</a>
    </div>
</div>

---

<div class="terminal-centered-header" style="text-align: center;">
    <div class="terminal-command-wrapper">
        <span class="terminal-prompt">guest@bizumatica:~$</span> <span class="terminal-command">tail -n 20 dica_de_ouro.sh</span>
    </div>
</div>

## ⚙️ Automação em Destaque

{{< terminal lang="bash" titulo="backup.sh" >}}
#!/bin/bash
# Backup Universal - Bizumática
ORIGEM="$HOME/documentos"
DESTINO="$HOME/backups"
DATA=$(date +"%Y-%m-%d_%H-%M")
ARQUIVO="backup_$DATA.tar.gz"

mkdir -p "$DESTINO"
if tar -czvf "$DESTINO/$ARQUIVO" "$ORIGEM" > /dev/null 2>&1; then
    echo "✅ Sucesso! O arquivo foi gerado em: $DESTINO/$ARQUIVO"
else
    echo "❌ Erro: Falha ao gerar o backup."
    exit 1
fi
{{< /terminal >}}

---

## 🌟 Apoie o Projeto Bizumática

{{< apoie >}}

## 💬 Contato e Redes

* **Código Fonte:** [github.com/bizumatica](https://github.com/bizumatica/bizumatica.github.io)
* **E-mail:** [julio.prata@proton.me](mailto:julio.prata@proton.me)

<div style="text-align: center; margin-top: 40px;">
    {{< contador >}}
</div>