<h1 align="center">Welcome to PrettyLog 👋</h1>
<p align="center">
  <a href="https://swiftpackageindex.com/bennokress/PrettyLog" target="_blank">
    <img alt="Swift Package Index" src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbennokress%2FPrettyLog%2Fbadge%3Ftype%3Dswift-versions&style=for-the-badge" />
  </a>
  <a href="https://github.com/bennokress/PrettyLog/blob/main/LICENSE" target="_blank">
    <img alt="License" src="https://img.shields.io/github/license/bennokress/PrettyLog?style=for-the-badge" />
  </a>
</p>

> PrettyLog is a small Swift Package that makes logging in the Xcode Console a little bit more beautiful.

## Installation

```sh
dependencies: [
    .package(url: "https://github.com/bennokress/PrettyLog", .upToNextMajor(from: "2.0.0"))
]
```

## Requirements

- Xcode 26 / Swift 6.2 toolchain or later (`swift-tools-version: 6.2`)
- iOS 15, Mac Catalyst 15, macOS 12, tvOS 15 or watchOS 9 as deployment target

## Migrating from an earlier version

Every major version comes with migration notes that list what changed and what you have to do:

- [PrettyLog 1 → 2](Migration%20Notes/v1-to-v2.md)
- [PrettyLog 2 → 3](Migration%20Notes/v2-to-v3.md)

## Setup

PrettyLog ships no log target, no log levels, no log categories and no global log functions. Your app decides where its log statements go, which of those destinations may receive sensitive data, which levels it needs and how it titles its statements, so it defines all four once.

Every declaration in the samples below is marked `nonisolated`. New Xcode projects make the main actor the default isolation of an app (`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`). Without the keyword, your targets, levels, categories and log functions would belong to the main actor too, and logging from a background task, an actor or a `nonisolated` function would fail with errors like these:

- `Main actor-isolated global function 'logI(_:sensitiveMessages:joinedBy:category:)' cannot be called from outside of the actor`
- `Main actor-isolated conformance of 'ConsoleLog' to 'LogTarget' cannot be used in nonisolated context`
- `Main actor-isolated static property 'todo' can not be referenced from a nonisolated context`

In a project without that setting the keyword changes nothing, so keep it either way.

### 1. Define a log target

A log target conforms to `LogTarget` and decides how a log statement looks and where it goes. This one prints to the Xcode console and only includes sensitive messages in debug builds:

```swift
import Foundation
import PrettyLog

nonisolated struct ConsoleLog: LogTarget {

    var canLogSensitiveInformation: Bool { isDebugApp }

    func emit(_ level: LogLevel, message: String, category: LogCategory) {
        print("\(prefix(level: level, category: category)) \(message)")
    }

    // MARK: Private Helpers

    private var isDebugApp: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    private var currentTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }

    private func prefix(level: LogLevel, category: LogCategory) -> String {
        "\(currentTimestamp) \(category.name.truncatedOrPadded(to: 20)) \(level.emoji)"
    }

}

nonisolated extension String {

    /// The String cut or padded to exactly the given length, so the categories of all log statements line up.
    /// A longer String ends in "…", a shorter one is padded with spaces at the beginning.
    func truncatedOrPadded(to length: Int) -> String {
        guard length > 0 else { return "" }
        guard count <= length else { return String(prefix(length - 1)) + "…" }
        return String(repeating: " ", count: length - count) + self
    }

}
```

`LogTarget` has three requirements:

- `canLogSensitiveInformation`: if `false`, the target never receives the sensitive part of a log statement.
- `emit(_:message:category:)`: gives the log statement its form and passes it on to its destination.
- `levelFilter`: the levels the target accepts, for example `.fromPriority(of: .info)` or `.onlyPriority(of: .keyEvent)`. It is optional and accepts every level by default.

### 2. Define your log levels

A log level is an emoji and a priority. Targets filter by priority, so give every level its own. This set is a good start:

```swift
import PrettyLog

nonisolated extension LogLevel {

    static var debug: LogLevel { LogLevel(emoji: "🟤", priority: 100) }
    static var verbose: LogLevel { LogLevel(emoji: "🔵", priority: 300) }
    static var info: LogLevel { LogLevel(emoji: "🟢", priority: 500) }
    static var warning: LogLevel { LogLevel(emoji: "🟡", priority: 700) }
    static var error: LogLevel { LogLevel(emoji: "🔴", priority: 900) }
    static var keyEvent: LogLevel { LogLevel(emoji: "📊", priority: .max) }

}
```

The names are yours. If you would rather name the lower levels after where a statement should end up, see <a href="#semantic-log-levels">'Semantic Log Levels'</a>.

### 3. Define your log categories

A log category is a name that titles a log statement. The only one PrettyLog brings along is `.uncategorized`, the empty title of a statement without a category. This set is a good start:

