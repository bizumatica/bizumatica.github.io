---
title: "Dijkstra vs A*: qual algoritmo de caminho mínimo usar?"
slug: "dijkstra-vs-a-star"
date: 2026-10-08T15:30:00-03:00
lastmod: 2026-10-16T10:00:00-03:00
draft: false
description: "Entenda a diferença entre Dijkstra e A* em grafos, com código em Python e um benchmark que mostra quantos nós cada algoritmo explora. Do Euler às GNNs."
categories: ["matematica"]
tags: ["matematica", "algoritmos", "teoria-dos-grafos", "dijkstra", "a-star", "python", "inteligencia-artificial"]
image: "cover-grafos.webp"
math: true
---

**Resposta curta:** o Dijkstra encontra o menor caminho explorando o grafo em todas as direções. O A* encontra o mesmo caminho, mas usa uma *heurística* para ir na direção do destino e, com uma boa heurística, visita menos nós. Se a heurística for zero, o A* vira o Dijkstra.

Neste post você vê a diferença na prática, com código em Python e números reais de um benchmark. No caminho, passamos por Euler, que inventou tudo isso em 1736, e terminamos nas redes neurais de grafos.

*Atualizado em 16/10/2026 · Testado com Python 3.12.*

{{< foto src="cover-grafos.webp" alt="Grafo com vértices e arestas conectado a circuitos de inteligência artificial" legenda="Grafos estão por trás de rotas de GPS, redes de dados e modelos de IA" class="thumb-frame thumb-center" >}}

---

## Dijkstra ou A*: qual escolher?

Depende de uma pergunta: você sabe estimar a distância até o destino?

{{< bizu-tabela caption="Comparativo: Dijkstra vs A*" cor="#05d9e8" >}}
| Métrica / Critério | Dijkstra | A* |
|---|---|---|
| Garante o menor caminho? | Sim (pesos não negativos) | Sim, se a heurística for admissível |
| Precisa de heurística? | Não | Sim |
| Como explora | Em todas as direções | Em direção ao destino |
| Melhor uso | Menor caminho até todos os nós; sem noção de direção | Um destino só, com estimativa útil (mapas, jogos, grades) |
{{< /bizu-tabela >}}

Se você tem um destino e uma boa estimativa, vá de A*. Se precisa das distâncias até todos os nós, ou não tem estimativa confiável, fique com o Dijkstra.

---

## De onde vem a teoria dos grafos?

De um problema de passeio. Em 1736, Leonhard Euler analisou a cidade de Königsberg, que tinha sete pontes ligando duas ilhas e as margens do rio Pregel. A pergunta: dá para cruzar todas as pontes sem repetir nenhuma?

Euler percebeu que a largura do rio e o formato das ilhas não importavam. Só importava **quem se liga a quem**:

1. **Vértices** ($V$): cada porção de terra.
2. **Arestas** ($E$): cada ponte.
3. **Conclusão:** a estrutura das ligações decide o problema, não as medidas.

{{< box tipo="bizu" titulo="BIZU" >}}
Para saber se existe um trajeto que passa por todas as arestas uma única vez, a distância em metros é irrelevante. O que decide é a **paridade do grau** de cada vértice, isto é, se ele tem um número par ou ímpar de ligações.
{{< /box >}}

{{< axioma titulo="Teorema de Euler (circuito euleriano)" referencia="Euler, 1736 (publicado em 1741)" cor="#ff9d00" >}}
Um grafo conectado admite um circuito euleriano (caminho fechado que percorre cada aresta exatamente uma vez) se, e somente se, **todo vértice tem grau par**. Uma relação que vale em qualquer grafo, e que ajuda a contar graus:

$$\sum_{v \in V} \text{grau}(v) = 2|E|$$
{{< /axioma >}}

Em Königsberg, os quatro trechos de terra tinham grau ímpar. Logo, o passeio era impossível. E nasceu a teoria dos grafos.

---

## Como funciona o Dijkstra?

Agora trocamos a pergunta "dá para passar?" por "qual é o caminho mais barato?". Em um grafo com pesos $G = (V, E, w)$, o Dijkstra (concebido em 1956 por Edsger W. Dijkstra) resolve isso em três ideias:

- Começa na origem com custo 0 e os demais com custo infinito.
- Sempre expande o nó de **menor custo conhecido**, usando uma fila de prioridade (*min-heap*).
- Para cada vizinho, pergunta se passar pelo nó atual sai mais barato. Se sair, atualiza (o chamado *relaxamento*):

$$\text{se } d[u] + w(u, v) < d[v] \implies d[v] = d[u] + w(u, v)$$

