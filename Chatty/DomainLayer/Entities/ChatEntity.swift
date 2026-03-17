//
//  ChatEntity.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation

public struct ChatEntity: Identifiable {
    public var id: String
    public var participants: [UserEntity]
    public var lastMessage: String
    public var lastMessageTimestamp: TimeInterval
    public var isRead: Bool
}