```swift
import PrettyLog

nonisolated extension LogCategory {

    static var appState: LogCategory { LogCategory("App State") }
    static var debug: LogCategory { LogCategory("Debug") }
    static var general: LogCategory { LogCategory("General") }
    static var manager: LogCategory { LogCategory("Manager") }
    static var service: LogCategory { LogCategory("Service") }
    static var storage: LogCategory { LogCategory("Storage") }
    static var user: LogCategory { LogCategory("User Action") }
    static var view: LogCategory { LogCategory("View") }

}
```

### 4. Define your log functions

Create one Swift file in your app that imports PrettyLog, lists your targets and defines the global log functions you want to use. Every function hands its arguments on to `PrettyLogProxy`, because Swift can't forward variadic parameters from one function to another. With this file in place, no other file in your app needs to import PrettyLog.

```swift
import Foundation
import PrettyLog

/// Log a statement with DEBUG level.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages, also used between the public and the sensitive part (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
nonisolated func logD(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .debug, category: category, to: logTargets)
}

/// Log a statement with VERBOSE level.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages, also used between the public and the sensitive part (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
nonisolated func logV(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .verbose, category: category, to: logTargets)
}

/// Log a statement with INFO level.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages, also used between the public and the sensitive part (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
nonisolated func logI(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .info, category: category, to: logTargets)
}

/// Log a statement with WARNING level.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages, also used between the public and the sensitive part (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
nonisolated func logW(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .warning, category: category, to: logTargets)
}

/// Log a statement with ERROR level.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages, also used between the public and the sensitive part (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
nonisolated func logE(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .error, category: category, to: logTargets)
}

/// Log a Key Event.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or consist only of `nil`-elements!
nonisolated func logK(_ messages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(messages, joinedBy: separator, as: .keyEvent, category: category, to: logTargets)
}

/// Log an `Error`.
///
/// The public part is the `localizedDescription` of a `LocalizedError` or an `NSError`, and the name of the type for any other error,
/// because Foundation would only produce "The operation couldn't be completed." for it. The full description goes into the sensitive part,
/// because it can contain the `userInfo` of an `NSError`, a complete URL or the associated values of an error enum.
/// - Parameters:
///   - error: The error to log
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `error` is `nil`.
nonisolated func log(_ error: Error?, category: LogCategory = .uncategorized) {
    guard let error else { return }
    let isReadable = error is LocalizedError || type(of: error) is NSError.Type
    let publicPart = isReadable ? error.localizedDescription : String(describing: type(of: error))
    PrettyLogProxy.log([publicPart], sensitiveMessages: ["\(error)"], as: .error, category: category, to: logTargets)
}

// TODO: Add a log function for every other level you define -> for example `logT` for a level `.todo` (see "Custom Log Levels").

// MARK: - Log Targets

/// Every log statement is sent to these targets. Add your own, for example one that sends statements to your backend.
nonisolated private var logTargets: [LogTarget] {
    [ConsoleLog()]
}
```

## Basic Usage

With the setup in place you can make your print statements prettier and more useful. Just replace this ...

```swift
print("User tapped Continue Button")
```

<img alt="Console Output with default print statement" src="Assets/README/1-Basic-Usage-print.png" />

... with this:

```swift
logD("User tapped Continue Button")
```

<img alt="Console Output with PrettyLog statement" src="Assets/README/2-Basic-Usage-logD.png" />

So far so good. You have a lot more options with PrettyLog though ...

## Advanced Usage

All samples below call the log functions from your own file (see <a href="#setup">'Setup'</a>).

### Log Levels

```swift
logD("A debug log")
logV("A verbose log")
logI("An info log")
logW("A warning log")
logE("An error log")
```

<img alt="Console Output of multiple PrettyLog statements with different Log Levels" src="Assets/README/3-Advanced-Usage-Levels.png" />

### Semantic Log Levels

If your app has a staging environment, you may prefer to name the lower levels after where a statement should end up: Xcode, Staging and Production instead of Debug, Verbose and Info. Define them with the same values in place of `debug`, `verbose` and `info`, and use one set or the other, not both:

```swift
nonisolated extension LogLevel {

    static var xcode: LogLevel { LogLevel(emoji: "🟤", priority: 100) }
    static var staging: LogLevel { LogLevel(emoji: "🔵", priority: 300) }
    static var production: LogLevel { LogLevel(emoji: "🟢", priority: 500) }

}
```

Then name the log functions `logX`, `logS` and `logP`, passing `as: .xcode`, `as: .staging` and `as: .production`:

```swift
logX("A log only to Xcode")
logS("A log up to the Staging Environment")
logP("A log up to Production")
```

The Key Event from the setup is for statistics. It has the highest priority, so every target that filters by a minimum level receives it:

```swift
logK("And this is a Key Event Log for statistics")
```

<img alt="Console Output of multiple PrettyLog statements using Semantic Log Levels" src="Assets/README/4-Advanced-Usage-Semantic-Levels.png" />

### Log Categories

