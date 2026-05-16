//
//  ChatEntity+Sorting.swift
//  Chatty
//
//  Created by Codex on 16/05/26.
//

import Foundation

extension Array where Element == ChatEntity {
    func sortedByRecentMessage() -> [ChatEntity] {
        sorted { lhs, rhs in
            lhs.lastMessageTimestamp > rhs.lastMessageTimestamp
        }
    }
}
