# SwiftfulUtilities

Collection of iOS/macOS utilities: device info, local notifications, calendar events, ATT, App Store ratings. All via static methods on helper classes.

## Utilities

`Utilities` is a `@MainActor` struct with static properties. Use `typealias Utilities = SwiftfulUtilities.Utilities` for convenience.

### Commonly Used Properties

```swift
// App info
Utilities.appVersion           // "1.0.0"
Utilities.buildNumber          // "3"
Utilities.bundleIdentifier     // "com.organization.MyApp"

// Device
Utilities.isiPhone             // Bool
Utilities.isiPad               // Bool
Utilities.systemVersion        // "17.0"
Utilities.identifierForVendor  // IDFV string
Utilities.modelIdentifier      // "iPhone12,1"
Utilities.hasNotch             // Bool

// Screen
Utilities.screenWidth          // CGFloat
Utilities.screenHeight         // CGFloat
Utilities.isSmallerVerticalHeight // Bool (height < 800px)

// Environment
Utilities.isDebug              // Bool
Utilities.isTestFlight         // Bool
Utilities.isDevUser            // Bool (debug or testflight)
Utilities.isProdUser           // Bool (app store)
Utilities.userType             // .debug, .testFlight, .appStore
Utilities.isXcodePreview       // Bool
Utilities.isUITesting          // Bool

// Locale
Utilities.userCountry          // "US"
Utilities.userLanguage         // "en"
Utilities.userCurrencyCode     // "USD"
Utilities.measurementSystem    // .us, .uk, .metric
Utilities.userTimeZone         // "America/New_York"
```

### Bulk Export for Analytics

```swift
let dict = Utilities.eventParameters
// All properties as [String: Any] prefixed with "utility_"
```

Use `eventParameters` to log device context with analytics events. Call once on app launch or session start.

## App Tracking Transparency

```swift
let status = await AppTrackingTransparencyHelper.requestTrackingAuthorization()
let dict = status.eventParameters
```

Call ATT prompt early in the onboarding flow, after explaining why tracking helps. Do NOT call on first launch without context.

## Local Notifications

### Authorization

```swift
await LocalNotifications.canRequestAuthorization()
let isAuthorized = try await LocalNotifications.requestAuthorization()
```

### Schedule

```swift
let content = AnyNotificationContent(
    id: "reminder-1",
    title: "Time to practice!",
    body: "Your daily lesson is ready.",
    sound: true,
    badge: 1
)

let trigger = NotificationTriggerOption.date(date: date, repeats: false)
let trigger = NotificationTriggerOption.time(timeInterval: 3600, repeats: false)
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
LocalNotifications.setApplicationIconBadgeNumber(to: 0) // hide
```

## Calendar Events

Requires Info.plist: `Privacy - Calendars Usage Description`

```swift
// Authorization
let status = EventKitHelper.getCalendarAccessStatus()
let isAuthorized = try await EventKitHelper.requestAccessToCalendar()

// Add event
let eventId = try EventKitHelper.addEventToCalendar(
    title: "Team Meeting",
    startDate: date,
    eventDuration: .hours(1),
    alarms: [.minutesBeforeEvent(15)],
    recurring: .weekly(occurrenceCount: 12, interval: 1)
)

// Modify
try EventKitHelper.modifyEventInCalendar(eventId: eventId, newTitle: "Updated")

// Remove
try EventKitHelper.removeEventFromCalendar(eventId: eventId)
```

### Supporting Types

```swift
// Duration
EventDurationOption.hours(1)
EventDurationOption.minutes(30)
EventDurationOption.days(2)
EventDurationOption.allDay

// Alarms
EventAlarmOption.minutesBeforeEvent(15)
EventAlarmOption.hoursBeforeEvent(1)
EventAlarmOption.daysBeforeEvent(1)

// Recurrence
EventRecurrenceRule.never
EventRecurrenceRule.daily(occurrenceCount: 30, interval: 1)
EventRecurrenceRule.weekly(occurrenceCount: 12, interval: 1)
EventRecurrenceRule.monthly(occurrenceCount: 6, interval: 1)
EventRecurrenceRule.yearly(occurrenceCount: 3, interval: 1)
```

## Reminders

Requires Info.plist: `Privacy - Reminders Usage Description`

```swift
// Authorization
let status = EventKitHelper.getRemindersAccessStatus()
let isAuthorized = try await EventKitHelper.requestAccessToReminders()

// Add
let reminderId = try EventKitHelper.addReminder(
    title: "Buy groceries",
    dueDate: date,
    alarms: [.hoursBeforeEvent(1)]
)

// Modify
try EventKitHelper.modifyReminder(reminderId: reminderId, newTitle: "Updated")

// Remove
try EventKitHelper.removeReminder(reminderId: reminderId)
```

## App Store Ratings

```swift
AppStoreRatingsHelper.requestRatingsReview()
let lastDate = AppStoreRatingsHelper.lastRatingsRequestReviewDate
```

The last request date is persisted in UserDefaults automatically. Use this to throttle requests — Apple may ignore frequent calls.

## VIPER Integration

In a VIPER architecture, utilities are accessed directly (no interactor wrapper needed) since they are static and read-only:

```swift
// View or Presenter — access directly
let version = Utilities.appVersion
let params = Utilities.eventParameters

// Interactor — for actions that require authorization
func requestNotificationPermission() async throws -> Bool {
    try await LocalNotifications.requestAuthorization()
}

func requestTrackingPermission() async -> ATTrackingManager.AuthorizationStatus {
    await AppTrackingTransparencyHelper.requestTrackingAuthorization()
}
```
