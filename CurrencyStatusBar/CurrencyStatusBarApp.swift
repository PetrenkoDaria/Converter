//
//  CurrencyStatusBarApp.swift
//  CurrencyStatusBar
//
//  Created by Артем Дорожкин on 04.06.2023.
//

import SwiftUI

@main
struct CurrencyStatusBarApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            ContentView()
        }
    }
}
