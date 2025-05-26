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

## Migration Guide (v1 → v2)

PrettyLog v2 introduces several new features while maintaining backward compatibility except for one small breaking change. Here's what's new and what you need to update:

### New Features

#### 1. New Semantic Log Levels
Three new log levels have been added with environment-specific semantics. In our team at work this has been established to make clear which level is appropriate for a log message.

- 🟤 `.xcode` - identical to `.debug`
- 🔵 `.staging` - identical to `.verbose`
- 🟢 `.production` - identical to `.info`

Additionally Key Event Logging was added which is meant to always log without sensitive data, perhaps even to another system, to gain insights and generate statistics.

- 📊 `.keyEvent` - Highest priority for critical events (📊)

#### 2. Sensitive Data Logging Support
All logging methods except `logK` now support an optional `sensitiveMessages` parameter for data that should only be logged in certain environments (configurable for each `LogTarget`):

```swift
// Before (1.x)
logI("Login", "User ID: \(userID), category: .user)

// After (2.0) - with sensitive data support we could for example log the password to the console, but not in production
logI("Login", "User ID: \(userID), sensitiveMessages: "Password: \(password)", category: .user)
```

#### 3. Swift 6.1 Compatibility
PrettyLog is now officially compatible with Swift 6.1.

### Breaking Change

#### Log Target Protocol Update
With the new sensitive data, an additional parameter is needed to define a `LogTarget` that defines if the target should log or omit sensitive information.

```swift
public protocol LogTarget {

    /// If `false`, Strings passed to the `log` method as sensitive data will be discarded.
    var canLogSensitiveInformation: Bool { get }

    // …

}
```

### Optional Changes

- All existing `logD()`, `logV()`, `logI()`, `logW()`, `logE()` calls continue to work unchanged, but can be adjusted to the new semantic notation
- Global log method definitions from the "Import once" pattern work as before, but can be expanded to support the new functionalities

## Basic Usage

With PrettyLog you can make your print statements prettier and more useful. Just replace this ...

```swift
print("User tapped Continue Button")
```

<img alt="Console Output with default print statement" src="https://www.dropbox.com/scl/fi/dgk54lv9ujsy6202eug0x/1-Basic-Usage-print.png?rlkey=rgftvpk2e7m3f85t7lpb62586&st=sx4dartt&raw=1" />

... with this:

```swift
logD("User tapped Continue Button")
```

<img alt="Console Output with PrettyLog statement" src="https://www.dropbox.com/scl/fi/d5ew6983vwljrdynkuhet/2-Basic-Usage-logD.png?rlkey=6geqqu2cs7nladky1e38dgneb&st=ewszp8d3&raw=1" />

So far so good. You have a lot more options with PrettyLog though ...

## Advanced Usage

### Log Levels

```swift
logD("A debug log")
logV("A verbose log")
logI("An info log")
logW("A warning log")
logE("An error log")
```

<img alt="Console Output of multiple PrettyLog statements with different Log Levels" src="https://www.dropbox.com/scl/fi/4q5hn09bkuuu8pk12ml98/3-Advanced-Usage-Levels.png?rlkey=e7i4eq9ndiu8b6qnbxsngv908&st=07wb1pgn&raw=1" />

### Semantic Log Levels

Instead of Debug, Verbose and Info, you can also use Xcode, Staging and Production, as well as the new Key Event for Statistics Generation:

```swift
logX("A log only to Xcode is basically a debug log")
logS("A log up to the Staging Environment is basically a verbose log")
logP("A log up to Production is basically an info log")

logK("And this is a Key Event Log for statistics")
```

<img alt="Console Output of multiple PrettyLog statements using Semantic Log Levels" src="https://www.dropbox.com/scl/fi/ju83pf96vetnen5ncfx04/4-Advanced-Usage-Semantic-Levels.png?rlkey=apzd1evjdm7tqp8bx3d1py7v1&st=njjfm3nq&raw=1" />

### Log Categories

```swift
logV("Got an API Response ...", category: .service)
logV("Saving Token from API: \(token)", category: .storage)
logI("User tapped Continue Button", category: .user)
logE("Username and Password did not match", category: .manager)
logW("Or create your own Category ...", category: .custom("Announcement"))
```

<img alt="Console Output of multiple PrettyLog statements with different Log Categories" src="https://www.dropbox.com/scl/fi/f72nox9eqn69z4702o66j/5-Log-Categories.png?rlkey=r6i181zo69bu3ohq5whus0tr7&st=wfhn51wv&raw=1" />

### Sensitive Data Logging

But wouldn't it be nice to log that a token was saved in production, but omit the token itself there while still logging it in development? This is possible with v2 of PrettyLog:

```swift
logV("Got an API Response ...", category: .service)
logI("Saving Token from API", sensitiveMessages: token, category: .storage)
logI("User tapped Continue Button", category: .user)
logE("Username and Password did not match", category: .manager)
logW("Or create your own Category ...", category: .custom("Announcement"))
```

