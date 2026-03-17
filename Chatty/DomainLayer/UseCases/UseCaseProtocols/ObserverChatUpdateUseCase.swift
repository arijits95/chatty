//
//  ObserverChatUpdateUseCase.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation

protocol ObserverChatUpdateUseCase {
    func observe() -> AsyncStream<ChatUpdateEntity>
}
