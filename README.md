# IFBA Comunicação BOT

Este código possui uma interface de comunicação com telegram capaz de enviar as noticias presentes no Portal do IFBA, IFBA Santo Amaro e PRPGI para um canal.

As configurações de execução são adicionadas a partir do arquivo de execução utilizando `--dart-define`:

```json
"toolArgs": [
    "--define=SUPABASE_URL=",
    "--define=SUPABASE_KEY=",
    "--define=TELEGRAM_TOKEN=",
    "--define=TELEGRAM_BOT_NAME=",
    "--define=TELEGRAM_CHAT_ID=",
    "--define=PYTHON_PICTURE_CREATOR=image_creator/main.py",
]
```