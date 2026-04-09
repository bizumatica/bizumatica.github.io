---
title: "Regras de Divisibilidade: do 2 ao 9"
date: 2026-04-08T14:40:00-03:00
draft: false
description: "Aprenda atalhos mentais poderosos para identificar divisores sem precisar de divisões longas."
categories: ["mathematics"]
tags: ["aritmetica", "teoria-dos-numeros", "fundamental"]
math: true
image: "prod-regras-divisibilidade.webp"
# --- SEÇÃO DE MONETIZAÇÃO ---
recommendations:
  casio:
    name: "Casio fx-991lacw Classwiz"
    price: 158
    img: "cassio"
    store: "MercadoLivre"
    link: "https://meli.la/2FReLQa"
  livro:
    name: "Fundamentos de matemática elementar - Volume 1 - Iezzi e Murakami"
    price: 269
    img: "livro"
    store: "Amazon"
    link: "https://amzn.to/41Za6q8"
---

### O Conceito

Você já precisou saber rapidamente se um número grande é par, ou se divide exatamente por 3? As **regras de divisibilidade** são atalhos poderosos. Em vez de fazer a divisão inteira, basta analisar os dígitos do número — e em segundos você tem a resposta.

Formalmente, definimos:

{{< box tipo="teorema" titulo="DEFINIÇÃO DE DIVISIBILIDADE" >}}
Dizemos que um número natural $a$ é **divisível** por $b$ (com $b \neq 0$) quando existe um número natural $q$ tal que:
$$a = b \cdot q$$
Ou seja, o resto da divisão é zero ($r = 0$).
{{< /box >}}

---

## As regras, uma a uma

<div style="display:grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1rem; margin: 1.5rem 0;">

<div style="border-radius:4px; border:1px solid #00ffff; background: rgba(0, 255, 255, 0.05); overflow:hidden; font-family: 'Courier New', Courier, monospace;">
  <div style="background: rgba(0, 255, 255, 0.2); padding:0.5rem 1rem; display:flex; align-items:center; gap:10px;">
    <div style="font-weight:bold; color:#00ffff;">[ 02 ]</div>
    <div><div style="font-weight:bold; color:#00ffff; text-transform:uppercase; font-size:13px;">Divisibilidade por 2</div></div>
  </div>
  <div style="padding:0.75rem 1rem; font-size:0.85rem; line-height:1.6; color: #ddd;">
    Último dígito deve ser <strong>par</strong> (0, 2, 4, 6 ou 8).
    <div style="background: #1a1a1a; border-left: 3px solid #00ffff; padding:0.4rem; margin:0.5rem 0; color:#00ffff;">
      $$n \equiv 0 \pmod{2}$$
    </div>
    <div style="font-size:12px; font-family: monospace;">
      <span style="color:#50fa7b;">[✓] 348</span>: dígito 8<br>
      <span style="color:#ff5555;">[✗] 517</span>: dígito 7
    </div>
  </div>
</div>

<div style="border-radius:4px; border:1px solid #50fa7b; background: rgba(80, 250, 123, 0.05); overflow:hidden; font-family: 'Courier New', Courier, monospace;">
  <div style="background: rgba(80, 250, 123, 0.2); padding:0.5rem 1rem; display:flex; align-items:center; gap:10px;">
    <div style="font-weight:bold; color:#50fa7b;">[ 03 ]</div>
    <div><div style="font-weight:bold; color:#50fa7b; text-transform:uppercase; font-size:13px;">Divisibilidade por 3</div></div>
  </div>
  <div style="padding:0.75rem 1rem; font-size:0.85rem; line-height:1.6; color: #ddd;">
    A <strong>soma dos dígitos</strong> deve ser divisível por 3.
    <div style="background: #1a1a1a; border-left: 3px solid #50fa7b; padding:0.4rem; margin:0.5rem 0; color:#50fa7b;">
      $$3 \mid \sum \text{dígitos}$$
    </div>
    <div style="font-size:12px; font-family: monospace;">
      <span style="color:#50fa7b;">[✓] 2.541</span>: $\sum=12$<br>
      <span style="color:#ff5555;">[✗] 1.234</span>: $\sum=10$
    </div>
  </div>
