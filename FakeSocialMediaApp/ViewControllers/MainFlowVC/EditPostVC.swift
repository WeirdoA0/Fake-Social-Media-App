//
//  EditPostVC.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 14.12.2024.
//

import UIKit

final class EditPostVC: UIViewController, UINavigationControllerDelegate  {
    //MARK: Properties
    
    weak var coordinator: IMainFlowCoordinator?
    
    var confirmDidTap: ((String) ->Void)?
    
    private var viewModel: EditPostVM
    
    private var imageHeightConstraint: NSLayoutConstraint?
    
    //MARK: Subviews
    private lazy var scrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var postImage = CustomImageView(UIImage: nil)
    private lazy var postTitleField = CustomTextField(fontSize: 25, textColor: .customTintColor, textAlignment: .center, backgroundColor: .systemGray5, isSecured: false, placeholder: "Title", delegate: nil)
    private lazy var postTextField: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        textView.backgroundColor = .systemGray5
        textView.isScrollEnabled = false
        textView.text = "Text"
        textView.textContainer.maximumNumberOfLines = 0
        return textView
    }()
    private lazy var attachImageButton = CustomButton(title: "Attach image", textColor: .customTintColor, UiBtnDidTapAction: { [weak self] in
        guard let self else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
        
    })

    private lazy var confirmBtn = CustomButton(title: "Confirm", textColor: .white, backgroundImage: .btnBackGround, UiBtnDidTapAction: { [weak self] in
        guard let self else { return }
        didTapOnFinish()
    })
    
    //MARK: Init
    
    init(viewModel: EditPostVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        tuneSubviews()
        setGesture()
        update(post: viewModel.post)
        print(postTextField.frame)
    }
    //MARK: Private
    
    private func layout(){
        [scrollView, confirmBtn].forEach({
            view.addSubview($0)
        })
        
        
        [postImage, postTextField, postTitleField, attachImageButton].forEach({
            scrollView.addSubview($0)
        })
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 4),
            scrollView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -130),
            
            confirmBtn.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            confirmBtn.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            confirmBtn.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 10),
            confirmBtn.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: 10),
            
            
            postTitleField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            postTitleField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            postTitleField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            postTitleField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            postTitleField.heightAnchor.constraint(equalToConstant: 25),
            
            attachImageButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            attachImageButton.topAnchor.constraint(equalTo: postTitleField.bottomAnchor, constant: 10),
            attachImageButton.heightAnchor.constraint(equalToConstant: 20),
            
            postImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            postImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            postImage.heightAnchor.constraint(equalToConstant: 0),
            postImage.topAnchor.constraint(equalTo: postTitleField.bottomAnchor, constant: 10),
            
            postTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            postTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            postTextField.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 25),
            postTextField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        imageHeightConstraint = postImage.heightAnchor.constraint(equalToConstant: 0)
        imageHeightConstraint?.isActive = true
    }
    
    private func tuneSubviews() {
        scrollView.showsHorizontalScrollIndicator = false
        view.backgroundColor = .customViewBackGroundColor
        [postTextField, postTitleField].forEach({
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 10
        })
        postImage.layer.masksToBounds = true
        postImage.layer.cornerRadius = 25
        
        confirmBtn.layer.masksToBounds = true
        confirmBtn.layer.cornerRadius = 15
    }
    
    //MARK: Set Gesutre
    
    private func setGesture() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureAction))
        self.postImage.addGestureRecognizer(gestureRecognizer)
        self.postImage.isUserInteractionEnabled = false
    }
    
    @objc private func gestureAction(){
        self.presentActionSheetForPostManage(editAction: {
            let picker = UIImagePickerController()
            picker.delegate = self
            self.present(UIImagePickerController(), animated: true)
        }, deleteAction: { [weak self] in
            guard let self else { return }
            postImage.image = nil
            imageHeightConstraint?.constant = 0
            postImage.layoutIfNeeded()
            postTextField.layoutIfNeeded()
            
            attachImageButton.isUserInteractionEnabled = true
            attachImageButton.isHidden = false
        })
    }
    
    //MARK: Update
    
    private func update(post: Post?){
        guard let post else { return }
        postTextField.text = post.text
        postTitleField.text = post.labelText
        if let image = post.image {
            postImage.image = image
            imageHeightConstraint?.constant = (view.frame.width - 32)/4*3
            postImage.layoutIfNeeded()
            postImage.isUserInteractionEnabled = true
            attachImageButton.isUserInteractionEnabled = false
            attachImageButton.isHidden = true
        }
    }
    
    //MARK: Interactive
    private func didTapOnFinish(){
        guard let confirmDidTap else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.view.isUserInteractionEnabled = false
            self?.navigationController?.isNavigationBarHidden = true
        }
        
        let newPostData = Post(
            id: viewModel.post?.id ?? "none",
            authorId: CurrentUserManager.getData().id,
            text: postTextField.text!,
            image: postImage.image,
            labelText: postTitleField.text!)
        
        viewModel.finishChanges(newPostData: newPostData) {  result in
            switch result {
            case .success(let id):
                confirmDidTap(id)
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.view.isUserInteractionEnabled = true
                    self?.navigationController?.isNavigationBarHidden = false
                    print(error)
                }
            }
        }
    }
    

}

//MARK: Image Picker Delegate

extension EditPostVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        postImage.image = image
        imageHeightConstraint?.constant = (view.frame.width - 32)/4*3
        postImage.layoutIfNeeded()
        postImage.isUserInteractionEnabled = true
        attachImageButton.isUserInteractionEnabled = false
        attachImageButton.isHidden = true
    }
}
