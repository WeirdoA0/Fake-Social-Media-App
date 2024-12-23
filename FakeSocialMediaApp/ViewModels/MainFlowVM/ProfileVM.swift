//
//  ProfileVM.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 16.12.2024.
//

final class ProfileVM {
    
    weak var coordinator: IMainFlowCoordinator?
    
    private var userDataService = UserDataSerivce.shared
    private var postService = UserPostService.shared
    private var likeService = LikedPostService.shared
    private var postLoader = PostCellLoader.shared
    private var userData = CurrentUserManager.getData()
    
    
    var posts: [PostCell] = []
    
    func loadPosts(completion: @escaping(Error?) -> Void){
        postService.getPostIdOfUser(userID: userData.id, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let postID):
                postLoader.loadPostCell(postID: postID, currentUserID: userData.id, completion: { result in
                    switch result {
                    case .success(let post):
                        self.posts.append(post)
                        completion(nil)
                    case .failure(let error):
                        completion(error)
                    }
                })
            case .failure(let error):
                completion(error)
            }
        })
    }
    
    func didTapOnChnageProfile(){
        coordinator?.pushUserSetupScreen(userData: userData)
    }
    //MARK: LikeButton
    
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
        case .success(let likeData):
            posts[postIndex].likeData = likeData
            completion(nil)
        case .failure(let error):
            completion(error)
        }
    }
    
    //MARK: Post Update/Create
    
    func didTapOnChangePost(index: Int, completion: @escaping(Error?) -> Void){
        let post = posts[index].postData
        coordinator?.pushPostEditVC(post: post) { [weak self] id in
            guard let self else { return }
            postLoader.loadPostCell(postID: id, currentUserID: userData.id) { result in
                switch result {
                case .success(let postCell):
                    self.posts[index] = postCell
                    completion(nil)
                    self.coordinator?.parentCoordinator?.navigationVC.popToRootViewController(animated: true)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
    
    func deletePost(index: Int,  completion: @escaping(Error?) -> Void){
        let postID = posts[index].postData.id
        likeService.delete(postID: postID) { [weak self] error in
            guard let self else { return }
            guard error == nil else { return }
            postService.deletePost(postID: postID, completion: completion)
        }
        
    }
    
    func didTapOnCreatePost(completion: @escaping(Error?) -> Void){
        coordinator?.pushPostEditVC(post: nil) { [weak self] id in
            guard let self else { return }
            postLoader.loadPostCell(postID: id, currentUserID: userData.id) { result in
                switch result {
                case .success(let postCell):
                    self.posts.append(postCell)
                    completion(nil)
                    self.coordinator?.parentCoordinator?.navigationVC.popToRootViewController(animated: true)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
    
    //MARK: Detailed Post
    
    func didTapOnPushDeatiledPost(postIndex: Int){
        let postData = posts[postIndex].postData
        coordinator?.pushDetailVC(headerText: postData.labelText, text: postData.text, image: postData.image)
    }
    
}

