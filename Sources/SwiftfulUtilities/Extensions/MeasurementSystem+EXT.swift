//
//  MeasurementSystem+EXT.swift
//  SwiftfulUtilities
//
//  Created by Nick Sarno on 10/9/24.
//
import UIKit

public extension Locale.MeasurementSystem {
    var stringValue: String {
        switch self {
        case .us:
            return "us"
        case .uk:
            return "uk"
        case .metric:
            return "metric"
        default:
            return "unknown"
        }
    }
}
