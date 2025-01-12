//
//  CustomTableView.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 14.12.2024.
//
import UIKit

class CustomTableView: UITableView{
    
    init(delegate: UITableViewDelegate? = nil, dataSource: UITableViewDataSource? = nil) {
        super.init(frame: .zero, style: .grouped)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = delegate
        self.dataSource = dataSource
        self.register(PostViewCell.self, forCellReuseIdentifier: .postCellID)
        self.register(PostViewCellNoImage.self, forCellReuseIdentifier: .postCellIDText)
        self.register(ProfileHeader.self, forHeaderFooterViewReuseIdentifier: .headerCellID)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
