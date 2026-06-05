//
//  AppEnvironment.swift
//  Chatty
//
//  Created by Codex on 16/05/26.
//

import Foundation

enum AppEnvironment: String, CaseIterable {
    case development
    case demo
    case production

    nonisolated static var current: AppEnvironment {
        guard let rawValue = Bundle.main.object(forInfoDictionaryKey: "CHATTY_ENVIRONMENT") as? String,
              let environment = AppEnvironment(rawValue: rawValue.lowercased()) else {
            return .demo
        }
        return environment
    }
}

enum BackendKind: String {
    case demo
    case firebase
    case custom
}

struct AppConfiguration {
    let environment: AppEnvironment
    let backendKind: BackendKind

    nonisolated static var current: AppConfiguration {
        let environment = AppEnvironment.current
        let backendKind: BackendKind

        switch environment {
        case .demo:
            backendKind = .demo
        case .development, .production:
            backendKind = .firebase
        }

        return AppConfiguration(environment: environment, backendKind: backendKind)
    }
}
