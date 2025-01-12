//
//  Coordinator.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 28.11.2024.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationVC: UINavigationController { get set}
    var childCoordinator: [String: Coordinator]  {get set}
    var parentCoordinator: Coordinator? {get set}
    func start()
}
extension Coordinator {
    func clearChildCoordinator(coordinatorKey: String) {
        self.childCoordinator[coordinatorKey]?.parentCoordinator = nil
        self.childCoordinator.removeValue(forKey: coordinatorKey)
    }
    
}

