//
//  EditProfileVC.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 14.12.2024.
//

import UIKit

final class EditProfileVC: UIViewController, UINavigationControllerDelegate {
    //MARK: Properties
    
    private var viewModel: EditProfileVM
    
    //MARK: Subviews
    
    private lazy var userNameField = CustomTextField(fontSize: 20, textColor: .customTintColor, textAlignment: .center, backgroundColor: .systemGray5, isSecured: false, placeholder: "Name", delegate: nil)
    private lazy var userStatusField = CustomTextField(fontSize: 15, textColor: .customTintColor, textAlignment: .center, backgroundColor: .systemGray5, isSecured: false, placeholder: "Status", delegate: nil)
    
    private lazy var userAvatarImage = CustomImageView(UIImage: .profile)
    
    private lazy var confirmBtn = CustomButton(title: "Confirm", textColor: .white, backgroundImage: .btnBackGround, UiBtnDidTapAction: { [weak self] in
        guard let self else { return }
        viewModel.finishChanges(newUserData: UserData(id: viewModel.userData?.id ?? "none", name: userNameField.text!, status: userStatusField.text!, image: userAvatarImage.image ?? .profile))
    })
    
    //MARK: LifeCycle
    init(viewModel: EditProfileVM) {
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
        setGesture()
        update(userData: viewModel.userData)
    }

    //MARK: Private
    private func layout() {
        [userNameField ,userNameField, userStatusField, confirmBtn, userAvatarImage].forEach({
            self.view.addSubview($0)
        })
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            userAvatarImage.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            userAvatarImage.heightAnchor.constraint(equalToConstant: 100),
            userAvatarImage.widthAnchor.constraint(equalToConstant: 100),
            userAvatarImage.topAnchor.constraint(equalTo: safe.topAnchor, constant: 10),
            
            userNameField.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            userNameField.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            userNameField.topAnchor.constraint(equalTo: userAvatarImage.bottomAnchor, constant: 20),
            
            userStatusField.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            userStatusField.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            userStatusField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 5),
            
            confirmBtn.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            confirmBtn.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            confirmBtn.topAnchor.constraint(equalTo: userStatusField.bottomAnchor, constant: 40),
            confirmBtn.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func tuneSubviews() {
        view.backgroundColor = .customViewBackGroundColor
        [userNameField ,userNameField, userStatusField, confirmBtn].forEach({
            $0.layer.masksToBounds = true
        })
        
        
        confirmBtn.layer.cornerRadius = 15
        
        userStatusField.layer.cornerRadius = 5
        userNameField.layer.cornerRadius = 7
        
        userAvatarImage.layer.cornerCurve = .circular
    }
    
    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureAction))
        userAvatarImage.addGestureRecognizer(tapGesture)
        userAvatarImage.isUserInteractionEnabled = true
    }
    
    @objc private func gestureAction() {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    private func update(userData: UserData?) {
        guard let userData else { return }
        userNameField.text = userData.name
        userStatusField.text = userData.status
        userAvatarImage.image = userData.image
    }
}

//MARK: ImagePickerDelegate

extension EditProfileVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        userAvatarImage.image = image
    }
}
