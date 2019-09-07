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
 This extension allow to easily load image from an url
 This break the single responsibility principle but it is very useful on a small application like that.
 In a bigger application, this kind of solution should be discussed and probably avoid.
 */
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
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
