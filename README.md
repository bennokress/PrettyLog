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

- Xcode 16 / Swift 6.0 toolchain or later (`swift-tools-version: 6.0`)
- iOS 15, Mac Catalyst 15, macOS 12, tvOS 15 or watchOS 9 as deployment target

## Migrating from an earlier version

Every major version comes with migration notes that list what changed and what you have to do:

- [PrettyLog 1 → 2](Migration%20Notes/v1-to-v2.md)
- [PrettyLog 2 → 3](Migration%20Notes/v2-to-v3.md)

## Setup

PrettyLog ships no log target and no global log functions. Your app decides where its log statements go and which of those destinations may receive sensitive data, so it defines both once.

### 1. Define a log target

A log target conforms to `LogTarget` and decides how a log statement looks and where it goes. This one prints to the Xcode console and only includes sensitive messages in debug builds:

```swift
import Foundation
import PrettyLog

struct ConsoleLog: LogTarget {

    var canLogSensitiveInformation: Bool { isDebugApp }

    func createLog(_ level: LogLevel, message: String, category: LogCategory) {
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
        "\(currentTimestamp) \(category.truncatedOrPadded(to: 20)) \(level.emoji)"
    }

}
```

`LogTarget` has three requirements:

- `canLogSensitiveInformation`: if `false`, the target never receives the sensitive part of a log statement.
- `createLog(_:message:category:)`: builds the log statement and sends it to its destination.
- `logPriorityRange`: the levels the target accepts. It is optional and allows every level by default.

### 2. Define your log functions

Create one Swift file in your app that imports PrettyLog, lists your targets and defines the global log functions you want to use. Every function hands its arguments on to `PrettyLogProxy`, because Swift can't forward variadic parameters from one function to another. With this file in place, no other file in your app needs to import PrettyLog.

```swift
import Foundation
import PrettyLog

// TODO: Decide, if you want to use logD or logX, logV or logS, as well as logI or logP below

/// Log a statement with DEBUG level.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logD(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logD(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: logTargets)
}

/// Log a statement with VERBOSE level.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logV(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logV(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: logTargets)
}

/// Log a statement with INFO level.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logI(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logI(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: logTargets)
}

/// Log a statement with WARNING level.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logW(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logW(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: logTargets)
}

/// Log a statement with ERROR level.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logE(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logE(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: logTargets)
}

/// Log a Key Event.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - separator: The separator between messages (defaults to `" - "`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or consist only of `nil`-elements!
func logK(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logK(messages, joinedBy: separator, category: category, to: logTargets)
}

/// Log an `Error`.
/// - Parameters:
///   - error: The error to log
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `error` is `nil`.
func log(_ error: Error?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(error, category: category, to: logTargets)
}

/// Log a `NSException`.
/// - Parameters:
///   - exception: The exception to log
///   - category: The category of the log statement (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `exception` is `nil`.
func log(_ exception: NSException?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(exception, category: category, to: logTargets)
}

// TODO: Add custom global log methods if needed -> for example: if you have custom LogLevel and LogCategory `.todo`, you could define `logT` for that (see "Custom Log Levels").

// MARK: - Log Targets

/// Every log statement is sent to these targets. Add your own, for example one that sends statements to your backend.
private var logTargets: [LogTarget] {
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

Instead of Debug, Verbose and Info, you can also use Xcode, Staging and Production, as well as the Key Event for Statistics Generation.

To call them like below, define `logX`, `logS` and `logP` in your logging file the same way as `logD`, `logV` and `logI`, handing on to `PrettyLogProxy.logX`, `PrettyLogProxy.logS` and `PrettyLogProxy.logP`:

```swift
logX("A log only to Xcode is basically a debug log")
logS("A log up to the Staging Environment is basically a verbose log")
logP("A log up to Production is basically an info log")

