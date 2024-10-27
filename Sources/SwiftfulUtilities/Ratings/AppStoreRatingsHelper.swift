//
//  AppStoreRatingsHelper.swift
//  SwiftfulUtilities
//
//  Created by Nick Sarno on 10/27/24.
//
import Foundation
import SwiftUI
import StoreKit

@MainActor
public final class AppStoreRatingsHelper {
    
    /// The last time the ratings was requested. Default value is .distantPast.
    static var lastRatingsRequestReviewDate: Date = UserDefaults.lastRatingsRequest

    static func requestRatingsReview() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        if #available(iOS 18.0, *) {
            AppStore.requestReview(in: scene)
        } else {
            SKStoreReviewController.requestReview(in: scene)
        }
        
        lastRatingsRequestReviewDate = .now
    }

}

private extension UserDefaults {
    
    static let lastRequestKey = "last_ratings_request_date"
    
    /// Retrieves or saves the date of the last rating request
    static var lastRatingsRequest: Date {
        get {
            standard.object(forKey: lastRequestKey) as? Date ?? .distantPast
        }
        set {
            standard.set(newValue, forKey: lastRequestKey)
        }
    }
}
