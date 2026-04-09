//
//  BluetoothStatusViewModel.swift
//  P2PMessenger
//
//  Created by Sergei on 2026/04/03.
//

import Observation

@MainActor
@Observable
final class BluetoothStatusViewModel {

    private let monitor: BluetoothMonitorProtocol

    var isBluetoothOff: Bool {
        monitor.managerState == .poweredOff
    }

    init(monitor: BluetoothMonitorProtocol) {
        self.monitor = monitor
    }
}
