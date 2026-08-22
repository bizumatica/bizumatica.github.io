---
title: "Unicamp 2022: Largura do Canal de Suez"
author: "Julio Prata"
date: 2026-01-30T08:00:00-03:00
math: true
draft: false
slug: "unicamp2022-q40-f1"
tags: ["matemática"]
image: "cover.webp"
categories: ["mathematics"]
---

No dia 23 de março de 2021, o porta-contêineres *Ever Given* — uma embarcação colossal com 400 metros de comprimento e 60 metros de largura — encalhou no Canal de Suez, no Egito. O navio atravessou-se na diagonal devido a fortes rajadas de vento e uma tempestade de areia, bloqueando totalmente a principal artéria do comércio marítimo global entre a Ásia e a Europa por seis dias consecutivos.

A Unicamp aproveitou o evento histórico para elaborar a Questão 40 da 1ª Fase do Vestibular 2022 (Caderno K), transformando um desastre logístico global em uma elegante aplicação de geometria plana e trigonometria de precisão.

{{< foto src="/images/canal.webp" alt="Foto de satélite do navio Ever Given encalhado no Canal de Suez" legenda="Vista de satélite do Ever Given bloqueando a navegação no Canal de Suez" >}}

---

## O Enunciado do Problema

> **(Unicamp 2022 - Adaptada)** No dia 23 de março de 2021, um navio encalhou no Canal de Suez, no Egito. A embarcação tinha 400 metros de comprimento e 60 metros de largura. No ponto onde aconteceu o acidente, o canal de Suez tem sua largura limitada pelas margens paralelas. 
>
> A figura abaixo representa a situação em que o navio atinge a largura máxima ocupada no canal sob um ângulo $\alpha = 67{,}5^\circ$ em relação à margem.
> 
> Sabendo que a fórmula do cosseno do arco duplo é dada por $\cos(2\theta) = 2\cos^2(\theta) - 1$, determine a largura $L$ do canal entre as duas margens no ponto do bloqueio.

{{< foto src="/images/gcanal.webp" alt="Esquema geométrico mostrando a projeção do navio no canal" legenda="Modelagem geométrica do navio retangular rotacionado de ângulo alfa entre margens paralelas" >}}

---

## Modelagem Geométrica e Decomposição de Projeções

Para calcular a largura $L$ perpendicular às margens paralelas do canal, precisamos entender como um retângulo inclinado projeta sua sombra transversal sobre duas retas paralelas.

O navio pode ser representado no plano cartesiano como um retângulo de dimensão $AB = 400\text{ m}$ (comprimento) e $BC = 60\text{ m}$ (largura). Quando o navio se atravessa na diagonal tocando ambas as margens, a distância total $L$ entre as margens é composta pela soma das projeções ortogonais de ambos os lados do retângulo sobre a perpendicular às margens:

1. **Projeção do Comprimento ($400\text{ m}$):** O comprimento do navio faz um ângulo de $67{,}5^\circ$ com a margem paralela. O cateto oposto a esse ângulo em relação à linha perpendicular que cruza o canal é dado por:
   $$P_1 = 400 \cdot \operatorname{sen}(67{,}5^\circ)$$

2. **Projeção da Largura ($60\text{ m}$):** A largura do navio é perpendicular ao comprimento (forma um ângulo de $90^\circ$). Por complementaridade de ângulos em triângulos retângulos formados com as paralelas, o segmento correspondente à largura projeta-se na transversal através do cosseno do mesmo ângulo $\alpha$:
   $$P_2 = 60 \cdot \cos(67{,}5^\circ)$$

Somando as duas componentes ortogonais, obtemos a **Equação Fundamental da Largura**:

$$L = 400 \cdot \operatorname{sen}(67{,}5^\circ) + 60 \cdot \cos(67{,}5^\circ)$$

---

## Deduzindo as Razões Trigonométricas via Arco Metade

O ângulo de $67{,}5^\circ$ não faz parte da tabela clássica de ângulos notáveis ($30^\circ$, $45^\circ$, $60^\circ$). No entanto, perceba que ele é exatamente a metade de um ângulo muito conhecido:

$$2 \cdot 67{,}5^\circ = 135^\circ$$

Como $135^\circ$ pertence ao 2º quadrante e é o suplementar de $45^\circ$ ($180^\circ - 45^\circ = 135^\circ$), sabemos diretamente seus valores trigonométricos:
- $\cos(135^\circ) = -\cos(45^\circ) = -\frac{\sqrt{2}}{2}$
- $\operatorname{sen}(135^\circ) = \operatorname{sen}(45^\circ) = \frac{\sqrt{2}}{2}$

