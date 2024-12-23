//
//  UserDataSerivce.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 28.11.2024.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage

protocol IUserDataService {
    func createUser(id: String, name: String, status: String, userImage: UIImage, completion: @escaping(Result<UserData, Error>) -> Void)
    func getUserData(id: String, completion: @escaping (Result<UserData, Error>) -> Void)
    func updateUser(newData: UserData, completion: @escaping() -> Void)
    
}

final class UserDataSerivce: IUserDataService {
    
    static let shared = UserDataSerivce()
    
    private let dataBase = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    private init() {}
    
    //MARK: Create
    func createUser(id: String, name: String, status: String, userImage: UIImage, completion: @escaping (Result<UserData, Error>) -> Void) {
        guard let imageData: Data = userImage.pngData() else { return }
         
        let user = [
            "userName": name,
            "userStatus": status,
        ] as [String : Any]
        
        dataBase.collection("users").document(id).setData(user, merge: false){ [weak self] error in
            if let error {
                completion(.failure(error))
                return
            }
            self?.storage.child("image/\(id).png").putData(imageData, completion: { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(_):
                    self?.getUserData(id: id, completion: completion)
                }
            })
        }
    }
    
    //MARK: Read
    
    func getUserData(id: String, completion: @escaping (Result<UserData, Error>) -> Void){
         dataBase.collection("users").document(id).getDocument(completion: { [weak self]document, error in
             guard let self else { return }
             if let error {
                completion(.failure(error))
            } else {
                guard let document  else {
                    print("Unknown error")
                    return }
                guard let data = document.data() else {
                    print("Unknown error")
                    return }
                
                let path: String =  "image/\(id).png"
                
            self.storage.child(path).downloadURL(completion: { reuslt in
                    switch reuslt {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let url):
                    
                        let request = URLRequest(url: url)
                        self.loadImage(request: request, completion: { image in
                            let user = UserData(dictionary: data, uiImage: image, id: document.documentID)
                            completion(.success(user))
                        })
                    }
                })
            }
        })
    }
    //MARK: Update
    func updateUser(newData: UserData, completion: @escaping() -> Void) {

        guard let imageData = newData.image.pngData() else { return }
        
        storage.child("image/\(newData.id).png").putData(imageData, completion: { [weak self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(_):
                    self?.dataBase.collection("users").document(newData.id).updateData([
                        "userName": newData.name,
                        "userStatus": newData.status,
                    ]){ error in
                        if error != nil {
                            return
                        }
                        completion()
                    }
                }
        })
        
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


