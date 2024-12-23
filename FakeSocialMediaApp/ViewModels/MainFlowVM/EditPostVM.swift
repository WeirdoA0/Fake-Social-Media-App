//
//  EditPostVM.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 18.12.2024.
//

final class EditPostVM {
    
    weak var coordinator: IMainFlowCoordinator?
    
    private var postService = UserPostService.shared
    
    var post: Post?
    
    init(post: Post? = nil) {
        self.post = post
    }
    
    func finishChanges(newPostData: Post, completion: @escaping (Result<String, Error>) -> Void) {
        if post != nil {
            postService.updatePost(newPost: newPostData) {  result in
                completion(result)
            }
        } else {
            postService.createPost(
                userID:newPostData.authorId,
                text: newPostData.text,
                image: newPostData.image,
                label: newPostData.labelText) { result in
                completion(result)
            }
        }
    }
}
