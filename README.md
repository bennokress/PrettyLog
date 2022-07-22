<h1 align="center">Welcome to PrettyLog 👋</h1>
<p align="center">
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
logV("Got an API Response ...", category: .service)
logI("Saving Token from API: \(token)", category: .storage)
logV("User tapped Continue Button", category: .user)
logE("Username and Password did not match", category: .manager)
logW("Or create your own Category ...", category: .custom("Announcement"))
```

<img alt="Console Output of multiple PrettyLog statements with different Log Categories" src="https://www.dropbox.com/s/0vays657yh7p0to/message%20concatenation.png?raw=1" />

### Errors and Exceptions

```swift
let error = NetworkError.notFound
let exception = NSException(name: .portTimeoutException, reason: nil)
logE(error, category: .service)
logE(exception, category: .service)
```

<img alt="Console Output of PrettyLog statements that take in Error and NSException as arguments" src="raw=1" />

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

Another option is to create a Swift file somewhere in your app that serves as a proxy to PrettyLog. This enables you to import PrettyLog once and define the log methods globally once.

```swift
//
// 📄 PrettyLog.swift
// 👨🏼‍💻 Author: Benno Kress
// 🗓️ Created: 22.07.22
//

import Foundation
import PrettyLog

// MARK: - Global aliases

/// Log strings in order with VERBOSE level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logV(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logV(messages, joinedBy: separator, category: category)
}

/// Log strings in order with DEBUG level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logD(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logD(messages, joinedBy: separator, category: category)
}

/// Log strings in order with INFO level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logI(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logI(messages, joinedBy: separator, category: category)
}

/// Log strings in order with WARNING level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logW(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logW(messages, joinedBy: separator, category: category)
}

/// Log strings in order with ERROR level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logE(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logE(messages, joinedBy: separator, category: category)
}

/// Log with ERROR level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logE(_ error: Error?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.logE(error, category: category)
}

/// Log with ERROR level
/// - Parameters:
///     - messages: The messages to log
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` is empty or `nil`.
public func logE(_ exception: NSException?, category: LogCategory = .uncategorized) {
    PrettyLogProxy.logE(exception, category: category)
}
```

## Author

👤 **Benno Kress**

-   Website: [bennokress.de](https://bennokress.de)
-   Twitter: [@bennokress](https://twitter.com/bennokress)
-   Github: [@bennokress](https://github.com/bennokress)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/bennokress/PrettyLog/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc).

## 📝 License

Copyright © 2022 [Benno Kress](https://github.com/bennokress).<br />
This project is [MIT](https://github.com/bennokress/PrettyLog/blob/main/LICENSE) licensed.

---

_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
