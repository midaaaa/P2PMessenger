#!/bin/bash
# Переходим в директорию, где находится сам скрипт
cd "$(dirname "$0")"

echo "--- P2PMessenger Project Setup ---"
make -f .github/Makefile setup

echo ""
echo "Готово! Теперь вы можете открыть P2PMessenger.xcodeproj"
# Опционально: можно сразу открывать Xcode, если проект сгенерировался успешно
# open P2PMessenger.xcodeproj

# Оставляем окно открытым, чтобы увидеть результат (опционально)
# read -p "Нажмите любую клавишу для выхода..."
