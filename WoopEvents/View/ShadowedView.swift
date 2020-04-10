//
//  ShadowedView.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 09/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

import MaterialComponents

class ShadowedView: UIView {
    
    override class var layerClass: AnyClass {
      return MDCShadowLayer.self
    }

    var shadowLayer: MDCShadowLayer {
      return self.layer as! MDCShadowLayer
    }

    func setDefaultElevation() {
        self.shadowLayer.elevation = .cardResting
    }
    
}
