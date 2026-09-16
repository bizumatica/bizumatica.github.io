---
title: "Política de Privacidade"
slug: "privacidade"
description: "Diretiva de privacidade, tratamento de dados, conformidade LGPD e diretrizes de publicidade (Google AdSense) do ecossistema Bizumática."
summary: "Transparência sobre coleta de dados, cookies de publicidade contextual, métricas de tráfego e direitos do usuário sob a LGPD."
date: 2026-04-09T10:00:00-03:00
draft: false
layout: "single"
type: "page"
math: false
---

A presente Política de Privacidade e Diretiva de Conformidade regula os processos de tratamento de dados, telemetria de tráfego e veiculação de anúncios no ecossistema digital do **Bizumática**. Este documento foi elaborado em estrita observância à Lei Geral de Proteção de Dados Pessoais (LGPD - Lei nº 13.709/2018) e às Políticas de Editores do Google (Google AdSense e Google Ad Manager).

### 1. Coleta e Processamento de Informações

Como uma plataforma baseada em Arquitetura Estática (Jamstack) e distribuição via rede de entrega de conteúdo (*Edge Network*), limitamos o processamento de dados ao estritamente necessário para garantir performance, segurança e monetização sustentável:

* **Dados fornecidos voluntariamente:** Endereço de e-mail e nome submetidos de forma ativa pelo usuário em formulários de contato, inscrição em *newsletters* ou caixas de comentários. Esses dados são processados exclusivamente para a finalidade informada no momento da coleta.
* **Metadados de tráfego e logs de rede:** Registros automatizados de requisições HTTP/HTTPS (incluindo endereço IP anonimizado, *User-Agent* do navegador, tipo de dispositivo, páginas solicitadas e carimbo de data/hora), processados na camada de *Edge* para mitigação de ataques (DDoS/botnets) e otimização da entrega estática.

### 2. Publicidade Digital e Cookies do Google AdSense

O **Bizumática** utiliza o Google AdSense e tecnologias de publicidade de terceiros para exibição de anúncios. O funcionamento desta camada segue os seguintes parâmetros técnicos e legais:

* **Cookies de Terceiros e Tecnologias de Identificação:** O Google e seus parceiros de publicidade usam cookies, identificadores móveis e métricas de armazenamento local para veicular anúncios personalizados com base em suas visitas a este e a outros sites da internet.
* **Anonimização de IP e Telemetria:** As ferramentas de medição de audiência e desempenho de renderização utilizam dados estatísticos agregados e IP anonimizado para análise de tempo de permanência, resposta de layout e Core Web Vitals (INP, LCP, CLS).
* **Gestão e Opt-Out de Publicidade:** O usuário pode gerenciar suas preferências de publicidade personalizada a qualquer momento acessando as [Configurações de Anúncios do Google](https://adssettings.google.com) ou através do portal independente [Network Advertising Initiative (NAI)](https://optout.networkadvertising.org).

### 3. Base Legal e Finalidade do Tratamento (LGPD)

O tratamento de dados pessoais no portal fundamenta-se nos seguintes pilares do Artigo 7º da LGPD:

* **Legítimo Interesse (Art. 7º, IX):** Para garantia da estabilidade, segurança em *Edge*, prevenções contra fraudes de cliques (*invalid click traffic*) e otimização de performance do site.
* **Consentimento (Art. 7º, I):** Para envio de comunicações técnicas por e-mail e exibição de publicidade personalizada via rede AdSense, coletado de forma clara e revogável por meio de nossos mecanismos de consentimento (*Cookie Consent Banner* / CMP).
* **Cumprimento de Obrigação Legal (Art. 7º, II):** Para guarda de logs de acesso a aplicações de internet, conforme exigido pelo Marco Civil da Internet (Lei nº 12.965/2014).

### 4. Armazenamento, Segurança e Filosofia FOSS

Por ser um projeto focado na cultura **FOSS (Free and Open Source Software)**, prezamos pela minimização da coleta (*Data Minimization*). Não mantemos bancos de dados relacionais locais contendo dados pessoais de navegação. 

Adotamos criptografia em trânsito via TLS 1.3/HTTPS, políticas rígidas de *Content Security Policy* (CSP) e isolamento de dependências para prevenir injeção de scripts maliciosos (*Cross-Site Scripting* - XSS).

### 5. Direitos do Titular de Dados

Em conformidade com o Artigo 18 da LGPD, você possui o direito de solicitar a qualquer momento:

1. Confirmação da existência de tratamento de seus dados pessoais.
2. Acesso, correção, anonimização ou eliminação de dados desnecessários ou excessivos.
3. Revogação do consentimento concedido para comunicações diretas ou rastreamento.

### 6. Encarregado de Proteção de Dados (DPO) e Contato

Para exercer seus direitos de privacidade, realizar auditorias de conformidade ou sanar dúvidas sobre o tratamento de dados no **Bizumática**, entre em contato com o responsável pela administração e segurança do sistema:

* **Encarregado / Administrador:** Julio Prata (`BackInBash`)
* **Canal Oficial de Privacidade:** `julio@bizumatica.com.br`

*Última revisão técnica e jurídica: 09 de Abril de 2026.*