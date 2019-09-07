//
//  UIView+Extensions.swift
//  UBCodingChallenge
//
//  Created by Etienne Mercier on 07/09/2019.
//  Copyright © 2019 Etienne Mercier. All rights reserved.
//

import Foundation
import UIKit

/**
 This extension allow to easily load image from an url and store it using NSCache
 This break the single responsibility principle but it is very useful on a small application like that.
 In a bigger application, this kind of solution should be discussed and probably avoid.
 */
extension UIImageView {
    static var cache: NSCache<NSString, UIImage> = NSCache()
    
    func load(url: URL) {
        let cachedImage = UIImageView.cache.object(forKey: url.absoluteString as NSString)
        if  cachedImage != nil {
            UIView.transition(with: self,
                              duration:0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.image = cachedImage },
                              completion: nil)
            return;
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    UIImageView.cache.setObject(image, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        UIView.transition(with: self,
                                          duration:0.5,
                                          options: .transitionCrossDissolve,
                                          animations: { self.image = image },
                                          completion: nil)
                    }
                }
            }
        }
    }
}
