import Foundation
import MultipeerConnectivity

extension MPCNetworkService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        guard let context,
              let invite = try? decoder.decode(InvitationContextDTO.self, from: context),
              invite.protocolVersion == MPCNetworkConstants.protocolVersion,
              invite.senderID != localUserID else {
            invitationHandler(false, nil)
            publishError(.invalidInvitation)
            return
        }

        updateDiscoveredPeer(
            peerID: peerID,
            info: [
                MPCNetworkConstants.discoveryUserIDKey: invite.senderID,
                MPCNetworkConstants.discoveryDisplayNameKey: invite.senderDisplayName,
                MPCNetworkConstants.discoveryLeaderIDKey: invite.senderLeaderID,
                MPCNetworkConstants.discoveryClusterSizeKey: String(invite.senderClusterSize),
                MPCNetworkConstants.discoveryGroupEpochKey: String(invite.senderGroupEpoch)
            ]
        )

        let remoteID = invite.senderID
        guard canAcceptInvitation(
            from: remoteID,
            senderLeaderID: invite.senderLeaderID,
            senderClusterSize: invite.senderClusterSize
        ) else {
            invitationHandler(false, nil)
            return
        }

        unmarkPeerInvited(remoteID)
        cancelInviteExpiry(for: remoteID)
        markIncomingInvitation(remoteID)
        markPeerConnecting(remoteID)
        publishConnectingPeers()

        invitationHandler(true, session)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        publishError(.transportFailure(error.localizedDescription))
    }
}