A banca da Unicamp forneceu a identidade do cosseno do arco duplo:
$$\cos(2\theta) = 2\cos^2(\theta) - 1$$

Fazendo a substituição de variável $\theta = 67{,}5^\circ$ (onde $2\theta = 135^\circ$), isolamos as funções para $67{,}5^\circ$.

### 1. Deduzindo o Cosseno de $67{,}5^\circ$

Isolando $\cos(\theta)$ na identidade do arco duplo:

$$2\cos^2(\theta) = 1 + \cos(2\theta) \implies \cos(\theta) = \sqrt{\frac{1 + \cos(2\theta)}{2}}$$

Como $67{,}5^\circ$ está no 1º quadrante, o valor do cosseno é estritamente positivo:

$$\cos(67{,}5^\circ) = \sqrt{\frac{1 + \cos(135^\circ)}{2}} = \sqrt{\frac{1 + \left(-\frac{\sqrt{2}}{2}\right)}{2}}$$

Simplificando a fração dentro do radical:

$$\cos(67{,}5^\circ) = \sqrt{\frac{\frac{2 - \sqrt{2}}{2}}{2}} = \frac{\sqrt{2-\sqrt{2}}}{2}$$

### 2. Deduzindo o Seno de $67{,}5^\circ$

Utilizando a identidade fundamental da trigonometria $\operatorname{sen}^2(\theta) + \cos^2(\theta) = 1$, ou adaptando a fórmula do arco duplo para o seno ($\cos(2\theta) = 1 - 2\operatorname{sen}^2(\theta)$):

$$\operatorname{sen}(\theta) = \sqrt{\frac{1 - \cos(2\theta)}{2}}$$

Substituindo $\cos(135^\circ) = -\frac{\sqrt{2}}{2}$:

$$\operatorname{sen}(67{,}5^\circ) = \sqrt{\frac{1 - \left(-\frac{\sqrt{2}}{2}\right)}{2}} = \sqrt{\frac{1 + \frac{\sqrt{2}}{2}}{2}}$$

Simplificando o radical:

$$\operatorname{sen}(67{,}5^\circ) = \frac{\sqrt{2+\sqrt{2}}}{2}$$

> 💡 **Bizu:** Note o padrão dos radicais aninhados para arcos da forma $\frac{45^\circ}{2^n}$. O seno e o cosseno de $67{,}5^\circ$ diferem apenas pelo sinal interno sob o radical primário:
> - **Seno** (ângulo maior no 1º quadrante): sinal positivo $+ \rightarrow \frac{\sqrt{2+\sqrt{2}}}{2}$
> - **Cosseno** (ângulo menor no 1º quadrante): sinal negativo $- \rightarrow \frac{\sqrt{2-\sqrt{2}}}{2}$

---

## Resolução Algébrica Passo a Passo

Agora que temos as expressões exatas para $\operatorname{sen}(67{,}5^\circ)$ e $\cos(67{,}5^\circ)$, retornamos à equação principal da largura $L$:

$$L = 400 \cdot \left( \frac{\sqrt{2+\sqrt{2}}}{2} \right) + 60 \cdot \left( \frac{\sqrt{2-\sqrt{2}}}{2} \right)$$

Simplificando os coeficientes pelas divisões por 2:

$$L = 200\sqrt{2+\sqrt{2}} + 30\sqrt{2-\sqrt{2}} \text{ metros}$$

Esta é a resposta exata em termos de radicais aninhados pedida nas questões discursivas ou no gabarito oficial da Unicamp.

---

## Estimativa Numérica e Dimensão Real do Canal

Para um engenheiro de navegação ou especialista em logística marítima, uma expressão com radicais aninhados como $200\sqrt{2+\sqrt{2}} + 30\sqrt{2-\sqrt{2}}$ não diz imediatamente se o canal mede 100 metros ou 500 metros. Vamos calcular a aproximação decimal desse valor para validar o sentido físico do resultado:

1. **Aproximação de $\sqrt{2} \approx 1{,}4142$**
2. **Cálculo do Seno:**
   $$\sqrt{2 + 1{,}4142} = \sqrt{3{,}4142} \approx 1{,}8477$$
   $$\operatorname{sen}(67{,}5^\circ) \approx \frac{1{,}8477}{2} \approx 0{,}9239$$

