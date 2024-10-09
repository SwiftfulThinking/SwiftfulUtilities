//
//  BatteryState+EXT.swift
//  SwiftfulUtilities
//
//  Created by Nick Sarno on 10/9/24.
//
import UIKit

public extension UIDevice.BatteryState {
    var stringValue: String {
        switch self {
        case .unplugged:
            return "unplugged"
        case .charging:
            return "charging"
        case .full:
            return "full"
        default:
            return "unknown"
        }
    }
}
