//
//  ChattyApp.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import SwiftUI

@main
struct ChattyApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            ChatListView(viewModel: dependencies.makeChatListViewModel())
        }
    }
}
