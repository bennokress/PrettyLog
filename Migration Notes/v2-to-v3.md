# Migrating from PrettyLog 2 to PrettyLog 3

Applies to every 3.x release.

## Requirements

| | 2.x | 3.x |
| --- | --- | --- |
| swift-tools-version | 5.9 in 2.0.4 | 6.0 (Xcode 16 or later) |
| Swift language modes | 5 and 6 | 5 and 6 |
| iOS | 15 | 15 |
| Mac Catalyst | 15 | 15 |
| macOS | 12 | 12 |
| tvOS | 15 | 15 |
| watchOS | 8 | 9 |

## Checklist

- [ ] [Use Xcode 16 and raise watchOS to 9](#1-use-xcode-16-and-raise-watchos-to-9)
- [ ] [Define your own log targets](#2-define-your-own-log-targets)
- [ ] [Define your own log functions](#3-define-your-own-log-functions)
- [ ] [Pass your targets to every `PrettyLogProxy` call](#4-pass-your-targets-to-every-prettylogproxy-call)
- [ ] [Check what your targets receive from errors and exceptions](#5-check-what-your-targets-receive-from-errors-and-exceptions)

## Breaking changes

### 1. Use Xcode 16 and raise watchOS to 9

**Affects you if** you build with a toolchain older than Swift 6.0, or your app supports watchOS 8.

**What changed:** The package manifest uses `swift-tools-version: 6.0`, and the minimum watchOS version is 9.

**What to do:** Build with Xcode 16 or later. Raise the watchOS deployment target of every target that depends on PrettyLog to 9, or stay on PrettyLog 2.

### 2. Define your own log targets

**Affects you if** you use `ConsoleLog`, directly or through the default targets of the log functions.

**What changed:** PrettyLog ships no log target anymore. `ConsoleLog` included sensitive messages in every build, so an app that relied on it printed sensitive data to stdout in release builds too. A package can't know where an app may send sensitive data, so every app now defines its targets itself.

**What to do:** Write your own target that conforms to `LogTarget`. The README shows a console target under "Setup" that prints the same format as `ConsoleLog` did and includes sensitive messages only in debug builds. If you name it `ConsoleLog`, existing references such as `[ConsoleLog(), BackendLog()]` keep compiling.

```swift
// Before (2.x): ConsoleLog came from PrettyLog
import PrettyLog

PrettyLogProxy.logI(messages, to: [ConsoleLog()])

// After (3.x): ConsoleLog is a type in your app
struct ConsoleLog: LogTarget {

    var canLogSensitiveInformation: Bool { isDebugApp }

    func createLog(_ level: LogLevel, message: String, category: LogCategory) { … }

}
```

### 3. Define your own log functions

**Affects you if** you call `logD`, `logX`, `logV`, `logI`, `logW`, `logE`, `logK` or `log` from PrettyLog directly, usually in files that `import PrettyLog`.

**What changed:** PrettyLog has no global log functions anymore. `PrettyLogProxy` is the only entry point.

**What to do:** Add one file to your app that defines the log functions you use and the list of targets they send to. The README has a complete file under "Setup". Your call sites stay the same, and the other files no longer need `import PrettyLog`. If you already have such a file, only step 4 applies to you.

```swift
// Before (2.x): any file
import PrettyLog

logI("User tapped Continue Button", category: .user)

// After (3.x): your logging file
import PrettyLog

func logI(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logI(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: logTargets)
}

private var logTargets: [LogTarget] {
    [ConsoleLog()]
}

// After (3.x): any file, no import needed
logI("User tapped Continue Button", category: .user)
```

### 4. Pass your targets to every `PrettyLogProxy` call

**Affects you if** you call a method of `PrettyLogProxy` without the `to:` argument.

**What changed:** `to:` has no default value anymore and is required on every method.

**What to do:** Pass your targets.

```swift
// Before (2.x)
PrettyLogProxy.logI(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category)

// After (3.x)
PrettyLogProxy.logI(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: logTargets)
```

### 5. Check what your targets receive from errors and exceptions

**Affects you if** you log errors or exceptions and evaluate the resulting statements, for example in a backend, or rely on the full details reaching a target whose `canLogSensitiveInformation` is `false`.

**What changed:** The details of errors and exceptions are now treated as sensitive, because they can contain tokens, URLs and other personal data. This compiles unchanged, but the content of the statements changes:

| | 2.x | 3.x, target may receive sensitive data | 3.x, target may not |
| --- | --- | --- | --- |
| `Error` | `localizedDescription (full description)` | `localizedDescription - full description` | `localizedDescription` |
| `NSException` | the `description` of the exception | `name - reason - userInfo` | `name` |

**What to do:** Adjust anything that parses these statements. If a target really needs the details, it has to allow sensitive data.
