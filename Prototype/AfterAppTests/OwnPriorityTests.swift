import PrettyLog
import Testing

// An enum that writes its own `priority` next to the raw value.
private enum OwnPriorityLevel: Int, LogLevel {
    case high = 900
    case low = 100
    var emoji: String { "x" }
    var priority: Int { self == .high ? 1 : 2 }
}

struct OwnPriorityTests {

    @Test func packageIgnoresOwnPriorityAndUsesRawValue() {
        #expect(LogLevelFilter<OwnPriorityLevel>.from(.low).contains(.high))
        #expect(!LogLevelFilter<OwnPriorityLevel>.from(.high).contains(.low))
    }

}
