//
//  MPCNetworkServiceState.swift
//  Sirius
//
//  Created by Екатерина on 04.04.2026.
//

import Foundation

struct MPCNetworkLifecycleState {
    var isRunning = false
    var hasStartedOnce = false
    var isSuspended = false
}

struct MPCNetworkAdvertiserState {
    var lastAdvertisedLeaderID: String?
    var lastAdvertisedClusterSize: Int?
    var lastAdvertisedGroupEpoch: Int?
}
