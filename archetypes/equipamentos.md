---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: false
slug: ""

# Imagem para Redes Sociais e Listagens
images: ["/images/produtos/nome-do-produto.jpg"]

product:
  name: ""
  current_price: 0
  currency: "BRL"
  thumbnail: "/images/produtos/thumb-produto.jpg" # Campo novo para o Shortcode
  pros: []
  cons: []

affiliate:
  - store: "Amazon"
    link: ""
  - store: "MercadoLivre"
    link: ""
---

{{< compra >}}