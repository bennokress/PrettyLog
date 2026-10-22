# Survey: how the maintainer's apps use levels, categories, targets and log functions

Research for #80 on the map #82, collected on 2026-10-22 by reading the local clones of every app of the maintainer that depends on PrettyLog. Nothing was built or run for this survey: every statement comes from reading source files, project files and `Package.resolved`, so it describes the code as written, not observed behaviour.

## Sources and method

- **Private apps** (named and quoted): **EV Stats** (iOS app, last commit 2026-09-10), **Verktøy** (iOS project with two app targets, Verktøy and Werkzeug, compiled from one shared source folder; last commit 2026-10-22), **Työkalu** (iOS app, last commit 2026-02-11). Found by searching every `Package.swift`, `Package.resolved` and `project.pbxproj` for "PrettyLog"; no other private project depends on it.
- **Other projects** (described in generic form only): **the largest app** (a modular iOS app with 37 first-party Swift packages, state of 2026-10-22), **app B** (an earlier rewrite of the same product, last commit March 2025, apparently dormant) and **app C** (a Swift package, an SDK meant to be embedded in another app, plus a demo app; last commit August 2026). Six further folders of these projects were searched and do not use PrettyLog.
- Call-site counts come from single-line `grep` over all first-party `.swift` files, with wrapper declarations and forwarding lines excluded. A `category:` on a later line of a multi-line call is not seen, so "calls without a category" is an upper bound and totals are approximate.
- Package versions referred to: 2.0.4 (`LogLevel` an enum with nine named cases plus `.custom(emoji:priority:)`; `LogCategory` an enum with nine built-in cases plus `.custom(_:)`; `LogTarget` with `createLog`, `logPriorityRange: ClosedRange<LogLevel>?` and `canLogSensitiveInformation`) and 1.1.1 (five named levels plus `.custom`, no sensitive messages in `LogTarget`).

## Overview per app

| | EV Stats | Verktøy | Työkalu | Largest app | App B | App C |
| --- | --- | --- | --- | --- | --- | --- |
| PrettyLog pin | up to next major from 2.0.4 (resolved 2.0.4) | up to next major from 2.0.0 (resolved 2.0.4) | up to next major from 2.0.4 (resolved 2.0.4) | exact 2.0.4 | exact 1.1.1 | from 2.0.4 (resolved 2.0.4) |
| Swift language mode | 6 | 6 for both app targets, 5 for tests | 5 | 5 for the app and all 37 first-party packages | 5 | 6 (tools version 6.3) |
| Default actor isolation | `MainActor` | none (nonisolated) | `MainActor` | none | none | none |
| Approachable concurrency | yes | yes (tests) | yes | no | no | n/a |
| Where wrappers live | app target, one file | shared folder of two app targets | app target, one file | a dedicated logging package, `public` | app target, one file | inside the SDK, `package` access |
| Wrapper functions declared | 21 | 21 | 14 | 17 (3 deprecated) | 9 | 11 |
| Wrapper calls (approx.) | 25 | 60 | 8 | about 1,020 | 86 | about 109 |
| Targets in production code | 2 named, 1 of them not defined (see section 3) | 2 | 1 | 2 | 3 (2 are stubs) | 1 |
| Test targets | none | 1 memory target | none | 1 discarding target, copied into 2 packages | none | 1 capture through redirection |
| Own categories | 0 | 1 | 1 | 7 plus 1 factory function | 7 plus 1 factory function, plus 1 private | 1, fixed |
| Default category of the wrappers | `.general` | `.general` | `.uncategorized` | `.general` (doc comments say `.uncategorized`) | `.general`, `.debug` for one wrapper | none, every statement gets the fixed one |

## 1. Levels

**No app defines its own level set.** All six use the levels the package ships. There is one custom level in total: app B declares a key-event level as `.custom` with priority `Int.max` in a `LogLevel` extension, because 1.1.1 had no key-event level yet.

**Levels actually called** (through the wrappers, approximate):

