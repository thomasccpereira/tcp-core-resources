# tcp-core-resources

A Swift utility package with zero external dependencies, providing reusable extensions for primitive types, SwiftUI views, dates, collections, and more. Includes scroll offset tracking, observation helpers, photo picking utilities, localization support, and a `DomainModelable` protocol for Clean Architecture mapping.

## Requirements

- iOS 18.0+
- Swift 6.1+

## Installation

### Swift Package Manager

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/thomasccpereira/tcp-core-resources", from: "1.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies** and enter the repository URL.

---

## What's inside

### 🔤 String

| Extension | Description |
|---|---|
| `.trimmed` | Removes whitespace, newlines and tabs |
| `.cleaned` | Trimmed + lowercased |
| `.condensed` / `.extraCondensed` | Collapses or removes all whitespace |
| `.nilWhenEmpty` | Returns `nil` if the string is empty after trimming |
| `.validLines` | Filters out empty lines |
| `.escaped` | Escapes single quotes |
| `.isEmailValid` | Pragmatic email format validation |
| `.formattedBrazilianTaxID` | Formats CPF (11 digits) and CNPJ (14 digits) |
| `.formattedAsCompanyTaxID` | Incrementally applies the CNPJ mask |
| `.date` | Parses a date from a raw digit string (`yyyyMMddHHmmss`) |

### 🔢 Double

| Extension | Description |
|---|---|
| `.integerValue` | Locale-aware integer string |
| `.currencyValue` / `.unitCurrencyValue` | Locale-aware currency formatting (2 or 4 decimal places) |
| `.twoDecimals` / `.threeDecimals` / `.fourDecimals` | Decimal string with grouping separators |
| `*Sync` variants | Same formatters without grouping separators, for sync/API use |
| `.percentualTwoDecimals` / `.percentualThreeDecimals` | Percentage string |
| `.round(_:roundingMode:)` | Rounds using a `NumberFormatter`'s precision |
| `.roundUp(to:)` | Rounds up to N decimal places |

### 🔢 Int?

| Extension | Description |
|---|---|
| `.zeroWhenNil` | Returns `"0"` for `nil` |
| `.emptyWhenNil` | Returns `""` for `nil` |
| `.emptyWhenZero` | Returns `""` for `nil` or `0` |

### ✅ Bool

| Extension | Description |
|---|---|
| `.nilWhenFalse` | Returns `nil` when `false` |
| `.intValue` | `Int` representation (`0` or `1`) |
| `@AnyBool` | Property wrapper that decodes booleans from `Bool`, `Int`, or `String` (`"true"`, `"1"`, `"yes"`, `"y"`) |

### 📅 Date

| Extension | Description |
|---|---|
| `init(day:month:year:hour:minute:seconds:)` | Failable initializer from components |
| `.isSameDate(_:)` | Compares two dates ignoring time |
| `.adding(_:value:)` / `.plusOneHour` | Calendar-safe date arithmetic |
| `.startOfDay` / `.endOfDay` | Day boundaries |
| `.day` / `.month` / `.year` | Calendar component accessors |
| `.daysTo(_:)` / `.daysAgo(_:)` | Day difference utilities |
| `Date.yesterday` / `Date.startOfMonth` / `Date.endOfMonth` | Convenient static accessors |
| `Date.uses24Hours` | Detects the device's time format preference |
| `Date.nowTimeIntervalSince2001` | SwiftData-compatible timestamp |

**Formatting** (locale-aware, 24h/AM-PM adaptive):

`.prettyShort`, `.pretty`, `.yearMonth`, `.yearMonthDay`, `.dayAndMonthName`, `.weekday`, `.dateTime`, `.dateTimeWithSeconds`, `.time`, `.timeWithSeconds`

### 🗂 Collection / Array / Sequence

