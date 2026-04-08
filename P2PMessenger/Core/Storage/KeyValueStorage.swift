import Foundation

protocol KeyValueStorageProtocol {
    func string(forKey key: String) -> String?
    func set(_ value: Any?, forKey key: String)
    func bool(forKey key: String) -> Bool
    func integer(forKey key: String) -> Int
    func data(forKey key: String) -> Data?
}

final class AppKeyValueStorage: KeyValueStorageProtocol {
    private let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    func string(forKey key: String) -> String? {
        defaults.string(forKey: key)
    }

    func set(_ value: Any?, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    func bool(forKey key: String) -> Bool {
        defaults.bool(forKey: key)
    }

    func integer(forKey key: String) -> Int {
        defaults.integer(forKey: key)
    }

    func data(forKey key: String) -> Data? {
        defaults.data(forKey: key)
    }
}
