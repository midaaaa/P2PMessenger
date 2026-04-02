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
        NavigationStack {
            List {
                Section {
                    Button {

                    } label: {
                        userCard(username: username)
                            .tint(.primary)
                    }
                } header: {
                    Text("ПРОФИЛЬ")
                        .font(.footnote)
                }

                Section {
                    Toggle(isOn: $visibilityToggle) {
                        textCard(label: "Разрешить находить меня", text: "Виден пользователям рядом")
                    }
                    .tint(Color("P2PDarkBlue"))
                    Toggle(isOn: $requestToggle) {
                        textCard(label: "Разрешить запросы на переписку", text: "Принимать новые запросы")
                    }
                    .tint(Color("P2PDarkBlue"))
                } header: {
                    Text("ПРИВАТНОСТЬ")
                        .font(.footnote)
                }

                Section {
                    Toggle(isOn: $networkToggle) {
                        textCard(label: "В сети", text: "Активен в P2P сети")
                    }
                    .tint(Color("P2PDarkBlue"))
                } header: {
                    Text("СЕТЬ")
                        .font(.footnote)
                }

                Section {
                    storageCard(size: spaceTaken, progress: $progress)
                } header: {
                    Text("ДАННЫЕ")
                        .font(.footnote)
                }

                Section {
                    Button {

                    } label: {
                        deleteCard()
                    }
                }

                Section {} footer: {
                    Text("P2P Messenger ⋅ v0.1.0 beta")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Настройки")
        }
    }
}

struct userCard: View {
    var username: String

    var body: some View {
        HStack {
            Circle()
                .fill(.secondary)
                .stroke(Color.black, lineWidth: Constants.userAvatarStrokeWidth)
                .frame(width: Constants.userAvatarSize, height: Constants.userAvatarSize)
                .opacity(Constants.userAvatarOpacity)
                .overlay {
                    Text(String(username.uppercased().first ?? "?"))
                        .font(.title)
                }
                .padding(.trailing, Constants.userAvatarPadding)

            VStack(alignment: .leading) {
                Text("Имя пользователя")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .padding(.bottom, Constants.userTextPadding)
                Text(username)
                    .font(.title3)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding(.vertical, Constants.userCardPadding)
    }
}

struct textCard: View {
    var label: String
    var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.system(size: Constants.mainFontSize))
                .padding(.bottom, Constants.textCardPadding)
            Text(text)
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .padding(.vertical, Constants.verticalPadding)
    }
}

struct storageCard: View {
    var size: Int
    @Binding var progress: Double

    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.storageIconCornerRadius)
                    .frame(width: Constants.storageIconSize, height: Constants.storageIconSize)
                    .foregroundStyle(.secondary)
                    .opacity(Constants.storageIconOpacity)
                Image(systemName: "server.rack")
            }
            .padding(.trailing, Constants.storageIconPadding)
            VStack(alignment: .leading) {
                Text("Занято памяти")
                Text("\(size) МБ ⋅ Чаты и медиафайлы")  // compute size units
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            Spacer()
            ProgressView(value: progress)
                .scaleEffect(x: Constants.progressViewWidthScale,
                             y: Constants.progressViewHeightScale)
                .tint(.secondary)
                .frame(maxWidth: Constants.progressViewWidth)
        }
        .padding(.vertical, Constants.verticalPadding)
    }
}

struct deleteCard: View {
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.deleteIconCornerRadius)
                    .frame(width: Constants.deleteIconSize, height: Constants.deleteIconSize)
                    .foregroundStyle(.secondary)
                    .opacity(Constants.deleteIconOpacity)
                Image(systemName: "trash")
            }
            .padding(.trailing, Constants.deleteIconPadding)
            Text("Удалить все чаты")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .tint(.primary)
        .padding(.vertical, Constants.verticalPadding)
    }
}

private enum Constants {
    static let mainFontSize: CGFloat = 16

    static let userAvatarSize: CGFloat = 60
    static let userAvatarStrokeWidth: CGFloat = 0.5
    static let userAvatarOpacity: CGFloat = 0.2
    static let userAvatarPadding: CGFloat = 6
    static let userTextPadding: CGFloat = 2
    static let userCardPadding: CGFloat = 5

    static let textCardPadding: CGFloat = 4

    static let storageIconCornerRadius: CGFloat = 20
    static let storageIconSize: CGFloat = 50
    static let storageIconOpacity: CGFloat = 0.2
    static let storageIconPadding: CGFloat = 6

    static let progressViewWidth: CGFloat = 80
    static let progressViewWidthScale: CGFloat = 1
    static let progressViewHeightScale: CGFloat = 1.5

    static let deleteIconCornerRadius: CGFloat = 20
    static let deleteIconSize: CGFloat = 50
    static let deleteIconOpacity: CGFloat = 0.2
    static let deleteIconPadding: CGFloat = 6

    static let verticalPadding: CGFloat = 6
}

#Preview {
    SettingsView()
}
