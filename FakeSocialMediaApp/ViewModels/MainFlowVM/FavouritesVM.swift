//
//  FavouritesVM.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 21.12.2024.
//

final class FavouritesVM {
    
    private var postService = UserPostService.shared
    private var likeService = LikedPostService.shared
    private var postLoader = PostCellLoader.shared
    private var userData = CurrentUserManager.getData()
    
    var posts = [PostCell]()
    
    weak var coordinator: IMainFlowCoordinator?
    
    //MARK: Load
    
    func loadPosts(completion: @escaping(Error?) -> Void){
        likeService.getMostPopularPosts(numberOfPosts: 20) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let idArray):
                postLoader.loadPostCells(postIDs: idArray, currentUserID: userData.id) {  result in
                    switch result {
                    case .success(let posts):
                        self.posts = posts.sorted(by: { $0.likeData.numberOfLikes > $1.likeData.numberOfLikes})
                        completion(nil)
                    case .failure(let error):
                        completion(error)
                    }
                }
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    //MARK: Like button
    
    func didTapOnLike(postIndex: Int, completion: @escaping(Error?) -> Void) {
        let postID = posts[postIndex].postData.id
        let isLiked = posts[postIndex].likeData.userLikedPost
        
        if !isLiked {
            likeService.likePost(userID: userData.id, postID: postID) { [weak self] error in
                guard let self else { return }
        
                guard error == nil else { print(error ?? "Unknown error"); return}
                
                likeService.likePost(userID: userData.id, postID: postID) {  error in
                    guard error == nil else { print(error ?? "Unknown error"); return}
                    self.likeService.getNumberOfLikes(postID: postID, userID: self.userData.id) { result in
                        self.handleResult(postIndex: postIndex, result: result, completion: completion)
                    }
                }
            }
        } else {
            likeService.unlikePost(userID: userData.id, postID: postID) { [weak self] error in
                guard let self else { return }
                guard error == nil else { print(error ?? "Unknown error"); return}
                likeService.getNumberOfLikes(postID: postID, userID: userData.id) { result in
                    self.handleResult(postIndex: postIndex, result: result, completion: completion)
                }
            }
        }
    }
    private func handleResult(postIndex: Int, result: Result<PostLikesData, Error>, completion: @escaping(Error?) -> Void) {
        switch result {
        case .success(_):
            loadPosts(completion: completion)
            completion(nil)
        case .failure(let error):
            completion(error)
        }
    }
    //MARK: Detailed Post
    
    func didTapOnPushDeatiledPost(postIndex: Int){
        let postData = posts[postIndex].postData
        coordinator?.pushDetailVC(headerText: postData.labelText, text: postData.text, image: postData.image)
    }
    
    
}
