import Foundation
import Observation

protocol OnboardingStorageProtocol {
    func getIsOnboardingPassed() -> Bool
    func setIsOnboardingPassed(_ passed: Bool)
}

final class OnboardingStorage: OnboardingStorageProtocol {
    private let storage: KeyValueStorageProtocol
    private let onboardingKey = "isOnboardingPassed"

    init(storage: KeyValueStorageProtocol) {
        self.storage = storage
    }

    func getIsOnboardingPassed() -> Bool {
        return storage.bool(forKey: onboardingKey)
    }

    func setIsOnboardingPassed(_ passed: Bool) {
        storage.set(passed, forKey: onboardingKey)
    }
}

@Observable
final class OnboardingState: OnboardingStateProtocol {
    private let storage: OnboardingStorageProtocol

    var isOnboardingPassed: Bool {
        didSet {
            storage.setIsOnboardingPassed(isOnboardingPassed)
        }
    }

    init(storage: OnboardingStorageProtocol) {
        self.storage = storage
        self.isOnboardingPassed = storage.getIsOnboardingPassed()
    }

    func markOnboardingPassed() {
        isOnboardingPassed = true
    }
}
