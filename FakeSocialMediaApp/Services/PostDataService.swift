//
//  PostDataService.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 28.11.2024.
//
import FirebaseStorage
import FirebaseFirestore


protocol IUserPostDataService {
    func createPost(userID: String, text: String, image: UIImage?, label: String, completion: @escaping(Result<String, Error>) -> Void)
    func getPostData(postID: String, completion: @escaping(Result<Post, Error>) -> Void)
    func getPostIdOfUser(userID: String, completion: @escaping(Result<String, Error>) -> Void)
    func updatePost(newPost: Post, completion: @escaping(Result<String, Error>) -> Void)
    func deletePost(postID: String, completion: @escaping(Error?) -> Void)
}

final class UserPostService: IUserPostDataService {
    
    static let shared = UserPostService()
    
    private let dataBase = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    private init() {}
    

    
    //MARK: Create
    
    func createPost(userID: String, text: String, image: UIImage?, label: String, completion: @escaping(Result<String, Error>) -> Void){
        
        let reference: DocumentReference =  dataBase.collection("posts").document()
        let containsImage: Bool = (image != nil)
      
        let data: [String: Any] = [
            "userID": userID,
            "text": text,
            "labelText": label,
            "containsImage": containsImage,
        ]
        
        reference.setData(data) { [weak self] error in
            if let error {
                completion(.failure(error))
                return
            }
            if let image {
                let imageData = image.pngData()!
                self?.storage.child("image/postImage/\(reference.documentID).png").putData(imageData, completion: {  result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(_):
                        break
                    }
                })
            }
            self?.getPostData(postID: reference.documentID, completion: { result in
                switch result {
                case .success(let data):
                    completion(.success(data.id))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
            }
        self.dataBase.collection("likedPosts").document( reference.documentID).setData(["likers": Array<String>()], merge: true)
    }
    
    //MARK: Read
    
    func getPostData(postID: String, completion: @escaping(Result<Post, Error>) -> Void) {
        dataBase.collection("posts").document(postID).getDocument(completion: { [weak self] document, error in
            guard let self else { return }
            if let error  {
                completion(.failure(error))
                return
            }
            guard let document else  {
                return
            }
                guard let dictionary = document.data() else { return }
                let containtsImage: Bool = dictionary["containsImage"] as? Bool ?? false
                if !containtsImage {
                    completion(.success(Post(dictionary: dictionary, uiImage: nil, id: document.documentID)))
                } else {
                    self.storage.child("image/postImage/\(document.documentID).png").downloadURL(completion: { reuslt in
                            switch reuslt {
                            case .failure(let error):
                                completion(.failure(error))
                            case .success(let url):
                            
                                let request = URLRequest(url: url)
                                self.loadImage(request: request, completion: { image in
                                    completion(.success(Post(dictionary: dictionary, uiImage: image, id: document.documentID)))
                                    
                                })
                            }
                    })
                }
        })
    }
    func getPostIdOfUser(userID: String, completion: @escaping(Result<String, Error>) -> Void) {
        let query = dataBase.collection("posts").whereField("userID", isEqualTo: userID)

        query.getDocuments(completion: {  documents, error in
            if let error {
                completion(.failure(error))
                return
            }
            guard let documents else { return }
            if documents.isEmpty {
                completion(.failure(PostServiceError.emptyDocument))
            }
            documents.documents.forEach({
                completion(.success($0.documentID))
            })
        })
    }
    
    
    //MARK: Update
    
    func updatePost(newPost: Post, completion: @escaping(Result<String, Error>) -> Void){
        let containsImage: Bool = (newPost.image != nil)
        let data: [String: Any] = [
            "text":  newPost.text,
            "labelText": newPost.labelText,
            "containsImage": containsImage
        ]
        dataBase.collection("posts").document(newPost.id).updateData(data)
        if containsImage {
            guard let imageData = newPost.image?.pngData() else { return }
            storage.child("image/postImage/\(newPost.id).png").putData(imageData){ result  in
                switch result {
                case .success(_):
                    break
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        }
        completion(.success(newPost.id))
    }
    //MARK: Delete
    
    func deletePost(postID: String, completion: @escaping(Error?) -> Void) {
        dataBase.collection("posts").document(postID).delete(){ [weak self] error in
            if let error {
                completion(error)
            } else {
                self?.dataBase.collection("likedPosts").document(postID).delete(){ error in
                    if let error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    //MARK: Private
    
    private func loadImage(request: URLRequest, completion: @escaping(UIImage) -> Void){
        DataTaskService.completeRequest(request: request, completion: { result in
            switch result {
            case .failure(_):
                completion(.photoIcon)
                
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completion(.photoIcon)
                    return
                }
                completion(image)
                
                
            }
        })
    }
}

 enum PostDataCollection: String {
    case userID = "userID"
    case text = "text"
}

enum PostServiceError: Error {
    case emptyDocument
    var code: Int {
        switch self {
        case.emptyDocument:
            return 0
        }
    }
}
