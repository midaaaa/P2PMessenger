//
//  ViewModel.swift
//  P2PMessenger
//
//  Created by Sergei on 2026/04/03.
//

import SwiftUI
import Combine

final class BluetoothStatusViewModel: ObservableObject {
    
    @Published var isBluetoothOff: Bool = true
    
    private let monitor: BluetoothMonitor
    private var cancellables = Set<AnyCancellable>()
    
    init(monitor: BluetoothMonitor = .shared) {
        self.monitor = monitor
        bindBluetoothState()
    }
    
    private func bindBluetoothState() {
        monitor.$isBluetoothEnabled
            .compactMap { !$0 }
            .sink { [weak self] isEnabled in
                self?.isBluetoothOff = isEnabled
            }
            .store(in: &cancellables)
    }
}
