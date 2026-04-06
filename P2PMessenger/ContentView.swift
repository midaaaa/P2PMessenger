//
//  ContentView.swift
//  P2PMessenger
//
//  Created by Maksim on 31.03.2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(DependencyContainer.self) var container

    var body: some View {
        WelcomeScreenView(vm: container.welcomeScreenVM)
    }
}

#Preview {
    ContentView()
        .environment(DependencyContainer())
}