O resultado é o menor caminho da origem até todos os outros nós. **Atenção:** isso só vale com pesos não negativos.

{{< box tipo="atencao" titulo="LIMITAÇÃO DO DIJKSTRA" >}}
O Dijkstra não sabe onde fica o destino. Ele se espalha em círculos a partir da origem e visita muitos nós que estão na direção errada. Em mapas grandes, isso custa memória e tempo à toa.
{{< /box >}}

---

## Como o A* melhora o Dijkstra?

Com um "palpite" de direção. Em 1968, Peter Hart, Nils Nilsson e Bertram Raphael criaram o **A\*** (*A-Star*), que escolhe o próximo nó pela soma de dois valores:

$$f(n) = g(n) + h(n)$$

- $g(n)$: o custo real já percorrido até $n$.
- $h(n)$: a estimativa do custo restante de $n$ até o destino (a heurística).

Repare que, se $h(n) = 0$, sobra só $g(n)$, e o A* se comporta exatamente como o Dijkstra.

{{< axioma titulo="Condições para uma heurística confiável" referencia="Hart, Nilsson e Raphael (1968)" cor="#05d9e8" >}}
Para o A* garantir o menor caminho, a heurística deve ser **admissível** (nunca superestimar o custo real $h^*(n)$) e, de preferência, **consistente** (respeitar a desigualdade triangular):

$$0 \le h(n) \le h^*(n) \quad \land \quad h(u) \le w(u, v) + h(v), \quad \forall u, v \in V$$
{{< /axioma >}}

Em grades onde você anda só nas quatro direções, a **distância de Manhattan** (diferença em $x$ mais diferença em $y$) cumpre as duas condições.

---

## Quanto o A* realmente economiza?

Vamos medir. O código abaixo roda os dois algoritmos na mesma grade de 60×60, com um muro vertical no meio que obriga a contornar. Com `heuristica` vazia, ele é Dijkstra; com Manhattan, é A*.

{{< term-tokyo >}}
#!/usr/bin/env python3
"""Bizumática - Roteamento Mínimo: Benchmark Dijkstra vs A*"""
from heapq import heappop, heappush
from math import inf
import time

manhattan = lambda a, b: abs(a[0] - b[0]) + abs(a[1] - b[1])


def buscar(w, h, inicio, fim, obstaculos=frozenset(), heuristica=lambda a, b: 0):
    """Dijkstra por padrão (h=0); A* se uma função heurística for fornecida."""
    t0 = time.perf_counter_ns()
    custo, avaliados = {inicio: 0}, 0
    fila = [(heuristica(inicio, fim), 0, inicio)]

    while fila:
        _, g, p = heappop(fila)
        if g > custo[p]:
            continue  # Descarta estados obsoletos na min-heap
        avaliados += 1
        if p == fim:
            break

        x, y = p
        for q in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if 0 <= q[0] < w and 0 <= q[1] < h and q not in obstaculos:
                novo_g = g + 1
                if novo_g < custo.get(q, inf):
                    custo[q] = novo_g
                    f_val = novo_g + heuristica(q, fim)
                    heappush(fila, (f_val, novo_g, q))

    t1 = time.perf_counter_ns()
    latencia_us = (t1 - t0) / 1000.0
    return custo.get(fim, inf), avaliados, latencia_us


if __name__ == "__main__":
    dim_w, dim_h = 60, 60
    ini, fim = (0, 0), (59, 59)

    # Barreiras verticais para simular impedimentos na malha
    muro = frozenset((30, y) for y in range(0, 50))

    custo_d, nos_d, tempo_d = buscar(dim_w, dim_h, ini, fim, obstaculos=muro)
    custo_a, nos_a, tempo_a = buscar(dim_w, dim_h, ini, fim, obstaculos=muro, heuristica=manhattan)

    ganho_nos = ((nos_d - nos_a) / nos_d) * 100

    print("--- BENCHMARK DE EXPLORAÇÃO DE ESTADOS ---")
    print(f"Dijkstra -> Nós: {nos_d:4d} | Latência: {tempo_d:7.2f} µs | Custo: {custo_d}")
    print(f"A*       -> Nós: {nos_a:4d} | Latência: {tempo_a:7.2f} µs | Custo: {custo_a}")
    print(f"Vetorização A*: redução de {ganho_nos:.2f}% dos estados explorados.")
{{< /term-tokyo >}}

Saída de exemplo (Python 3.12; as latências variam de máquina para máquina, mas a contagem de nós é sempre a mesma):

