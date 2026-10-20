# Migrating from PrettyLog 1 to PrettyLog 2

Applies to every 2.x release.

## Requirements

| | 1.x | 2.x |
| --- | --- | --- |
| swift-tools-version | 5.6 | 6.1 in 2.0.0, 2.0.2 and 2.0.3 (Xcode 16.3 or later), 5.9 in 2.0.1 and 2.0.4 (Xcode 15 or later) |
| Swift language modes | 5 | 5 and 6 |
| iOS | 11 | 15 |
| Mac Catalyst | 13 | 15 |
| macOS | 10.13 | 12 |
| tvOS | 11 | 15 |
| watchOS | 4 | 8 |

## Checklist

- [ ] [Raise your deployment targets](#1-raise-your-deployment-targets)
- [ ] [Add `canLogSensitiveInformation` to your log targets](#2-add-canlogsensitiveinformation-to-your-log-targets)
- [ ] [Handle the new log levels in exhaustive switches](#3-handle-the-new-log-levels-in-exhaustive-switches)

## Breaking changes

### 1. Raise your deployment targets

**Affects you if** your app supports an OS version below the ones in the table above.

**What changed:** PrettyLog 2 needs iOS 15, Mac Catalyst 15, macOS 12, tvOS 15 or watchOS 8.

**What to do:** Raise the deployment target of every target that depends on PrettyLog to at least these versions, or stay on PrettyLog 1.

### 2. Add `canLogSensitiveInformation` to your log targets

**Affects you if** you have your own types that conform to `LogTarget`.

**What changed:** `LogTarget` has a new requirement. It decides whether a target receives the sensitive part of a log statement (see "Sensitive messages" below).

**What to do:** Add the property to each of your targets.

```swift
// Before (1.x)
struct BackendLog: LogTarget {

    func createLog(_ level: LogLevel, message: String, category: LogCategory) { … }

}

// After (2.x)
struct BackendLog: LogTarget {

    let canLogSensitiveInformation = false

    func createLog(_ level: LogLevel, message: String, category: LogCategory) { … }

}
```

### 3. Handle the new log levels in exhaustive switches

**Affects you if** your code has a `switch` over `LogLevel` without a `default` case.

**What changed:** `LogLevel` has four new cases: `.xcode`, `.staging`, `.production` and `.keyEvent`.

**What to do:** Add the new cases to the `switch`, or add a `default` case.

```swift
// Before (1.x)
switch level {
case .debug, .verbose, .info: …
case .warning, .error: …
case .custom: …
}

// After (2.x)
switch level {
case .debug, .verbose, .info, .xcode, .staging, .production: …
case .warning, .error, .keyEvent: …
case .custom: …
}
```

## New and optional

Nothing in this section is required. Every call of `logD`, `logV`, `logI`, `logW`, `logE` and `log` from PrettyLog 1 keeps working unchanged.

### Sensitive messages

Every log function except `logK` takes an optional `sensitiveMessages` parameter. Only targets whose `canLogSensitiveInformation` is `true` receive these messages.

```swift
// Before (1.x)
logI("Saving Token from API", category: .storage)

// After (2.x): the token reaches only the targets that may receive sensitive data
logI("Saving Token from API", sensitiveMessages: token, category: .storage)
```

### Semantic log levels

Three levels name the environment a statement is meant for. In our team at work this has been established to make clear which level is appropriate for a log message. Each has the same emoji and priority as an existing level, but is a separate case, so `LogLevel.xcode == LogLevel.debug` is `false`.

- 🟤 `.xcode`: same emoji and priority as `.debug`
- 🔵 `.staging`: same emoji and priority as `.verbose`
- 🟢 `.production`: same emoji and priority as `.info`

The matching functions are `logX`, `logS` and `logP`. They log with the classic levels `.debug`, `.verbose` and `.info`, not with the semantic cases. `logX` ships as a global function, `logS` and `logP` exist on `PrettyLogProxy` only.

### Key events

📊 `.keyEvent` has the highest priority and is meant for events you want to count or analyse, perhaps in another system. Log them with `logK`. It takes no sensitive messages, so a key event never contains sensitive data.

### Swift 6

PrettyLog builds in the Swift 6 language mode and still supports the Swift 5 language mode for consumers.
