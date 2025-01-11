//
//  EventKitHelper.swift
//  SwiftfulUtilities
//
//  Created by Nick Sarno on 1/11/25.
//
import Foundation
import EventKit

public final class EventKitHelper {
    
    @MainActor
    private static let eventStore = EKEventStore()
    
    // MARK: EVENTS
    
    /// Returns the current authorization status for accessing the user's calendar.
    ///
    /// - Returns: The current authorization status (`EKAuthorizationStatus`) for calendar events.
    @MainActor
    public static func getCalendarAccessStatus() -> EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }
    
    /// Requests access to the user's calendar.
    ///
    /// - Returns: A Boolean value indicating whether access to the calendar was granted.
    /// - Throws: An error if the access request fails.
    @MainActor
    public static func requestAccessToCalendar() async throws -> Bool {
        if #available(iOS 17, *) {
            return try await eventStore.requestFullAccessToEvents()
        } else {
            return try await eventStore.requestAccess(to: .event)
        }
    }
        
    /// Adds a new event to the user's calendar.
    ///
    /// - Parameters:
    ///   - title: The title of the event.
    ///   - description: An optional description of the event.
    ///   - url: An optional URL associated with the event.
    ///   - startDate: The start date and time of the event.
    ///   - eventDuration: The duration of the event, specified using `EventDurationOption`.
    ///   - alarms: An optional array of alarms to trigger before the event, specified using `EventAlermOption`.
    ///   - recurring: The recurrence rule for the event, specified using `EventRecurrenceRule`. Defaults to `.never`.
    ///     - **Example for "weekly" events**: Use `.weekly(weeks: 6, interval: 1)` to create events that occur every week for a total of 6 occurrences.
    ///     - **Example for "bi-weekly" events**: Use `.weekly(weeks: 6, interval: 2)` to create events that occur every two weeks for a total of 6 occurrences.
    /// - Returns: The unique identifier for the event created in the calendar. Use this if you need to cancel or modify the event later.
    /// - Throws: An error if the event cannot be created or saved to the calendar.
    @MainActor
    public static func addEventToCalendar(
        title: String,
        description: String? = nil,
        url: URL? = nil,
        startDate: Date,
        eventDuration: EventDurationOption,
        alarms: [EventAlermOption]? = nil,
        recurring: EventRecurrenceRule = .never
    ) throws -> String {
        guard Thread.isMainThread else {
            throw EventKitError.notOnMainActor
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.title = title
        event.notes = description
        event.url = url
        event.startDate = startDate
        
        switch eventDuration {
        case .hours(let count):
            event.endDate = Calendar.current.date(byAdding: .hour, value: count, to: startDate)
        case .minutes(let count):
            event.endDate = Calendar.current.date(byAdding: .minute, value: count, to: startDate)
        case .days(let count):
            event.endDate = Calendar.current.date(byAdding: .day, value: count, to: startDate)
        case .allDay:
            event.isAllDay = true
            event.endDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
        }
        
        if let alarms = alarms, !alarms.isEmpty {
            event.alarms = alarms.map { alarmOption in
                switch alarmOption {
                case .minutesBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 60))
                case .hoursBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 60 * 60))
                case .daysBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 24 * 60 * 60))
                }
            }
        }
        
        switch recurring {
        case .never:
            break
        case .daily(let occurrenceCount, let interval):
            let recurrenceRule = EKRecurrenceRule(recurrenceWith: .daily, interval: interval, end: EKRecurrenceEnd(occurrenceCount: occurrenceCount))
            event.addRecurrenceRule(recurrenceRule)
        case .weekly(let occurrenceCount, let interval):
            let recurrenceRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: interval, end: EKRecurrenceEnd(occurrenceCount: occurrenceCount))
            event.addRecurrenceRule(recurrenceRule)
        case .monthly(let occurrenceCount, let interval):
            let recurrenceRule = EKRecurrenceRule(recurrenceWith: .monthly, interval: interval, end: EKRecurrenceEnd(occurrenceCount: occurrenceCount))
            event.addRecurrenceRule(recurrenceRule)
        case .yearly(let occurrenceCount, let interval):
            let recurrenceRule = EKRecurrenceRule(recurrenceWith: .yearly, interval: interval, end: EKRecurrenceEnd(occurrenceCount: occurrenceCount))
            event.addRecurrenceRule(recurrenceRule)
        }
        
        try eventStore.save(event, span: .futureEvents, commit: true)
        return event.eventIdentifier
    }
    
    /// Modifies an existing event in the user's calendar.
    ///
    /// - Parameters:
    ///   - eventId: The unique identifier of the event to modify.
    ///   - newTitle: An optional new title for the event. If `nil`, the title remains unchanged.
    ///   - newDescription: An optional new description for the event. If `nil`, the description remains unchanged.
    ///   - newUrl: An optional new URL associated with the event. If `nil`, the URL remains unchanged.
    ///   - newStartDate: An optional new start date for the event. If `nil`, the start date remains unchanged.
    ///   - newEventDuration: An optional new duration for the event, specified using `EventDurationOption`. If `nil`, the duration remains unchanged.
    ///   - newAlarms: An optional array of new alarms to set for the event, specified using `EventAlermOption`. If `nil`, alarms remain unchanged.
    ///   - newRecurring: An optional new recurrence rule for the event, specified using `EventRecurrenceRule`. If `nil`, the recurrence rules remain unchanged.
    ///     - **Example for "weekly recurrence"**: Use `.weekly(weeks: 6, interval: 1)` for an event that recurs weekly for 6 occurrences.
    ///     - **Example for "bi-weekly recurrence"**: Use `.weekly(weeks: 6, interval: 2)` for an event that recurs every two weeks for 6 occurrences.
    /// - Throws: An error if the event is not found or cannot be modified.
    @MainActor
    public static func modifyEventInCalendar(
        eventId: String,
        newTitle: String? = nil,
        newDescription: String? = nil,
        newUrl: URL? = nil,
        newStartDate: Date? = nil,
        newEventDuration: EventDurationOption? = nil,
        newAlarms: [EventAlermOption]? = nil,
        newRecurring: EventRecurrenceRule? = nil
    ) throws {
        // Fetch the existing event using its identifier
        guard let event = eventStore.event(withIdentifier: eventId) else {
            throw EventKitError.eventNotFound
        }
        
        // Modify event properties if new values are provided
        if let newTitle = newTitle {
            event.title = newTitle
        }
        if let newDescription = newDescription {
            event.notes = newDescription
        }
        if let newUrl = newUrl {
            event.url = newUrl
        }
        if let newStartDate = newStartDate {
            event.startDate = newStartDate
            
            // Update the end date if new duration is provided
            if let newEventDuration = newEventDuration {
                switch newEventDuration {
                case .hours(let count):
                    event.endDate = Calendar.current.date(byAdding: .hour, value: count, to: newStartDate)
                case .minutes(let count):
                    event.endDate = Calendar.current.date(byAdding: .minute, value: count, to: newStartDate)
                case .days(let count):
                    event.endDate = Calendar.current.date(byAdding: .day, value: count, to: newStartDate)
                case .allDay:
                    event.isAllDay = true
                    event.endDate = Calendar.current.date(byAdding: .day, value: 1, to: newStartDate)
                }
            }
        }
        
        // Update alarms if provided
        if let newAlarms = newAlarms {
            event.alarms = newAlarms.map { alarmOption in
                switch alarmOption {
                case .minutesBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 60))
                case .hoursBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 60 * 60))
                case .daysBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 24 * 60 * 60))
                }
            }
        }
        
        // Update recurrence rule if provided
        if let newRecurring = newRecurring {
            event.recurrenceRules = nil // Remove existing recurrence rules
            switch newRecurring {
            case .never:
                break
            case .daily(let days, let interval):
                let recurrenceRule = EKRecurrenceRule(recurrenceWith: .daily, interval: interval, end: EKRecurrenceEnd(occurrenceCount: days))
                event.addRecurrenceRule(recurrenceRule)
            case .weekly(let weeks, let interval):
                let recurrenceRule = EKRecurrenceRule(recurrenceWith: .weekly, interval: interval, end: EKRecurrenceEnd(occurrenceCount: weeks))
                event.addRecurrenceRule(recurrenceRule)
            case .monthly(let months, let interval):
                let recurrenceRule = EKRecurrenceRule(recurrenceWith: .monthly, interval: interval, end: EKRecurrenceEnd(occurrenceCount: months))
                event.addRecurrenceRule(recurrenceRule)
            case .yearly(let years, let interval):
                let recurrenceRule = EKRecurrenceRule(recurrenceWith: .yearly, interval: interval, end: EKRecurrenceEnd(occurrenceCount: years))
                event.addRecurrenceRule(recurrenceRule)
            }
        }
        
        try eventStore.save(event, span: .futureEvents, commit: true)
    }
    
    /// Removes an event from the user's calendar using its unique identifier.
    ///
    /// - Parameter eventId: The unique identifier of the event to remove.
    /// - Throws: An error if the event cannot be found or removed.
    @MainActor
    public static func removeEventFromCalendar(eventId: String) throws {
        guard let event = eventStore.event(withIdentifier: eventId) else {
            throw EventKitError.eventNotFound
        }
        
        try eventStore.remove(event, span: .futureEvents, commit: true)
    }
    
    public enum EventKitError: Error {
        case notOnMainActor, eventNotFound
    }
    
    public enum EventDurationOption {
        case hours(_ count: Int)
        case minutes(_ count: Int)
        case days(_ count: Int)
        case allDay
    }
    
    public enum EventAlermOption {
        case minutesBeforeEvent(_ count: Int)
        case hoursBeforeEvent(_ count: Int)
        case daysBeforeEvent(_ count: Int)
    }
    
    public enum EventRecurrenceRule {
        case never
        case daily(occurrenceCount: Int, interval: Int = 1)
        case weekly(occurrenceCount: Int, interval: Int = 1)
        case monthly(occurrenceCount: Int, interval: Int = 1)
        case yearly(occurrenceCount: Int, interval: Int = 1)
    }
    
    // MARK: REMINDERS

    /// Returns the current authorization status for accessing the user's reminders.
    ///
    /// - Returns: The current authorization status (`EKAuthorizationStatus`) for reminder events.
    @MainActor
    public static func getRemindersAccessStatus() -> EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .reminder)
    }

    /// Requests access to the user's reminders.
    ///
    /// - Returns: A Boolean value indicating whether access to reminders was granted.
    /// - Throws: An error if the access request fails.
    @MainActor
    public static func requestAccessToReminders() async throws -> Bool {
        if #available(iOS 17, *) {
            return try await eventStore.requestFullAccessToReminders()
        } else {
            return try await eventStore.requestAccess(to: .reminder)
        }
    }

    /// Adds a new reminder to the user's reminders list.
    ///
    /// - Parameters:
    ///   - title: The title of the reminder.
    ///   - notes: An optional note associated with the reminder.
    ///   - dueDate: An optional due date for the reminder.
    ///   - alarms: An optional array of alarms for the reminder, specified using `EventAlermOption`.
    ///   - url: An optional URL associated with the reminder.
    /// - Returns: The unique identifier for the reminder created.
    /// - Throws: An error if the reminder cannot be created or saved.
    @MainActor
    public static func addReminder(
        title: String,
        notes: String? = nil,
        dueDate: Date? = nil,
        alarms: [EventAlermOption]? = nil,
        url: URL? = nil
    ) throws -> String {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = title
        reminder.notes = notes
        reminder.url = url
        
        if let dueDate = dueDate {
            reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        }
        
        if let alarms = alarms, !alarms.isEmpty {
            reminder.alarms = alarms.map { alarmOption in
                switch alarmOption {
                case .minutesBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 60))
                case .hoursBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 60 * 60))
                case .daysBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 24 * 60 * 60))
                }
            }
        }
        
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        
        try eventStore.save(reminder, commit: true)
        return reminder.calendarItemIdentifier
    }

    /// Modifies an existing reminder.
    ///
    /// - Parameters:
    ///   - reminderId: The unique identifier of the reminder to modify.
    ///   - newTitle: An optional new title for the reminder.
    ///   - newNotes: An optional new note for the reminder.
    ///   - newDueDate: An optional new due date for the reminder.
    ///   - newAlarms: An optional array of new alarms for the reminder.
    ///   - newUrl: An optional new URL associated with the reminder.
    /// - Throws:
    ///   - `EventKitError.eventNotFound` if the reminder cannot be found.
    ///   - `EventKitError.failedToModifyEvent` if the reminder cannot be modified.
    @MainActor
    public static func modifyReminder(
        reminderId: String,
        newTitle: String? = nil,
        newNotes: String? = nil,
        newDueDate: Date? = nil,
        newAlarms: [EventAlermOption]? = nil,
        newUrl: URL? = nil
    ) throws {
        guard let reminder = eventStore.calendarItem(withIdentifier: reminderId) as? EKReminder else {
            throw EventKitError.eventNotFound
        }
        
        if let newTitle = newTitle {
            reminder.title = newTitle
        }
        if let newNotes = newNotes {
            reminder.notes = newNotes
        }
        if let newDueDate = newDueDate {
            reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: newDueDate)
        }
        if let newAlarms = newAlarms {
            reminder.alarms = newAlarms.map { alarmOption in
                switch alarmOption {
                case .minutesBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 60))
                case .hoursBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 60 * 60))
                case .daysBeforeEvent(let count):
                    return EKAlarm(relativeOffset: TimeInterval(-count * 24 * 60 * 60))
                }
            }
        }
        if let newUrl = newUrl {
            reminder.url = newUrl
        }
        
        try eventStore.save(reminder, commit: true)
    }

    /// Removes a reminder from the user's reminders list.
    ///
    /// - Parameter reminderId: The unique identifier of the reminder to remove.
    /// - Throws:
    ///   - `EventKitError.eventNotFound` if the reminder cannot be found.
    ///   - `EventKitError.failedToModifyEvent` if the reminder cannot be removed.
    @MainActor
    public static func removeReminder(reminderId: String) throws {
        guard let reminder = eventStore.calendarItem(withIdentifier: reminderId) as? EKReminder else {
            throw EventKitError.eventNotFound
        }
        
        try eventStore.remove(reminder, commit: true)
    }
}
