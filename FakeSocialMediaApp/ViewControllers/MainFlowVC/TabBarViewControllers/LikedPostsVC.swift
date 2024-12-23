//
//  LikedPostsVC.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 14.12.2024.
//

import UIKit

final class LikedPostsVC: UIViewController {
    //MARK: Properties
    
    private var viewModel: LikedPostsVM
    
    //MARK: Subviews
    private lazy var collectionView = CustomCollectionView(configureHeader: false, dataSource: self)
    
    //MARK: Init
    
    init(viewModel: LikedPostsVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        view.backgroundColor = .customViewBackGroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPosts()
    }
    
    //MARK: Private
    private func layout(){
        view.addSubview(collectionView)
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 4),
            collectionView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -4)
        ])
    }
    private func loadPosts(){
        let uIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        DispatchQueue.main.async(execute: { [weak self] in
            guard let self else { return }
            view.addSubview(uIActivityIndicatorView)
            uIActivityIndicatorView.center = view.center
            uIActivityIndicatorView.startAnimating()
            collectionView.isHidden = true
            collectionView.isUserInteractionEnabled = false
        })
        
        viewModel.loadPosts() { [weak self] error in
            guard let self else { return }
            guard error == nil else {
                uIActivityIndicatorView.removeFromSuperview()
                print(error ?? "Unknown error")
                return
            }
            DispatchQueue.main.async(execute: {
                uIActivityIndicatorView.removeFromSuperview()
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
                self.collectionView.isUserInteractionEnabled = true
            })
        }
    }
}


extension LikedPostsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var newCell: ICollectionViewCell & UICollectionViewCell
        if viewModel.posts[indexPath.item].postData.image == nil {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .postCellIDText, for: indexPath) as? PostViewCellNoImage else {
                fatalError()
            }
            newCell = cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .postCellID, for: indexPath) as? PostViewCell else {
                fatalError()
            }
            newCell = cell
        }
        newCell.likeBtnAction = { [weak self] in
            self?.viewModel.didTapOnLike(postIndex: indexPath.item) { _ in
                DispatchQueue.main.async(execute: {
                    collectionView.reloadData()
                })
            }
            newCell.pushDetailedPost = { [weak self] in
                self?.viewModel.didTapOnPushDeatiledPost(postIndex: indexPath.item)
            }
        }
        newCell.update(post: viewModel.posts[indexPath.item])
        return newCell
    }
    
    
}

