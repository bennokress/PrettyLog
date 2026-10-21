//
// 📄 EverydayCalls.swift
// 👨🏼‍💻 Author: Benno Kress
//

// PROTOTYPE (#71): the same in BeforeApp and AfterApp. No import of PrettyLog, like in a real app.

import Foundation

nonisolated struct FDDBService {

    func parse(label: String, raw: String) {
        logW("FDDB Product", "Nutrient value unparseable", label, raw, category: .service)
    }

    func sync(recordName: String) {
        logX("Current iCloud Record ID", sensitiveMessages: recordName, category: .service)
    }

    func handle(_ error: any Error) {
        log(error, category: .service)
    }

    func bool(for key: String, in store: [String: Bool]) -> Bool {
        guard let value = store[key] else {
            fatalLog("Value for '\(key)' could not be found or converted into a Bool!", category: .storage)
        }
        return value
    }

}

// Logging from off the main actor must keep working with main actor default isolation.
actor BackgroundWorker {

    func run() {
        logI("Background work started", category: .service)
        logK("Subscription verified", category: .service)
    }

}

@MainActor
final class SomeViewModel {

    func appear() {
        logD("View appeared", category: .general)
    }

}
