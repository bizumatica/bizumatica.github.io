---
title: "Unicamp 2022: Largura do Canal de Suez"
author: "Julio Prata"
date: 2026-01-30T08:00:00-03:00
math: true
draft: false
slug: "unicamp2022-q40-f1"
tags: ["matemática"]
categories: ["mathematics"]
---

  No dia 23 de março de 2021 um navio encalhou no canal de Suez, no Egito. A embarcação tinha 400 metros de comprimento e metros de largura. No ponto onde aconteceu o acidente, o canal de Suez não tem mais do que  metros de largura. Abaixo apresentamos uma foto de satélite e uma figura representando a situação. O ângulo 𝛼 indicado na figura abaixo mede 67,5º

### Resolução: Largura do Canal de Suez (Unicamp 2022)

![Foto do Canal.](/images/canal.png)
![Geometria do Problema.](/images/gcanal.png)

*Legenda: O problema.*

Para encontrar a largura $L$ do canal, decompomos o posicionamento do navio em relação às margens. A largura total é a soma das projeções do comprimento ($400 \text{ m}$) e da largura ($60 \text{ m}$) do navio.

**1. A Equação da Largura**

Pela análise trigonométrica da figura, temos:

$$L = 400 \cdot \operatorname{sen}(67,5^\circ) + 60 \cdot \cos(67,5^\circ)$$

**2. Cálculo das Funções Trigonométricas (Arco Metade)**

Como não temos o valor direto de $67,5^\circ$, utilizamos a fórmula do arco metade fornecida pela Unicamp: $\cos(2\theta) = 2\cos^2(\theta) - 1$. Sabendo que $2 \cdot 67,5^\circ = 135^\circ$:

- **Para o Cosseno:**
    
    $$\cos(67,5^\circ) = \sqrt{\frac{1 + \cos(135^\circ)}{2}}$$
    
    $$\cos(67,5^\circ) = \sqrt{\frac{1 - \frac{\sqrt{2}}{2}}{2}} = \frac{\sqrt{2-\sqrt{2}}}{2}$$
    
- **Para o Seno:**
    
    $$\operatorname{sen}(67,5^\circ) = \sqrt{\frac{1 - \cos(135^\circ)}{2}}$$
    
    $$\operatorname{sen}(67,5^\circ) = \sqrt{\frac{1 + \frac{\sqrt{2}}{2}}{2}} = \frac{\sqrt{2+\sqrt{2}}}{2}$$
    

**3. Substituição Final**

Substituindo os valores encontrados na equação inicial:

$$L = 400 \cdot \left( \frac{\sqrt{2+\sqrt{2}}}{2} \right) + 60 \cdot \left( \frac{\sqrt{2-\sqrt{2}}}{2} \right)$$

Simplificando as divisões:

$$L = 200\sqrt{2+\sqrt{2}} + 30\sqrt{2-\sqrt{2}}$$

---