- EV Stats: info 7, warning 4, error 13, plus 1 `fatalLog`. The debug, verbose, xcode, staging, production and key-event wrappers exist but have no call site.
- Verktøy: debug 15, verbose 11, info 3, warning 12, error 7, key event 1, `fatalLog` 11. The semantic aliases (`logX`, `logS`, `logP`) are declared but not called.
- Työkalu: verbose 5, warning 2, error 1.
- Largest app: only the semantic names: xcode about 134, staging about 48, production about 636, warning about 99, error about 44, `fatalLog` about 56. The plain names (`logD`, `logV`, `logI`) exist only as deprecated aliases with no call site. No key-event wrapper.
- App B: an xcode wrapper (mapped to verbose) 11, a test-systems wrapper (mapped to debug) 1, production 12, warning 10, error 4, key event 14, `fatalLog` 35.
- App C: xcode 2, staging 11, production 39, warning 39, error 9, error wrapper about 1.

**Two names per priority.** In 2.0.4, `.debug`/`.xcode`, `.verbose`/`.staging` and `.info`/`.production` share priority and emoji. EV Stats and Verktøy declare wrappers for both names of every pair; the largest app and app C use only the semantic name; app B maps its xcode wrapper to verbose and its test wrapper to debug. With unique raw values in PrettyLog 3, an app enum cannot hold both names of a pair at the same priority, so each app has to pick one name per priority, or keep the second name as a wrapper that forwards to the same case. The largest app already does the latter with its three deprecated aliases.

**Mapping levels to something else.** Every mapping is a `switch` over the package's level enum **without a `default`**:

- An OSLog target in Verktøy and one in the largest app, nearly character for character the same: 10 cases (9 named plus `.custom`) onto 5 `Logger` methods (`debug`, `notice`, `info`, `warning`, `fault`); key event and custom go to `notice`. App B has the same shape for 1.1.1: 6 cases onto 5 methods.
- A backend target in the largest app maps 10 cases onto 5 backend severities (key event and custom count as the middle one), and a second `switch` maps those 5 severities to the numeric values the backend filters on.
- No target maps levels with a `default`, and none compares levels except through the priority filter.

## 2. Categories (input for #81)

**How they are declared.** Always as `static var` in an extension of `LogCategory` that returns `.custom("Name")`. No app writes `.custom("…")` or a category string at a call site: every custom category is declared once and used by name. Two projects add a **factory function**: the largest app and app B each have a `static func` that takes an app enum with 6 cases (one per backend environment) and returns a category through a `switch` without `default`, plus one catch-all category for "any environment". App B makes the six per-environment categories `private`, so only the factory and the catch-all are visible.

**How many, and how much the built-in ones are used.**

- EV Stats: no own category (one commented-out example in the file), and no call passes a category; everything goes to the default `.general`.
- Verktøy: 1 own (`.intent`). All but about one of 60 calls name a category: service 27, intent 9, general 9, debug 8, storage 7.
- Työkalu: 1 own (`.intent`). Every call names one: general 4, intent 3, service 1.
- Largest app: 7 own categories plus the factory. Explicit categories at the call sites (approximate): manager 237, view 212, the per-environment factory 187, user 171, service 48, general 44, storage 38, the catch-all 27, debug 25, app state 10, uncategorized 2. So **9 of the 2.0.4 built-in categories carry about 790 call sites** in this app alone. About 22 places pass on a `category` parameter they received (helpers such as a string extension that logs itself under a given category). One commented-out call names a category that is not declared.
- App B: 7 own plus a private key-event category used by one wrapper. Built-ins: storage 17, service 11, general 6, manager 4, debug 4, user 3, view 2.
- App C: one category, fixed inside the SDK's single funnel function. No wrapper has a `category` parameter, by design, so that every console line says it came from the SDK.

**Duplicate declarations across modules.** One package of the largest app declares the app's catch-all category a second time under the same name, so its log lines look as they did before the code moved into that package. The two declarations are kept equal by hand.

**Do targets compare or switch over categories?** No. No target or app code compares two categories or switches over one. Targets use a category only through `name` (as the `Logger` category in the OSLog targets, as a `[name]` prefix of the event name in the backend target) and through `truncatedOrPadded(to: 20)` for the console prefix.

**How "no category" is handled.** Four projects default the wrapper parameter to `.general` and Työkalu to `.uncategorized`; app B uses `.debug` for its xcode wrapper. The largest app's `fatalLog` has **no default**, so the category is required there, while all its other wrappers default to `.general`. Explicit `.uncategorized` appears twice in the largest app. Its doc comments still say "defaults to `.uncategorized`" while the code says `.general`.

