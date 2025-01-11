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

View all values: https://github.com/SwiftfulThinking/SwiftfulUtilities/blob/main/Sources/SwiftfulUtilities/Utilities/Utilities.swift

#### Bulk export:

```swift
let dict = Utilities.eventParameters
print(dict)
```

#### ATT Prompt:

```swift
let status = await AppTrackingTransparencyHelper.requestTrackingAuthorization()
let dict = status.eventParameters
```

#### Local Push Notifications:

```swift
// Check if can request push authorization
await LocalNotifications.canRequestAuthorization()

// Request push authorization
let isAuthorized = try await LocalNotifications.requestAuthorization()

// Schedule push notification
try await LocalNotifications.scheduleNotification(content: content, trigger: trigger)

// Customize notification content
let content = AnyNotificationContent(id: String, title: String, body: String?, sound: Bool, badge: Int?)

// Customize trigger option by date, time, or location
let trigger = NotificationTriggerOption.date(date: date, repeats: false)
let trigger = NotificationTriggerOption.time(timeInterval: timeInterval, repeats: false)
let trigger = NotificationTriggerOption.location(coordinates: coordinates, radius: radius, notifyOnEntry: true, notifyOnExit: false, repeats: false)

// Cancel outstanding push notifications
LocalNotifications.removeAllPendingNotifications()
LocalNotifications.removeAllDeliveredNotifications()
LocalNotifications.removeNotifications(ids: [String])
```

#### Calendar Events:

Add info.plist values:

`Privacy - Calendars Usage Description` : `We request access to the calendar to manage app events.`

```swift
// Check if can request calendar access
await EventKitHelper.getCalendarAccessStatus()

// Request calendar authorization
let isAuthorized = try await EventKitHelper.requestAccessToCalendar()

// Add calendar events
let eventId = try await EventKitHelper.addEventToCalendar(event)
try await EventKitHelper.modifyEventInCalendar(eventId: eventId, newTitle: "")
try await EventKitHelper.removeEventFromCalendar(eventId: eventId)
```

#### Reminders:

Add info.plist values:

`Privacy - Reminders Usage Description` : `We request access to the reminders to manage reminders.`

```swift
// Check if can request reminders access
await EventKitHelper.getRemindersAccessStatus()

// Request calendar authorization
let isAuthorized = try await EventKitHelper.requestAccessToReminders()

// Add calendar events
let reminderId = try await EventKitHelper.addReminder(reminder)
try await EventKitHelper.modifyReminder(reminderId: reminderId, newTitle: "")
try await EventKitHelper.removeReminder(reminderId: reminderId)
```
