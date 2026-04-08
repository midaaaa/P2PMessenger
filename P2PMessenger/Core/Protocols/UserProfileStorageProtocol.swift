import Foundation

protocol UserProfileStorageProtocol {
    var userID: String { get }
    var displayName: String? { get set }
    var groupEpoch: Int { get set }
}