```swift
logV("Got an API Response ...", category: .service)
logV("Saving Token from API: \(token)", category: .storage)
logI("User tapped Continue Button", category: .user)
logE("Username and Password did not match", category: .manager)
logW("Or create a Category on the spot ...", category: LogCategory("Announcement"))
```

<img alt="Console Output of multiple PrettyLog statements with different Log Categories" src="Assets/README/5-Log-Categories.png" />

### Sensitive Data Logging

But wouldn't it be nice to log that a token was saved in production, but omit the token itself there while still logging it in development? Pass it as a sensitive message. Only targets whose `canLogSensitiveInformation` is `true` receive it:

```swift
logV("Got an API Response ...", category: .service)
logI("Saving Token from API", sensitiveMessages: token, category: .storage)
logI("User tapped Continue Button", category: .user)
logE("Username and Password did not match", category: .manager)
logW("Or create a Category on the spot ...", category: LogCategory("Announcement"))
```

The sensitive part is appended to the public part with the same separator as the messages.

<img alt="The same Log Statements as before, but the Token is now marked as sensitive data and can be sent to Production like that" src="Assets/README/6-Sensitive-Data.png" />

### Log Message Concatenation

```swift
logV(service, "Got an API Response ...", category: .service)
logW(screen, element, "Username too long", joinedBy: " → ", category: .manager)
```

Messages don't have to be strings. Anything that conforms to `CustomStringConvertible` is written as its `description`, and `nil` is left out:

```swift
logD("Loaded items:", items.count, "from", url)
```

<img alt="Console Output of multiple PrettyLog statements with different Log Categories" src="Assets/README/7-Concatenation.png" />

### Errors

PrettyLog has no method of its own for errors. The `log(_:category:)` function from the setup file logs the readable part of an error for every target and its full description only for targets that may receive sensitive data:

```swift
let error = NetworkError.notFound
log(error, category: .service)
```

<img alt="Console Output of a PrettyLog statement that takes in an Error as argument" src="Assets/README/8-Errors-and-Exceptions.png" />

## Expert Usage

### Custom Log Categories

The categories from the setup are only a suggestion. Add any category you need to the same extension:

```swift
nonisolated extension LogCategory {

    /// This category can be used like all the others: logV("Running Unit Tests ...", category: .todo)
    static var todo: LogCategory { LogCategory("To Do") }

}
```

A target can compare categories with `==`, for example to send only `.storage` statements to a separate file.

### Custom Log Levels

The levels from the setup are only a suggestion. Add any level you need to the same extension, with its own emoji and a priority that sorts it between the others:

```swift
nonisolated extension LogLevel {

    /// Sorts between `debug` and `verbose`.
    static var todo: LogLevel { LogLevel(emoji: "🟣", priority: 200) }

}
```

To use it like the other levels, define a global method like `logT` for it in your logging file (see <a href="#setup">'Setup'</a>):

```swift
/// Log messages in the provided order with TODO level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages, also used between the public and the sensitive part (defaults to `" - "`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements.
nonisolated func logT(_ messages: (any CustomStringConvertible)?..., sensitiveMessages: (any CustomStringConvertible)?..., joinedBy separator: String = " - ") {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .todo, category: .todo, to: logTargets)
}
```

### More Log Targets

In real world apps you might want to log to backends and web services as well, or locally with something other than `print`. Each destination is its own `LogTarget`, and your logging file sends every statement to all of them. A target for a backend would typically reject sensitive data and only accept the more important levels:

```swift
import Foundation
import PrettyLog

nonisolated struct BackendLog: LogTarget {

    let canLogSensitiveInformation = false

    var levelFilter: LogLevelFilter { .fromPriority(of: .info) }

    func emit(_ level: LogLevel, message: String, category: LogCategory) {
        // Send the statement to your backend
    }

}
```

Then add it to the list in your logging file:

```swift
nonisolated private var logTargets: [LogTarget] {
    [ConsoleLog(), BackendLog()]
}
```

### Keeping Targets in a Constant

`LogTarget` doesn't require `Sendable`, so a target can be any type, including a class with mutable state. The computed `logTargets` above creates the targets on every call and works with any of them. If you would rather create them once and keep them in a constant, the Swift 6 language mode requires the constant to be `Sendable`. Make your target types `Sendable` and declare the list like this:

```swift
nonisolated private let logTargets: [any LogTarget & Sendable] = [ConsoleLog(), BackendLog()]
```

Structs whose stored properties are all `Sendable` get the conformance automatically, as long as they aren't `public`. A class needs to be `final` and protect its mutable state itself, for example with a lock.

## Author

👨🏻‍💻 **Benno Kress**

-   Website: [bennokress.de](https://bennokress.de)
-   Mastodon: [@benno@iosdev.space](https://iosdev.space/@benno)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/bennokress/PrettyLog/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc).

## 📝 License

Copyright © [Benno Kress](https://github.com/bennokress).<br />
This project is [MIT](https://github.com/bennokress/PrettyLog/blob/main/LICENSE) licensed.

---

_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
