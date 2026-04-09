//
//  ConnectionSchedulerTests.swift
//  P2PMessenger
//
//  Created by Екатерина on 08.04.2026.
//


import Foundation
import Testing
@testable import P2PMessenger

struct ConnectionSchedulerTests {
    @Test //проверяет работу retry, что он реально срабатывает и успевает выполнится
    func scheduleRetry_storesDateAndFiresCallback() async throws {
        let scheduler = ConnectionScheduler()
        let fireDate = Date().addingTimeInterval(0.15)
        let counter = Counter()

        scheduler.scheduleRetry(
            for: "peer",
            at: fireDate,
            isRunning: true,
            isSuspended: false,
            defaultBackoff: 1
        ) {
            counter.increment()
        }

        #expect(scheduler.retryDate(for: "peer") == fireDate)
        try await Task.sleep(for: .milliseconds(300))
        #expect(counter.value == 1)
    }

    @Test //проверяет, чтобы retry не дергался, если сервис не работает
    func scheduleRetry_doesNothingWhenServiceIsNotRunnable() async throws {
        let scheduler = ConnectionScheduler()
        let counter = Counter()

        scheduler.scheduleRetry(for: "peer", isRunning: false, isSuspended: false, defaultBackoff: 0.1) {
            counter.increment()
        }
        scheduler.scheduleRetry(for: "peer2", isRunning: true, isSuspended: true, defaultBackoff: 0.1) {
            counter.increment()
        }

        try await Task.sleep(for: .milliseconds(250))
        #expect(scheduler.retryDate(for: "peer") == nil)
        #expect(scheduler.retryDate(for: "peer2") == nil)
        #expect(counter.value == 0)
    }

    @Test //проверяет работоспособность отмены retry, чтобы retry внезапно запоздало не срабатывал
    func cancelRetry_preventsCallback() async throws {
        let scheduler = ConnectionScheduler()
        let counter = Counter()

        scheduler.scheduleRetry(for: "peer", isRunning: true, isSuspended: false, defaultBackoff: 0.1) {
            counter.increment()
        }
        scheduler.cancelRetry(for: "peer")

        try await Task.sleep(for: .milliseconds(250))
        #expect(counter.value == 0)
    }

    @Test //проверяет таймерные сценарии для scheduler (когда время инвайта истекает или когда требуется reevaluation)
    func inviteExpiryAndReevaluation_fireAndCanBeCancelled() async throws {
        let scheduler = ConnectionScheduler()
        let expiryCounter = Counter()
        let reevaluateCounter = Counter()

        scheduler.scheduleInviteExpiry(for: "peer", after: 0.1) {
            expiryCounter.increment()
        }
        scheduler.scheduleReevaluation(after: 0.1, isRunning: { true }, isSuspended: { false }) {
            reevaluateCounter.increment()
        }

        try await Task.sleep(for: .milliseconds(250))
        #expect(expiryCounter.value == 1)
        #expect(reevaluateCounter.value == 1)

        scheduler.scheduleInviteExpiry(for: "peer2", after: 0.1) {
            expiryCounter.increment()
        }
        scheduler.scheduleReevaluation(after: 0.1, isRunning: { true }, isSuspended: { false }) {
            reevaluateCounter.increment()
        }
        scheduler.cancelInviteExpiry(for: "peer2")
        scheduler.cancelReevaluation()

        try await Task.sleep(for: .milliseconds(250))
        #expect(expiryCounter.value == 1)
        #expect(reevaluateCounter.value == 1)
    }
}

private final class Counter: @unchecked Sendable {
    private let lock = NSLock()
    private var storage = 0

    var value: Int {
        lock.lock()
        defer { lock.unlock() }
        return storage
    }

    func increment() {
        lock.lock()
        storage += 1
        lock.unlock()
    }
}
