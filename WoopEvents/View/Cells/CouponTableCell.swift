//
//  CouponTableCell.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 14/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class CouponTableCell: UITableViewCell {
    
    static let reusableIdentifier = "CouponTableCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var coupons: [Coupon]! {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(UINib.init(nibName: R.nib.couponCollectionCell.name, bundle: nil), forCellWithReuseIdentifier: CouponCollectionCell.reusableIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CouponTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CouponCollectionCell.reusableIdentifier, for: indexPath) as! CouponCollectionCell
        
        let discount = coupons[indexPath.row].discount
        
        cell.labelCoupon.text = "\(discount) %"
        
        return cell
    }
    
    
}
