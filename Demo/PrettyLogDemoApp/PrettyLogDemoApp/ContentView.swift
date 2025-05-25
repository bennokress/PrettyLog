//
// 📄 ContentView.swift
// 👨🏼‍💻 Author: Benno Kress
//

import SwiftUI
import PrettyLog

struct ContentView: View {
    
    // MARK: - State Properties
    
    @State private var selectedLogLevel: LogLevelOption = .info
    @State private var selectedCategory: LogCategoryOption = .general
    @State private var message1: String = ""
    @State private var message2: String = ""
    @State private var message3: String = ""
    @State private var sensitiveMessage1: String = ""
    @State private var sensitiveMessage2: String = ""
    @State private var showingResult = false
    @State private var resultMessage = ""
    
    // MARK: - Body
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            formContent
        }
        .navigationViewStyle(StackNavigationViewStyle())
        #else
        VStack {
            formContent
        }
        .padding()
        #endif
    }
    
    private var formContent: some View {
        Form {
            Section(header: Text("Log Configuration")) {
                Picker("Log Level", selection: $selectedLogLevel) {
                    ForEach(LogLevelOption.allCases, id: \.self) { level in
                        Text("\(level.emoji) \(level.displayName)")
                            .tag(level)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("Category", selection: $selectedCategory) {
                    ForEach(LogCategoryOption.allCases, id: \.self) { category in
                        Text(category.displayName)
                            .tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Section(header: Text("Messages")) {
                TextField("Message 1", text: $message1)
                TextField("Message 2 (optional)", text: $message2)
                TextField("Message 3 (optional)", text: $message3)
            }
            
            Section(header: Text("Sensitive Messages")) {
                TextField("Sensitive Message 1 (optional)", text: $sensitiveMessage1)
                TextField("Sensitive Message 2 (optional)", text: $sensitiveMessage2)
                
                Text("⚠️ Sensitive messages are only sent to console logs, not to backend servers for security reasons.")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
            Section {
                Button(action: sendLogMessage) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Send Log Message")
                    }
                    .frame(maxWidth: .infinity)
                }
                .disabled(message1.isEmpty)
            }
        }
        .navigationTitle("PrettyLog Demo")
        .alert("Log Sent", isPresented: $showingResult) {
            Button("OK", role: .cancel) { 
                clearForm()
            }
        } message: {
            Text(resultMessage)
        }
    }
    
    // MARK: - Private Methods
    
    private func sendLogMessage() {
        let messages = [message1, message2, message3].filter { !$0.isEmpty }
        let sensitiveMessages = [sensitiveMessage1, sensitiveMessage2].filter { !$0.isEmpty }
        
        let messageCount = messages.count
        let sensitiveCount = sensitiveMessages.count
        
        switch selectedLogLevel {
        case .verbose:
            logV(messages[0], 
                 messageCount > 1 ? messages[1] : nil,
                 messageCount > 2 ? messages[2] : nil,
                 sensitiveMessages: sensitiveCount > 0 ? sensitiveMessages[0] : nil,
                 sensitiveCount > 1 ? sensitiveMessages[1] : nil,
                 category: selectedCategory.logCategory)
        case .debug:
            logX(messages[0],
                 messageCount > 1 ? messages[1] : nil,
                 messageCount > 2 ? messages[2] : nil,
                 sensitiveMessages: sensitiveCount > 0 ? sensitiveMessages[0] : nil,
                 sensitiveCount > 1 ? sensitiveMessages[1] : nil,
                 category: selectedCategory.logCategory)
        case .info:
            logP(messages[0],
                 messageCount > 1 ? messages[1] : nil,
                 messageCount > 2 ? messages[2] : nil,
                 sensitiveMessages: sensitiveCount > 0 ? sensitiveMessages[0] : nil,
                 sensitiveCount > 1 ? sensitiveMessages[1] : nil,
                 category: selectedCategory.logCategory)
        case .warning:
            logW(messages[0],
                 messageCount > 1 ? messages[1] : nil,
                 messageCount > 2 ? messages[2] : nil,
                 sensitiveMessages: sensitiveCount > 0 ? sensitiveMessages[0] : nil,
                 sensitiveCount > 1 ? sensitiveMessages[1] : nil,
                 category: selectedCategory.logCategory)
        case .error:
            logE(messages[0],
                 messageCount > 1 ? messages[1] : nil,
                 messageCount > 2 ? messages[2] : nil,
                 sensitiveMessages: sensitiveCount > 0 ? sensitiveMessages[0] : nil,
                 sensitiveCount > 1 ? sensitiveMessages[1] : nil,
                 category: selectedCategory.logCategory)
        case .keyEvent:
            logK(messages[0],
                 messageCount > 1 ? messages[1] : nil,
                 messageCount > 2 ? messages[2] : nil,
                 category: selectedCategory.logCategory)
        case .todo:
            logT(messages[0],
                 messageCount > 1 ? messages[1] : nil,
                 messageCount > 2 ? messages[2] : nil,
                 sensitiveMessages: sensitiveCount > 0 ? sensitiveMessages[0] : nil,
                 sensitiveCount > 1 ? sensitiveMessages[1] : nil,
                 category: selectedCategory.logCategory)
        }
        
        resultMessage = "Log message sent with level '\(selectedLogLevel.displayName)' and category '\(selectedCategory.displayName)'"
        showingResult = true
    }
    
    private func clearForm() {
        message1 = ""
        message2 = ""
        message3 = ""
        sensitiveMessage1 = ""
        sensitiveMessage2 = ""
    }

}

// MARK: - Supporting Types

enum LogLevelOption: CaseIterable {

    case verbose, debug, info, warning, error, keyEvent, todo
    
    var displayName: String {
        switch self {
        case .verbose: return "Verbose"
        case .debug: return "Debug"
        case .info: return "Info"
        case .warning: return "Warning"
        case .error: return "Error"
        case .keyEvent: return "Key Event"
        case .todo: return "TODO"
        }
    }
    
    var emoji: String {
        switch self {
        case .verbose: return "🔵"
        case .debug: return "🟤"
        case .info: return "🟢"
        case .warning: return "🟡"
        case .error: return "🔴"
        case .keyEvent: return "📊"
        case .todo: return "🟣"
        }
    }

}

enum LogCategoryOption: CaseIterable {

    case appState, debug, general, manager, service, storage, uncategorized, user, view, demo, todo
    
    var displayName: String {
        switch self {
        case .appState: return "App State"
        case .debug: return "Debug"
        case .general: return "General"
        case .manager: return "Manager"
        case .service: return "Service"
        case .storage: return "Storage"
        case .uncategorized: return "Uncategorized"
        case .user: return "User Action"
        case .view: return "View"
        case .demo: return "Demo"
        case .todo: return "To Do"
        }
    }
    
    var logCategory: LogCategory {
        switch self {
        case .appState: return .appState
        case .debug: return .debug
        case .general: return .general
        case .manager: return .manager
        case .service: return .service
        case .storage: return .storage
        case .uncategorized: return .uncategorized
        case .user: return .user
        case .view: return .view
        case .demo: return .custom("Demo")
        case .todo: return .custom("To Do")
        }
    }

}

// MARK: - Preview

#Preview {
    ContentView()
}
