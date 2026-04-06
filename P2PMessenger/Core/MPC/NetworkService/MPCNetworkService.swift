//
//  MPCNetworkService.swift
//  P2PMessenger
//
//  Created by Екатерина on 03.04.2026.
//

import Foundation
import MultipeerConnectivity
import UIKit

@MainActor
protocol MPCNetworkServiceDelegate: AnyObject {
    func networkService(_ service: MPCNetworkService, didReceive message: ChatMessage)
    func networkService(_ service: MPCNetworkService, peersChanged peers: [ChatPeer])
    func networkService(_ service: MPCNetworkService, connectedPeersChanged peers: [ChatPeer])
    func networkService(_ service: MPCNetworkService, connectingPeersChanged peers: [ChatPeer])
    func networkService(_ service: MPCNetworkService, didUpdateLocalPeer peer: ChatPeer)
    func networkService(_ service: MPCNetworkService, didEncounter error: NetworkServiceError)
}

final class MPCNetworkService: NSObject {
    weak var delegate: MPCNetworkServiceDelegate?

}
