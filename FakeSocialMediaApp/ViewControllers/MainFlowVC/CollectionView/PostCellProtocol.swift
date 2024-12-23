//
//  PostCellProtocol.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 16.12.2024.
//

protocol ICollectionViewCell {
    
    var editAction: (() -> Void)? { get set }
    
    var likeBtnAction:  (() -> Void)? { get set }
    
    var pushDetailedPost: (() -> Void)? { get set}
    
    func setupEditButton()
    
    func update(post: PostCell)
}
