//
//  MPCNetworkConstants.swift
//  Sirius
//
//  Created by Екатерина on 04.04.2026.
//

import Foundation

enum MPCNetworkConstants {
    static let serviceType = "meshchat"

    static let userDefaultsPeerIDKey = "chat.localUserID"
    static let userDefaultsDisplayNameKey = "chat.displayName"
    static let userDefaultsGroupEpochKey = "chat.groupEpoch"

    static let discoveryUserIDKey = "userID"
    static let discoveryDisplayNameKey = "displayName"
    static let discoveryLeaderIDKey = "leaderID"
    static let discoveryClusterSizeKey = "clusterSize"
    static let discoveryGroupEpochKey = "groupEpoch"

    static let maxDisplayNameLength = 30
    static let protocolVersion = 3

    static let invitationTimeout: TimeInterval = 10
    static let retryBackoff: TimeInterval = 3
    static let inviteReapTime: TimeInterval = 12
    static let reevaluateDelay: TimeInterval = 0.5
}