3. **Cálculo do Cosseno:**
   $$\sqrt{2 - 1{,}4142} = \sqrt{0{,}5858} \approx 0{,}7654$$
   $$\cos(67{,}5^\circ) \approx \frac{0{,}7654}{2} \approx 0{,}3827$$

4. **Substituição na Largura:**
   $$L \approx 400 \cdot (0{,}9239) + 60 \cdot (0{,}3827)$$
   $$L \approx 369{,}56 + 22{,}96 = 392{,}52 \text{ metros}$$

{{< bizu-tabela cor="#05d9e8" caption="Projeções e Parâmetros Geométricos do Canal" >}}
| Parâmetro Geométrico | Valor Exato (Radicais) | Valor Aproximado (Decimal) |
| :--- | :--- | :--- |
| **Projeção do Comprimento ($P_1$)** | $200\sqrt{2+\sqrt{2}}\text{ m}$ | $\approx 369{,}56\text{ m}$ |
| **Projeção da Largura ($P_2$)** | $30\sqrt{2-\sqrt{2}}\text{ m}$ | $\approx 22{,}96\text{ m}$ |
| **Largura Total do Canal ($L$)** | $200\sqrt{2+\sqrt{2}} + 30\sqrt{2-\sqrt{2}}\text{ m}$ | **$\approx 392{,}52\text{ m}$** |
{{< /bizu-tabela >}}

O cálculo revela que a largura do Canal de Suez no ponto do acidente era de aproximadamente **392,5 metros**. Como o navio *Ever Given* possui $400\text{ m}$ de comprimento, fica geometricamente evidente por que ele encalhou firmemente nas duas margens: o seu comprimento isolado ($400\text{ m}$) já superava a largura do trecho do canal ($392{,}5\text{ m}$).

---

{{< recomenda id="needham-vca" >}}
A dedução do seno e cosseno de $67{,}5^\circ$ por arco-metade é um caso particular de um princípio muito mais amplo: toda identidade trigonométrica tem uma leitura geométrica direta como rotação e projeção no plano. Needham reconstrói a análise complexa inteira a partir dessa intuição visual — leitura essencial para quem quer enxergar *por que* as fórmulas de arco duplo/metade funcionam, não só decorá-las.
{{< /recomenda >}}


## Erros Comuns e Estratégias de Prova

Essa questão é um clássico exemplo de como a Unicamp testa dois pilares do candidato em uma única pergunta: **visão espacial de projeção** e **domínio de álgebra trigonométrica**.

Os erros mais frequentes cometidos pelos vestibulandos nessa questão foram:

1. **Ignorar a largura do navio ($60\text{ m}$):** Muitos candidatos consideraram o navio como um segmento de reta unidimensional de $400\text{ m}$, calculando apenas $400 \cdot \operatorname{sen}(67{,}5^\circ) \approx 369{,}5\text{ m}$. Isso errava a resposta por quase 23 metros.
2. **Inversão de Seno e Cosseno:** Trocar as projeções ortogonais nos retângulos formados (usar cosseno para o comprimento e seno para a largura), o que resulta em um valor de $L$ incoerente com o ângulo visualmente agudo/obtuso apresentado no diagrama.
3. **Erro de Sinal na Fórmula do Arco Metade:** Confundir a fórmula do seno e do cosseno do arco metade, esquecendo que o cosseno de $135^\circ$ é **negativo** ($-\sqrt{2}/2$). A troca de sinal no meio da simplificação destrói todo o radical aninhado.

---

## Aplicação na Engenharia de Software e Gráficos por Computador

A matemática envolvida nesta questão da Unicamp não é apenas um exercício acadêmico. A determinação do espaço ocupado por um retângulo rotacionado no plano 2D é o princípio fundamental por trás do algoritmo **Bounding Box Orientado (OBB - Oriented Bounding Box)**, utilizado exaustivamente em:

* **Motores de Jogos (Collision Detection):** Para checar se um carro rotacionado colidiu com a parede de uma pista em jogos 2D/3D.
* **Sistemas de Informação Geográfica (GIS):** Para calcular restrições de gabarito em canais de navegação, simulações de tráfego aéreo e planejamento urbano.
* **Processamento de Imagens e OCR:** Para recortar e alinhar documentos escaneados que estão levemente rotacionados em relação à borda.

A projeção de vetores via seno e cosseno é a base matemática que permite transformar matrizes de rotação em limites físicos computáveis de maneira ultraeficiente.