//
//  ModalViewNetworkError.swift
//  P2PMessenger
//
//  Created by Sergei on 2026/04/03.
//

import CoreBluetooth
import Combine

final class BluetoothMonitor: NSObject, ObservableObject {
    
    static let shared = BluetoothMonitor()
    
    @Published var isBluetoothEnabled: Bool = false
    
    private var centralManager: CBCentralManager!
    
    private override init() {
        super.init()
        print("BluetoothMonitor init")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
}

extension BluetoothMonitor: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Bluetooth state:", central.state.rawValue)
        DispatchQueue.main.async {
            self.isBluetoothEnabled = (central.state == .poweredOn)
        }
    }
}
