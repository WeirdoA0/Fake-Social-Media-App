//
//  StartVC.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 14.12.2024.
//

import UIKit

final class StartVC: UIViewController {
    //MARK: Properties
    
    weak var coordinator: IAuthCoordinator?
    
    //MARK: Subviews
    
    private lazy var loginBtn: UIButton = CustomButton(title: "Login", textColor: .white, backgroundImage: .btnBackGround, UiBtnDidTapAction: { [weak self] in
        self?.coordinator?.pushLoginScreen(userData: nil)
    })
    private lazy var signUpBtn: UIButton = CustomButton(title: "Sign up", textColor: .white, backgroundImage: .btnBackGround, UiBtnDidTapAction: { [weak self] in
        self?.coordinator?.pushUserSetupScreen()
    })
    private lazy var btnStack: UIStackView = CustomStack(axis: .vertical, spacing: 10, spaceColor: nil, subviews: [loginBtn, signUpBtn])
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        tuneSubviews()
    }
    
    //MARK: Private
    

    private func layout() {
        self.view.addSubview(btnStack)
        let safe = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            btnStack.centerYAnchor.constraint(equalTo: safe.centerYAnchor),
            btnStack.heightAnchor.constraint(equalToConstant: 220),
            btnStack.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 20),
            btnStack.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -20)
        ])
    }
    
    private func tuneSubviews() {
        view.backgroundColor = .customViewBackGroundColor
        [loginBtn, signUpBtn].forEach({
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 15
        })
        btnStack.clipsToBounds = true
    }
}
