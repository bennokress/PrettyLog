# PROTOTYPE (#73): one-line log level definitions

Throwaway branch, never merged. Question: can an app define each log level in one line with emoji and priority, sorted alphabetically, with priorities as safe from duplicates as possible?

All four variants build in apps with main actor default isolation, the V3 macro variant also in Swift 5 language mode (`Swift5App`). Every app uses the same `Logging.swift`: wrapper functions, an OSLog-style target with a `switch` without `default`, and filtered targets. Nothing in that file names the variant. The package side is the same for all: `LogLevel` requires `emoji`, `priority` and `CaseIterable`, is `Comparable` via priority, and `LogLevelPriorityFilter` stores the set of levels it accepts.

Build and test runs on 2026-10-22 with Xcode 27.1 on the iOS 27.1 simulator (iPhone 18 Pro): build succeeded, 4 of 4 tests passed (`Prototype/Tests/VariantTests.swift`, the same checks for every variant).

## The four variants

### V0: raw value plus emoji switch (the plan before this ticket)

```swift
nonisolated enum AppLogLevel: Int, LogLevel {

    case debug = 100
    case error = 900
    …

    var emoji: String {
        switch self {
        case .debug: "🟤"
        case .error: "🔴"
        …
        }
    }

}
```

### V1: no macro, text as raw value

```swift
nonisolated enum AppLogLevel: LogLevelSpec, LogLevel {

    case debug = "🟤 100"
    case error = "🔴 900"
    …

}
```

`LogLevelSpec` is a package type built from a string literal and split into emoji and priority.

### V2: macro plus `Int` raw value

```swift
@LogLevels
nonisolated enum AppLogLevel: Int {

    @Emoji("🟤") case debug = 100
    @Emoji("🔴") case error = 900
    …

}
```

The compiler checks the raw values, the macro adds `emoji`, `allCases` and the `LogLevel` conformance.

### V3: macro, no raw value

```swift
@LogLevels
nonisolated enum AppLogLevel {

    @Level("🟤", priority: 100) case debug
    @Level("🔴", priority: 900) case error
    …

}
```

The macro adds `emoji`, `priority`, `allCases` and the conformance, and checks the priorities itself.

## What happens with mistakes (deliberately broken build, 2026-10-22)

| Mistake | V0 | V1 | V2 | V3 |
| --- | --- | --- | --- | --- |
| second level with priority 500, other emoji | "Raw value for enum case is not unique" | **builds**, only the debug check in the filter stops the app at runtime | "Raw value for enum case is not unique" | "Priority 500 is already used by 'info'; every level needs its own priority" |
| same emoji and priority twice | as above | "Raw value for enum case is not unique" | as above | as above |
| new level without emoji | "Switch must be exhaustive" | can't happen, the emoji is in the text | "Every case needs @Emoji(…) or @Level(…)" | same message |
| typo in the priority (`6OO`) | doesn't compile (not an `Int`) | **builds**, `preconditionFailure` when the raw value is first read (in the code, not run) | doesn't compile | "The priority has to be an integer literal" |
| priority as an expression (`600 + 1`) | not allowed as raw value | not possible | not allowed as raw value | "The priority has to be an integer literal" |

The macro messages point at the line of the case, with "(from macro 'LogLevels')" appended.

## Cost per variant

| | V0 | V1 | V2 | V3 |
| --- | --- | --- | --- | --- |
| lines per level | 2 (case and switch branch) | 1 | 1 | 1 |
| dependency of the package | none | none | `swift-syntax` | `swift-syntax` |
| new package API | none | `LogLevelSpec` | `@LogLevels`, `@Emoji` | `@LogLevels`, `@Level` |
| who checks unique priorities | compiler | partly the compiler (whole text only), otherwise runtime in debug builds | compiler | macro |
| `.rawValue` / `init(rawValue:)` | `Int` | `LogLevelSpec` | `Int` | none |

About `swift-syntax`: the build log shows no compile step for the `SwiftSyntax` modules, only for the small C module `_SwiftSyntaxCShims`. That suggests Xcode used prebuilt `swift-syntax` modules. The build time of an app that adds the package for the first time was not measured. An app that uses another package with a different `swift-syntax` version range could get a version conflict; not tested.

## Ideas not built

- **Emoji as the case name** (`case 🟤 = 100`): Swift allows emoji in identifiers, but the call sites would read `.🟤`. Ruled out.
- **Static values instead of an enum** (the struct on `feature/api`): one line per level, but no exhaustive `switch` and no compiler check of the priorities. That is what #71 moved away from.
- **A freestanding macro that declares the whole enum** (`#logLevels(debug: ("🟤", 100), …)`): as far as I know, a macro at global scope can only declare names fixed in its declaration, so the app could not name its type. Neither the rule nor the macro was tried in code.
- **The syntax from the conversation** (`case debug(emoji: "🟤", priority: 100)`): checked with `swiftc -typecheck`: "expected parameter type following ':'" and "enum with raw type cannot have cases with arguments".
