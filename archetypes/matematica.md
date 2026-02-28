---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
description: "Resolução e conceitos de..."
categories: ["Matemática"]
tags: ["vestibular", "teorema"]
math: true
---

Breve introdução ao conceito matemático.

{{< box tipo="teorema" titulo="Teorema de Exemplo" >}}
Escreva sua fórmula aqui:
$$E = mc^2$$
{{< /box >}}

## Resolução Passo a Passo
Explique a lógica aqui...

<!-- Nota: este é o comando padrão: hugo new matematica/resolucao-unicamp.md -->