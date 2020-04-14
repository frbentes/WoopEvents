//
//  BaseXibComponent.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 14/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import UIKit

open class BaseXibComponent: UIView {
    
    open var view: UIView!
    
    open var nibName: String {
        get {
            return ""
        }
    }
    
    open func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [AutoresizingMask.flexibleWidth, AutoresizingMask.flexibleHeight]
        
        addSubview(view)
        
        self.customize()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    open func customize() {
        // custom action here
    }
    
    open func updateComponentHeight(_ newHeight: CGFloat) {
        let heightConstraints = self.constraints.filter({ (constraint) -> Bool in
            return constraint.firstAttribute == NSLayoutConstraint.Attribute.height
        })
        heightConstraints.forEach { (constraint) in
            constraint.constant = newHeight
        }
        self.layoutIfNeeded()
    }
    
}