logK("And this is a Key Event Log for statistics")
```

<img alt="Console Output of multiple PrettyLog statements using Semantic Log Levels" src="Assets/README/4-Advanced-Usage-Semantic-Levels.png" />

### Log Categories

```swift
logV("Got an API Response ...", category: .service)
logV("Saving Token from API: \(token)", category: .storage)
logI("User tapped Continue Button", category: .user)
logE("Username and Password did not match", category: .manager)
logW("Or create your own Category ...", category: .custom("Announcement"))
```

<img alt="Console Output of multiple PrettyLog statements with different Log Categories" src="Assets/README/5-Log-Categories.png" />

### Sensitive Data Logging

But wouldn't it be nice to log that a token was saved in production, but omit the token itself there while still logging it in development? Pass it as a sensitive message. Only targets whose `canLogSensitiveInformation` is `true` receive it:

```swift
logV("Got an API Response ...", category: .service)
logI("Saving Token from API", sensitiveMessages: token, category: .storage)
logI("User tapped Continue Button", category: .user)
logE("Username and Password did not match", category: .manager)
logW("Or create your own Category ...", category: .custom("Announcement"))
```

<img alt="The same Log Statements as before, but the Token is now marked as sensitive data and can be sent to Production like that" src="Assets/README/6-Sensitive-Data.png" />

### Log Message Concatenation

```swift
logV(service, "Got an API Response ...", category: .service)
logW(screen, element, "Username too long", joinedBy: " → ", category: .manager)
```

<img alt="Console Output of multiple PrettyLog statements with different Log Categories" src="Assets/README/7-Concatenation.png" />

### Errors and Exceptions

```swift
let error = NetworkError.notFound
let exception = NSException(name: .portTimeoutException, reason: nil)
log(error, category: .service)
log(exception, category: .service)
```

<img alt="Console Output of PrettyLog statements that take in Error and NSException as arguments" src="Assets/README/8-Errors-and-Exceptions.png" />

## Expert Usage

### Custom Log Categories

Included in PrettyLog are the categories that I use routinely. Those may differ from what is useful in your project, so I made it easy for you to define your own categories. Simply extend `LogCategory` like this:

```swift
extension LogCategory {

    /// This custom category can be used like all the predefined ones: logV("Running Unit Tests ...", category: .todo)
    static var todo: LogCategory { .custom("To Do") }

}
```

### Custom Log Levels

PrettyLog contains a few default Log Levels, but that doesn't mean that you are limited to them. To define your own level extend `LogLevel` like this:

```swift
extension LogLevel {

    /// This custom level can be used like all the predefined ones, it has to be called with the universal `log` method of the proxy though: `PrettyLogProxy.log(["The login method is not yet implemented"], as: .todo, category: .todo, to: logTargets)`
    static var todo: LogLevel { .custom(emoji: "🟣", priority: 200) }

}
```

If you want to use your custom Log Level in line with all the predefined ones, define a global method like `logT` for it in your logging file (see <a href="#setup">'Setup'</a>):

```swift
/// Log messages in the provided order with TODO level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `" - "`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements.
func logT(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ") {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .todo, category: .todo, to: logTargets)
}
```

### More Log Targets

In real world apps you might want to log to backends and web services as well, or locally with something other than `print`. Each destination is its own `LogTarget`, and your logging file sends every statement to all of them. A target for a backend would typically reject sensitive data and only accept the more important levels:

```swift
import Foundation
import PrettyLog

struct BackendLog: LogTarget {

    let canLogSensitiveInformation = false

    var logPriorityRange: ClosedRange<LogLevel>? { .allowFrom(min: .info) }

    func createLog(_ level: LogLevel, message: String, category: LogCategory) {
        // Send the statement to your backend
    }

}
```

Then add it to the list in your logging file:

```swift
private var logTargets: [LogTarget] {
    [ConsoleLog(), BackendLog()]
}
```

### Keeping Targets in a Constant

`LogTarget` doesn't require `Sendable`, so a target can be any type, including a class with mutable state. The computed `logTargets` above creates the targets on every call and works with any of them. If you would rather create them once and keep them in a constant, the Swift 6 language mode requires the constant to be `Sendable`. Make your target types `Sendable` and declare the list like this:

```swift
private let logTargets: [any LogTarget & Sendable] = [ConsoleLog(), BackendLog()]
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
