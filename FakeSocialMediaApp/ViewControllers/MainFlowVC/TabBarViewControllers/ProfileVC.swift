//
//  ProfileVC.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 14.12.2024.
//

import UIKit

final class ProfileVC: UIViewController {
    //MARK: Properties
    
    private var viewModel: ProfileVM
    
    private var updateHeaderClosure: ((UserData) -> Void)?
    
    //MARK: Subviews
    private lazy var collectionView = CustomCollectionView(configureHeader: true, dataSource: self)
    
    private var uIActivityIndicatorView: UIActivityIndicatorView?
    
    //MARK: Init
    
    init(viewModel: ProfileVM) {
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
        loadPosts()
        view.backgroundColor = .customControllerBackGroundColor
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
        
        if viewModel.posts.isEmpty {
           uIActivityIndicatorView = UIActivityIndicatorView(style: .large)
            DispatchQueue.main.async(execute: { [weak self] in
                guard let self else { return }
                view.addSubview(uIActivityIndicatorView ?? UIView())
                uIActivityIndicatorView?.center = view.center
                uIActivityIndicatorView?.startAnimating()
            })
        }
        
        viewModel.loadPosts() { [weak self] error in
            guard let self else { return }
            guard error == nil else {
                print(error ?? "Unknown error")
                return
            }
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
                self.uIActivityIndicatorView?.removeFromSuperview()
            })
        }
    }
    
    //MARK: Internal
    func updateHeader(userData: UserData){
        guard let updateHeaderClosure else { return }
        updateHeaderClosure(userData)
    }
}

//MARK: DataSource

extension ProfileVC: UICollectionViewDataSource {
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
                collectionView.reloadItems(at: [indexPath])
            }
        }
        newCell.editAction = { [weak self] in
            
            self?.presentActionSheetForPostManage(
                editAction: {
                    self?.viewModel.didTapOnChangePost(index: indexPath.item) { error in
                        guard error == nil else { return}
                        collectionView.reloadItems(at: [indexPath])
                    }
            },
                deleteAction: {
                    self?.viewModel.deletePost(index: indexPath.item, completion: { error in
                        guard error == nil else { return}
                        collectionView.reloadData()
                    })
            })
        }
        newCell.pushDetailedPost = { [weak self] in
            self?.viewModel.didTapOnPushDeatiledPost(postIndex: indexPath.item)
        }
        newCell.update(post: viewModel.posts[indexPath.item])
        newCell.setupEditButton()
        return newCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: .headerCellID, for: indexPath) as! ProfileHeader
        header.editAction =  { [weak self] in
            self?.viewModel.didTapOnChnageProfile() }
        header.newPostAction = { [weak self] in
            self?.viewModel.didTapOnCreatePost{ error in
                collectionView.reloadData()
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
        header.update(userData: CurrentUserManager.getData())
        
        self.updateHeaderClosure = header.update(userData:)
        
        return header
    }
    
}
