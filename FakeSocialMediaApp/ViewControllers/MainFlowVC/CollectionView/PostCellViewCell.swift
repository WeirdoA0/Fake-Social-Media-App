//
//  PostCellViewCell.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 15.12.2024.
//

import UIKit

final class PostViewCell: UICollectionViewCell, ICollectionViewCell {
    //MARK: Properties
    
    var editAction: (() -> Void)?
    var likeBtnAction:  (() -> Void)?
    var pushDetailedPost: (() -> Void)?
    private var isLiked = false
    
    //MARK: Subviews
    private lazy var authorImage = CustomImageView(UIImage: .profile)
    private lazy var authorName = CustomLabel(text: "Name", textColor: .customTintColor, fontSize: 15, alignment: .left)
    
    private lazy var postTitle = CustomLabel(text: "Title", textColor: .customTintColor, fontSize: 20, alignment: .center)
    private lazy var postImage = CustomImageView(UIImage: .photoIcon)
    private lazy var postText = CustomLabel(text: "Text", textColor: .customTintColor, fontSize: 15, alignment: .left)
    
    private lazy var likeButton = CustomButton(title: nil, textColor: .clear, fontSize: 0, backgroundImage: .like, UiBtnDidTapAction: {  [weak self] in
        if let likeBtnAction = self?.likeBtnAction {
            self?.setupLikeBtnColor()
            likeBtnAction()
        }
    })
    private lazy var likesLabel = CustomLabel(text: "0", textColor: .customTintColor, fontSize: 10, alignment: .center)
    
    private lazy var pushDetailedPostButton = CustomButton(title: "See more", textColor: .customTintColor, UiBtnDidTapAction: { [weak self] in
        if let pushDetailedPost = self?.pushDetailedPost {
            pushDetailedPost()
        }
    })
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        tuneSubviews()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Private
    
    private func layout(){
        [authorImage, authorName, postTitle, postImage, postText, likeButton, likesLabel, pushDetailedPostButton].forEach({
            contentView.addSubview($0)
        })
        NSLayoutConstraint.activate([

            
            authorImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            authorImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            authorImage.heightAnchor.constraint(equalToConstant: 50),
            authorImage.widthAnchor.constraint(equalToConstant: 50),
            
            authorName.leadingAnchor.constraint(equalTo: authorImage.trailingAnchor, constant: 5),
            authorName.centerYAnchor.constraint(equalTo: authorImage.centerYAnchor),
            authorName.heightAnchor.constraint(equalToConstant: 15),
            
            postTitle.topAnchor.constraint(equalTo: authorImage.bottomAnchor, constant: 10),
            postTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            postTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            postTitle.heightAnchor.constraint(equalToConstant: 20),
            
            postImage.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: 10),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            postImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4, constant: -20),
            
            postText.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 10),
            postText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            postText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            postText.heightAnchor.constraint(lessThanOrEqualToConstant: 150),
            
            likeButton.topAnchor.constraint(equalTo: postText.bottomAnchor, constant: 10),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.bottomAnchor.constraint(equalTo: pushDetailedPostButton.topAnchor, constant: -20),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            likesLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 10),
            
            pushDetailedPostButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pushDetailedPostButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            pushDetailedPostButton.heightAnchor.constraint(equalToConstant: 20),
            pushDetailedPostButton.widthAnchor.constraint(equalToConstant: 200),
            
            
        ])
    }
    
    private func tuneSubviews(){
        self.backgroundColor = .customViewBackGroundColor
        authorImage.layer.masksToBounds = true
        authorImage.layer.cornerRadius = 12.5
        
        postImage.layer.masksToBounds = true
        postImage.layer.cornerRadius = 10
        
        postText.numberOfLines = 0
    }
    
    private func setupLikeBtnColor(){
        isLiked.toggle()
        likeButton.tintColor = isLiked ? .red : .blue
    }
    
    //MARK: Internal
    
    func update(post: PostCell) {
        authorName.text = post.userData.name
        authorImage.image = post.userData.image
        
        postTitle.text = post.postData.labelText
        postText.text = post.postData.text
        postImage.image = post.postData.image
        
        likesLabel.text = String(post.likeData.numberOfLikes)
        likeButton.tintColor = post.likeData.userLikedPost ? .red : .blue
        isLiked = post.likeData.userLikedPost
    }
    
    func setupEditButton(){
        let btn = CustomButton(title: "Edit post", textColor: .white, backgroundImage: .btnBackGround, UiBtnDidTapAction: { [weak self] in
            if let editAction = self?.editAction {
               editAction()
            }
        })
        contentView.addSubview(btn)
        NSLayoutConstraint.activate([
            btn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            btn.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            btn.heightAnchor.constraint(equalToConstant: 50),
            btn.widthAnchor.constraint(equalToConstant: 180)
        ])
        
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        
    }
}
