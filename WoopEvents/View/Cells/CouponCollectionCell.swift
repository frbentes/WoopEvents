//
//  CouponCollectionCell.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 14/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class CouponCollectionCell: UICollectionViewCell {
    
    static let reusableIdentifier = "CouponCollectionCell"
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var labelCoupon: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewContainer.layer.borderWidth = 1
        self.viewContainer.layer.borderColor = Palette.cardTitleText()?.cgColor
        self.viewContainer.layer.cornerRadius = 10
    }

}
