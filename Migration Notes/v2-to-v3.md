# Migrating from PrettyLog 2 to PrettyLog 3

Applies to every 3.x release.

## Requirements

| | 2.x | 3.x |
| --- | --- | --- |
| swift-tools-version | 5.9 in 2.0.4 | 6.2 (Xcode 26 or later) |
| Swift language modes | 5 and 6 | 5 and 6 |
| iOS | 15 | 15 |
| Mac Catalyst | 15 | 15 |
| macOS | 12 | 12 |
| tvOS | 15 | 15 |
| watchOS | 8 | 9 |

## Checklist

- [ ] [Use Xcode 26 and raise watchOS to 9](#1-use-xcode-26-and-raise-watchos-to-9)
- [ ] [Define your own log targets](#2-define-your-own-log-targets)
- [ ] [Define your own log levels](#3-define-your-own-log-levels)
- [ ] [Define your own log categories](#4-define-your-own-log-categories)
- [ ] [Define your own log functions](#5-define-your-own-log-functions)
- [ ] [Pass your targets to every `PrettyLogProxy` call](#6-pass-your-targets-to-every-prettylogproxy-call)
- [ ] [Log errors and exceptions yourself](#7-log-errors-and-exceptions-yourself)
- [ ] [Filter levels with `LogLevelFilter`](#8-filter-levels-with-loglevelfilter)
- [ ] [Rename `createLog` to `emit` in your targets](#9-rename-createlog-to-emit-in-your-targets)
- [ ] [Cut or pad category names in your targets](#10-cut-or-pad-category-names-in-your-targets)

## Breaking changes

### 1. Use Xcode 26 and raise watchOS to 9

**Affects you if** you build with a toolchain older than Swift 6.2, or your app supports watchOS 8.

**What changed:** The package manifest uses `swift-tools-version: 6.2`, and the minimum watchOS version is 9. Swift 6.2 is the first version that lets an app default to main actor isolation, and the setup in the README relies on `nonisolated` declarations that older toolchains don't fully support.

**What to do:** Build with Xcode 26 or later, which the App Store requires for uploads anyway. Raise the watchOS deployment target of every target that depends on PrettyLog to 9, or stay on PrettyLog 2.

### 2. Define your own log targets

**Affects you if** you use `ConsoleLog`, directly or through the default targets of the log functions.

**What changed:** PrettyLog ships no log target anymore. `ConsoleLog` included sensitive messages in every build, so an app that relied on it printed sensitive data to stdout in release builds too. A package can't know where an app may send sensitive data, so every app now defines its targets itself.

**What to do:** Write your own target that conforms to `LogTarget`. The README shows a console target under "Setup" that prints the same format as `ConsoleLog` did and includes sensitive messages only in debug builds. If you name it `ConsoleLog`, existing references such as `[ConsoleLog(), BackendLog()]` keep compiling. If your app makes the main actor its default isolation, which new Xcode projects do, the type has to be `nonisolated`, as in the sample below. Otherwise you can only log from the main actor. The README explains this under "Setup".

```swift
// Before (2.x): ConsoleLog came from PrettyLog
import PrettyLog

PrettyLogProxy.logI(messages, to: [ConsoleLog()])

// After (3.x): ConsoleLog is a type in your app
nonisolated struct ConsoleLog: LogTarget {

    var canLogSensitiveInformation: Bool { isDebugApp }

    func emit(_ level: LogLevel, message: String, category: LogCategory) { … }

}
```

### 3. Define your own log levels

**Affects you if** you use a log level in any way: through the `PrettyLogProxy` methods `logD`, `logX`, `logV`, `logS`, `logI`, `logP`, `logW`, `logE` or `logK`, as a predefined level such as `.debug`, `.xcode` or `.keyEvent`, or with `.custom(emoji:priority:)`. That is every app that uses PrettyLog.

**What changed:** PrettyLog ships no log levels anymore. `LogLevel` is a struct with an emoji and a priority, and your app defines the levels it uses. The proxy methods that were tied to a predefined level are gone. `PrettyLogProxy.log(_:sensitiveMessages:joinedBy:as:category:to:)` takes the level as an argument. In 2.x each of the three lower levels had two names, `.debug` and `.xcode`, `.verbose` and `.staging`, `.info` and `.production`. They had the same emoji and priority but were not equal, so a target that switched over the level had to handle both. Now each app picks one set of names. Two levels with the same priority are now equal, whatever their emoji.

**What to do:**

1. Define your levels in an extension on `LogLevel`, as in step 2 of "Setup" in the README. With the values below, filtering and console output stay as they were. Pick one name per row.

    | 2.x proxy method | 2.x level | 3.x definition |
    | --- | --- | --- |
    | `logD`, `logX` | `.debug`, `.xcode` | `LogLevel(emoji: "🟤", priority: 100)` |
    | `logV`, `logS` | `.verbose`, `.staging` | `LogLevel(emoji: "🔵", priority: 300)` |
    | `logI`, `logP` | `.info`, `.production` | `LogLevel(emoji: "🟢", priority: 500)` |
    | `logW` | `.warning` | `LogLevel(emoji: "🟡", priority: 700)` |
    | `logE` | `.error` | `LogLevel(emoji: "🔴", priority: 900)` |
    | `logK` | `.keyEvent` | `LogLevel(emoji: "📊", priority: .max)` |

2. In your logging file, replace every call of one of these proxy methods with `PrettyLogProxy.log(..., as: <level>, ...)`.
3. Replace `.custom(emoji: e, priority: p)` with `LogLevel(emoji: e, priority: p)`.
4. A `switch` over the level needs a `default` branch now, because levels are values and not enum cases. Merge branches like `case .debug, .xcode:` into the one name you kept, otherwise the code doesn't compile.
5. Declare the extension `nonisolated` if your app makes the main actor its default isolation.

```swift
// Before (2.x)
PrettyLogProxy.logX(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: logTargets)

extension LogLevel {
    static var todo: LogLevel { .custom(emoji: "🟣", priority: 200) }
}

switch level {
case .debug, .xcode: logger.debug("\(message)")
case .error: logger.fault("\(message)")
case .custom: logger.notice("\(message)")
…
}

// After (3.x)
nonisolated extension LogLevel {
    static var xcode: LogLevel { LogLevel(emoji: "🟤", priority: 100) }
    static var error: LogLevel { LogLevel(emoji: "🔴", priority: 900) }
    static var todo: LogLevel { LogLevel(emoji: "🟣", priority: 200) }
    …
}

PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .xcode, category: category, to: logTargets)

switch level {
case .xcode: logger.debug("\(message)")
case .error: logger.fault("\(message)")
default: logger.notice("\(message)")
}
```

### 4. Define your own log categories

**Affects you if** you use a predefined category such as `.service`, `.storage` or `.user`, or create one with `.custom(_:)`. `.uncategorized` is the one exception: it still exists and is still the default of every `category:` parameter.

**What changed:** PrettyLog ships no log categories anymore apart from `.uncategorized`. `LogCategory` is a struct with a name, and your app defines the categories it uses. `.custom(_:)` is gone. Two categories with the same name are equal, and `LogCategory` is `Hashable`, so a target can compare categories with `==` instead of a `switch`.

**What to do:**

1. Define your categories in an extension on `LogCategory`, as in step 3 of "Setup" in the README. With the names below, the console output stays as it was. Copy only the ones you use.

    | 2.x category | 3.x definition |
    | --- | --- |
    | `.appState` | `LogCategory("App State")` |
    | `.debug` | `LogCategory("Debug")` |
    | `.general` | `LogCategory("General")` |
    | `.manager` | `LogCategory("Manager")` |
    | `.service` | `LogCategory("Service")` |
    | `.storage` | `LogCategory("Storage")` |
    | `.user` | `LogCategory("User Action")` |
    | `.view` | `LogCategory("View")` |

2. Replace `.custom(name)` with `LogCategory(name)`.
3. A `switch` over the category needs a `default` branch now, because categories are values and not enum cases. A `switch` that already has one compiles unchanged.
4. Declare the extension `nonisolated` if your app makes the main actor its default isolation.

```swift
// Before (2.x)
extension LogCategory {
    static var todo: LogCategory { .custom("To Do") }
}

// After (3.x)
nonisolated extension LogCategory {
    static var storage: LogCategory { LogCategory("Storage") }
    static var todo: LogCategory { LogCategory("To Do") }
}
```

### 5. Define your own log functions

**Affects you if** you call `logD`, `logX`, `logV`, `logI`, `logW`, `logE`, `logK` or `log` from PrettyLog directly, usually in files that `import PrettyLog`.

**What changed:** PrettyLog has no global log functions anymore. `PrettyLogProxy` is the only entry point.

**What to do:** Add one file to your app that defines the log functions you use and the list of targets they send to. The README has a complete file under "Setup". Your call sites stay the same, and the other files no longer need `import PrettyLog`. If you already have such a file, only steps 3, 4 and 6 apply to you. Mark the functions and the list of targets `nonisolated`, as in the sample below. In an app whose default isolation is the main actor they would otherwise only be callable from the main actor; in other apps the keyword changes nothing.

```swift
// Before (2.x): any file
import PrettyLog

logI("User tapped Continue Button", category: .user)

// After (3.x): your logging file
import PrettyLog

nonisolated func logI(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .info, category: category, to: logTargets)
}

nonisolated private var logTargets: [LogTarget] {
    [ConsoleLog()]
}

// After (3.x): any file, no import needed
logI("User tapped Continue Button", category: .user)
```

### 6. Pass your targets to every `PrettyLogProxy` call

**Affects you if** you call a method of `PrettyLogProxy` without the `to:` argument.

**What changed:** `to:` has no default value anymore and is required on every method.

**What to do:** Pass your targets.

```swift
// Before (2.x)
PrettyLogProxy.logI(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)

// After (3.x), with the level from step 3
PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .info, category: category, to: logTargets)
```

### 7. Log errors and exceptions yourself

**Affects you if** you log an `Error` or an `NSException` through `PrettyLogProxy`, usually in a `log(_ error:)` or `log(_ exception:)` function of your logging file.

**What changed:** PrettyLog no longer has methods for errors and exceptions. How much of an error a destination may see is a decision of your app, and `sensitiveMessages` already gives it everything it needs to make that decision. The package ships no rule of its own for it, the same as for targets, levels and categories.

**What to do:** Write the function yourself in your logging file. The sample below puts the readable part into the public messages and the full description into the sensitive ones, so a target that may not receive sensitive data never sees the `userInfo` of an `NSError`, a complete URL or the associated values of an error enum. For an error that is neither a `LocalizedError` nor an `NSError`, Foundation's `localizedDescription` is only "The operation couldn't be completed.", so the sample logs the name of the type instead. Delete a `log(_ exception:)` function nothing calls; if you do log exceptions, pass the `name` as message and the `reason` and `userInfo` as sensitive messages in the same way.

```swift
// Before (2.x)
nonisolated func log(_ error: Error?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(error, category: category, to: logTargets)
}

// After (3.x)
nonisolated func log(_ error: Error?, category: LogCategory = .uncategorized) {
    guard let error else { return }
    let isReadable = error is LocalizedError || type(of: error) is NSError.Type
    let publicPart = isReadable ? error.localizedDescription : String(describing: type(of: error))
    PrettyLogProxy.log([publicPart], sensitiveMessages: ["\(error)"], as: .error, category: category, to: logTargets)
}
```

With this function an `enum NetworkError: Error` thrown as `.notFound` reads `NetworkError - notFound`, or `NetworkError` for a target that may not receive sensitive data. In 2.x it read `localizedDescription (full description)` for every target.

### 8. Filter levels with `LogLevelFilter`

**Affects you if** a target of yours implements `logPriorityRange`, or your code uses `.allowAll`, `.allowNone`, `.allowFrom(min:)` or `.allowUntil(max:)`.

**What changed:** `LogTarget.logPriorityRange: ClosedRange<LogLevel>?` is replaced by `LogTarget.levelFilter: LogLevelFilter`. In 2.x, `nil` meant that a target accepts no level, which reads like "no filter". A reversed range like `.warning ... .debug` stopped the app at runtime. `LogLevelFilter` says what it accepts by name, and `.betweenPriority(of:and:)` orders its two levels itself, so a reversed filter can't crash. The filters compare priorities only, and their names say so: a level with the same priority as the given one is accepted too, whatever its emoji. Targets that never implemented `logPriorityRange` keep accepting every level and need no change.

| 2.x | 3.x |
| --- | --- |
| `.allowAll` | `.all` |
| `.allowNone` or `nil` | `.none` |
| `.allowFrom(min: level)` | `.fromPriority(of: level)` |
| `.allowUntil(max: level)` | `.untilPriority(of: level)` |
| `lower ... upper` | `.betweenPriority(of: lower, and: upper)` |
| `level ... level` | `.onlyPriority(of: level)` |
| (not possible) | `.onlyPriority(of: level, otherLevel)` |

**What to do:** Rename the property, change its type and use the matching filter.

```swift
// Before (2.x)
var logPriorityRange: ClosedRange<LogLevel>? { .allowFrom(min: .info) }

// After (3.x)
var levelFilter: LogLevelFilter { .fromPriority(of: .info) }
```

### 9. Rename `createLog` to `emit` in your targets

**Affects you if** you have a log target of your own, which every app has, see step 2.

**What changed:** The `LogTarget` requirement `createLog(_:message:category:)` is now `emit(_:message:category:)`. It gives the statement its form and passes it on, but it creates nothing the caller gets back, so the old name was misleading. The parameters are the same. There is no deprecated forward: a target that still implements `createLog` no longer conforms to `LogTarget` and doesn't compile.

**What to do:** Rename the method in every target.

```swift
// Before (2.x)
func createLog(_ level: LogLevel, message: String, category: LogCategory) { … }

// After (3.x)
func emit(_ level: LogLevel, message: String, category: LogCategory) { … }
```

### 10. Cut or pad category names in your targets

**Affects you if** a target of yours calls `category.truncatedOrPadded(to:)`.

**What changed:** `LogCategory.truncatedOrPadded(to:)` is gone. How a category appears in a log statement is up to the target that formats it, and PrettyLog itself never used the method.

**What to do:** Add the method to `String` in your app, next to your targets, and call it on the name of the category.

```swift
// Before
"\(currentTimestamp) \(category.truncatedOrPadded(to: 20)) \(level.emoji)"

// After
"\(currentTimestamp) \(category.name.truncatedOrPadded(to: 20)) \(level.emoji)"

nonisolated extension String {

    func truncatedOrPadded(to length: Int) -> String {
        guard length > 0 else { return "" }
        guard count <= length else { return String(prefix(length - 1)) + "…" }
        return String(repeating: " ", count: length - count) + self
    }

}
```

## New and optional

### `LogLevel` and `LogCategory` are `Sendable`

You can now keep levels and categories in a `static let` or pass them into a `Task` in the Swift 6 language mode, including the levels and categories your app defines. Nothing to change.

`LogTarget` still doesn't require `Sendable`, so your existing targets keep compiling. If you want to keep your targets in a `static let` or hand them across isolation boundaries, make your target types `Sendable` yourself, see "Keeping Targets in a Constant" in the README.

### Messages can be any `CustomStringConvertible`

`PrettyLogProxy.log(_:sensitiveMessages:joinedBy:as:category:to:)` now takes `[(any CustomStringConvertible)?]` instead of `[String?]`, so numbers, URLs and your own types can be logged without string interpolation. Each message is written as its `description`, and `nil` is still left out. Log functions declared with `String?...` keep compiling. To pass other values, change their parameters:

```swift
// Before
nonisolated func logD(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) { … }
logD("Loaded items: \(items.count)")

// After
nonisolated func logD(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) { … }
logD("Loaded items:", items.count)
```
