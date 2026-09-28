# 🚀 Bizumática

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bizumatica/bizumatica.github.io/deploy.yml?branch=main&label=pipeline&color=2ac3de&style=flat-square)
![GitHub last commit](https://img.shields.io/github/last-commit/bizumatica/bizumatica.github.io/main?label=%C3%BAltimo%20push&color=blue&logo=github&logoColor=white&style=flat-square)
![Hugo Version](https://img.shields.io/badge/hugo-extended-ff4088?logo=hugo&logoColor=white&style=flat-square)
![PWA Ready](https://img.shields.io/badge/PWA-enabled-51a0cf?logo=pwa&logoColor=white&style=flat-square)
![GitHub License](https://img.shields.io/badge/license-MIT-8532D3?logo=creativecommons&logoColor=white&style=flat-square)

> Ecossistema estático focado em educação tecnológica, matemática elementar, shell scripting avançado e curadoria programática de hardware.

O **Bizumática** é um portal de conteúdo de alta performance construído sobre o gerador de sites estáticos (SSG) Hugo. O projeto adota os princípios do **SEO Programático**, gerando e atualizando dinamicamente páginas de curadoria a partir de fontes de dados estruturadas, mantendo o consumo de recursos no zero absoluto.

---

## 🎨 Filosofia & Estética

* **Interface Retro-Hacker:** Design minimalista baseado na paleta *Tokyo Night*, priorizando legibilidade, contraste e renderização limpa de blocos de código.
* **Performance Extrema:** 100/100 no Google PageSpeed Insights. Sem frameworks JS pesados, sem rastreadores intrusivos.
* **Search Nativo:** Motor de busca local indexado via Pagefind, garantindo privacidade e velocidade instantânea de busca sem APIs de terceiros.

---

## 🛠️ Stack Tecnológica

| Componente | Tecnologia | Papel no Ecossistema |
| --- | --- | --- |
| **Engine Principal** | Hugo (Extended) | Compilação estática ultrarrápida do conteúdo |
| **Automação** | Python 3.x + Pandas | Consumo de dados estruturados e SEO programático |
| **Motor de Busca** | Pagefind (WASM) | Indexação de conteúdo e busca cliente-side |
| **Estilização** | CSS3 Puro (Extended) | Customização visual responsiva e layouts neon |
| **Infraestrutura** | GitHub Pages + Cloudflare | Hospedagem imutável e proteção na camada de DNS |

---

## 📁 Estrutura de Conteúdo (Navegação Rápida)

O conteúdo do portal está distribuído nas seguintes seções nativas dentro do diretório `content/`:

* `linux/` — Engenharia de sistemas operacionais, arquiteturas imutáveis e novidades de distribuições.
* `foss/` — Cobertura do ecossistema Open Source, subsistemas de áudio moderno (<small>PipeWire</small>) e hardware aberto.
* `matematica/` — Artigos conceituais, demonstrações matemáticas e resoluções de alto nível (ex: <small>Identidade de Euler, Integral de Gauss</small>).
* `apps/` — Análises técnicas detalhadas de aplicativos, aplicações e softwares (ex: <small>VLC, GIMP, XFCE4</small>)
* `shell/` — Guias de automação segura, boas práticas de CLI e engenharia de scripts DevOps.

---

## 🏗️ Operação Básica

Para quem deseja clonar o repositório e consumir o conteúdo localmente:

#### Clone o repositório

git clone [https://github.com/bizumatica/bizumatica.github.io.git](https://github.com/bizumatica/bizumatica.github.io.git?utm_source=gemini)

#### Execute o servidor de desenvolvimento do Hugo

hugo server -D

---

**Mantenedor:** Julio Prata (BackInBash)

![GitHub License](https://img.shields.io/badge/license-MIT-8532D3?logo=creativecommons&logoColor=white&style=flat-square) ![Feito com Café](https://img.shields.io/badge/feito%20com-caf%C3%A9%20%E2%98%95%20e%20canela%20%F0%9F%AA%B5-8B4513?logo=buymeacoffee&logoColor=white&style=flat-square) 

```