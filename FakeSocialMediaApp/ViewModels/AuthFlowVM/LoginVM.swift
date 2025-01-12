//
//  LoginVM.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 16.12.2024.
//
import FirebaseAuth

final class LoginVM {
    //MARK: Properties
    
    private var userDataService = UserDataSerivce.shared
    
    weak var coordinator: IAuthCoordinator?
    
    private var userData: UserData?
    
    init(coordinator: IAuthCoordinator? = nil, userData: UserData? = nil) {
        self.coordinator = coordinator
        self.userData = userData
    }
    
    //MARK: Methods
    
    func pressButton(login: String, password: String, completion: @escaping(Error) -> Void){
        if userData != nil {
            signUp(login: login, password: password, completion: completion)
        } else {
            singIn(login: login, password: password, completion: completion)
        }
    }
    
    private func singIn(login: String, password: String, completion: @escaping(Error) -> Void) {
        Auth.auth().signIn(withEmail: login, password: password, completion: { [weak self] result, error in
            guard let self else { return }
            if let error {
                completion(error)
            }
            if let result {
                userDataService.getUserData(id: result.user.uid, completion: { result in
                    self.handleResult(result: result, completion: completion)
                })
            }
        })
    }
    
    private func signUp(login: String, password: String,  completion: @escaping(Error) -> Void) {
        guard let userData else { return }
        Auth.auth().createUser(withEmail: login, password: password, completion: { [weak self] result, error in
            guard let self else { return }
            if let error {
                completion(error)
            }
            if let result {
                userDataService.createUser(id: result.user.uid, name: userData.name, status: userData.status, userImage: userData.image, completion: { result in
                    self.handleResult(result: result, completion: completion)
                })
            }
        })
    }
    
    private func handleResult(result: Result<UserData, Error>, completion: @escaping(Error) -> Void) {
        switch result {
        case .success(let userData):
            DispatchQueue.main.async { [weak self] in
                self?.coordinator?.finishFlow(userData: userData)
            }
        case .failure(let error):
            completion(error)
        }
    }
    
}
