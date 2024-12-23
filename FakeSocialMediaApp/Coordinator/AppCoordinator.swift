//
//  AppCoordinator.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 28.11.2024.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationVC: UINavigationController
    var parentCoordinator: Coordinator? = nil
    var childCoordinator = [String: Coordinator]()
    
    init(navigationVC: UINavigationController) {
        self.navigationVC = navigationVC
        childCoordinator[.authFlow] = AuthCoordinator(navigationVC: UINavigationController(), parent: self)
        childCoordinator[.profileFlow] = MainFlowCoordinator(navigationVC: UINavigationController(), parent: self)
    }
    
    func start() {
        self.childCoordinator[.authFlow]?.start()
    }
}
