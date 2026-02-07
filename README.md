# SwiftfulUtilities 🦾

A collection of utilities for iOS and macOS apps. Provides easy access to device info, app metadata, locale settings, local notifications, calendar events, ATT prompts, and App Store ratings.

## Features

- **Device & app info** via static properties on `Utilities`
- **Bulk export** all device/app parameters as a dictionary for analytics
- **Local push notifications** with date, time, and location triggers
- **Calendar events & reminders** via EventKit
- **App Tracking Transparency** prompt wrapper
- **App Store ratings** with last-request tracking

## Setup

<details>
<summary> Details (Click to expand) </summary>
<br>

Add SwiftfulUtilities to your project.

```
https://github.com/SwiftfulThinking/SwiftfulUtilities.git
```

Import the package.

```swift
import SwiftfulUtilities
```

Create a typealias for convenience.

```swift
typealias Utilities = SwiftfulUtilities.Utilities
```

</details>

## Utilities

<details>
<summary> Details (Click to expand) </summary>
<br>

All properties are `static` on the `@MainActor` `Utilities` struct.

### Bundle.main

```swift
Utilities.appVersion           // "1.0.0"
Utilities.buildNumber          // "3"
Utilities.appName              // "MyApp"
Utilities.bundleIdentifier     // "com.organization.MyApp"
Utilities.appDisplayName       // "My App"
Utilities.minimumOSVersion     // "17.0"
Utilities.appExecutable        // "MyApp"
Utilities.appDevelopmentRegion // "en"
Utilities.appSupportedPlatforms // ["iPhoneOS"]
Utilities.appInfoDictionaryVersion // "6.0"
Utilities.appIconFiles         // [String]?
```

### UIDevice.current

```swift
Utilities.isiPad               // Bool
Utilities.isiPhone             // Bool
Utilities.deviceName           // "Nick's iPhone"
Utilities.systemName           // "iOS"
Utilities.systemVersion        // "17.0"
Utilities.model                // "iPhone"
Utilities.localizedModel       // "iPhone"
Utilities.identifierForVendor  // UUID string (IDFV)
Utilities.batteryLevel         // Double
Utilities.batteryState         // .charging, .full, .unplugged
Utilities.deviceOrientation    // .portrait, .landscapeLeft, etc.
Utilities.isPortrait           // Bool
Utilities.isLandscape          // Bool
```

### UIScreen.main

```swift
Utilities.isSmallerVerticalHeight // Bool (height < 800px)
Utilities.screenWidth          // CGFloat
Utilities.screenHeight         // CGFloat
Utilities.screenScale          // CGFloat
```

### ProcessInfo.processInfo

```swift
Utilities.isXcodePreview       // Bool
Utilities.isUITesting          // Bool
Utilities.isUnitTesting        // Bool
Utilities.processName          // String
Utilities.processIdentifier    // Int
Utilities.launchEnvironmentVariables // [String: String]
Utilities.launchArguments      // [String]
Utilities.isLowPowerModeEnabled // Bool
Utilities.thermalState         // .nominal, .fair, .serious, .critical
Utilities.physicalMemory       // Int (bytes)
Utilities.physicalMemoryInGB   // Double
Utilities.systemUptime         // Double (seconds)
Utilities.systemUptimeInDays   // Double
Utilities.isMacCatalystApp     // Bool
Utilities.isiOSAppOnMac        // Bool
```

### Locale.current

```swift
Utilities.userCountry          // "US"
Utilities.userLanguage         // "en"
Utilities.userCurrencyCode     // "USD"
Utilities.userCurrencySymbol   // "$"
Utilities.measurementSystem    // .us, .uk, .metric
Utilities.userTimeZone         // "America/New_York"
Utilities.userCalendar         // "gregorian"
Utilities.collationIdentifier  // String
```

### Other

```swift
Utilities.modelIdentifier      // "iPhone12,1" or "arm64"
Utilities.hasNotch             // Bool
Utilities.isTestFlight         // Bool
Utilities.isDebug              // Bool
Utilities.isDevUser            // Bool (debug or testflight)
Utilities.isProdUser           // Bool (app store)
Utilities.userType             // .debug, .testFlight, .appStore
```

### Bulk Export

```swift
let dict = Utilities.eventParameters
// All properties as [String: Any] prefixed with "utility_"
```

</details>

## App Tracking Transparency

<details>
<summary> Details (Click to expand) </summary>
<br>

```swift
let status = await AppTrackingTransparencyHelper.requestTrackingAuthorization()
let dict = status.eventParameters
// ["att_status": "authorized", "att_status_code": 3]
```

</details>

## Local Notifications

<details>
<summary> Details (Click to expand) </summary>
<br>

### Authorization

