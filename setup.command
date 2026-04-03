#!/bin/bash
# Переходим в директорию, где находится сам скрипт
cd "$(dirname "$0")"

echo "--- P2PMessenger Project Setup ---"
echo ""

# Создаём local.yml с персональным bundleIdPrefix (если ещё не создан)
if [ ! -f "local.yml" ]; then
  read -p "Введи свой bundleIdPrefix (например, com.yourname или ru.yourname): " BUNDLE_PREFIX

  if [ -z "$BUNDLE_PREFIX" ]; then
    echo "Prefix не введён. Используется дефолтный dev.p2pTeam"
    cat > local.yml <<EOF
options:
  bundleIdPrefix: dev.p2pTeam
EOF
  else
    cat > local.yml <<EOF
options:
  bundleIdPrefix: ${BUNDLE_PREFIX}
EOF
    echo "Сохранено в local.yml (файл добавлен в .gitignore и не попадёт в репозиторий)"
  fi
  echo ""
fi

make -f .github/Makefile setup

echo ""
echo "Готово! Теперь вы можете открыть P2PMessenger.xcodeproj"
