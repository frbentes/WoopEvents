//
//  ErrorView.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 14/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorViewDelegate {
    func tryToReload(_ view: ErrorView)
}

class ErrorView: BaseXibComponent {
    
    var delegate: ErrorViewDelegate? = nil
    
    static let viewHeight: CGFloat = 250.0
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var imageError: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    
    override var nibName: String {
        get { return "ErrorView" }
    }
    
    override var view: UIView! {
        get { return self.containerView }
        set { self.containerView = newValue }
    }
    
    override func xibSetup() {
        super.xibSetup()
        
    }
    
    @IBAction func onTouch(_ sender: Any) {
        self.delegate?.tryToReload(self)
    }
    
}

extension ErrorView {
    static func create(withWidth width: CGFloat = 320) -> ErrorView {
        let view = ErrorView(frame: CGRect.init(x: 0, y: 0, width: width, height: ErrorView.viewHeight))
        view.awakeFromNib()
        
        return view
    }
}

