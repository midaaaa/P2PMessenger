//
//  BluetoothMonitor.swift
//  P2PMessenger
//
//  Created by Sergei on 2026/04/03.
//

import CoreBluetooth
import Observation

@Observable
final class BluetoothMonitor: NSObject {
    
    var isBluetoothEnabled: Bool = false
    
    @ObservationIgnored
    private var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
}

extension BluetoothMonitor: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        DispatchQueue.main.async {
            self.isBluetoothEnabled = (central.state == .poweredOn)
        }
    }
}
