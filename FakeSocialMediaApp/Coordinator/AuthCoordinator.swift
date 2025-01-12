//
//  AuthCoordinator.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 28.11.2024.
//

import UIKit

protocol IAuthCoordinator: Coordinator {
    func pushLoginScreen(userData: UserData?)
    func pushUserSetupScreen()
    func finishFlow(userData: UserData)

}

final class AuthCoordinator: IAuthCoordinator {
    
    var navigationVC: UINavigationController
    weak var parentCoordinator: Coordinator? = nil
    var childCoordinator = [String: Coordinator]()
    
    lazy var finishFlow: ((UserData) -> Void) = { [weak self]  userData in
        guard let self else { return }
        (self.parentCoordinator?.childCoordinator[.profileFlow] as? MainFlowCoordinator)?.setupViewControllers(userData: userData)
        self.parentCoordinator?.childCoordinator.removeValue(forKey: .authFlow)
        self.parentCoordinator = nil
    }
    
    init(navigationVC: UINavigationController, parent: Coordinator? = nil) {
        self.navigationVC = navigationVC
        self.parentCoordinator = parent
    }
    func start() {
        let vc = StartVC()
        vc.coordinator = self
        self.navigationVC.pushViewController(vc, animated: false)
        self.parentCoordinator?.navigationVC.setViewControllers(navigationVC.viewControllers, animated: false)
    }
    func pushUserSetupScreen() {
        let viewModel = EditProfileVM(userData: nil, coordinator: self)
        let editVC = EditProfileVC(viewModel: viewModel)
        self.parentCoordinator?.navigationVC.pushViewController(editVC, animated: true)
    }
    func pushLoginScreen(userData: UserData?) {
        let viewModel = LoginVM(coordinator: self, userData: userData)
        let loginVC = LoginVC(viewModel: viewModel)
        parentCoordinator?.navigationVC.pushViewController(loginVC, animated: true)
    }
    
    func finishFlow(userData: UserData) {
        (self.parentCoordinator?.childCoordinator[.profileFlow] as? MainFlowCoordinator)?.setupViewControllers(userData: userData)
        self.parentCoordinator?.clearChildCoordinator(coordinatorKey: .authFlow)
    }
}
