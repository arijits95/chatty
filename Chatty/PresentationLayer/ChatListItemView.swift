//
//  ChatListItem.swift
//  Chatty
//
//  Created by Arijit Sarkar on 13/02/26.
//

import SwiftUI

struct ChatListItemView: View {
    
    let chat: ChatListItemData
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: 60, height: 60)
                .foregroundStyle(.secondary)
                .background {
                    Circle()
                        .fill(Color.secondary.opacity(0.18))
                }
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(chat.name)
                        .lineLimit(1)
                        .bold()
                        .foregroundStyle(.primary)
                    Text(chat.lastMessage)
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(chat.lastMessageDateTime)
                        .font(.caption)
                        .bold()
                        .foregroundStyle(chat.unreadMessageCount > 0 ? .green : .secondary)
                    if chat.unreadMessageCount > 0 {
                        Text("\(chat.unreadMessageCount)")
                            .font(.caption.bold())
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background {
                                Capsule()
                                    .fill(.green)
                            }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    VStack {
        ChatListItemView(chat:
                            ChatListItemData(id: "1",
                                             name: "Sukesh",
                                             lastMessage: "Hi, whats up?",
                                             lastMessageDateTime: "9.05 PM",
                                             unreadMessageCount: 2))
        ChatListItemView(chat:
                        ChatListItemData(id: "2",
                                         name: "Animesh Shukla",
                                         lastMessage: "Hi, whats up? Can you spot this for me?",
                                         lastMessageDateTime: "9.05 PM",
                                         unreadMessageCount: 2))
        ChatListItemView(chat:
                        ChatListItemData(id: "3",
                                         name: "Animesh Shukla",
                                         lastMessage: "Hi, whats up? Can you spot this for me or should i contact someone",
                                         lastMessageDateTime: "9.05 PM",
                                         unreadMessageCount: 2))
    }
    .padding()
}
