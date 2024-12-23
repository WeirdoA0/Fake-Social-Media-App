//
//  CustomCollectionView.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 19.12.2024.
//

import UIKit

class CustomCollectionView: UICollectionView {
    
    init(configureHeader: Bool, dataSource: UICollectionViewDataSource){
        let layout = UICollectionViewCompositionalLayout.configure(configureHeader: configureHeader)
        super.init(frame: .zero, collectionViewLayout: layout)
        register(PostViewCell.self, forCellWithReuseIdentifier: .postCellID)
        register(PostViewCellNoImage.self, forCellWithReuseIdentifier: .postCellIDText)
        register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: .headerCellID)
        self.backgroundColor = .clear
        self.dataSource = dataSource
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UICollectionViewCompositionalLayout {
    static func configure(configureHeader: Bool) -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.estimated(500))
        let groupSuze =  NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.estimated(500))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSuze, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        if configureHeader {
            let headerSize = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1), heightDimension: NSCollectionLayoutDimension.absolute(330))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0)
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
