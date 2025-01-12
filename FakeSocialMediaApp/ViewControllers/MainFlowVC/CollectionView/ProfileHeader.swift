//
//  ProfileHeader.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 16.12.2024.
//

import UIKit

final class ProfileHeader: UICollectionReusableView {
    //MARK: Properties
    
    var editAction: (() -> Void)?
    var newPostAction: (() -> Void)?
    
    //MARK:  Subviews
    private lazy var userImage = CustomImageView(UIImage: .profile)
    private lazy var userNameLabel = CustomLabel(text: "Name", textColor: .customTintColor, fontSize: 20, alignment: .left)
    private lazy var userStatusLabel = CustomLabel(text: "Status", textColor: .customTintColor, fontSize: 15, alignment: .left)
    private lazy var editProfileButton = CustomButton(title: "Edit profile", textColor: .white, backgroundImage: .btnBackGround, UiBtnDidTapAction: { [weak self] in
        if let editAction = self?.editAction {
            editAction()
        }
    })
    private lazy var newPostButton = CustomButton(title: "New post", textColor: .white, backgroundImage: .btnBackGround, UiBtnDidTapAction: { [weak self] in
        if let newPostAction = self?.newPostAction {
            newPostAction()
        }

    })
    
    //MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        tuneSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private
    private func layout() {
        [userImage, userNameLabel, userStatusLabel, newPostButton, editProfileButton].forEach({
            self.addSubview($0)
        })
        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            userImage.heightAnchor.constraint(equalToConstant: 100),
            userImage.widthAnchor.constraint(equalToConstant: 100),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            userNameLabel.centerYAnchor.constraint(equalTo: userImage.centerYAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 20),
            userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -16),
            
            userStatusLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            userStatusLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 10),
            userStatusLabel.heightAnchor.constraint(equalToConstant: 15),
            userStatusLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -16),
            
            editProfileButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            editProfileButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            editProfileButton.heightAnchor.constraint(equalToConstant: 75),
            editProfileButton.topAnchor.constraint(equalTo: userStatusLabel.bottomAnchor, constant: 10),
            
            newPostButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            newPostButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            newPostButton.heightAnchor.constraint(equalToConstant: 75),
            newPostButton.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 10)
        ])
        
    }
    
    private func tuneSubviews() {
        self.backgroundColor = .customViewBackGroundColor
        [userImage, editProfileButton, newPostButton].forEach({
            $0.layer.masksToBounds = true
        })
        userImage.layer.cornerRadius = 25
        [editProfileButton, newPostButton].forEach({
            $0.layer.cornerRadius = 15
        })
    }
    //MARK: Internal
    func update(userData: UserData) {
        userImage.image = userData.image
        userNameLabel.text = userData.name
        userStatusLabel.text = userData.status
    }
}
