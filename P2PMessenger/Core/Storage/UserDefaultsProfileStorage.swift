import Foundation

final class UserDefaultsProfileStorage: UserProfileStorageProtocol {

    private enum Keys {
        static let userID = "chat.localUserID"
        static let displayName = "chat.displayName"
        static let groupEpoch = "chat.groupEpoch"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        if defaults.string(forKey: Keys.userID) == nil {
            defaults.set(UUID().uuidString, forKey: Keys.userID)
        }
    }

    var userID: String {
        defaults.string(forKey: Keys.userID)!
    }

    var displayName: String? {
        get { defaults.string(forKey: Keys.displayName) }
        set { defaults.set(newValue, forKey: Keys.displayName) }
    }

    var groupEpoch: Int {
        get {
            let stored = defaults.integer(forKey: Keys.groupEpoch)
            return stored == 0 ? 1 : stored
        }
        set { defaults.set(newValue, forKey: Keys.groupEpoch) }
    }
}
