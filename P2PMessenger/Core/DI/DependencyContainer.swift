//
//  DependencyContainer.swift
//  P2PMessenger
//
//  Created by Maksim on 03.04.2026.
//

import Foundation
import Observation

@Observable
final class DependencyContainer {
    
    let notificationService: NotificationServiceProtocol
    
    let router: AppRouter
    
    
    init(notificationService: NotificationServiceProtocol = NotificationService(),
         router: AppRouter = AppRouter()) {
        self.notificationService = notificationService
        self.router = router
    }
}
