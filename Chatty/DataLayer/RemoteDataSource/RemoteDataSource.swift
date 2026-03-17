//
//  RemoteDataSource.swift
//  Chatty
//
//  Created by Arijit Sarkar on 16/02/26.
//

import Foundation

protocol RemoteDataSource {
    func getChats(after: TimeInterval) async throws -> [ChatDTO]
    func getChats(before: TimeInterval) async throws -> [ChatDTO]
    func sendMessage()
}
