//
//  EventCell.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 10/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    static let reusableIdentifier = "EventCell"
    
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