**What this means for PrettyLog 3.** On `feature/api`, `LogCategory` is a struct with `name` and only `.uncategorized`; `.general`, `.manager`, `.view`, `.user`, `.service`, `.storage`, `.debug` and `.appState` are gone. Every project except Työkalu defaults to `.general`, and the largest app relies on 9 of the removed built-ins, so a migration has to declare them in the app. An app-defined category enum would hold them in one place. No app needs a category created on the spot or a comparison of categories. The per-environment factory is the only case where a category depends on a runtime value, and it maps a closed app enum, so it would fit an enum case with an associated value, or one case per environment.

## 3. Targets (input for #78)

### Per target

| App | Target | Purpose | Sensitive | Filter | State | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| EV Stats | package `ConsoleLog` | Xcode console in debug builds | package default | package default (all) | none | the only target in debug |
| EV Stats | `OSLogTarget(bundleID:canLogSensitiveInformation:logPriorityRange:)` | unified log in release builds | `false` | from `.production` | n/a | called in the `#else` branch, but **no type of that name is defined in the project, and none was ever committed**. That suggests a release build of EV Stats does not compile today; not verified by building. |
| Verktøy | `Console` (struct) | Xcode console | `true` | all | none | timestamp, padded category, emoji, message via `print` |
| Verktøy | `OSLogTarget` (struct) | unified log | init parameter (TestFlight `true`, App Store `false`) | init parameter (TestFlight from `.staging`, App Store from `.production`) | stores the bundle ID | level `switch` without `default` |
| Verktøy tests | `MemoryLogTarget` (final class) | collects messages in tests | init parameter | init parameter | mutable `[String]` | |
| Työkalu | `Console` (struct) | Xcode console | `true` | all | none | the only target, in every build |
| Largest app | OSLog target (struct) | unified log in every build | debug build only | all | stores the bundle ID | same level `switch` as Verktøy |
| Largest app | backend target (struct) | sends statements to a remote log service once the user has consented | debug build only | **computed per statement**: from `.info` while a consent closure returns `true`, otherwise none | holds a reference to an actor that queues, batches on a timer, compresses and posts, with an optional encrypted disk buffer | init with 11 parameters, several of them `@Sendable` closures; `createLog` captures the timestamp and hops to the actor in an unstructured `Task`; exposes extra methods (flush, enable or disable, reset) that the app calls through a typed static reference it keeps next to the target list |
| Largest app tests | discarding target (private struct) | gives package tests a target, because the package asserts when there is none | `false` | default | none | identical file copied into the tests of two packages |
| App B | OSLog target | unified log | n/a (1.1.1) | all | none | |
| App B | two stubs (backend, key events) | placeholders | n/a | none | none | bodies commented out |
| App C | console target (struct) | console of the host app | from a build policy: debug `true`, release `false` | from the build policy: debug all, release from `.warning` | the policy plus an optional `@Sendable` emit closure for tests | formatting handed to the package's `ConsoleLog`; the target list is computed per statement and can only be replaced through a `@TaskLocal` redirection used by a `Mutex`-guarded capture class in tests |

### Patterns across targets

- **Sensitivity** is always decided per build or per environment when the target is created (debug build, TestFlight versus App Store, a build policy), never at the call site. Console targets always allow it.
- **Filters** are mostly fixed at creation. The one dynamic filter is the backend target, which checks consent again for every statement. On `feature/api`, `levelFilter` is a get-only property requirement, so a computed implementation stays possible.
- **State** ranges from none (console) through a stored bundle ID (OSLog) to an actor with a queue, a timer and a disk buffer (backend). Only test targets are classes.
- **Sendable.** No target declares `Sendable` (the 2.0.4 protocol is not `Sendable`), and the consequences show in four projects. EV Stats and Verktøy keep the target list in a `nonisolated(unsafe) static var`. The largest app writes its list through a concurrent `DispatchQueue` with asynchronous barrier writes, while the wrappers read the static directly, bypassing the queue (consistent with a data race; not checked with the thread sanitizer). Its tests skip the asynchronous setter because the first log of a test could otherwise find no target. App C recomputes its target list for every statement, because Swift 6 mode rejects a `static let` of a non-`Sendable` type.
- **Registry shape.** Three projects (EV Stats, Verktøy, the largest app) use the same registry shape: a static `current` list with `set(_:)` and `add(_:)` (called `ActiveLogTargets` in the private apps). It is set at launch and replaced once the environment is better known: after StoreKit answers in Verktøy, and after storage and consent are available in the largest app, which first sets OSLog only and adds the backend target later. Työkalu and app B use a `private static var` in an array extension; app C uses a computed static with a task-local override.
- **Sharing.** Verktøy compiles one target set into two app targets. The largest app keeps its targets in a dedicated package that depends on the wrappers package, so library packages log without seeing any target. The OSLog targets of Verktøy and the largest app are near copies of each other, and so are the console targets of Verktøy and Työkalu.
- **Level mapping** is a `switch` without `default` in all three OSLog targets and in the backend target (section 1).

