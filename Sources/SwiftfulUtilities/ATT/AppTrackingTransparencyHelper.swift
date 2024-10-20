//
//  asdf.swift
//  SwiftfulUtilities
//
//  Created by Nick Sarno on 10/20/24.
//
import Foundation
import SwiftUI
import AppTrackingTransparency

public final class AppTrackingTransparencyHelper {

    public static func requestTrackingAuthorization() async -> ATTrackingManager.AuthorizationStatus {
        await ATTrackingManager.requestTrackingAuthorization()
    }

}

public extension ATTrackingManager.AuthorizationStatus {

    var eventParameters: [String: Any] {
        [
            "att_status": stringValue,
            "att_status_code": rawValue
        ]
    }

    var stringValue: String {
        switch self {
        case .notDetermined:
            return "not_determined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorized:
            return "authorized"
        default:
            return "unknown"
        }
    }
}
