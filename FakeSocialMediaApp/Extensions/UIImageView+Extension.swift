//
//  CustomAsyncImage.swift
//  FakeSocialMediaApp
//
//  Created by Руслан Усманов on 26.11.2024.
//

import UIKit

extension UIImageView {
    
    func loadImageFromURL(urlString: String, placeholder: UIImage?, failedImage: UIImage?) {
        self.image = placeholder
        guard let url = URL(string: urlString) else {
            self.image = failedImage
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) {data, response, error in
            if error != nil {
                self.image = UIImage(named: "noimage")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else  {
                self.image = failedImage
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data else {
                    self.image = UIImage(named: "noimage")
                    return
                }
                guard let newImage = UIImage(data: data) else {
                    self.image = UIImage(named: "noimage")
                    return
                }
                self.image = newImage
                
            default:
                self.image = failedImage
            }
        }.resume()
        
    }
}
