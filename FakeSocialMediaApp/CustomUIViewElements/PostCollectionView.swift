//
//  PostCollectionView.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 30.11.2024.
//

import UIKit

final class PostCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayot = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: flowLayot)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(PostViewCell.self, forCellWithReuseIdentifier: .postCellID)
        self.backgroundColor = .customViewBackGroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
