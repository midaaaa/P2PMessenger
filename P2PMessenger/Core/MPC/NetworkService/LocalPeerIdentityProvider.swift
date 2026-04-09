//
//  LocalPeerIdentityProvider.swift
//  P2PMessenger
//

import Foundation
import MultipeerConnectivity
import UIKit

protocol LocalPeerIdentityDelegate: AnyObject {
    func identityProviderDidChangeIdentity()
}

enum LocalPeerIdentityUpdateResult {
    case invalidDisplayName
    case unchanged
    case changed
}

final class LocalPeerIdentityProvider: LocalPeerIdentityReading {
    weak var delegate: LocalPeerIdentityDelegate?

    private var profileStorage: UserProfileStorageProtocol

    let localUserID: String
    private(set) var peerID: MCPeerID

    private(set) var groupEpoch: Int {
        didSet {
            profileStorage.groupEpoch = groupEpoch
        }
    }

    var displayName: String {
        peerID.displayName
    }

    var localPeer: ChatPeer {
        ChatPeer(id: localUserID, displayName: displayName)
    }

    init(profileStorage: UserProfileStorageProtocol) {
        self.profileStorage = profileStorage
        self.localUserID = profileStorage.userID

        let initialDisplayName = Self.validatedDisplayName(
            profileStorage.displayName ?? UIDevice.current.name
        ) ?? "Sirius"

        self.groupEpoch = profileStorage.groupEpoch
        self.peerID = MCPeerID(displayName: initialDisplayName)
    }

    static func validatedDisplayName(_ rawValue: String) -> String? {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let collapsedWhitespace = trimmed
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        let shortened = String(collapsedWhitespace.prefix(MPCNetworkConstants.maxDisplayNameLength))
        guard !shortened.isEmpty else { return nil }
        return shortened
    }

    func updateDisplayName(_ newName: String) -> LocalPeerIdentityUpdateResult {
        guard let validatedName = Self.validatedDisplayName(newName) else {
            return .invalidDisplayName
        }

        guard validatedName != displayName else {
            return .unchanged
        }

        profileStorage.displayName = validatedName

        groupEpoch += 1
        peerID = MCPeerID(displayName: validatedName)

        delegate?.identityProviderDidChangeIdentity()

        return .changed
    }
}
