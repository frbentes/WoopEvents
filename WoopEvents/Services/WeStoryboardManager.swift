//
//  WeStoryboardManager.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 12/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import UIKit

public class WeStoryboardManager {
    private static var storyboardInstances: [String: UIStoryboard] = [:]
    
    public static func getStoryboard(withName name: String) -> UIStoryboard {
        if let storyboard = storyboardInstances[name] {
            return storyboard
        }
        
        let storyboard = UIStoryboard.init(name: name, bundle: nil)
        storyboardInstances[name] = storyboard
        
        return storyboard
    }
    
    public static func instanceViewController<T>(fromStoryboard storyboardName: String,
                                                 withIdentifier viewControllerIdentifier: String) -> T where T: UIViewController {
        let storyboard = getStoryboard(withName: storyboardName)
        return storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! T
    }
    
    public static func instanceViewController<T>() -> T where T: UIViewController, T: WeStoryboardViewController {
        let identifier = String(describing: T.self)
        let vc: T = instanceViewController(fromStoryboard: T.getStoryboardName(), withIdentifier: identifier)
        return vc
    }
    
}
