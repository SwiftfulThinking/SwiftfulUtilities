import Foundation
import UIKit

@MainActor
public struct Utilities {
    
    // MARK: Bundle.main

    /// The app's version number from the bundle (1.0.0)
    public static var appVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }

    /// The app's build number from the bundle (3)
    public static var buildNumber: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }

    /// The app's name from the bundle (MyApp)
    public static var appName: String? {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String
    }

    /// The app's bundle identifier (com.organization.MyApp)
    public static var bundleIdentifier: String? {
        return Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    }

    /// The app's display name from the bundle (My App)
    public static var appDisplayName: String? {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String
    }

    /// The minimum required OS version for the app (17.0)
    public static var minimumOSVersion: String? {
        return Bundle.main.infoDictionary?["MinimumOSVersion"] as? String
    }

    /// The executable name of the app (MyApp)
    public static var appExecutable: String? {
        return Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
    }

    /// The app's development region setting (en)
    public static var appDevelopmentRegion: String? {
        return Bundle.main.infoDictionary?["CFBundleDevelopmentRegion"] as? String
    }

    /// The platforms supported by the app.
    public static var appSupportedPlatforms: [String]? {
        return Bundle.main.infoDictionary?["CFBundleSupportedPlatforms"] as? [String]
    }

    /// The version of the Info.plist file.
    public static var appInfoDictionaryVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleInfoDictionaryVersion"] as? String
    }

    /// The icon files of the app, if available.
    public static var appIconFiles: [String]? {
        return Bundle.main.infoDictionary?["CFBundleIconFiles"] as? [String]
    }

    // MARK: UIDevice.current

    /// A Boolean value indicating whether the device is an iPad.
    public static var isiPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    /// A Boolean value indicating whether the device is an iPhone.
    public static var isiPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    /// The name of the device.
    public static var deviceName: String {
        UIDevice.current.name
    }

    /// The system name of the device (e.g., "iOS").
    public static var systemName: String {
        UIDevice.current.systemName
    }

    /// The system version of the device (17.0)
    public static var systemVersion: String {
        UIDevice.current.systemVersion
    }

    /// The model of the device (e.g., "iPhone").
    public static var model: String {
        UIDevice.current.model
    }

    /// The localized version of the device model (iPhone)
    public static var localizedModel: String {
        UIDevice.current.localizedModel
    }

    /// The identifier for the vendor (IDFV) of the device.
    public static var identifierForVendor: String {
        UIDevice.current.identifierForVendor?.uuidString ?? "no_idfv"
    }

    /// The current battery level of the device.
    public static var batteryLevel: Double {
        Double(UIDevice.current.batteryLevel)
    }

    /// The current battery state of the device (charging, full, unplugged).
    public static var batteryState: UIDevice.BatteryState {
        UIDevice.current.batteryState
    }

    /// The physical orientation of the device (portrait, landscapeLeft, etc.)
    public static var deviceOrientation: UIDeviceOrientation {
        UIDevice.current.orientation
    }

    /// A Boolean value indicating whether the device is in portrait orientation.
    public static var isPortrait: Bool {
        UIDevice.current.orientation.isPortrait
    }

    /// A Boolean value indicating whether the device is in landscape orientation.
    public static var isLandscape: Bool {
        UIDevice.current.orientation.isLandscape
    }

    // MARK: UIScreen.main

    /// A Boolean value indicating whether the current vertical orientation of the device has a height less than 800px.
    public static var isSmallerVerticalHeight: Bool {
        let height = isLandscape ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
        return height < 800
    }

    /// The width of the screen.
    public static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    /// The height of the screen.
    public static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    /// The scale factor of the screen.
    public static var screenScale: CGFloat {
        UIScreen.main.scale
    }

    // MARK: ProcessInfo.processInfo
    
    /// A Boolean value indicating if running SwiftUI Preview mode.
    public static var isXcodePreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    /// The name of the process.
    public static var processName: String {
        ProcessInfo.processInfo.processName
    }

    /// The unique identifier for the current process.
    public static var processIdentifier: Int {
        Int(ProcessInfo.processInfo.processIdentifier)
    }

    /// The environment variables of the current process.
    public static var launchEnvironmentVariables: [String: String] {
        ProcessInfo.processInfo.environment
    }

    /// The command-line arguments used to launch the app.
    public static var launchArguments: [String] {
        ProcessInfo.processInfo.arguments
    }

    /// A Boolean value indicating whether Low Power Mode is enabled.
    public static var isLowPowerModeEnabled: Bool {
        ProcessInfo.processInfo.isLowPowerModeEnabled
    }

    /// The thermal state of the device (e.g., nominal, fair, serious, critical).
    public static var thermalState: ProcessInfo.ThermalState {
        ProcessInfo.processInfo.thermalState
    }

    /// The physical memory (RAM) of the device in bytes.
    public static var physicalMemory: Int {
        Int(ProcessInfo.processInfo.physicalMemory)
    }

    /// The total physical memory (RAM) of the device in bytes, converted to a human-readable format.
    public static var physicalMemoryInGB: Double {
        let bytes = ProcessInfo.processInfo.physicalMemory
        return Double(bytes) / 1_073_741_824 // 1 GB = 1,073,741,824 bytes
    }

    /// The time interval since the system was booted.
    public static var systemUptime: Double {
        ProcessInfo.processInfo.systemUptime
    }

    /// The time interval since the system was booted, represented in days.
    public static var systemUptimeInDays: Double {
        let uptimeInSeconds = ProcessInfo.processInfo.systemUptime
        let uptimeInDays = uptimeInSeconds / 86400 // 1 day = 86,400 seconds
        return round(uptimeInDays * 100) / 100 // Rounds to 2 decimal places
    }

    /// A Boolean value indicating whether the app is running on Mac Catalyst.
    public static var isMacCatalystApp: Bool {
        ProcessInfo.processInfo.isMacCatalystApp
    }

    /// A Boolean value indicating whether the app is an iOS app running on a Mac.
    public static var isiOSAppOnMac: Bool {
        ProcessInfo.processInfo.isiOSAppOnMac
    }

    // MARK: Locale.current

    /// The user's country or region based on the current locale (US)
    public static var userCountry: String {
        Locale.current.region?.identifier ?? "unknown"
    }

    /// The user's language based on the current locale (en)
    public static var userLanguage: String {
        Locale.current.language.languageCode?.identifier ?? "unknown"
    }

    /// The user's currency code based on the current locale (e.g., "USD").
    public static var userCurrencyCode: String {
        Locale.current.currency?.identifier ?? "unknown"
    }

    /// The user's currency symbol based on the current locale (e.g., "$").
    public static var userCurrencySymbol: String {
        Locale.current.currencySymbol ?? "unknown"
    }

    /// A Boolean indicating whether the user's locale uses the metric system (us, uk, metric)
    public static var measurementSystem: Locale.MeasurementSystem {
        Locale.current.measurementSystem
    }

    /// The user's time zone identifier (e.g., "America/New_York").
    public static var userTimeZone: String {
        TimeZone.current.identifier
    }

    /// The user's preferred calendar identifier (e.g., "gregorian").
    public static var userCalendar: String {
        Locale.current.calendar.identifier.debugDescription
    }

    /// The user's collation identifier, if available, which determines sort order.
    public static var collationIdentifier: String {
        Locale.current.collation.identifier
    }

    // MARK: Other

    /// The device model identifier (e.g., "iPhone12,1", "arm64").
    public static var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("", { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        })
        return identifier
    }

    /// A Boolean value indicating whether the device has a notch.
    public static var hasNotch: Bool {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let keyWindow = windowScene.windows.first { $0.isKeyWindow }
            let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        }
        return false
    }

    // MARK: UserType

    /// The different types of users based on the app's environment.
    public enum UserType: String {
        case debug
        case testFlight = "testflight"
        case appStore = "appstore"
    }

    /// A Boolean value indicating whether the app is running in TestFlight.
    public static var isTestFlight: Bool {
        guard let component = Bundle.main.appStoreReceiptURL?.lastPathComponent else {
            return false
        }
        return component == "sandboxReceipt" || component == "CoreSimulator"
    }

    /// A Boolean value indicating whether the app is running in a debug build.
    public static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    /// A Boolean value indicating whether the user is a development user.
    public static var isDevUser: Bool {
        userType != .appStore
    }

    /// A Boolean value indicating whether the user is a production user.
    public static var isProdUser: Bool {
        userType == .appStore
    }

    /// The type of user based on the app's build and environment.
    public static var userType: UserType {
        if isDebug {
            return .debug
        } else if isTestFlight {
            return .testFlight
        }
        return .appStore
    }
}
