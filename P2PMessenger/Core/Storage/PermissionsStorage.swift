protocol PermissionsStorageProtocol {
    var isLocalNetworkGranted: Bool { get set }
    var isNearbyGranted: Bool { get set }
}

final class PermissionsStorage: PermissionsStorageProtocol {
    private enum Keys {
        static let localNetwork = "permission.localNetwork.granted"
        static let nearby = "permission.nearby.granted"
    }

    private let storage: KeyValueStorageProtocol

    init(storage: KeyValueStorageProtocol) {
        self.storage = storage
    }

    var isLocalNetworkGranted: Bool {
        get { storage.bool(forKey: Keys.localNetwork) }
        set { storage.set(newValue, forKey: Keys.localNetwork) }
    }

    var isNearbyGranted: Bool {
        get { storage.bool(forKey: Keys.nearby) }
        set { storage.set(newValue, forKey: Keys.nearby) }
    }
}
