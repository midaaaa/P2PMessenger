//
//  DependencyContainer.swift
//  P2PMessenger
//
//  Created by Maksim on 03.04.2026.
//

import Foundation

final class DependencyContainer: ObservableObject {
    
    let notificationService: NotificationServiceProtocol
    
    let router: AppRouter
    
    
    init(notificationService: NotificationServiceProtocol = NotificationService(),
         router: AppRouter = AppRouter()) {
        self.notificationService = notificationService
        self.router = router
    }
}
