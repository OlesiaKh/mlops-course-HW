#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="install.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "Початок налаштування середовища..."

# --- Перевіряємо тип системи (орієнтуємось на Ubuntu/Debian) ---
if [[ -f /etc/os-release ]]; then
  # shellcheck source=/dev/null
  . /etc/os-release
  DIST_ID="${ID:-unknown}"
else
  DIST_ID="unknown"
fi

if [[ "$DIST_ID" != "ubuntu" && "$DIST_ID" != "debian" ]]; then
  log "Цей скрипт розраховано на Ubuntu/Debian. Поточна система: $DIST_ID"
  log "Можна використати цей файл як приклад, але встановлення потрібно адаптувати під вашу ОС."
  exit 0
fi

log "Виявлено дистрибутив: $DIST_ID"

# --- Docker ---
if ! command -v docker >/dev/null 2>&1; then
  log "Docker не знайдено. Встановлюю docker.io..."
  sudo apt-get update
  sudo apt-get install -y docker.io
  sudo systemctl enable docker || true
  sudo systemctl start docker || true
  log "Docker встановлено."
else
  log "Docker вже є: $(docker --version)"
fi

# --- Docker Compose (як плагін або окремий пакет) ---
if docker compose version >/dev/null 2>&1; then
  log "Docker Compose (v2) вже доступний як плагін."
elif command -v docker-compose >/dev/null 2>&1; then
  log "Знайдено docker-compose (v1): $(docker-compose --version)"
else
  log "Docker Compose не знайдено. Встановлюю docker-compose-plugin..."
  sudo apt-get update
  sudo apt-get install -y docker-compose-plugin
  log "Плагін docker compose встановлено."
fi

# --- Python 3.9+ і pip ---
if ! command -v python3 >/dev/null 2>&1; then
  log "python3 не знайдено. Встановлюю python3 та python3-pip..."
  sudo apt-get update
  sudo apt-get install -y python3 python3-pip
fi

PY_VERSION=$(python3 -c 'import sys; v=sys.version_info; print(f"{v.major}.{v.minor}")')
log "Поточна версія python3: $PY_VERSION"

PY_OK=$(python3 - << 'EOF'
import sys
print(int(sys.version_info >= (3, 9)))
EOF
)

if [[ "$PY_OK" -ne 1 ]]; then
  log "Увага: версія Python < 3.9. За потреби можна оновити через pyenv або інший спосіб."
fi

if ! python3 -m pip --version >/dev/null 2>&1; then
  log "pip для python3 не знайдено. Встановлюю через get-pip..."
  curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python3 get-pip.py --user
  rm -f get-pip.py
else
  log "pip вже присутній: $(python3 -m pip --version)"
fi

# --- Допоміжна функція для Python-пакетів ---
install_python_pkg() {
  local pkg="$1"
  if python3 -m pip show "$pkg" >/dev/null 2>&1; then
    log "Пакет $pkg вже встановлено."
  else
    log "Встановлюю Python-пакет: $pkg ..."
    python3 -m pip install "$pkg"
    log "Пакет $pkg встановлено."
  fi
}

# --- Встановлення потрібних бібліотек ---
install_python_pkg torch
install_python_pkg torchvision
install_python_pkg pillow
install_python_pkg Django

# --- Підсумкова інформація ---
log "Перевірка встановлених версій:"
log "Docker: $(docker --version 2>/dev/null || echo 'не знайдено')"
log "Docker Compose (plugin): $(docker compose version 2>/dev/null || echo 'немає')"
log "docker-compose (v1): $(docker-compose --version 2>/dev/null || echo 'немає')"
log "python3: $(python3 --version 2>/dev/null || echo 'не знайдено')"
log "pip: $(python3 -m pip --version 2>/dev/null || echo 'не знайдено')"

log "Налаштування завершено."
