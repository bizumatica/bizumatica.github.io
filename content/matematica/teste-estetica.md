---
title: "🧪 Teste de Estética e Funcionalidades"
date: 2026-01-27
slug: "teste-estetica"
author: "Julio Prata"
description: "Post para validar KaTeX, Shortcodes e o novo CSS Tokyo Night."
categories: ["Matemática", "Shell Scripting", "Bizus"]
tags: ["hugo", "css", "katex", "deploy"]
math: true
draft: false
---

Este post serve para validar se o novo `extended.css` e os shortcodes estão funcionando corretamente no ambiente do **Bizumática**.

## 1. Teste de Boxes (Shortcodes)

Vamos testar os três níveis de destaque que configuramos:

{{< box tipo="bizu" titulo="Macete de Potência" >}}
Para elevar ao quadrado números que terminam em 5:
1. Multiplique o primeiro algarismo pelo sucessor dele.
2. Escreva **25** no final.
*Exemplo: $25^2 \rightarrow 2 \times 3 = 6 \rightarrow 625$.*
{{< /box >}}

{{< box tipo="teorema" titulo="Teorema Fundamental" >}}
A soma dos quadrados dos catetos é igual ao quadrado da hipotenusa:
$$a^2 + b^2 = c^2$$
{{< /box >}}

{{< box tipo="aviso" >}}
Aproveitamos o teste para lembrar mais $\mathrm{M}\alpha\theta\eta\mu\alpha\tau\iota\kappa\acute{\alpha}$
{{< /box >}}

## 2. Teste de Matemática (KaTeX)

Aqui testamos se o fundo sutil (`background: rgba(255, 255, 255, 0.05)`) e a borda lateral turquesa estão aparecendo nas fórmulas em bloco:

$$
f(x) = \int_{-\infty}^{\infty} \hat{f}(\xi) e^{2 \pi i x \xi} \, d\xi
$$

E uma fórmula inline para testar o alinhamento: $\lim_{x \to \infty} \frac{1}{x} = 0$.

{{< bizu >}} $$\frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$${{< /bizu >}}

---

## 3. Teste de Código (Estilo Terminal)

Como o tema é **Terminal**, o bloco de código deve harmonizar com as cores do Tokyo Night:

```bash
# Testando o script de deploy
chmod +x deploy.sh
./deploy.sh "Ajuste visual completo"