---
title: "Política de Privacidade"
slug: "privacidade"
description: "Diretiva de privacidade, tratamento de dados, conformidade LGPD e diretrizes de publicidade (Google AdSense) do ecossistema Bizumática."
summary: "Transparência sobre coleta de dados, cookies de publicidade contextual, métricas de tráfego e direitos do usuário sob a LGPD."
date: 2026-10-30T10:00:00-03:00
lastmod: 2026-10-30T10:00:00-03:00
draft: false
layout: "single"
type: "page"
math: false
---

A presente Política de Privacidade e Diretiva de Conformidade regula os processos de tratamento de dados, telemetria de tráfego e veiculação de anúncios no ecossistema digital do **Bizumática**. Este documento foi elaborado em estrita observância à Lei Geral de Proteção de Dados Pessoais (LGPD - Lei nº 13.709/2018) e às Políticas de Editores do Google (Google AdSense e Google Ad Manager).

### 1. Arquitetura Estática e Processamento de Informações

Como uma plataforma baseada em Arquitetura Estática (Jamstack) hospedada via rede de entrega de conteúdo (*Edge Network*), o **Bizumática** funciona sem necessidade de cadastro, criação de contas de usuário ou formulários de comentários integrados. Limitamos o processamento técnico de dados ao estritamente necessário para garantir performance, segurança e monetização sustentável:

- **Comunicação Direta:** Caso o leitor opte por entrar em contato diretamente via e-mail ou repositório oficial no GitHub, o endereço de e-mail e o nome fornecidos serão utilizados exclusivamente para responder à solicitação específica.
- **Metadados de Tráfego e Logs de Rede:** Registros automatizados de requisições HTTP/HTTPS (incluindo endereço IP anonimizado, *User-Agent* do navegador, tipo de dispositivo, páginas solicitadas e carimbo de data/hora) são processados na camada de *Edge* para mitigação de ataques (DDoS/botnets) e otimização da entrega dos arquivos estáticos.

### 2. Publicidade Digital e Cookies do Google AdSense

O **Bizumática** utiliza o Google AdSense e tecnologias de publicidade de terceiros para exibição de anúncios. O funcionamento desta camada segue os parâmetros técnicos e legais abaixo:

- **Cookies do Google e Parceiros de Anúncios:** O Google utiliza cookies (como o cookie DoubleClick) e identificadores móveis para veicular anúncios aos leitores com base em suas visitas a este e a outros sites da internet.
- **Anonimização de IP e Telemetria:** As ferramentas de medição de audiência e desempenho utilizam dados estatísticos agregados e IP anonimizado para análise do tempo de permanência e métricas do *Core Web Vitals* (INP, LCP, CLS).
- **Gestão e Opt-Out de Publicidade:** O usuário pode gerenciar suas preferências de publicidade personalizada a qualquer momento acessando as [Configurações de Anúncios do Google](https://adssettings.google.com) ou através do portal [Network Advertising Initiative (NAI)](https://optout.networkadvertising.org).

### 3. Base Legal e Finalidade do Tratamento (LGPD)

O tratamento de dados no portal fundamenta-se nos seguintes pilares do Artigo 7º da LGPD:

- **Legítimo Interesse (Art. 7º, IX):** Para garantia da estabilidade da infraestrutura, segurança em *Edge*, prevenção contra fraudes de cliques (*invalid click traffic*) e otimização da entrega de conteúdo.
- **Consentimento (Art. 7º, I):** Para exibição de publicidade personalizada via rede AdSense, gerenciada conforme as diretrizes de consentimento e sinalização dos navegadores.
- **Cumprimento de Obrigação Legal (Art. 7º, II):** Para a guarda temporária de logs de acesso a aplicações de internet, conforme exigido pelo Marco Civil da Internet (Lei nº 12.965/2014).

### 4. Armazenamento, Segurança e Filosofia FOSS

Em consonância com a cultura **FOSS (Free and Open Source Software)**, adotamos a minimização da coleta (*Data Minimization*). Não mantemos bancos de dados relacionais com dados pessoais dos leitores. Adotamos criptografia em trânsito via TLS 1.3/HTTPS, políticas de *Content Security Policy* (CSP) e isolamento de dependências para prevenir injeção de scripts maliciosos.

### 5. Direitos do Titular de Dados

Em conformidade com o Artigo 18 da LGPD, o leitor possui o direito de solicitar a qualquer momento a confirmação, acesso, correção ou eliminação de dados fornecidos diretamente por e-mail.

### 6. Responsável e Contato

Para dúvidas técnicas sobre esta política ou auditorias de conformidade, entre em contato com a administração do sistema:

- **Administrador:** Julio Prata (`BackInBash`)
- **Canal Oficial de Privacidade:** `julio@bizumatica.com.br`

*Última revisão técnica e jurídica: 30 de Outubro de 2026.*