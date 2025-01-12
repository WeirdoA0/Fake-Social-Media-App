//
//  MainCoordinator.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 28.11.2024.
//
import UIKit
import Foundation

protocol IMainFlowCoordinator: Coordinator {
    func setupViewControllers(userData: UserData)
    func pushPostEditVC(post: Post?, didFinishCompletion: @escaping(String) -> Void)
    func updateProfileVC(userData: UserData)
    func pushDetailVC(headerText: String, text: String, image: UIImage?)
    func pushUserSetupScreen(userData: UserData)

}

final class MainFlowCoordinator: IMainFlowCoordinator {
    
    
    var navigationVC: UINavigationController
    var parentCoordinator: Coordinator? = nil
    var childCoordinator = [String: Coordinator]()
    
    
    init(navigationVC: UINavigationController, parent: Coordinator? = nil) {
        self.navigationVC = navigationVC
        self.parentCoordinator = parent
    }
    
    func setupViewControllers(userData: UserData) {
        CurrentUserManager.createInstance(userData: userData)
        let profileVM = ProfileVM()
        let profileVC = ProfileVC(viewModel: profileVM)
        let LikeVM = LikedPostsVM()
        let likedPostsVC = LikedPostsVC(viewModel: LikeVM)
        let favouritesVM = FavouritesVM()
        let favouriteVC = FavouritesVC(viewModel: favouritesVM)
        profileVM.coordinator = self
        LikeVM.coordinator = self
        favouritesVM.coordinator = self

            
            likedPostsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 2)
            profileVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
            favouriteVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
            let viewControllers = [favouriteVC, profileVC, likedPostsVC].map{
                UINavigationController(rootViewController: $0)
            }
            let tabBar = UITabBarController()
            tabBar.viewControllers = viewControllers
            tabBar.selectedIndex = 1
            navigationVC.setViewControllers([tabBar], animated: false)
            start()
    }
    
    
    func start() {
        self.parentCoordinator?.navigationVC.setViewControllers(navigationVC.viewControllers, animated: true)
        self.parentCoordinator?.navigationVC.setNavigationBarHidden(false, animated: false)
    }
    
    func pushPostEditVC(post: Post?, didFinishCompletion: @escaping(String) -> Void) {
        let viewModel = EditPostVM(post: post)
        let vc = EditPostVC(viewModel: viewModel)
        vc.confirmDidTap = didFinishCompletion
        viewModel.coordinator = self
        self.parentCoordinator?.navigationVC.pushViewController(vc, animated: true)
    }
    func pushUserSetupScreen(userData: UserData) {
        let viewModel = EditProfileVM(userData: userData, coordinator: self)
        let vc = EditProfileVC(viewModel: viewModel)
        self.parentCoordinator?.navigationVC.pushViewController(vc, animated: true)
    }
    func updateProfileVC(userData: UserData) {
        CurrentUserManager.updateUserData(userData: userData)
        ((self.parentCoordinator?.navigationVC.viewControllers.first as? UITabBarController)?.viewControllers?[1] as? ProfileVC)?.updateHeader(userData: userData) 
        self.parentCoordinator?.navigationVC.popToRootViewController(animated: true)
    }

    
    func pushDetailVC(headerText: String, text: String, image: UIImage?) {
        let vc = DetailedPostVC()
        vc.prepareVC(headerText: headerText, mainText: text, image: image)
        self.parentCoordinator?.navigationVC.pushViewController(vc, animated: true)
    }
}
