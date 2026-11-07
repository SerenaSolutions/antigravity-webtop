# Antigravity no navegador, como desktop

Desktop Linux completo acessível por navegador, com o **Google Antigravity** instalado.
Você abre uma URL no navegador e encontra um ambiente gráfico de verdade, com menu,
terminal, gerenciador de janelas e o app rodando. Nada é instalado na sua máquina além do
Docker.

## Por que existe

O Antigravity é aplicativo de desktop (build Electron para Linux, macOS e Windows). Não
existe versão web. Para usar de outro computador ou de um tablet, a saída é rodar um
desktop Linux num container e acessá-lo pelo navegador, que é o que este pacote faz.

## Requisitos

- Docker e Docker Compose na máquina que vai hospedar
- 4 GB de RAM livres (2 GB de shm reservados ao app) e cerca de 3 GB de disco
- Porta 3000 livre

## Subir

```bash
cd antigravity-webtop
export WEBTOP_USER=operador
export WEBTOP_PASSWORD='uma-senha-boa'
docker compose up -d
```

Acesse `http://localhost:3000` e entre com o usuário e a senha acima.

Depois, instale o app dentro do desktop:

```bash
docker exec -it antigravity-webtop bash /config/install-antigravity.sh
```

O atalho aparece no menu de aplicativos e na área de trabalho. O login do Google acontece
dentro do próprio app.

## Acesso de fora da máquina

Em rede local, troque `localhost` pelo IP do servidor. Para acesso pela internet, **não
publique a porta 3000 direto**: coloque atrás de um proxy com TLS (Caddy ou Nginx) ou use
uma VPN. Este desktop dá shell completo; expor sem autenticação e sem TLS é entregar a
máquina.

Se usar a porta 3001, o webtop já sobe com certificado autoassinado.

## O que já foi verificado

A montagem foi feita e testada em Debian 12 headless: Xvfb em 1600x900, gerenciador de
janelas, VNC servido por noVNC, e o Antigravity 2.29.0 instalado e aberto, com o
`language_server` ativo junto.

## Limites honestos

- Electron sem GPU usa rasterização por software: interface funciona, animações ficam
  pesadas. Em servidor sem GPU, use `--disable-gpu`, que já está no atalho.
- A sessão morre com o container. O volume `./config` preserva login e preferências.
- Isso é um desktop remoto, não uma versão web oficial do produto. O suporte é do
  Antigravity, e o consumo de cota da conta Google é o seu.
