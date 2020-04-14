//
//  PersonCell.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 14/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    
    static let reusableIdentifier = "PersonCell"
    
    @IBOutlet weak var imagePerson: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    var person: Person! {
        didSet {
            if let url = person.picture {
                let targetSize = CGSize(width: 35, height: 35)
                self.imagePerson.load(fromUrl: url, placeholder: R.image.ic_placeholder_person(), targetSize: targetSize, circular: true) { (image) in
                    self.imagePerson.image = image
                }
            } else {
                self.imagePerson.image = R.image.ic_placeholder_person()
            }
            
            self.labelName.text = person.name
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
