//
//  Untitled.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 26.11.2024.
//

import UIKit

final class CustomImageView: UIImageView {
    
    init(named name: String) {
        super.init(frame: .zero)
        if let UIImage = UIImage(named: name) {
            self.image = UIImage
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    init(UIImage: UIImage?) {
        super .init(frame: .zero)
        self.image = UIImage
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
