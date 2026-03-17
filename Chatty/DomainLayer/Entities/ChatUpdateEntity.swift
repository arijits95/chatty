//
//  ChatUpdateEntity.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation

public enum ChatUpdateEntity {
    case newChat(ChatEntity)
    case newMessage(MessageEntity)
    case messageStatusUpdate(messageId: String, updatedStatus: MessageEntity.MessageStatus)
}
