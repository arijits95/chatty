//
//  MessageEntity.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation

public struct MessageEntity: Identifiable {
    public var id: String
    public var chatId: String
    public var senderId: String
    public var receiverId: String
    public var content: String
    public var attachment: Attachment?
    public var status: MessageStatus
    public var createdAt: TimeInterval
    public var editedAt: TimeInterval?
    
    public enum Attachment {
        case image(URL), file(URL), video(URL)
        
        public var url: URL {
            switch self {
            case .image(let url),
                 .file(let url),
                 .video(let url):
                return url
            }
        }
    }
    
    public enum MessageStatus {
        case sending, sent, delivered, read, failed
    }
}
