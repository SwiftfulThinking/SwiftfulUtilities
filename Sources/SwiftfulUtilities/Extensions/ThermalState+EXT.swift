//
//  ThermalState+EXT.swift
//  SwiftfulUtilities
//
//  Created by Nick Sarno on 10/9/24.
//
import UIKit

public extension ProcessInfo.ThermalState {
    var stringValue: String {
        switch self {
        case .nominal:
            return "nominal"
        case .fair:
            return "fair"
        case .serious:
            return "serious"
        case .critical:
            return "critical"
        default:
            return "unknown"
        }
    }
}