```text
--- BENCHMARK DE EXPLORAÇÃO DE ESTADOS ---
Dijkstra -> Nós: 2767 | Latência: 4773.87 µs | Custo: 118
A*       -> Nós: 2100 | Latência: 3218.61 µs | Custo: 118
Vetorização A*: redução de 24.10% dos estados explorados.
```

Os dois acham o mesmo custo (118), como esperado. O A* visitou **cerca de 24% menos nós**. É um ganho real, mas bem longe de "ordens de magnitude".

{{< box tipo="check" titulo="PEGADINHA DA GRADE ABERTA" >}}
Retire o muro e rode de novo: **os dois visitam 3.600 nós**, a grade inteira. Em uma grade aberta, de canto a canto, toda célula tem o mesmo $f = g + h$, então o A* não tem como "preferir" nenhuma e empata com o Dijkstra. Moral: a heurística só ajuda quando ela consegue **diferenciar** os caminhos. Obstáculos e destinos fora dos cantos mostram mais ganho.
{{< /box >}}

---

## E as Graph Neural Networks, entram onde?

Dijkstra e A* resolvem muito bem grafos conhecidos e estáveis. Mas e quando o grafo é enorme, muda o tempo todo ou não tem forma de grade, como redes sociais, moléculas e fluxos financeiros?

Aí entram as **Graph Neural Networks (GNNs)**. Diferente das redes convolucionais clássicas, pensadas para grades regulares como imagens, as GNNs aprendem diretamente sobre grafos, usando a ideia de *message passing*.

{{< box tipo="teorema" titulo="MESSAGE PASSING EM DUAS ETAPAS" >}}
A cada camada, cada nó faz duas coisas:
1. **Agregação:** reúne os vetores de características dos vizinhos $\mathcal{N}(v)$.
2. **Atualização:** combina o resultado com o próprio estado, por meio de uma transformação linear $W^{(k)}$ e uma função de ativação não linear $\sigma$.
{{< /box >}}

Em fórmula, o vetor (*embedding*) $h_v^{(k)}$ do nó $v$ na camada $k$ é:

$$h_v^{(k)} = \sigma \left( W^{(k)} \cdot \text{AGGREGATE}^{(k)} \left( \left\{ h_u^{(k-1)} : u \in \mathcal{N}(v) \cup \{v\} \right\} \right) \right)$$

As GNNs não substituem o Dijkstra: elas resolvem outro tipo de problema, como prever propriedades de moléculas ou recomendar conexões. Os dois mundos usam a mesma base, que é o grafo.

---

## Perguntas frequentes

### O Dijkstra funciona com pesos negativos?

Não. Com arestas de peso negativo, ele pode dar resultado errado. Nesse caso, use o algoritmo de **Bellman-Ford**.

### O A* sempre encontra o menor caminho?

Sim, desde que a heurística seja **admissível**, isto é, nunca superestime o custo real até o destino. Com uma heurística que superestima, o A* ainda acha um caminho, mas sem garantia de ser o mais curto.

### Qual é a complexidade do Dijkstra?

Com *min-heap* binária, é $O((V + E) \log V)$. É o que a implementação em Python deste post usa.

### Qual heurística usar no A*?

Depende do movimento permitido. Em grades com 4 direções, **Manhattan**. Em grades com diagonais, **Chebyshev** ou **octile**. Em mapas reais, a distância em linha reta (**euclidiana**).

### GNNs substituem os algoritmos clássicos de caminho mínimo?

Não. Para caminho mínimo exato em grafos conhecidos, os algoritmos clássicos continuam sendo a escolha certa. GNNs brilham quando é preciso *aprender* padrões em grafos grandes e dinâmicos.

---

{{< recomenda id="west-graph-theory" >}}
Quer ir mais fundo? Este é o livro de referência para estudar teoria dos grafos com rigor: o de Douglas B. West cobre conectividade, árvores, grafos planares, coloração e otimização, base de tudo o que vimos aqui.
{{< /recomenda >}}

---

{{< conclusao >}}
## Resumo rápido

- **Dijkstra:** menor caminho sem noção de direção; explora para todos os lados.
- **A\*:** o mesmo resultado, guiado por uma heurística admissível; explora menos quando a heurística diferencia os caminhos.
- **No nosso teste:** 2.767 nós contra 2.100, cerca de 24% a menos, com o mesmo custo final.
- **Próximo passo:** troque a heurística, mude o muro de lugar e veja o ganho mudar. É o jeito mais rápido de entender o A*.

Bons algoritmos começam com uma boa abstração, e foi isso que Euler fez em Königsberg.
{{< /conclusao >}}