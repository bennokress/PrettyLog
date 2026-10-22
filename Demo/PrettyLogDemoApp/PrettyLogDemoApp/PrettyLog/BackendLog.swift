//
// 📄 BackendLogTarget.swift
// 👨🏼‍💻 Author: Benno Kress
//

import Foundation
import PrettyLog

/// A custom log target that sends log messages to a backend server
/// This target only sends non-sensitive data for security reasons
struct BackendLog: LogTarget {
    
    // MARK: - Properties
    
    /// Backend log targets should not log sensitive information for security
    let canLogSensitiveInformation = false

    /// Only log INFO level and above to reduce server load
    var levelFilter: LogLevelPriorityFilter<AppLogLevel> { .from(.info) }
    
    private let serverURL = URL(string: "https://api.example.com/logs")!
    
    // MARK: - LogTarget Implementation
    
    func emit(_ level: AppLogLevel, message: String, category: LogCategory) {
        let logEntry = BackendLogEntry(timestamp: Date(), level: "\(level.emoji) \(level.priority)", category: category.name, message: message, deviceInfo: getDeviceInfo())
        sendToBackend(logEntry)
    }
    
    // MARK: - Private Methods
    
    private func getDeviceInfo() -> [String: String] {
        var info: [String: String] = [:]
        
        #if os(iOS)
        info["platform"] = "iOS"
        #elseif os(macOS)
        info["platform"] = "macOS"
        #elseif os(watchOS)
        info["platform"] = "watchOS"
        #elseif os(tvOS)
        info["platform"] = "tvOS"
        #else
        info["platform"] = "Unknown"
        #endif
        
        return info
    }
    
    private func sendToBackend(_ logEntry: BackendLogEntry) {
        do {
            let jsonData = try JSONEncoder().encode(logEntry)
            
            // For demo purposes, we'll just print what would be sent
            // In a real implementation, you would create a URLRequest and send it
            print("📡 [Backend Log] Would send to server:")
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("   \(jsonString)")
            }
            
        } catch {
            print("📡 [Backend Log] Failed to encode log: \(error)")
        }
    }

}

// MARK: - Backend Log Entry Model

private struct BackendLogEntry: Codable {

    let timestamp: Date
    let level: String
    let category: String
    let message: String
    let deviceInfo: [String: String]
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case level
        case category
        case message
        case deviceInfo = "device_info"
    }

}
