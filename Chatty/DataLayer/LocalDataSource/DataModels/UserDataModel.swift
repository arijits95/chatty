//
//  UserDataModel.swift
//  Chatty
//
//  Created by Arijit Sarkar on 04/02/26.
//

import Foundation
import SwiftData

@Model
class UserDataModel {
    var id: String
    var name: String
    var profileImage: URL

    init(id: String,
         name: String,
         profileImage: URL) {
        self.id = id
        self.name = name
        self.profileImage = profileImage
    }
}

extension UserDataModel {
    
    func toDTO() -> UserDTO {
        .init(id: id,
              name: name,
              profileImage: profileImage)
    }
}
