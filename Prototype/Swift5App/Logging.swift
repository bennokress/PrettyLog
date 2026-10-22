import Foundation
import PrettyLog

// Same file in every variant app: wrapper functions, a console target, an OSLog-style target with an
// exhaustive switch and a filtered analytics target. Nothing here names the variant.

nonisolated func logW(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .warning, category: category, to: logTargets)
}

nonisolated func logK(_ messages: (any CustomStringConvertible)?..., category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, as: .keyEvent, category: category, to: logTargets)
}

nonisolated private var logTargets: [any LogTarget<AppLogLevel>] {
    [ConsoleLog(), OSLogStyleLog(), AnalyticsLog()]
}

nonisolated struct ConsoleLog: LogTarget {
    let canLogSensitiveInformation = true
    func emit(_ level: AppLogLevel, message: String, category: LogCategory) {
        print("\(category.name) \(level.emoji) \(message)")
    }
}

nonisolated struct OSLogStyleLog: LogTarget {
    let canLogSensitiveInformation = false
    var levelFilter: LogLevelPriorityFilter<AppLogLevel> { .from(.info) }
    func emit(_ level: AppLogLevel, message: String, category: LogCategory) {
        // No default: a new level without a mapping does not compile.
        let type = switch level {
        case .debug: "debug"
        case .error: "fault"
        case .info: "info"
        case .keyEvent, .verbose: "notice"
        case .warning: "warning"
        }
        print("[\(type)] \(message)")
    }
}

nonisolated struct AnalyticsLog: LogTarget {
    let canLogSensitiveInformation = false
    var levelFilter: LogLevelPriorityFilter<AppLogLevel> { .only(.keyEvent) }
    func emit(_ level: AppLogLevel, message: String, category: LogCategory) { }
}

// Everyday calls, unchanged from today.
func everydayCalls(label: String, raw: String) {
    logW("FDDB Product", "Nutrient value unparseable", label, raw, category: LogCategory("Service"))
    logK("Onboarding finished")
}
