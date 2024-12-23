//
//  UIVC+Extension.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 27.11.2024.
//
import UIKit

extension UIViewController {
    func presentActionSheetForPostManage(editAction: @escaping() -> Void, deleteAction: @escaping() -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: {_ in
            editAction()
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            deleteAction()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        })
        [cancelAction ,editAction, deleteAction].forEach({
            alert.addAction($0)
        })
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
}
