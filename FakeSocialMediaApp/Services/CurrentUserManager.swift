//
//  CurrentUserManager.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 03.12.2024.
//

final class CurrentUserManager {
    private(set) var userData: UserData
    
    
    private static var shared: CurrentUserManager?
    
    static func createInstance(userData: UserData) {
        if shared != nil {
            return
        } else {
            shared = CurrentUserManager(userData: userData)
        }
    }
    
    static func getData() -> UserData {
        if let shared = self.shared {
            return shared.userData
        } else {
            return UserData(id: "None", name: "Invalid", status: "", image: .profile)
        }
    }
    
    static func updateUserData(userData: UserData) {
        self.shared = CurrentUserManager(userData: userData)
    }
    
    private init(userData: UserData) {
        self.userData = userData

    }
}
