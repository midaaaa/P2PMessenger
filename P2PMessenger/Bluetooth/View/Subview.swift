//
//  SubWiev.swift
//  P2PMessenger
//
//  Created by Sergei on 2026/04/03.
//

import SwiftUI

struct NoBluetoothView: View {

    @State private var animateCard = false

    var body: some View {

        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
            VStack(spacing: 24) {
                Image("bluetooth_slash")
                    .resizable()
                    .tint(.secondary)
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Text("noBluetoothConnection")
                    .font(.headline)
                    .font(.system(size: 50))
                    .multilineTextAlignment(.center)
                Text("turnItOnInSettings")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                Button("moveTo") {
                    openBluetoothSettings()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(24)
            .padding(30)
            .frame(maxWidth: 320)
            .background(Color("P2PBackground"))
            .cornerRadius(24)
            .shadow(radius: 20)
            .scaleEffect(animateCard ? 1 : 0.8)
            .opacity(animateCard ? 1 : 0)
            .offset(y: animateCard ? 0 : 50)
            .animation(.spring(response: 0.45, dampingFraction: 0.75), value: animateCard)
        }
        .onAppear {
            animateCard = true
        }
    }

    func openBluetoothSettings() {
        guard let settingsURL = URL(string: "App-Prefs:root=Bluetooth") else {
            return // UIApplication.openSettingsURLString
        }

        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }

    }
}

#Preview {
    NoBluetoothView()
}
