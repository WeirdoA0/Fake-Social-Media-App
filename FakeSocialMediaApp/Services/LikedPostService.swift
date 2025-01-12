//
//  LikedPostService.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 28.11.2024.
//

import FirebaseFirestore

protocol ILikedPostService {
    func likePost(userID: String, postID: String, completion: @escaping(Error?) -> Void)
    func unlikePost(userID: String, postID: String, completion: @escaping(Error?) -> Void)
    func getNumberOfLikes(postID: String, userID: String?, completion: @escaping(Result< PostLikesData, Error>) -> Void)
    func getMostPopularPosts(numberOfPosts: Int, completion: @escaping(Result<[String], Error>) -> Void)
    func getPostsLikedByUser(userID: String, completion: @escaping(Result<[String], Error>) -> Void)
    func delete(postID: String, completion: @escaping(Error?) -> Void)
}

final class LikedPostService: ILikedPostService {
    
    static let shared = LikedPostService()
    
    private init() {}
    
    private let dataBase = Firestore.firestore()
    
    //MARK: Like/Unlike
    
    func likePost(userID: String, postID: String, completion: @escaping(Error?) -> Void) {
        dataBase.collection("likedPosts").document(postID).updateData(["likers": FieldValue.arrayUnion([userID])]) { error in
            if let error {
            completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    
    func unlikePost(userID: String, postID: String, completion: @escaping(Error?) -> Void){
        dataBase.collection("likedPosts").document(postID).updateData([
            "likers": FieldValue.arrayRemove([userID])
        ]){error in
            if let error {
            completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    //MARK: Get data for likes
    
    func getNumberOfLikes(postID: String, userID: String?, completion: @escaping(Result<PostLikesData, Error>) -> Void) {
        getArrayOfLikers(postID: postID, completion: { result in
            switch result {
            case .failure(let error):
                    completion(.failure(error))
                    return
            case .success(let array):
                let number = array.count
                var bool: Bool
                if let userID{
                    bool = array.contains(where: {
                        $0 == userID
                    })
                } else {
                    bool = false }
                
                    completion(.success(PostLikesData(userLikedPost: bool, numberOfLikes: number)))
                }
            })
    }
    func getMostPopularPosts(numberOfPosts: Int, completion: @escaping(Result<[String], Error>) -> Void){
        dataBase.collection("likedPosts").getDocuments { [weak self] query, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            if let query {
                var dictionary = [String: Int]()
                var blocks = [DispatchWorkItem]()
                let group = DispatchGroup()
                query.documents.forEach({ document in
                    let disptachWorkItem = DispatchWorkItem(block: {
                        self?.getNumberOfLikes(postID: document.documentID, userID: nil, completion: { result in
                            switch result {
                            case .failure(let error):
                                completion(.failure(error))
                                group.leave()
                                return
                            case .success(let value):
                                dictionary[document.documentID] = value.numberOfLikes
                                group.leave()
                            }
                        })
                    })
                    blocks.append(disptachWorkItem)
                })
                blocks.forEach({
                    group.enter()
                    DispatchQueue.global().async(group: group, execute: $0)
                })
                group.notify(queue:   DispatchQueue.global(), execute: {
                    let number = numberOfPosts > query.count ? query.count : numberOfPosts
                    if number > 0 {
                        let array = Array<String>(dictionary.keys.sorted(by: >)[0...number-1])
                        completion(.success(array))
                    } else {
                        completion(.success([]))
                    }
                })
            }
        }
    }
    
    //MARK: Liked by user
    
    func getArrayOfLikers(postID: String, completion: @escaping(Result<[String], Error>) -> Void) {
        dataBase.collection("likedPosts").document(postID).getDocument(completion: { document, error in
            if let error {
                completion(.failure(error))
                return
            }
            if let document {
                if let likers: [String] = document.data()?["likers"] as? [String] {
                    completion(.success(likers))
                } else {
                    completion(.success([]))
                }
            }
        })
    }
    func getPostsLikedByUser(userID: String, completion: @escaping(Result<[String], Error>) -> Void) {
        dataBase.collection("likedPosts").whereField("likers", arrayContains: userID).getDocuments(completion: { query, error in
            if let error {
                completion(.failure(error))
                return
            }
            if let query {
                completion(.success(query.documents.map({
                    $0.documentID
                }))
            )}
            
        })
    }
    
    //MARK: Delete
    
    func delete(postID: String, completion: @escaping(Error?) -> Void) {
        dataBase.collection("likedPosts").document(postID).delete(completion: completion)
    }

}
