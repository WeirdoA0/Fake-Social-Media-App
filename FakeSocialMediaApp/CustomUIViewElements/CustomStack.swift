//
//  Untitled.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 26.11.2024.
//

import UIKit

final class CustomStack: UIStackView {
    init(axis: NSLayoutConstraint.Axis, spacing: CGFloat, spaceColor: UIColor?, subviews: [UIView]){
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.spacing = spacing
        self.backgroundColor = spaceColor
        self.distribution = .fillEqually
        
        subviews.forEach({
            self.addArrangedSubview($0)
        })
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
