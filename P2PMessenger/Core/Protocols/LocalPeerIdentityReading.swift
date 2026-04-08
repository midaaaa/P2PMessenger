import Foundation

protocol LocalPeerIdentityReading {
    var displayName: String { get }
    func updateDisplayName(_ newName: String) -> LocalPeerIdentityUpdateResult
}
