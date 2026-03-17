//
//  ChatDataModel.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation
import SwiftData

@Model
class ChatDataModel {
    var id: String
    var participants: [String]
    var lastMessage: String
    var lastMessageTimestamp: TimeInterval
    var isRead: Bool
    
    init(id: String,
         participants: [String],
         lastMessage: String,
         lastMessageTimestamp: TimeInterval,
         isRead: Bool) {
        self.id = id
        self.participants = participants
        self.lastMessage = lastMessage
        self.lastMessageTimestamp = lastMessageTimestamp
        self.isRead = isRead
    }
}

//extension ChatDataModel {
//    
//    func toDTO() -> ChatDTO {
//        .init(id: id, participants: participants.map({$0.toDTO()}), lastMessage: lastMessage, lastMessageTimestamp: lastMessageTimestamp, isRead: isRead)
//    }
//}