</div>

<div style="border-radius:4px; border:1px solid #bd93f9; background: rgba(189, 147, 249, 0.05); overflow:hidden; font-family: 'Courier New', Courier, monospace;">
  <div style="background: rgba(189, 147, 249, 0.2); padding:0.5rem 1rem; display:flex; align-items:center; gap:10px;">
    <div style="font-weight:bold; color:#bd93f9;">[ 04 ]</div>
    <div><div style="font-weight:bold; color:#bd93f9; text-transform:uppercase; font-size:13px;">Divisibilidade por 4</div></div>
  </div>
  <div style="padding:0.75rem 1rem; font-size:0.85rem; line-height:1.6; color: #ddd;">
    Os <strong>dois últimos</strong> dígitos formam um múltiplo de 4.
    <div style="background: #1a1a1a; border-left: 3px solid #bd93f9; padding:0.4rem; margin:0.5rem 0; color:#bd93f9;">
      $$4 \mid \overline{d_1 d_0}$$
    </div>
    <div style="font-size:12px; font-family: monospace;">
      <span style="color:#50fa7b;">[✓] 3.728</span>: $28$ ✅<br>
      <span style="color:#ff5555;">[✗] 1.526</span>: $26$ ❌
    </div>
  </div>
</div>

<div style="border-radius:4px; border:1px solid #ff79c6; background: rgba(255, 121, 198, 0.05); overflow:hidden; font-family: 'Courier New', Courier, monospace;">
  <div style="background: rgba(255, 121, 198, 0.2); padding:0.5rem 1rem; display:flex; align-items:center; gap:10px;">
    <div style="font-weight:bold; color:#ff79c6;">[ 07 ]</div>
    <div><div style="font-weight:bold; color:#ff79c6; text-transform:uppercase; font-size:13px;">Divisibilidade por 7</div></div>
  </div>
  <div style="padding:0.75rem 1rem; font-size:0.85rem; line-height:1.6; color: #ddd;">
    Subtraia o dobro do último dígito do restante do número.
    <div style="background: #1a1a1a; border-left: 3px solid #ff79c6; padding:0.4rem; margin:0.5rem 0; color:#ff79c6;">
      $$7 \mid (r - 2 \cdot d_0)$$
    </div>
    <div style="font-size:12px; font-family: monospace;">
      <span style="color:#50fa7b;">[✓] 343</span>: $34 - 6 = 28$<br>
      <span style="color:#ff5555;">[✗] 250</span>: $25 - 0 = 25$
    </div>
  </div>
</div>

</div>

---

### Desenvolvimento e Provas

<div style="border: 1px solid #f1fa8c; background: rgba(241, 250, 140, 0.05); padding: 1rem; border-radius: 4px; font-family: monospace; color: #f1fa8c;">
<div style="text-transform: uppercase; font-weight: bold; font-size: 11px; margin-bottom: 0.5rem; opacity: 0.8;">> PROVA_MODULAR_LOG:</div>

Como $10 \equiv 1 \pmod{3}$, qualquer potência $10^k$ também será $1 \pmod{3}$. Isso simplifica a expressão polinomial do número para a soma bruta de seus algarismos:

$$n = \sum_{i=0}^{k} d_i 10^i \equiv \sum_{i=0}^{k} d_i \pmod{3}$$

O mesmo se aplica para o divisor 9.
</div>

{{< bizu >}}
**Bizu de Ouro:** Se um número é divisível por 9, ele é obrigatoriamente divisível por 3, pois $9 = 3^2$.
{{< /bizu >}}

---

### Aplicação no Mundo Real

Na computação e no uso do **Terminal Linux**, entender divisibilidade é crucial para:
1.  **Criptografia:** Onde a divisibilidade por números primos grandes sustenta o RSA.
2.  **Scripts de Automação:** Usar o operador `%` (módulo) para disparar eventos a cada $n$ ciclos.

---

## Ferramentas Recomendadas

{{< links >}}
Recomendações técnicas para aprofundar nos estudos:
{{< /links >}}

{{< compra item="casio" >}}
{{< compra item="livro" >}}