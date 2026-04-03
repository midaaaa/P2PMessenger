//
//  SettingsView.swift
//  P2PMessenger
//
//  Created by Дмитрий Филимонов on 01.04.2026.
//

import SwiftUI

struct SettingsView: View {
    @State var visibilityToggle: Bool = false
    @State var requestToggle: Bool = false
    @State var networkToggle: Bool = false
    var username = "иван"
    var spaceTaken = 1234
    @State var progress = 0.67

    var body: some View {
            List {
                Section {
                    Button {

                    } label: {
                        UserCard(username: username)
                            .tint(.primary)
                    }
                } header: {
                    Text("ПРОФИЛЬ")
                        .font(.footnote)
                }

                Section {
                    Toggle(isOn: $visibilityToggle) {
                        TextCard(label: "Разрешить находить меня", text: "Виден пользователям рядом")
                    }
                    .tint(Color("P2PDarkBlue"))
                    Toggle(isOn: $requestToggle) {
                        TextCard(label: "Разрешить запросы на переписку", text: "Принимать новые запросы")
                    }
                    .tint(Color("P2PDarkBlue"))
                } header: {
                    Text("ПРИВАТНОСТЬ")
                        .font(.footnote)
                }

                Section {
                    Toggle(isOn: $networkToggle) {
                        TextCard(label: "В сети", text: "Активен в P2P сети")
                    }
                    .tint(Color("P2PDarkBlue"))
                } header: {
                    Text("СЕТЬ")
                        .font(.footnote)
                }

                Section {
                    StorageCard(size: spaceTaken, progress: $progress)
                } header: {
                    Text("ДАННЫЕ")
                        .font(.footnote)
                }

                Section {
                    Button {

                    } label: {
                        DeleteCard()
                    }
                }

                Section {} footer: {
                    Text("P2P Messenger ⋅ v0.1.0 beta")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
    }
}

#Preview {
    SettingsView()
}
