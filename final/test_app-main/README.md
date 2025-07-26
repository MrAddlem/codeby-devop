# Test Web Project

Простой тестовый проект на FastAPI для деплоя веб-сервера.

## Запуск локально

```bash
pip install -r requirements.txt
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