| Extension | Description |
|---|---|
| `collection[safe: index]` | Safe subscript that returns `nil` instead of crashing |
| `.remove(element:)` | Removes the first occurrence of an equatable element |
| `.uniqued` | Removes duplicates preserving order |
| `.asyncForEach` / `.asyncMap` / `.asyncCompactMap` | Serial async iteration |
| `.concurrentForEach` / `.concurrentMap` / `.concurrentCompactMap` | Concurrent async iteration with optional concurrency limit |

### 🔑 KeyPath

| Extension | Description |
|---|---|
| `.pathName` | Last component of a key path as a `String` |
| `.partialPathName` | Full key path string without the root type prefix |
| `.map(_:keyPath:)` | Maps a sequence by key path |
| `.sorted(by:keyPath:)` | Sorts a sequence by a comparable key path |
| `==`, `!=`, `<` operators | Predicate builders for key path comparisons |
| `prefix !` operator | Negates a `Bool` key path predicate |

### 📦 Data

| Extension | Description |
|---|---|
| `.base64` | Base64-encoded string |
| `.resizedImageData` | Resizes image data to a max of 1920×1080 with 0.7 JPEG quality |

### 🔗 URL

| Extension | Description |
|---|---|
| `.isDirectory` | Checks whether the URL points to a directory |
| `.isVideo` | Checks whether the URL points to a video file using `UTType` |

### 🔡 Encodable

| Extension | Description |
|---|---|
| `.json` | Encodes the value to a sorted-keys JSON string |

---

## SwiftUI Extensions

### 🎨 Color

| Extension | Description |
|---|---|
| `Color(hex: UInt, alpha:)` | Initializes from a hex integer (e.g., `0xFF0000`) |
| `Color(hex: String?, defaultColor:, alpha:)` | Initializes from a hex string (`"#RGB"`, `"#RRGGBB"`, `"#RRGGBBAA"`) |
| `.hexString` / `.hexStringWithAlpha` | Converts back to a hex string |
| `.isDark` | Detects whether the color is perceived as dark |
| `.lighterGray` / `.borderedViewColor` | Convenience static colors |

### 📐 View

| Extension | Description |
|---|---|
| `.flipped(_:)` | Flips a view horizontally or vertically |
| `.withoutAnimation(action:)` | Executes a state change with animations disabled |
| `.border(width:edges:color:)` | Applies a border to specific edges only |
| `.border(width:axis:color:)` | Applies a border along a horizontal or vertical axis |
| `.onSizeChange(closure:)` | Observes view size changes via `GeometryReader` and `PreferenceKey` |
| `.onScrollOffsetChange(closure:)` | Tracks horizontal scroll offset |

### 📜 ScrollableContent

A protocol that provides a type-safe `scrollToTopViewID` string, ready to use with `ScrollViewReader`.

```swift
struct MyView: View, ScrollableContent {
    // scrollToTopViewID is automatically provided
}
```

### 🖼 PhotosPickerItem

| Extension | Description |
|---|---|
| `.photoPickerItemMedia` | Async property that loads the picked item as a `PhotosPickerItemMedia` |

### 📏 EdgeInsets

| Extension | Description |
|---|---|
| `.zero` | Convenience `EdgeInsets` with all values set to `0` |

---

## Architecture

### DomainModelable

A protocol for mapping data/DTO objects to domain models, aligned with Clean Architecture:

```swift
public protocol DomainModelable {
    associatedtype DomainModel: Sendable
    var domainModel: DomainModel { get }
    var essentialDomainModel: DomainModel { get } // defaults to domainModel
}
```

### Observation

`makeObservationTask(of:fireImmediately:onChangeAsync:)` creates a self-rearming `@MainActor` `Task` that re-fires on every `@Observable` property change — a clean alternative to manual `withObservationTracking` loops.

```swift
let task = makeObservationTask(of: { viewModel.items }) { newItems in
    await updateUI(with: newItems)
}
// Cancel when done
task.cancel()
```

### Localization

A top-level `localized(_:comment:args:bundle:)` function wraps `NSLocalizedString` with variadic argument support:

```swift
let message = localized("welcome.message", args: userName)
```

---

## License

MIT
