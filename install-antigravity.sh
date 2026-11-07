#!/usr/bin/env bash
# Instala o Antigravity dentro do container webtop e cria o atalho no menu.
# Rode de dentro do terminal do desktop: docker exec -it antigravity-webtop bash /config/install-antigravity.sh
set -euo pipefail

VERSAO_APP="2.29.0-5723181030440960"
ARQ="https://storage.googleapis.com/antigravity-public/antigravity-hub/${VERSAO_APP}/linux-x64/Antigravity.tar.gz"
DESTINO="/config/.local/opt/antigravity"

echo "1/4 baixando ${ARQ}"
mkdir -p "$(dirname "$DESTINO")"
curl -# -L -o /tmp/antigravity.tar.gz "$ARQ"

echo "2/4 verificando o arquivo"
gzip -t /tmp/antigravity.tar.gz || { echo "arquivo corrompido"; exit 1; }

echo "3/4 extraindo em $DESTINO"
rm -rf "$DESTINO"
mkdir -p "$DESTINO"
tar -xzf /tmp/antigravity.tar.gz -C "$DESTINO"
BIN="$(find "$DESTINO" -maxdepth 3 -type f -name antigravity | head -1)"
chmod +x "$BIN"
echo "binario: $BIN"

echo "4/4 atalho no menu e na area de trabalho"
mkdir -p /config/Desktop /config/.local/share/applications
for alvo in /config/Desktop/Antigravity.desktop /config/.local/share/applications/Antigravity.desktop; do
  cat > "$alvo" <<DESK
[Desktop Entry]
Type=Application
Name=Antigravity
Comment=Google Antigravity
Exec=${BIN} --no-sandbox --disable-gpu --disable-dev-shm-usage
Terminal=false
Categories=Development;IDE;
DESK
  chmod +x "$alvo"
done

echo
echo "pronto. Abra pelo menu de aplicativos ou pelo icone na area de trabalho."
echo "O login do Google abre dentro do proprio app, entao nao precisa de navegador externo."
