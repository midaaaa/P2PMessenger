struct SettingsRootView: View {
    @Bindable var router: SettingsRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            SettingsView()
                .navigationDestination(for: SettingsRoute.self) { route in
                    switch route {
                    case .editProfile:
                        EditProfileView()

                    case .notifications:
                        NotificationsSettingsView()

                    case .privacy:
                        PrivacySettingsView()
                    }
                }
        }
    }
}