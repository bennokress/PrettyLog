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

## Install

```sh
dependencies: [
    .package(url: "https://github.com/bennokress/PrettyLog", .upToNextMajor(from: "1.0.0"))
]
```

## Basic Usage

With PrettyLog you can make your print statements prettier and more useful. Just replace this ...

```swift
print("User tapped Continue Button")
```

<img alt="Console Output with default print statement" src="https://www.dropbox.com/s/eifhi249i02n0p8/print.png?raw=1" />

... with this:

```swift
logD("User tapped Continue Button")
```

<img alt="Console Output with PrettyLog statement" src="https://www.dropbox.com/s/vsrxqw7g5jhw4ov/logD.png?raw=1" />

So far so good. You have a lot more options with PrettyLog though ...

## Advanced Usage

### Log Levels

```swift
logV("A verbose log")
logD("A debug log")
logI("An info log")
logW("A warning log")
logE("An error log")
```

<img alt="Console Output of multiple PrettyLog statements with different Log Levels" src="https://www.dropbox.com/s/utsba60ji8216zt/levels.png?raw=1" />

### Log Categories

```swift
logV("Got an API Response ...", category: .service)
logI("Saving Token from API: \(token)", category: .storage)
logV("User tapped Continue Button", category: .user)
logE("Username and Password did not match", category: .manager)
logW("Or create your own Category ...", category: .custom("Announcement"))
```

<img alt="Console Output of multiple PrettyLog statements with different Log Categories" src="https://www.dropbox.com/s/gglm46vh5z2ekc5/categories.png?raw=1" />

### Log Message Concatenation

```swift
logV(service, "Got an API Response ...", category: .service)
logW(screen, element, "Username too long", joinedBy: " → ", category: .manager)
```

<img alt="Console Output of multiple PrettyLog statements with different Log Categories" src="https://www.dropbox.com/s/0vays657yh7p0to/message%20concatenation.png?raw=1" />

### Errors and Exceptions

```swift
let error = NetworkError.notFound
let exception = NSException(name: .portTimeoutException, reason: nil)
log(error, category: .service)
log(exception, category: .service)
```

<img alt="Console Output of PrettyLog statements that take in Error and NSException as arguments" src="https://www.dropbox.com/s/nikg8h1yvkpvd6t/error%20exception.png?raw=1" />

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
///     - separator: The separator between messages (defaults to `-`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logT(_ messages: String?..., joinedBy separator: String = " - ") {
    PrettyLogProxy.log(messages, joinedBy: separator, as: .todo, category: .todo)
}
```

See the section <a href="#import-once">'Import once'</a> in the Integration part of this README for a well suited place to define this.

### Custom Log Targets

PrettyLog makes it easy to send your log messages to different destinations with Log Targets. Predefined in the package is `ConsoleLog` which sends statements of all Log Levels to the Xcode console.
In real world apps you might want to log to Backends and Web Services or locally using different local solutions than the plain old `print`. That's where the `LogTarget` protocol comes in.
It only requires you to specify how to handle a log statement consisting of a `LogLevel`, a message (`String`) and a `LogCategory`. Additionally you can specify a `logPriorityRange`
that filters out incoming log statements that don't meet the defined range requirements before sending it to your custom defined handler.

An example would be a custom Console Log Target that only logs if the app is running in specific environments:

```swift
import Foundation
import PrettyLog

struct Console: LogTarget {

    /// Create the log statement with a consistent design.
    /// - Parameters:
    ///   - level: The log level is responsible for the emoji displayed in the log statement.
    ///   - message: The message is printed to the right of the log level emoji.
    ///   - category: The category is printed to the left of the log level emoji.
    func createLog(_ level: LogLevel, message: String, category: LogCategory) {
        print("\(prefix(level: level, category: category)) \(message)")
    }

    var logPriorityRange: ClosedRange<LogLevel>? {
        App.shared.isDeveloperVersion ? .allowAll : .allowNone
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
//
// 📄 PrettyLog.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import PrettyLog

/// Log messages in the provided order with VERBOSE level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
func logV(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logV(messages, joinedBy: separator, category: category)
}

/// Log messages in the provided order with DEBUG level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
func logD(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logD(messages, joinedBy: separator, category: category)
}

/// Log messages in the provided order with INFO level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
func logI(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logI(messages, joinedBy: separator, category: category)
}

/// Log messages in the provided order with WARNING level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
func logW(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logW(messages, joinedBy: separator, category: category)
}

/// Log messages in the provided order with ERROR level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
func logE(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logE(messages, joinedBy: separator, category: category)
}

/// Log an `Error` with ERROR level.
/// - Parameters:
///     - error: The error to log
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `error` is `nil`.
func log(_ error: Error?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(error, category: category)
}

/// Log a `NSException` with ERROR level.
/// - Parameters:
///     - exception: The exception to log
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `exception` is `nil`.
func log(_ exception: NSException?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.log(exception, category: category)
}

/// Log with ERROR level and crash the app.
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message
/// - Attention: No log will be created, if `messages` is empty or `nil`.
func fatalLog(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) -> Never {
    PrettyLogProxy.logE(messages, joinedBy: separator, category: category)
    let messageComponents = messages.compactMap { $0 }
    let statement = messageComponents.joined(separator: separator)
    fatalError(statement)
}

// TODO: Add custom global log methods if needed -> for example: if you have custom LogLevel and LogCategory `.todo`, you could define `logT` for that.

// /// Log messages in the provided order with TODO level
// /// - Parameters:
// ///     - messages: One or more strings and string-convertible objects to include in the log statement
// ///     - separator: The separator between messages (defaults to `-`)
// /// - Attention: No log will be created, if `messages` is empty or `nil`.
// public func logT(_ messages: String?..., joinedBy separator: String = " - ") {
//     PrettyLogProxy.log(messages, joinedBy: separator, as: .todo, category: .todo)
// }
```

## Author

👨🏻‍💻 **Benno Kress**

-   Website: [bennokress.de](https://bennokress.de)
-   Mastodon: [@benno@iosdev.space](https://iosdev.space/@benno)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/bennokress/PrettyLog/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc).

## 📝 License

Copyright © 2022 [Benno Kress](https://github.com/bennokress).<br />
This project is [MIT](https://github.com/bennokress/PrettyLog/blob/main/LICENSE) licensed.

---

_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
