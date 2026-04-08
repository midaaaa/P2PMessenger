//
//  BluetoothMonitorProtocol.swift
//  P2PMessenger
//
//  Created by Antigravity on 08.04.2026.
//

import CoreBluetooth

@MainActor
protocol BluetoothMonitorProtocol: AnyObject {
    var managerState: CBManagerState { get }
    var isBluetoothEnabled: Bool { get }
}
