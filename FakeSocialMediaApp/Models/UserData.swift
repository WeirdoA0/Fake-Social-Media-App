//
//  UserData.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 27.11.2024.
//

import UIKit


struct UserData {
    let id: String
    let name: String
    let status: String
    let image: UIImage
    
    init(id: String, name: String, status: String, image: UIImage) {
        self.id = id
        self.name = name
        self.status = status
        self.image = image
    }
    
    init(dictionary: [String: Any], uiImage: UIImage, id: String) {
        self.id = id
        self.name = dictionary["userName"] as? String ?? "Invalid Name"
        self.status = dictionary["userStatus"] as? String ?? ""
        self.image = uiImage
    }
}
