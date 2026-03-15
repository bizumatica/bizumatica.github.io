---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: false
slug: ""

product:
  name: ""
  current_price: 0
  currency: "BRL"
  pros: []
  cons: []

# Aqui entra a lista de afiliados que o Shortcode vai percorrer
affiliate:
  - store: "Amazon"
    link: ""
  - store: "MercadoLivre"
    link: ""
---

{{< compra >}}