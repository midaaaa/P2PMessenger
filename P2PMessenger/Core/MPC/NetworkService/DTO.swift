import Foundation

struct WireMessageDTO: Codable {
    let id: UUID
    let text: String
    let senderID: String
    let senderDisplayName: String
    let recipientID: String?
    let recipientDisplayName: String?
    let timestamp: Date
}

struct HelloMessageDTO: Codable {
    let senderID: String
    let senderDisplayName: String
    let leaderID: String
    let clusterSize: Int
    let groupEpoch: Int
}

struct WirePacketDTO: Codable {
    let kind: String
    let chat: WireMessageDTO?
    let hello: HelloMessageDTO?

    static func chat(_ message: WireMessageDTO) -> WirePacketDTO {
        WirePacketDTO(kind: "chat", chat: message, hello: nil)
    }

    static func hello(_ message: HelloMessageDTO) -> WirePacketDTO {
        WirePacketDTO(kind: "hello", chat: nil, hello: message)
    }
}

struct InvitationContextDTO: Codable {
    let protocolVersion: Int
    let senderID: String
    let senderDisplayName: String
    let senderLeaderID: String
    let senderClusterSize: Int
    let senderGroupEpoch: Int
}
