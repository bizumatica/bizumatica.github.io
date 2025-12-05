+++
date = '2025-12-05T17:22:51-03:00'
draft = false
title = 'Fluxo De Trabalho'
+++

# Fluxo de Trabalho de Atualização da Bizumática

```mermaid
graph TD
    A[Editar Conteúdo no index.md] --> B{Conteúdo Pronto?};
    B -- Sim --> C[Converter MD para HTML];
    B -- Não --> A;
    C --> D[Copiar o bloco HTML gerado];
    D --> E[Abrir o index.html];
    E --> F[Colar o HTML após a tag </nav>];
    F --> G[git add index.html];
    G --> H[git commit];
    H --> I[git push];
    I --> J(Site Publicado e Atualizado);