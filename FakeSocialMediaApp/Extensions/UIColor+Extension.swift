//
//  UIColor+Extension.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 27.11.2024.
//

import Foundation
import UIKit

extension UIColor {
    
    static let  customViewBackGroundColor = createColor(lightMode: UIColor.systemGray6, darkMode: UIColor.systemGray)
    static let  customControllerBackGroundColor = createColor(lightMode: UIColor.white, darkMode: UIColor.black)
    static let  customTintColor = createColor(lightMode: UIColor.black, darkMode: UIColor.white)
    static let  customImageBackGrounColor = createColor(lightMode: UIColor.white, darkMode: UIColor.black)
    
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode :
            darkMode
        }
    }
}
