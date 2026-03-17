//
//  ChatListItem.swift
//  Chatty
//
//  Created by Arijit Sarkar on 13/02/26.
//

import SwiftUI

struct ChatListItemView: View {
    
    @State var chat: ChatListItemData
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "star")
                .resizable()
                .padding()
                .frame(width: 60, height: 60)
                .background {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                }
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(chat.name)
                        .lineLimit(1)
                        .bold()
                        .foregroundStyle(Color.black)
                    Text(chat.lastMessage)
                        .lineLimit(3)
                        .font(.subheadline)
                        .foregroundStyle(Color.black.opacity(0.8))
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(chat.lastMessageDateTime)
                        .bold()
                        .foregroundStyle(chat.unreadMessageCount > 0 ? Color.green : Color.black)
                    if chat.unreadMessageCount > 0 {
                        Text("\(chat.unreadMessageCount)")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 5)
                            .background {
                                GeometryReader { proxy in
                                    RoundedRectangle(cornerRadius: proxy.size.width)
                                        .fill(.green)
                                }
                            }
                    }
                }
            }
        }
        .border(.blue)
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
