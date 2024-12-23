//
//  LoginVC.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 14.12.2024.
//

import UIKit

final class LoginVC: UIViewController {
    //MARK: Properties
    
    private var viewModel: LoginVM
    //MARK: Subviews
    
    private lazy var loginField = CustomTextField(fontSize: 20, textColor: .customTintColor, textAlignment: .left, backgroundColor: .systemGray5, isSecured: false, placeholder: "Email", delegate: nil)
    private lazy var passwordField = CustomTextField(fontSize: 20, textColor: .customTintColor, textAlignment: .left, backgroundColor: .systemGray5, isSecured: true, placeholder: "Password", delegate: nil)
    private lazy var fieldStack = CustomStack(axis: .vertical, spacing: 5, spaceColor: nil, subviews: [loginField, passwordField])
    
    private lazy var confirmBtn = CustomButton(title: "Confirm", textColor: .white, backgroundImage: .btnBackGround, UiBtnDidTapAction: { [weak self] in
        guard let self else { return }
        buttonAction()
    })
    
    //MARK: LifeCycle
    init(viewModel: LoginVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        tuneSubviews()
    }
    
    //MARK: Private
    private func layout(){
        [fieldStack, confirmBtn].forEach({
            view.addSubview($0)
        })
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            fieldStack.centerYAnchor.constraint(equalTo: safe.centerYAnchor, constant: -60),
            fieldStack.heightAnchor.constraint(equalToConstant: 95),
            fieldStack.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            fieldStack.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            
            confirmBtn.topAnchor.constraint(equalTo: fieldStack.bottomAnchor, constant: 20),
            confirmBtn.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            confirmBtn.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            confirmBtn.heightAnchor.constraint(equalToConstant: 100),
            
        ])
    }
    
    private func tuneSubviews(){
        view.backgroundColor = .customViewBackGroundColor
        [loginField, passwordField, confirmBtn].forEach({
            $0.layer.masksToBounds = true
        })
        [loginField,passwordField].forEach({
            $0.layer.cornerRadius = 5
            $0.autocapitalizationType = .none
        })
        
        confirmBtn.layer.cornerRadius = 15
    }
    private func buttonAction(){
        DispatchQueue.main.async { [weak self] in
            self?.view.isUserInteractionEnabled = false
            self?.navigationController?.navigationBar.isUserInteractionEnabled = false
        }
         
        viewModel.pressButton(login: loginField.text!, password: passwordField.text!, completion: { [weak self] error in
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = true
                self?.navigationController?.navigationBar.isUserInteractionEnabled = true
                print(error)
            }
        })
    }
}
