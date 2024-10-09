<p align="left">
    <img src="https://github.com/user-attachments/assets/164ba12b-1124-4a67-9a36-4e2a75b58293" alt="Swift Utilities" width="300px" />
</p>

# Utilities for Swift projects 🦾

A generic Utilities implementation to access values from `Bundle.main`, `UIDevice.current`, `UIScreen.main`, `ProcessInfo.processInfo` and `Locale.current`.

#### Import the file:

```swift
import SwiftfulUtilities

typealias Utilities = SwiftfulUtilities.Utilities
```

#### Access values:

```swift
let appVersion = Utilities.appVersion
let isPortrait = Utilities.isPortrait
let isDevUser = Utilities.isDevUser
let identifierForVendor = Utilities.identifierForVendor
// ...and many more!
```

View all accessible values: https://github.com/SwiftfulThinking/SwiftfulUtilities/blob/main/Sources/SwiftfulUtilities/Utilities.swift

#### Bulk export:

```swift
let dict = Utilities.eventParameters
print(dict)
```
