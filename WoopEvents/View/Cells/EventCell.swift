//
//  EventCell.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 10/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import CoreLocation

class EventCell: UITableViewCell {
    
    static let reusableIdentifier = "EventCell"
    
    @IBOutlet weak var imageEvent: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    var event: Event! {
        didSet {
            self.labelTitle.text = event.title
            accessibilityLabel = AccessibilityIdentifiers.eventCellIdentifier(forTitle: event.title)
            
            let date = Date(timeIntervalSince1970: TimeInterval(event.date / 1000.0))
            self.labelDate.text = date.toDDMMYYYY() + " - " + date.toHHmm()
            
            if let url = event.imageUrl {
                self.imageEvent.load(fromUrl: url, placeholdered: true)
            } else {
                self.imageEvent.image = R.image.ic_placeholder_event()
            }
            
            guard let latitude = event.latitude, let longitude = event.longitude else {
                showUnavailableLocation()
                return
            }
            
            configureLocation(latitude, longitude)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAccessibilityIdentifiers()
    }
    
    func setupAccessibilityIdentifiers() {
        self.labelTitle.accessibilityIdentifier = AccessibilityIdentifiers.eventCellTitleLabel
    }
    
    func configureLocation(_ latitude: Double, _ longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if error != nil {
                self.showUnavailableLocation()
                return
            }
            guard let placemark = placemarks?.first else {
                self.showUnavailableLocation()
                return
            }
            let geoLocation = ReversedGeoLocation(with: placemark)
            if !geoLocation.city.isEmpty {
                self.labelLocation.textColor = Palette.cardRegularText()
                self.labelLocation.text = geoLocation.city
            } else {
                self.showUnavailableLocation()
            }
        }
    }
    
    func showUnavailableLocation() {
        self.labelLocation.textColor = Palette.errorText()
        self.labelLocation.text = R.string.we.invalidLocation()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