<img alt="The same Log Statements as before, but the Token is now marked as sensitive data and can be sent to Production like that" src="https://www.dropbox.com/scl/fi/chwpeb6h1pxg3a1ihrnrj/6-Sensitive-Data.png?rlkey=tauy4kbqqv8kvxnfu4qxlct25&st=pgyezqwn&raw=1" />

### Log Message Concatenation

```swift
logV(service, "Got an API Response ...", category: .service)
logW(screen, element, "Username too long", joinedBy: " → ", category: .manager)
```

<img alt="Console Output of multiple PrettyLog statements with different Log Categories" src="https://www.dropbox.com/scl/fi/wjx70lu2abrumt4jzqc0m/7-Concatenation.png?rlkey=yjmnpdclplxnh8wbpapso5lcm&st=d20osoh0&raw=1" />

### Errors and Exceptions

```swift
let error = NetworkError.notFound
let exception = NSException(name: .portTimeoutException, reason: nil)
log(error, category: .service)
log(exception, category: .service)
```

<img alt="Console Output of PrettyLog statements that take in Error and NSException as arguments" src="https://www.dropbox.com/scl/fi/t0mx2xt4mxkawul0lbt7x/8-Errors-and-Exceptions.png?rlkey=bq5blrafu1ixw73vatxelh522&st=iulaollm&raw=1" />

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

    /// This custom level can be used like all the predefined ones, it has to be called with the universal `log` method though: `log("The login method is not yet implemented", category: .todo, as: .todo)
    static var todo: LogLevel { .custom(emoji: "🟣", priority: 200) }

}
```

If you want to use your custom Log Level in line with all the predefined ones, you might want to define a global method like `logT` for it somewhere in your code:

```swift
/// Log messages in the provided order with TODO level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements.
public func logT(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ") {
    PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .todo, category: .todo)
}
```

See the section <a href="#import-once">'Import once'</a> in the Integration part of this README for a well suited place to define this.

### Custom Log Targets

PrettyLog makes it easy to send your log messages to different destinations with Log Targets. Predefined in the package is `ConsoleLog` which sends statements of all Log Levels to the Xcode console.
In real world apps you might want to log to Backends and Web Services or locally using different local solutions than the plain old `print`. That's where the `LogTarget` protocol comes in.

The updated `LogTarget` protocol in v2.0 requires you to implement:

```swift
import Foundation
import PrettyLog

struct Console: LogTarget {

    var canLogSensitiveInformation: Bool { !App.shared.isProductionVersion }

    var logPriorityRange: ClosedRange<LogLevel>? {
        App.shared.isDeveloperVersion ? .allowAll : .allowNone
    }

    /// Create the log statement with a consistent design.
    /// - Parameters:
    ///   - level: The log level is responsible for the emoji displayed in the log statement.
    ///   - message: The message is printed to the right of the log level emoji.
    ///   - category: The category is printed to the left of the log level emoji.
    func createLog(_ level: LogLevel, message: String, category: LogCategory) {
        print("\(prefix(level: level, category: category)) \(message)")
    }

    // MARK: Private Helpers

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

## Integration

When using PrettyLog you have basically two options:

### Import everywhere

Since you probably log throughout your app, importing PrettyLog in every single file might become cumbersome, but it's an option.

```swift
import Foundation
import PrettyLog

struct MyModel {
    func doStuff() {
        logV("Doing some stuff ...")
    }
}
```

### Import once

Another option is to create a Swift file somewhere in your app that serves as a proxy to PrettyLog. This enables you to import PrettyLog and define the log methods globally once.

```swift
import Foundation
import PrettyLog

/// Log a statement with VERBOSE level.
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logV(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logV(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)
}

/// Log a statement with DEBUG level.
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logD(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logD(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)
}

/// Log a statement with INFO level.
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logI(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logI(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)
}

/// Log a statement with WARNING level.
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logW(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logW(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)
}

/// Log a statement with ERROR level.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///   - separator: The separator between messages (defaults to `-`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
func logE(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logE(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)
}

/// Log a Key Event.
/// - Parameters:
///   - messages: One or more strings and string-convertible objects to include in the log statement
///   - separator: The separator between messages (defaults to `-`)
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or consist only of `nil`-elements!
func logK(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logK(messages, joinedBy: separator, category: category)
}

/// Log an `Error`.
/// - Parameters:
///   - error: The error to log
///   - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `error` is `nil`.
func log(_ error: Error?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(error, category: category)
}

/// Log a `NSException`.
/// - Parameters:
///   - exception: The exception to log
///   - category: The category of the log statement (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `exception` is `nil`.
func log(_ exception: NSException?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(exception, category: category)
}

// TODO: Add custom global log methods if needed -> for example: if you have custom LogLevel and LogCategory `.todo`, you could define `logT for that.

// /// Log a statement with TODO level.
// /// - Parameters:
// ///   - messages: One or more strings and string-convertible objects to include in the log statement
// ///   - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
// ///   - separator: The separator between messages (defaults to `-`)
// /// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
// public func logT(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ") {
//     PrettyLogProxy.log(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, as: .todo, category: .todo)
// }
```

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
