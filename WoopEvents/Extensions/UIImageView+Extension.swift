//
//  UIImageView+Extension.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 10/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import Foundation
import Nuke

extension UIImageView {
    
    func load(fromUrl urlString: String, placeholdered: Bool = false, placeholder: UIImage? = nil, hideWhenEmpty: Bool = false, targetSize: CGSize = CGSize(width: 50, height: 50), completion: ((PlatformImage) -> Void)? = nil) {
        guard let url = URL(string: urlString) else {
            if hideWhenEmpty {
                self.isHidden = true
            }
            return
        }
        if placeholdered || placeholder != nil {
            let placeholder = placeholder ?? R.image.ic_placeholder_event()
            let options = ImageLoadingOptions(placeholder: placeholder,
                                              transition: .fadeIn(duration: 0.33))
            let request = ImageRequest(
                url: url,
                processors: [ImageProcessor.Resize(size: targetSize,
                                                   contentMode: .aspectFill)])
            
            Nuke.loadImage(with: request, options: options, into: self) { result in
                switch result {
                case let .success(response):
                    completion?(response.image)
                case .failure(_):
                    break
                }
            }
        } else {
            let request = ImageRequest(
            url: url,
            processors: [ImageProcessor.Resize(size: targetSize,
                                               contentMode: .aspectFill)])
            Nuke.loadImage(with: request, into: self) { result in
                switch result {
                case let .success(response):
                    completion?(response.image)
                case .failure(_):
                    break
                }
            }
        }
    }
    
}
