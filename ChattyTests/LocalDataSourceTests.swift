//
//  LocalDataSourceTests.swift
//  ChattyTests
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Testing
import SwiftData
@testable import Chatty
internal import Foundation

@MainActor
struct LocalDataSourceTests {
    
    let sut: LocalDataSource
    
    init() async throws {
        let modelContainer = try ModelContainer(for: UserDataModel.self, ChatDataModel.self,
                                            configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        sut = LocalDataSourceImpl(modelContainer: modelContainer)
        try await sut.deleteAllChats()
    }

    @Test func testSaveAndGetChats() async throws {
        let chatParticipants = getChatParticipantPair(firstParticipantId: "1", secondParticipantId: "2")
        let chats = getChatsForParticipantPair(chatParticipants, chatCount: 100)
        try await sut.deleteAllChats()
        try await sut.saveChats(chats)
        let retrievedChats = try await sut.getChats(after: chatStartDate.timeIntervalSince1970)
        #expect(retrievedChats.count == 10, "Saved chat count must be equal to the retrieved chat counts")
        try await sut.deleteAllChats()
    }

}

extension LocalDataSourceTests {
    
    private func getChatParticipantPair(firstParticipantId: String, secondParticipantId: String) -> (UserDTO, UserDTO) {
        let first = UserDTO(id: firstParticipantId, name: "Participant " + firstParticipantId, profileImage: .applicationDirectory)
        let second = UserDTO(id: firstParticipantId, name: "Participant " + firstParticipantId, profileImage: .applicationDirectory)
        return (first, second)
    }
    
    private func getChatsForParticipantPair(_ pair: (UserDTO, UserDTO), chatCount: Int) -> [ChatDTO] {
        var chats = [ChatDTO]()
        var chatStartDate = chatStartDate
        for count in 1...chatCount {
            chatStartDate.addTimeInterval(60)
            let newChat = ChatDTO(id: "C-\(count)",
                                  participants: [pair.0, pair.1],
                                  lastMessage: "Hello",
                                  lastMessageTimestamp: chatStartDate.timeIntervalSince1970,
                                  isRead: true)
            chats.append(newChat)
        }
        return chats
    }
    
    private var chatStartDate: Date {
        var chatStartDateComponents = DateComponents()
        chatStartDateComponents.year = 2026
        chatStartDateComponents.month = 2
        chatStartDateComponents.day = 4
        chatStartDateComponents.hour = 10
        chatStartDateComponents.minute = 5
        guard let date = Calendar(identifier: .gregorian)
            .date(from: chatStartDateComponents) else {
            fatalError("Chat Start Date should be created correctly")
        }
        return date
    }
}
