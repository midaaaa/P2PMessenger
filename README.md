# P2PMessenger 

[![Swift](https://img.shields.io/badge/Swift-5-orange.svg)]()
[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)]()
[![XcodeGen](https://img.shields.io/badge/XcodeGen-2.40-green.svg)]()
[![CI](https://github.com/TeamP2P/P2PMessenger/actions/workflows/iOS-CI.yml/badge.svg)]()

Peer-to-peer мессенджер на iOS для обмена сообщениями между пользователями поблизости без внешнего сервера.
Связь построена на MultipeerConnectivity: устройство находит соседних пиров, подключается к ним и отправляет личные и общие сообщения.

## Ключевые возможности

- Личные чаты между двумя пользователями.
- Общий чат для всех подключенных участников.
- Автообновление списка найденных / подключенных / подключающихся пользователей.
- Сохранение истории сообщений (общий чат + приватные диалоги).
- Счетчик непрочитанных сообщений по каждому диалогу.
- Локальные push-уведомления по входящим сообщениям с роутингом в нужный экран.
- Онбординг с проверкой и запросом необходимых разрешений (Bluetooth, Nearby, Local Network, Notifications).
- Экран состояния Bluetooth с блокировкой приложения при выключенном модуле.
- String Catalog с поддержкой русского и английского языков (готов к расширению)

## Пример работы приложения

https://github.com/user-attachments/assets/b90488e9-92ed-4e44-a765-82d53a5aa1e7

## Технологический стек

- SwiftUI + Observation
- MultipeerConnectivity
- CoreBluetooth / Network
- UserNotifications
- XcodeGen + Makefile
- XCTest + XCUITest
- Lottie
- GitHub Actions (CI/CD)

## Архитектура

Проект построен вокруг композиционного корня `RootGraph`, который собирает зависимости (router, storage, network service, coordinators, view models, root views).
Навигация реализована через `AppRouter` + отдельные root-экраны для вкладок (Chats / Common Chat / Settings).
Сетевой слой — `MPCNetworkServiceImpl`, обернутый координатором `PeerSessionCoordinator`, который мультикастит сетевые события подписчикам (чаты, список диалогов, уведомления).
Хранение состояния и истории — через `KeyValueStorageProtocol` (профиль, онбординг, разрешения, чаты, количество непрочитанных сообщений).

## CI/CD

В проекте настроен GitHub Actions пайплайн, который запускается при `push` (и может запускаться при `pull request`, если включено в workflow).

### Что проверяется автоматически
- Сборка проекта (build)
- Проверка стиля и качества кода (SwiftLint)
- Unit-тесты (`P2PMessengerTests`)
- UI-тесты (`P2PMessengerUITests`)

### Зачем это нужно
- Быстрая проверка, что изменения не ломают сборку
- Контроль базового качества кода до ревью/мержа
- Раннее обнаружение регрессий в бизнес-логике и UI-сценариях

## Запуск проекта

### Требования
- Xcode 16+
- iOS deployment target: 17.0
- macOS с установленными инструментами для генерации проекта (XcodeGen)

### Установка
1. Клонировать репозиторий.
2. Запустить `setup.command` (или `make -f .github/Makefile setup`).
3. Открыть `P2PMessenger.xcodeproj`.
4. Выбрать target `P2PMessenger`, задать команду разработки и запустить на устройстве/симуляторе.

> Для полноценной проверки P2P-сценариев рекомендуется тестировать минимум на 2 реальных устройствах.

### Изменение bundleIdPrefix
Если хотите изменить префикс:
1. Задайте его в файле `local.yml`:
```yaml
options:
  bundleIdPrefix: com.yourname
```
2. Повторно запустить `setup.command`.

## Тесты

Проект покрыт:
- **Unit-тестами** (`P2PMessengerTests`) — бизнес-логика
- **UI-тестами** (`P2PMessengerUITests`) — ключевые сценарии

Запуск:
- через Xcode (Product -> Test)
- или через схему тестов (`P2PMessengerTests`, `P2PMessengerUITests`)

## ⚠️ Известные ограничения

- Максимальное количество участников в общем чате — 8 (ограничение MultipeerConnectivity)
- История сообщений не синхронизируется между устройствами одного пользователя