## 4. Log functions (input for #76)

### Shape every app shares

- Free global functions named `log` plus one letter, each forwarding to the `PrettyLogProxy` method for its level with the app's target list.
- First parameter `_ messages: String?...` (variadic, optional strings); `joinedBy separator: String = " - "` everywhere; `category: LogCategory = <default>` last.
- Sensitive content as a second variadic `sensitiveMessages: String?...`. Five projects declare **two overloads per level**, one with and one without `sensitiveMessages`, otherwise identical. App B instead has one function per level, with a differently labelled second variadic placed before `category`, and merges the sensitive part in the wrapper behind a hard-coded flag.
- The sensitive overloads are rarely used: EV Stats 2 calls, Verktøy 1, the largest app 1, app B 0, Työkalu 0, app C about 56 of about 109.
- An error wrapper `log(_ error: Error?, category:)` and an exception wrapper `log(_ exception: NSException?, category:)` exist in five projects (Työkalu adds `as level: LogLevel = .error`). **Neither has a single call site in any of the five.** Only app C calls its error wrapper (once); it builds the statement itself, with the error's type name as the public part and its description as the sensitive part.
- `fatalLog(...) -> Never` in five projects, as a pair with and without sensitive messages: it logs at error level and then calls `fatalError` with the joined public messages. Työkalu also puts the sensitive messages into the `fatalError` text, so they end up in the crash message whatever a target's `canLogSensitiveInformation` says. App C deliberately has no `fatalLog` (a library should not crash its host).
- A key-event wrapper `logK` without a sensitive overload exists in EV Stats and Verktøy (doc comment: "Bypasses every `allowFrom(min:)` filter"). App B's key-event wrapper has **no `category` parameter** and uses a fixed private category and level.

### What differs between the wrappers of one app, apart from the level

