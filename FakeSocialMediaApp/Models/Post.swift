//
//  Post.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 27.11.2024.
//
import UIKit

struct Post {
    let id: String
    let authorId: String
    let text: String
    let image: UIImage?
    let labelText: String
    
    init(id: String, authorId: String, text: String, image: UIImage?, labelText: String) {
        self.id = id
        self.authorId = authorId
        self.text = text
        self.image = image
        self.labelText = labelText
    }
    
    init(dictionary: [String: Any], uiImage: UIImage?, id: String) {
        self.id = id
        self.authorId = dictionary["userID"] as! String
        self.text = dictionary["text"] as? String ?? ""
        self.image = uiImage
        self.labelText = dictionary["labelText"] as? String ?? "invalid header"
    }
    
}
