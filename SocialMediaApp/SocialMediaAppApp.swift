//
//  SocialMediaAppApp.swift
//  SocialMediaApp
//
//  Created by Frank Chen on 2024-03-30.
//

import SwiftUI
import FirebaseCore

@main
struct SocialMediaAppApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
