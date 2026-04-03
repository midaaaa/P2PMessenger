//
//  AppRouterProtocol.swift
//  P2PMessenger
//
//  Created by Maksim on 03.04.2026.
//

import Foundation
import Combine

protocol AppRouterProtocol {
    var selectedTab: AppTab { get set }
    
    var activeChatId: String? { get set }
}
