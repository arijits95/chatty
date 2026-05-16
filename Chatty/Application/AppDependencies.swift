//
//  AppDependencies.swift
//  Chatty
//
//  Created by Codex on 16/05/26.
//

import Foundation

@MainActor
final class AppDependencies {
    let configuration: AppConfiguration
    let chatRepository: ChatRepository

    init(configuration: AppConfiguration = .current) {
        self.configuration = configuration
        self.chatRepository = Self.makeChatRepository(for: configuration)
    }

    func makeChatListViewModel() -> ChatListViewModelImpl {
        ChatListViewModelImpl(usecase: ChatsUseCaseImpl(repository: chatRepository))
    }

    private static func makeChatRepository(for configuration: AppConfiguration) -> ChatRepository {
        switch configuration.backendKind {
        case .demo:
            return DemoChatRepository()
        case .firebase:
            return ChatRepositoryImpl()
        case .custom:
            return ChatRepositoryImpl()
        }
    }
}
