//
//  NotificationTriggerOption.swift
//  SwiftfulUtilities
//
//  Created by Nick Sarno on 10/20/24.
//
import SwiftUI
import CoreLocation

public enum NotificationTriggerOption {
    case date(date: Date, repeats: Bool)
    case time(timeInterval: TimeInterval, repeats: Bool)

    @available(macCatalyst, unavailable, message: "Location-based notifications are not available on Mac Catalyst.")
    case location(coordinates: CLLocationCoordinate2D, radius: CLLocationDistance, notifyOnEntry: Bool, notifyOnExit: Bool, repeats: Bool)
}
