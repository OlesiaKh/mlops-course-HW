# Lesson 3 — TorchScript + Docker

## Вміст папки

- `export_model.py`  експортує MobileNetV2 з torchvision у формат TorchScript (`model.pt`)
- `inference.py`  завантажує `model.pt`, приймає шлях до зображення та виводить top-3 класи
- `model.pt`  збережена TorchScript-модель
- `Dockerfile.fat`  "важкий" Docker-образ на базі python:3.10
- `Dockerfile.slim`  multi-stage Dockerfile з компактним runtime (python:3.10-slim + venv)
- `install_dev_tools.sh` — приклад скрипта для встановлення Docker, Docker Compose, Python і ML-залежностей (Ubuntu/Debian)
- `comparison.txt` — коротке порівняння fat vs slim образів

## Локальний запуск (без Docker)

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install torch torchvision pillow

python export_model.py         # створює model.pt
python inference.py images/cat.jpg
