//
//  Untitled.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 26.11.2024.
//

import UIKit

final class CustomButton: UIButton {
    
    var UiBtnDidTapAction: () -> Void
    @objc func didTapOnButton(){
        UiBtnDidTapAction()
    }
    
    init(title: String?, textColor: UIColor, fontSize: CGFloat = 16, backgroundColor: UIColor? = nil,backgroundImage: UIImage? = nil, UiBtnDidTapAction: @escaping () -> Void) {
        self.UiBtnDidTapAction = UiBtnDidTapAction
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(title, for: .normal)
        if title != nil {
            self.setTitleColor(textColor, for: .normal)
        }
        self.backgroundColor = backgroundColor
        self.titleLabel?.font =  UIFont.systemFont(ofSize: fontSize)
        if let backgroundImage  {
            self.setBackgroundImage(backgroundImage, for: .normal)
        }

        
        self.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
