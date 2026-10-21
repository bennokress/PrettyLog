# PROTOTYPE: app log levels as an enum behind a package protocol

Throwaway. Answers issue #71. This branch is never merged.

`Sources/PrettyLogStruct` is the API of `feature/api` (3.0, levels as struct values), copied unchanged.
`Sources/PrettyLog` is the enum design. `Prototype/BeforeApp` and `Prototype/AfterApp` are the same app
written against each, modelled on Verktøy, both with main actor default isolation. Build the
`PrettyLog-Package` scheme and run its tests on a simulator.

## The package side of the enum design

Second round (2026-10-21, after feedback): the order of the cases must not matter, because the
maintainer sorts cases alphabetically. The priority is now the enum's `Int` raw value.

```swift
public protocol LogLevel: RawRepresentable, Sendable, Hashable where RawValue == Int {
    var emoji: String { get }
}

public extension LogLevel {
    var priority: Int { rawValue }   // no requirement, so an enum can't replace it
}

public protocol LogTarget<Level> {
    associatedtype Level: LogLevel
    var canLogSensitiveInformation: Bool { get }
    func emit(_ level: Level, message: String, category: LogCategory)
    var levelFilter: LogLevelFilter<Level> { get }
}

public struct LogLevelFilter<Level: LogLevel> // .all, .none, .only(…), .from(_:), .until(_:), .between(_:and:)

PrettyLogProxy.log<Level: LogLevel>(…, as level: Level, …, to targets: [any LogTarget<Level>])
```

The filter compares priorities, as on `feature/api`. Swift rejects two cases with the same raw value,
so two levels with the same priority can't exist within one enum. The first round used the order of
the cases instead (synthesized `Comparable`); it was dropped because sorting the cases would have
changed the meaning silently.

## Before and after

| File | Changes? |
| --- | --- |
| `EverydayCalls.swift` (`logW`, `logX`, `fatalLog`, `log(error)`) | no, identical |
| `Logging/PrettyLog.swift` (wrapper functions) | no, identical apart from the import |
| `Logging/Categories.swift` | no |
| `Logging/Levels.swift` | yes, extension with values becomes an enum |
| `Logging/ActiveLogTargets.swift` | yes, `[any LogTarget]` becomes `[any LogTarget<AppLogLevel>]` (5 places) |
| `Logging/Targets/*.swift` | yes, `emit` takes `AppLogLevel`, the filter type is `LogLevelFilter<AppLogLevel>` |
| Test target | yes, `MemoryLogTarget.emit` takes `AppLogLevel`, `[any LogTarget<AppLogLevel>]` in calls |

Levels, before:

```swift
nonisolated extension LogLevel {
    static var debug: LogLevel { LogLevel(emoji: "🟤", priority: 100) }
    …
    static var keyEvent: LogLevel { LogLevel(emoji: "📊", priority: .max) }
}
```

Levels, after:

```swift
nonisolated enum AppLogLevel: Int, LogLevel, CaseIterable {

    case debug = 100
    case error = 900
    case info = 500
    case keyEvent = 1000
    case verbose = 300
    case warning = 700

    var emoji: String {
        switch self {
        case .debug: "🟤"
        …
        case .warning: "🟡"
        }
    }
}
```

OSLog target, before and after: the `switch` loses its `default`, and a new case does not compile
until it has a mapping. Filters: `.fromPriority(of: .info)` becomes `.from(.info)`, and
`.only(.staging, .error)` matches exactly these priorities.

## What the compiler showed

Every point below comes from a build or test run of this branch on 2026-10-21 (Xcode 27, iOS 27.1
simulator).

1. **Minimum OS rises.** With the package's iOS 15 / macOS 12 / tvOS 15 minimum, `any LogTarget<Level>`
   fails: "Runtime support for parameterized protocol types is only available in iOS 16.0.0 or newer".
   This branch raises the minimum to iOS 16, macOS 13, tvOS 16 (watchOS 9 stays). The other way out
   would be a type-erasing `AnyLogTarget<Level>` wrapper in the package, which every app would then
   write around each target.
2. **A new case without mapping stops the build**, first in the `emoji` switch, then in the OSLog
   target: "Switch must be exhaustive".
3. **The raw value is enforced** (second round). Three cases with `= 500` fail with "Raw value for
   enum case is not unique". An enum without raw value fails with "Type 'NoRawValueLevel' does not
   conform to protocol 'RawRepresentable'". A `String` raw value fails with "'LogLevel' requires the
   types 'String' and 'Int' be equivalent". An enum that writes its own `var priority` builds, but the
   package ignores it and uses the raw value (test `packageIgnoresOwnPriorityAndUsesRawValue`).
   First round, now obsolete: a raw value removed the synthesized `Comparable`.
4. **A target of another app's level type** is rejected when added to the list: "Cannot convert value
   of type 'ForeignLevel' to expected argument type 'AppLogLevel'".
5. **`as: .debug` needs a typed target list.** `PrettyLogProxy.log(["x"], as: .debug, to: [])` fails
   with "Type 'LogLevel' has no member 'debug'". In the wrappers this never happens, because
   `ActiveLogTargets.current` carries the type.
6. **`nonisolated` under main actor default isolation**: the level enum builds without it, in both
   rounds. A target
   without it fails exactly as today: "Main actor-isolated conformance of 'Console' to 'LogTarget'
   cannot be used in nonisolated context".
7. **Swift 5 language mode** (`Prototype/Swift5App`): builds.
8. **Reuse across apps** (`Prototype/SharedLogTargets`, `Prototype/OtherApp`): a target that only needs
   the emoji is generic (`SharedConsole<Level>`) and Swift infers `Level` from the list type, so the
   app writes `SharedConsole()`. A target that maps levels (OSLog, backend) needs a second protocol the
   app's enum conforms to (`OSLogMappable`), and the mapping moves from the target into the enum.
9. **Tests**: 15 of 15 pass in the second round: the same three tests before and after, one that
   walks `AppLogLevel.allCases`, `.between(.warning, and: .info)` and `.only(.keyEvent, .error)` on
   alphabetically sorted cases, and the own-priority test from point 3.

## Not tested

- A library module with its own levels (like the Wallet SDK) next to an app with different levels.
  From point 4 it follows that the app could not hand its targets to the SDK; the SDK would need its own
  targets or a level mapping. Not built here.
- Performance of the existential `any LogTarget<Level>` compared to `any LogTarget`.