```swift
// Check if can request
await LocalNotifications.canRequestAuthorization()

// Request authorization
let isAuthorized = try await LocalNotifications.requestAuthorization()

// Check current status
let status = try await LocalNotifications.getNotificationStatus()

// Open Settings (if previously denied)
try LocalNotifications.openAppSettings()
```

### Schedule

```swift
// Using AnyNotificationContent
let content = AnyNotificationContent(
    id: "reminder-1",
    title: "Time to practice!",
    body: "Your daily lesson is ready.",
    sound: true,
    badge: 1
)

// Trigger by date
let trigger = NotificationTriggerOption.date(date: date, repeats: false)

// Trigger by time interval
let trigger = NotificationTriggerOption.time(timeInterval: 3600, repeats: false)

// Trigger by location
let trigger = NotificationTriggerOption.location(
    coordinates: coordinates,
    radius: 100,
    notifyOnEntry: true,
    notifyOnExit: false,
    repeats: false
)

try await LocalNotifications.scheduleNotification(content: content, trigger: trigger)
```

### Cancel

```swift
LocalNotifications.removeAllPendingNotifications()
LocalNotifications.removeAllDeliveredNotifications()
LocalNotifications.removeNotifications(ids: ["reminder-1"])
```

### Badge

```swift
LocalNotifications.setApplicationIconBadgeNumber(to: 3)
LocalNotifications.setApplicationIconBadgeNumber(to: 0) // hide badge
```

</details>

## Calendar Events

<details>
<summary> Details (Click to expand) </summary>
<br>

Requires Info.plist: `Privacy - Calendars Usage Description`

### Authorization

```swift
let status = EventKitHelper.getCalendarAccessStatus()
let isAuthorized = try await EventKitHelper.requestAccessToCalendar()
```

### Add / Modify / Remove

```swift
// Add event
let eventId = try EventKitHelper.addEventToCalendar(
    title: "Team Meeting",
    description: "Weekly sync",
    startDate: date,
    eventDuration: .hours(1),
    alarms: [.minutesBeforeEvent(15)],
    recurring: .weekly(occurrenceCount: 12, interval: 1)
)

// Modify event
try EventKitHelper.modifyEventInCalendar(
    eventId: eventId,
    newTitle: "Updated Meeting"
)

// Remove event
try EventKitHelper.removeEventFromCalendar(eventId: eventId)
```

### Duration Options

```swift
EventDurationOption.hours(1)
EventDurationOption.minutes(30)
EventDurationOption.days(2)
EventDurationOption.allDay
```

### Alarm Options

```swift
EventAlarmOption.minutesBeforeEvent(15)
EventAlarmOption.hoursBeforeEvent(1)
EventAlarmOption.daysBeforeEvent(1)
```

### Recurrence Rules

```swift
EventRecurrenceRule.never
EventRecurrenceRule.daily(occurrenceCount: 30, interval: 1)
EventRecurrenceRule.weekly(occurrenceCount: 12, interval: 1)    // weekly
EventRecurrenceRule.weekly(occurrenceCount: 12, interval: 2)    // bi-weekly
EventRecurrenceRule.monthly(occurrenceCount: 6, interval: 1)
EventRecurrenceRule.yearly(occurrenceCount: 3, interval: 1)
```

</details>

## Reminders

<details>
<summary> Details (Click to expand) </summary>
<br>

Requires Info.plist: `Privacy - Reminders Usage Description`

### Authorization

```swift
let status = EventKitHelper.getRemindersAccessStatus()
let isAuthorized = try await EventKitHelper.requestAccessToReminders()
```

### Add / Modify / Remove

```swift
// Add reminder
let reminderId = try EventKitHelper.addReminder(
    title: "Buy groceries",
    notes: "Milk, eggs, bread",
    dueDate: date,
    alarms: [.hoursBeforeEvent(1)]
)

// Modify reminder
try EventKitHelper.modifyReminder(
    reminderId: reminderId,
    newTitle: "Buy groceries and snacks"
)

// Remove reminder
try EventKitHelper.removeReminder(reminderId: reminderId)
```

</details>

## App Store Ratings

<details>
<summary> Details (Click to expand) </summary>
<br>

```swift
// Request review prompt
AppStoreRatingsHelper.requestRatingsReview()

// Check when last requested
let lastDate = AppStoreRatingsHelper.lastRatingsRequestReviewDate
```

The last request date is persisted in UserDefaults automatically.

</details>

## Claude Code

This package includes a `.claude/swiftful-utilities-rules.md` with usage guidelines and integration patterns for projects using [Claude Code](https://claude.ai/claude-code).

## Platform Support

- **iOS 16.0+**
- **macOS 12.0+**

## License

SwiftfulUtilities is available under the MIT license.
