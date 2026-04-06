import Foundation
import MultipeerConnectivity

extension MPCNetworkService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let info,
              let remoteID = info[MPCNetworkConstants.discoveryUserIDKey],
              remoteID != localUserID else {
            return
        }

        updateDiscoveredPeer(peerID: peerID, info: info)
        evaluateConnection(for: remoteID)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        removeDiscoveredPeer(peerID: peerID)
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        publishError(.transportFailure(error.localizedDescription))
    }
}
