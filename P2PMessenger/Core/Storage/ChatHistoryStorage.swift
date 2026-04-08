import Foundation

protocol ChatHistoryStorageProtocol {
    func loadMeshMessages() -> [CoreChatMessage]
    func saveMeshMessages(_ messages: [CoreChatMessage])
}

final class ChatHistoryStorage: ChatHistoryStorageProtocol {
    private enum Keys {
        static let mesh = "chat.common.messages"
    }

    private let storage: KeyValueStorageProtocol
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(storage: KeyValueStorageProtocol) {
        self.storage = storage
    }

    func loadMeshMessages() -> [CoreChatMessage] {
        guard let data = storage.data(forKey: Keys.mesh),
              let messages = try? decoder.decode([CoreChatMessage].self, from: data) else {
            return []
        }
        return messages.sorted { $0.timestamp < $1.timestamp }
    }

    func saveMeshMessages(_ messages: [CoreChatMessage]) {
        if let data = try? encoder.encode(messages) {
            storage.set(data, forKey: Keys.mesh)
        }
    }

}
