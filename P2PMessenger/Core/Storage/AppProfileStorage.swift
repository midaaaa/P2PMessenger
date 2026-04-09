import Foundation

final class AppProfileStorage: UserProfileStorageProtocol {

    private enum Keys {
        static let userID = "chat.localUserID"
        static let displayName = "chat.displayName"
        static let groupEpoch = "chat.groupEpoch"
    }

    private let storage: KeyValueStorageProtocol

    init(storage: KeyValueStorageProtocol) {
        self.storage = storage

        if storage.string(forKey: Keys.userID) == nil {
            storage.set(UUID().uuidString, forKey: Keys.userID)
        }
    }

    var userID: String {
        storage.string(forKey: Keys.userID)!
    }

    var displayName: String? {
        get { storage.string(forKey: Keys.displayName) }
        set { storage.set(newValue, forKey: Keys.displayName) }
    }

    var groupEpoch: Int {
        get {
            let stored = storage.integer(forKey: Keys.groupEpoch)
            return stored == 0 ? 1 : stored
        }
        set { storage.set(newValue, forKey: Keys.groupEpoch) }
    }
}
