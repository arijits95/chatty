//
//  AppDelegate.swift
//  Chatty
//
//  Created by Arijit Sarkar on 18/05/26.
//

import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        initializeThirdPartyDependencies()
        return true
    }
    
    private func initializeThirdPartyDependencies() {
        FirebaseApp.configure()
    }
}

