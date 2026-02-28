# ᗧ BΣ Bizumática

> **Linux, Shell Scripting e Matemática: Onde o terminal encontra a lógica.**

Bem-vindo ao repositório do **Bizumática**. Este é um projeto pessoal de documentação técnica, focado em compartilhar "bizus" (dicas rápidas) sobre sistemas Unix-like e resoluções matemáticas elegantes.

[Website Oficial](https://bizumatica.github.io/) | [Conteúdo de Matemática](https://bizumatica.github.io/matematica/) | [Blog](https://bizumatica.github.io/posts/)

---

## 🛠️ O Projeto

O site é gerado estaticamente para máxima performance e segurança.

* **Engine:** [Hugo](https://gohugo.io/) (versão estendida).
* **Tema:** [Terminal](https://github.com/panr/hugo-theme-terminal) modificado para suporte a Shortcodes customizados.
* **Busca:** Indexação via [Pagefind](https://pagefind.app/) (funciona 100% offline/estático).
* **Matemática:** Renderização via LaTeX para fórmulas complexas.

### Estrutura de Pastas Úteis:
* `content/posts/`: Artigos sobre tecnologia e Linux.
* `content/matematica/`: Notas de estudo e questões de vestibulares (ex: Unicamp).
* `layouts/shortcodes/`: Onde residem o `{{< bizu >}}` e o `{{< box >}}` que dão a cara do site.
* `static/`: Assets como o QR Code do Pix e imagens do canal.

---

## 🚀 Fluxo de Trabalho

Se você quiser rodar ou testar o site localmente:

1. **Submódulos e Temas:**
   ```bash
   git clone [https://github.com/bizumatica/bizumatica.github.io.git](https://github.com/bizumatica/bizumatica.github.io.git)
   cd bizumatica.github.io

```

2. **Server Local:**
```bash
hugo server -D

```


3. **Build e Indexação:**
O projeto usa um script de deploy customizado (`deploy.sh`) que automatiza o build e a atualização do índice de busca:
```bash
chmod +x deploy.sh
./deploy.sh

```



---

## 📜 Licença

Este projeto está licenciado sob a **GNU GPL v3.0**.
Isso significa que você é livre para copiar, modificar e distribuir o conteúdo, desde que mantenha os créditos originais e distribua suas modificações sob a mesma licença.

*A liberdade do software é o nosso bizu principal.* 🐧

---

**Mantido por:** [Bizumática](https://www.google.com/search?q=https://github.com/bizumatica)

```