- The doc comment (summary, sometimes a sentence on the environment it is meant for).
- Whether there is a sensitive overload (missing for `logK` and for the largest app's deprecated aliases).
- The default category (app B: `.debug` for the xcode wrapper, `.general` for the rest; largest app: no default on `fatalLog`).
- The return type and the extra `fatalError` call for `fatalLog`.
- `@available(*, deprecated, renamed:)` on the largest app's three aliases, which forward to a different level than their name says (`logD` to xcode, `logV` to staging, `logI` to production).
- Nothing else: within an app, the access level, isolation, parameter list and forwarding call are the same for every level.

### What differs between apps

| | EV Stats | Verktøy | Työkalu | Largest app | App B | App C |
| --- | --- | --- | --- | --- | --- | --- |
| Access | internal | internal | `public` | `public` (separate package) | internal | `package` |
| Isolation annotation | `nonisolated` on every wrapper (default isolation is `MainActor`) | none | none (default `MainActor`, Swift 5) | none | none | none |
| Doc comments | one line per function | one line per function | full DocC with `- Parameters:` and `- Attention:` | full DocC with `- Parameters:` and `- Attention:` | full DocC | full DocC |
| Category parameter | yes | yes | yes | yes | yes, except key event | no |
| Forwarding | `PrettyLogProxy.logX(...)` and the like | same | same | same | merges the sensitive part itself, then forwards | one internal funnel function calling `PrettyLogProxy.log(_:sensitiveMessages:joinedBy:as:category:to:)` |

EV Stats explains the `nonisolated` in a comment: the project defaults to main-actor isolation while logging happens on every actor, so without it a log call off the main actor does not compile.

### Representative wrapper file (EV Stats, PrettyLog 2.0.4)

`EVStats/Services/Logging/PrettyLog.swift`, quoted from line 40 to the end. The level pairs between Verbose and Key Event follow the same pattern and are shortened to one comment line here. Verktøy's file is the same without `nonisolated`.

```swift
// The wrappers below exist so call sites read as `logD("…")` instead of naming the target list
// every time. Each level has a variant taking `sensitiveMessages:`, which only reaches targets
// that are allowed to record it.
//
// Every one of them is `nonisolated`, because the project defaults to main-actor isolation while
// the things worth logging happen on every actor: the sync engine calls its delegate from wherever
// it is, and the database is reached from readers and writers everywhere. Without this a log call
// in such a place does not compile. It is safe because the target list is already
// `nonisolated(unsafe)` and written only at launch.

// MARK: - Verbose / Staging

/// Log messages with VERBOSE level.
nonisolated func logV(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.logV(messages, joinedBy: separator, category: category, to: ActiveLogTargets.current)
}

/// Log messages with VERBOSE level, including sensitive content for targets that allow it.
nonisolated func logV(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.logV(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: ActiveLogTargets.current)
}

/// Log messages with VERBOSE level, semantically targeting the Staging (TestFlight) environment.
nonisolated func logS(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.logS(messages, joinedBy: separator, category: category, to: ActiveLogTargets.current)
}

/// Log messages with VERBOSE level for Staging, including sensitive content for targets that allow it.
nonisolated func logS(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.logS(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: ActiveLogTargets.current)
}

// … the same two overloads each for logD, logX, logI, logP, logW and logE …

// MARK: - Key Event

/// Log a Key Event at the highest priority. Bypasses every `allowFrom(min:)` filter.
/// Use for important business events that should never be silently dropped.
nonisolated func logK(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .general) {
    PrettyLogProxy.logK(messages, joinedBy: separator, category: category, to: ActiveLogTargets.current)
}

// MARK: - Errors and Exceptions

/// Log an `Error` with ERROR level.
nonisolated func log(_ error: Error?, category: LogCategory = .general) {
    PrettyLogProxy.log(error, category: category, to: ActiveLogTargets.current)
}

/// Log an `NSException` with ERROR level.
nonisolated func log(_ exception: NSException?, category: LogCategory = .general) {
    PrettyLogProxy.log(exception, category: category, to: ActiveLogTargets.current)
}

// MARK: - Fatal

/// Log with ERROR level and crash the app.
nonisolated func fatalLog(_ messages: String?..., joinedBy separator: String = " - ", category: LogCategory = .general) -> Never {
    PrettyLogProxy.logE(messages, joinedBy: separator, category: category, to: ActiveLogTargets.current)
    fatalError(messages.compactMap { $0 }.joined(separator: separator))
}

/// Log with ERROR level and crash the app, including sensitive content for targets that allow it.
nonisolated func fatalLog(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .general) -> Never {
    PrettyLogProxy.logE(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: ActiveLogTargets.current)
    fatalError(messages.compactMap { $0 }.joined(separator: separator))
}
```

Työkalu's wrappers differ in being `public`, defaulting to `.uncategorized`, taking `as level: LogLevel = .error` on the error and exception wrappers, and carrying full DocC, for example:

```swift
/// Log a statement with DEBUG level
/// - Parameters:
///     - messages: One or more strings and string-convertible objects to include in the log statement
///     - sensitiveMessages: One or more strings and string-convertible objects to include in the log statement if the target allows sensitive content
///     - separator: The separator between messages (defaults to `-`)
///     - category: The category of the log message (defaults to `.uncategorized`)
/// - Attention: No log will be created, if `messages` and `sensitiveMessages` are both empty or consist only of `nil`-elements!
public func logD(_ messages: String?..., sensitiveMessages: String?..., joinedBy separator: String = " - ", category: LogCategory = .uncategorized) {
    PrettyLogProxy.logD(messages, sensitiveMessages: sensitiveMessages, joinedBy: separator, category: category, to: .defaultLogTargets)
}
```

### Shapes in the other projects, generically

- **Largest app:** 5 levels (xcode, staging, production, warning, error) with 2 overloads each, an error and an exception wrapper, a `fatalLog` pair and 3 deprecated aliases without a sensitive overload: 17 `public` functions in a package of their own, each with full DocC. `fatalLog` requires a category. About 1,020 calls across the app and the 6 packages that depend on the wrappers package.
- **App B:** 9 internal functions: one per level with an extra sensitive variadic before `category`; an xcode wrapper mapped to verbose with default category `.debug`; a test-systems wrapper mapped to debug; a key-event wrapper without a category; an error and an exception wrapper; one `fatalLog`.
- **App C:** 5 levels with 2 overloads each plus an error wrapper: 11 `package` functions, no `category` parameter, no `fatalLog`, no key event. All of them go through one internal funnel function with a fixed category and a target list that defaults to the SDK's own.

## 5. Modules and libraries (the library module case from #84)

- **Largest app:** 37 first-party packages, all in Swift 5 language mode. PrettyLog sits behind a thin wrapper package; one package holds the log wrappers and the registry, another holds the two production targets. Six packages log through the wrappers package. **No package has its own levels or targets**: every package logs with the app's levels into the app's target list. Package tests install a discarding target, because the package asserts when asked to log without targets.
- **App B:** its packages do not log through PrettyLog. One storage package notes in a comment that it must not log a certain access, to avoid a circular dependency between logging and storage.
- **App C** is the library case itself: an SDK that logs **with its own target list, its own build-dependent policy, one fixed category and its own wrappers**, and that deliberately gives the host app no way to add or replace a target (the only override is a task-local redirection for tests). Today its levels are the package's built-in ones, shared with any host app. With PrettyLog 3's app-defined level enums, such an SDK would declare its own enum, its targets would be typed to that enum, and a host app could not hand its own targets to the SDK. This SDK does not want that anyway, so the type separation fits its design. Whether a host app and such an SDK can each use their own level enum in one process without conflict has not been tested.
- **Verktøy** shares one logging folder between two app targets in one project (no separate module).

## 6. Suggestions for the follow-up tickets

These follow from the counts above. They are input for the discussion, not decisions.

- **#76 (log function macro):** within an app every wrapper has the same shape. What varies is the name, the level, the doc summary, the access level, the isolation (`nonisolated` in a `MainActor`-default app), whether there is a sensitive overload, and the default category. A macro that generates the pair per level from the level enum would cover every wrapper the five app-style consumers declare, except `fatalLog` (extra `fatalError`), the deprecated aliases (`@available` and a different level) and app C's fixed-category funnel. The error and exception wrappers have no call site in five of six projects, which raises the question whether a macro should generate them at all. The app has to choose access level and isolation: the observed values are internal, `public` and `package`, with `nonisolated` or nothing.
- **#81 (categories as an app-defined type with an app-chosen fallback):** every app already declares its categories centrally and never creates one on the spot, so an app-defined enum loses nothing at the call sites surveyed. The fallback differs per project (`.general` in four, `.uncategorized` in one, a fixed category in the SDK, a required category on one `fatalLog`), so an app-chosen fallback matches what exists. The one runtime-dependent category (a per-environment factory over a closed 6-case enum) would fit an enum case. The largest app would need the 9 built-in categories it uses declared in its own type.
- **#78 (target shape):** the targets observed are console, OSLog, a remote backend with an actor and a dynamic filter, and test targets that discard, collect or redirect. Every one takes `canLogSensitiveInformation` and the filter from fixed values or init parameters, except the backend's consent check on every statement. Level mapping is always an exhaustive `switch` without `default`. The missing `Sendable` on `LogTarget` leads to `nonisolated(unsafe)` statics, unsynchronised reads, recomputed target lists and asynchronous setters in four of six projects. That looks like the most widespread problem in the target area.

## Not determined

- No app was built. Whether EV Stats' release configuration compiles (the missing `OSLogTarget`) was inferred from the source and its history, not tested.
- Whether the largest app's registry has an actual data race was not checked with the thread sanitizer.
- Call-site counts are single-line `grep` results: multi-line calls make the "without category" figures upper bounds and the totals approximate.
- Code not on a local clone, such as planned apps, was not surveyed.
- Whether a host app and an SDK can each declare their own `@LogLevels` enum in one process (the library module case) was not tested.
