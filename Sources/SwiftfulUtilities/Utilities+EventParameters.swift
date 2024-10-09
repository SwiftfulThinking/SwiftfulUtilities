//
//  Utilities+EventParameters.swift
//  SwiftfulUtilities
//
//  Created by Nick Sarno on 10/9/24.
//

extension Utilities {
    
    /// A dictionary of various app and device parameters.
    public static var eventParameters: [String: Any] {
        let dict: [String: Any?] = [
            "utility_app_version": appVersion ?? "unknown",
            "utility_build_number": buildNumber ?? "unknown",
            "utility_app_name": appName ?? "unknown",
            "utility_bundle_id": bundleIdentifier ?? "unknown",
            "utility_app_display_name": appDisplayName ?? "unknown",
            "utility_minimum_OS_version": minimumOSVersion,
            "utility_app_executable": appExecutable,
            "utility_app_development_region": appDevelopmentRegion,
            "utility_device_name": deviceName,
            "utility_system_name": systemName,
            "utility_system_version": systemVersion,
            "utility_model": model,
            "utility_localized_model": localizedModel,
            "utility_model_identifier": modelIdentifier,
            "utility_idfv": identifierForVendor,
            "utility_is_ipad": isiPad,
            "utility_is_iphone": isiPhone,
            "utility_device_orientation": deviceOrientation.stringValue,
            "utility_is_smaller_vertical_height": isSmallerVerticalHeight,
            "utility_screen_width": screenWidth,
            "utility_screen_height": screenHeight,
            "utility_screen_scale": screenScale,
            "utility_battery_level": batteryLevel,
            "utility_battery_state": batteryState.stringValue,
            "utility_is_portrait": isPortrait,
            "utility_is_landscape": isLandscape,
            "utility_has_notch": hasNotch,
            "utility_is_testflight": isTestFlight,
            "utility_is_debug": isDebug,
            "utility_is_dev_user": isDevUser,
            "utility_is_prod_user": isProdUser,
            "utility_user_type": userType.rawValue,
            "utility_is_low_power_enabled": isLowPowerModeEnabled,
            "utility_thermal_state": thermalState.stringValue,
            "utility_is_mac_catalyst": isMacCatalystApp,
            "utility_is_iOS_on_mac": isiOSAppOnMac,
            "utility_physical_memory_gb": physicalMemoryInGB,
            "utility_system_uptime_days": systemUptimeInDays,
            "utility_locale_country": userCountry,
            "utility_locale_language": userLanguage,
            "utility_locale_currency_code": userCurrencyCode,
            "utility_locale_currency_symbol": userCurrencySymbol,
            "utility_locale_measurement_system": measurementSystem.stringValue,
            "utility_locale_time_zone": userTimeZone,
            "utility_locale_calendar": userCalendar
        ]
        return dict.compactMapValues({ $0 })
    }

}
