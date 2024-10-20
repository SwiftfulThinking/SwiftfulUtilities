//
//  Untitled.swift
//  SwiftfulUtilities
//
//  Created by Nick Sarno on 10/20/24.
//
import Foundation
import UIKit
import UserNotifications
import CoreLocation

public final class LocalNotifications {

    private static var instance: UNUserNotificationCenter {
        UNUserNotificationCenter.current()
    }

    /// Requests the user’s authorization to allow local and remote notifications for your app.
    @discardableResult
    public static func requestAuthorization(options: UNAuthorizationOptions = [.alert, .sound, .badge]) async throws -> Bool {
        try await instance.requestAuthorization(options: options)
    }

    public static func canRequestAuthorization() async -> Bool {
        let status = try? await getNotificationStatus()
        return status == .notDetermined
    }

    /// Retrieves the notification authorization settings for your app.
    ///
    /// - .authorized = User previously granted permission for notifications
    /// - .denied = User previously denied permission for notifications
    /// - .notDetermined = Notification permission hasn't been asked yet.
    /// - .provisional = The application is authorized to post non-interruptive user notifications (iOS 12.0+)
    /// - .ephemeral = The application is temporarily authorized to post notifications - available to App Clips only (iOS 14.0+)
    ///
    /// - Returns: User's authorization status
    public static func getNotificationStatus() async throws -> UNAuthorizationStatus {
        return await withCheckedContinuation({ continutation in
            instance.getNotificationSettings { settings in
                continutation.resume(returning: settings.authorizationStatus)
                return
            }
        })
    }

    /// Set the number as the badge of the app icon on the Home screen.
    ///
    /// Set to 0 (zero) to hide the badge number. The default value of this property is 0.
    public static func setApplcationIconBadgeNumber(to int: Int) {
        instance.setBadgeCount(int)
    }

    /// Open the Settings App on user's device.
    ///
    /// If user has previously denied notification authorization, the OS prompt will not appear again. The user will need to manually turn notifications in Settings.
    @MainActor
    public static func openAppSettings() throws {
        guard let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) else {
            throw URLError(.badURL)
        }
        UIApplication.shared.open(url)
    }

    /// Schedule a local notification
    public static func scheduleNotification(content: AnyNotificationContent, trigger: NotificationTriggerOption) async throws {
        try await scheduleNotification(
            id: content.id,
            title: content.title,
            body: content.body,
            sound: content.sound,
            badge: content.badge,
            trigger: trigger)
    }

    /// Schedule a local notification
    public static func scheduleNotification(id: String = UUID().uuidString, title: String, body: String? = nil, sound: Bool = true, badge: Int? = nil, trigger: NotificationTriggerOption) async throws {
        let notificationContent = getNotificationContent(title: title, body: body, sound: sound, badge: badge)
        let notificationTrigger = getNotificationTrigger(option: trigger)
        try await addNotification(identifier: id, content: notificationContent, trigger: notificationTrigger)
    }

    /// Cancel all pending notifications (notifications that are in the queue and have not yet triggered)
    public static func removeAllPendingNotifications() {
        instance.removeAllPendingNotificationRequests()
    }

    /// Remove all delivered notifications (notifications that have previously triggered)
    public static func removeAllDeliveredNotifications() {
        instance.removeAllDeliveredNotifications()
    }

    /// Remove notifications by ID
    ///
    /// - Parameters:
    ///   - ids: ID associated with scheduled notification.
    ///   - pending: Cancel pending notifications (notifications that are in the queue and have not yet triggered)
    ///   - delivered: Remove delivered notifications (notifications that have previously triggered)
    public static func removeNotifications(ids: [String], pending: Bool = true, delivered: Bool = true) {
        if pending {
            instance.removePendingNotificationRequests(withIdentifiers: ids)
        }
        if delivered {
            instance.removeDeliveredNotifications(withIdentifiers: ids)
        }
    }

}

// MARK: PRIVATE

private extension LocalNotifications {

    private static func getNotificationContent(title: String, body: String?, sound: Bool, badge: Int?) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        if let body {
            content.body = body
        }
        if sound {
            content.sound = .default
        }
        if let badge {
            content.badge = badge as NSNumber
        }
        return content
    }

    private static func getNotificationTrigger(option: NotificationTriggerOption) -> UNNotificationTrigger {
        switch option {
        case .date(date: let date, repeats: let repeats):
            let components = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: date)
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        case .time(timeInterval: let timeInterval, repeats: let repeats):
            return UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: repeats)

        #if !targetEnvironment(macCatalyst)
        case .location(coordinates: let coordinates, radius: let radius, notifyOnEntry: let notifyOnEntry, notifyOnExit: let notifyOnExit, repeats: let repeats):
            let region = CLCircularRegion(center: coordinates, radius: radius, identifier: UUID().uuidString)
            region.notifyOnEntry = notifyOnEntry
            region.notifyOnExit = notifyOnExit
            return UNLocationNotificationTrigger(region: region, repeats: repeats)
        #endif
        }
    }

    private static func addNotification(identifier: String?, content: UNNotificationContent, trigger: UNNotificationTrigger) async throws {
        let request = UNNotificationRequest(
            identifier: identifier ?? UUID().uuidString,
            content: content,
            trigger: trigger)

        try await instance.add(request)
    }

}
