//
//  Untitled.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 26.11.2024.
//

import UIKit

final class CustomTextField: UITextField {
    init(fontSize: CGFloat, textColor: UIColor, textAlignment: NSTextAlignment, backgroundColor: UIColor?, isSecured: Bool, placeholder: String?, delegate: UITextFieldDelegate?) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardType = .default
        self.clearButtonMode = .whileEditing
        self.returnKeyType = UIReturnKeyType.done
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.isSecureTextEntry = isSecured
        self.placeholder = placeholder
        self.delegate = delegate
        self.textAlignment = textAlignment
        if isSecured {
            self.textContentType = .oneTimeCode
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
