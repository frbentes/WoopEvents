//
//  UINavigationController+Extension.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 13/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        var viewControllers: [UIViewController] = self.viewControllers
        viewControllers = viewControllers.reversed()
        for currentViewController in viewControllers {
            if currentViewController .isKind(of: toControllerType) {
                self.popToViewController(currentViewController, animated: true)
                break
            }
        }
    }
    
}
