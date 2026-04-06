//
//  MPCNetworkServiceDelegate.swift
//  Sirius
//
//  Created by Екатерина on 06.04.2026.
//

import Foundation

@MainActor
protocol MPCNetworkServiceDelegate: AnyObject {
    func networkService(_ service: MPCNetworkService, didReceive message: CoreChatMessage)
    func networkService(_ service: MPCNetworkService, peersChanged peers: [ChatPeer])
    func networkService(_ service: MPCNetworkService, connectedPeersChanged peers: [ChatPeer])
    func networkService(_ service: MPCNetworkService, connectingPeersChanged peers: [ChatPeer])
    func networkService(_ service: MPCNetworkService, didUpdateLocalPeer peer: ChatPeer)
    func networkService(_ service: MPCNetworkService, didEncounter error: NetworkServiceError)
}
