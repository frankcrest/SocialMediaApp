//
//  ContentView.swift
//  SocialMediaApp
//
//  Created by Frank Chen on 2024-03-30.
//

import SwiftUI
import FirebaseCore

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        // MARK: Redirecting User Based on Log Status
        if logStatus {
            MainView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
