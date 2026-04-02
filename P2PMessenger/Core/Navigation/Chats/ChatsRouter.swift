import Observation

@Observable
final class ChatsRouter {
    var path: [ChatsRoute] = []

    func push(_ route: ChatsRoute) {
        path.append(route)
    }

    func popToRoot() {
        path.removeAll()
    }
}