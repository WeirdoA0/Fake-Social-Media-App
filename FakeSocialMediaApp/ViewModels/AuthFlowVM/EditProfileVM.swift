//
//  EditProfileVM.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 15.12.2024.
//

final class EditProfileVM {
    //MARK: Properties
    
    private var userDataService = UserDataSerivce.shared
    
    var userData: UserData?
    
    weak var coordinator: Coordinator?
    
    init(userData: UserData? = nil, coordinator: Coordinator? = nil) {
        self.userData = userData
        self.coordinator = coordinator
    }
    
    //MARK: Finish Button
    
    func finishChanges(newUserData: UserData){
        if  userData != nil {
            guard let coordinator = coordinator as? IMainFlowCoordinator else { return }
            userDataService.updateUser(newData: newUserData, completion: {
                coordinator.updateProfileVC(userData: newUserData)
            })
        } else {
            guard let coordinator = coordinator as? IAuthCoordinator else { return }
            coordinator.pushLoginScreen(userData: newUserData)
        }
    }
    
}
