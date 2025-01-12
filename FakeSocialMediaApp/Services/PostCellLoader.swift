//
//  PostCellLoader.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 01.12.2024.
//

import Foundation

protocol IPostLoader {
    func loadPostCell(postID: String, currentUserID: String, completion: @escaping(Result<PostCell, Error>) -> Void)
    func loadPostCells(postIDs: [String], currentUserID: String, completion: @escaping(Result<[PostCell], Error>) -> Void)
}

class PostCellLoader: IPostLoader {
    
    static let shared = PostCellLoader()
    
    private var likeService: ILikedPostService = LikedPostService.shared
    private var userDataService: IUserDataService =  UserDataSerivce.shared
    private var postDataService: IUserPostDataService = UserPostService.shared
    
    private init(){}
    
    func loadPostCell(postID: String, currentUserID: String, completion: @escaping(Result<PostCell, Error>) -> Void) {
        postDataService.getPostData(postID: postID, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let post):
                userDataService.getUserData(id: post.authorId, completion: {  result in
                    switch result {
                    case .success(let userData):
                        self.likeService.getNumberOfLikes(postID: postID, userID: currentUserID, completion: { result in
                            switch result {
                            case .success(let likes):
                                let cell = PostCell(postData: post, userData: userData, likeData: likes)
                                completion(.success(cell))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        })
                    case .failure(let error):
                        completion(.failure(error))
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            }
            
        })
    }
    func loadPostCells(postIDs: [String], currentUserID: String, completion: @escaping (Result<[PostCell], any Error>) -> Void) {
        let group = DispatchGroup()
        var workItems = [DispatchWorkItem]()
        var array = [PostCell]()
        
        postIDs.forEach({ postID in
            let workItem = DispatchWorkItem(block: { [weak self] in
                guard let self else { return }
                postDataService.getPostData(postID: postID, completion: { result in
                    switch result {
                    case .success(let post):
                        self.userDataService.getUserData(id: post.authorId, completion: {  result in
                            switch result {
                            case .success(let userData):
                                self.likeService.getNumberOfLikes(postID: postID, userID: currentUserID, completion: { result in
                                    switch result {
                                    case .success(let likes):
                                        let cell = PostCell(postData: post, userData: userData, likeData: likes)
                                        array.append(cell)
                                        group.leave()
                                    case .failure(let error):
                                        completion(.failure(error))
                                        group.leave()
                                    }
                                })
                            case .failure(let error):
                                completion(.failure(error))
                                group.leave()
                            }
                        })
                    case .failure(let error):
                        completion(.failure(error))
                        group.leave()
                    }
                })
            })
            workItems.append(workItem)
        })
        workItems.forEach({
            group.enter()
            DispatchQueue.global().async(group: group, execute: $0)
        })
        group.notify(queue: DispatchQueue.global(), execute: {
            completion(.success(array))
        })
    }
}
