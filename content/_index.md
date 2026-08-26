---
title: ""
math: true
---

<!-- Hero Principal integrado na Janela de Terminal -->
{{< term-box cmd="cat sobre_nos.md" hero=true / >}}

<p class="introduction" style="margin-top: 35px; text-align: left;">
No <strong>Bizumática</strong>, exploramos a intersecção entre o código aberto e a lógica pura. Aqui você encontrará análises técnicas, automação com Shell Script e insights práticos sobre o ecossistema Linux. Nosso foco é desmistificar a tecnologia para que você a domine com autonomia, provando que a 
<span class="math-term">$\text{μαθηματικα}$</span> e o terminal falam a mesma língua: a da elegância e da eficiência.
</p>

> **O Manifesto da Elegância:**
>
> $$e^{i\pi} + 1 = 0$$
>
> *A identidade de Euler une os cinco números mais importantes da matemática em uma única igualdade. Uma inspiração!*

---

{{< term-box title="MAN // DIRETÓRIO DO SISTEMA" cmd="ls -la /conteudos" variant="browser" / >}}

{{< diretorio >}}

---

{{< term-box title="SYSTEMD // AUTOMAÇÃO" cmd="tail -n 20 dica_de_ouro.sh" variant="browser" / >}}

{{< box tipo="code" titulo="SCRIPT // BACKUP.SH" >}}
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
{{< /box >}}

---

{{< term-box title="CONFIG // APOIE O PROJETO" cmd="cat /etc/sponsor.conf" variant="clean" / >}}

{{< apoie >}}

---

{{< box tipo="link" titulo="GIT // CONTATO.SH" >}}

* **Código Fonte:** [github.com/bizumatica](https://github.com/bizumatica/bizumatica.github.io)
* **E-mail:** [julio.prata@proton.me](mailto:julio.prata@proton.me)

{{< /box >}}


<div style="text-align: center; margin-top: 40px;">
    {{< contador >}}
</div>