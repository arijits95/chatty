//
//  UserDTO.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation

struct UserDTO {
    var id: String
    var name: String
    var profileImage: URL
}

extension UserDTO {
    
    func toDomain() -> UserEntity {
        .init(id: id, name: name, profileImage: profileImage)
    }
}

extension UserDTO {
    
    nonisolated func toPersistableModel() -> UserDataModel {
        .init(id: id, name: name, profileImage: profileImage)
    }
}
