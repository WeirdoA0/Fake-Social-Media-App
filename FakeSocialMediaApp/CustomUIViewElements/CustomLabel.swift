//
//  Untitled.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 26.11.2024.
//

import UIKit

final class CustomLabel: UILabel {
     
    init(text: String, textColor: UIColor?, fontSize: CGFloat, alignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textAlignment = alignment
    }
   
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
