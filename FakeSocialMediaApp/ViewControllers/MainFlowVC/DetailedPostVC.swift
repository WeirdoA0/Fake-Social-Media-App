//
//  DetailedPostVC.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 25.12.2024.
//


import UIKit

final class DetailedPostVC: UIViewController {
    private var headerLabel: UILabel = CustomLabel(text: "", textColor: .customTintColor, fontSize: 20, alignment: .left)
    private var imageView: UIImageView = CustomImageView(UIImage: nil)
    private var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        textView.textColor = .customTintColor
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .customViewBackGroundColor
    }
    
    //MARK: Private
    private func setConstraints(){
        let safe = self.view.safeAreaLayoutGuide
        [headerLabel,textView].forEach({
            self.view.addSubview($0)
        })
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
        ])
        
        if imageView.image != nil {
            self.view.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
                imageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
                imageView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
                imageView.heightAnchor.constraint(equalTo: safe.widthAnchor, multiplier: 1/2, constant: -32),
                
                textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16)
            ])
        } else {
            textView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16).isActive = true
        }
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: 16),
        ])
    }
    
    //MARK: Internal
    
    func prepareVC(headerText: String, mainText: String, image: UIImage?){
        headerLabel.text = headerText
        textView.text = mainText
        imageView.image = image
        
        setConstraints()
    }
}
