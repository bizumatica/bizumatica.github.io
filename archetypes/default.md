+++
date = '{{ .Date }}'
draft = true
title = '{{ replace .File.ContentBaseName "-" " " | title }}'
+++
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
description: "Um bizu rápido sobre..."
categories: ["Linux"]
tags: ["terminal", "bash"]
math: false
---

Resumo do que será abordado neste bizu.

## O Problema
Descreva a situação aqui.

{{< bizu >}}
Comando ou dica matadora!
{{< /bizu >}}

## Conclusão

<!-- Nota: este é o comando padrão: hugo new posts/meu-novo-bizu.md -->