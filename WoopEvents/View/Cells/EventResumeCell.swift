//
//  EventResumeCell.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 12/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import UIKit
import CoreLocation
import MaterialComponents.MaterialButtons

protocol EventResumeCellDelegate: class {
    func tapCheckin()
    func tapShare()
}

class EventResumeCell: UITableViewCell {
    
    static let reusableIdentifier = "EventResumeCell"
    
    weak var delegate: EventResumeCellDelegate?
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonCheckin: MDCButton!
    
    var event: Event! {
        didSet {
            self.labelTitle.text = event.title
            self.labelDescription.text = event.description
            
            let date = Date(timeIntervalSince1970: TimeInterval(event.date / 1000.0))
            self.labelDate.text = date.toDDMMYYYY() + " - " + date.toHHmm()
            
            guard let latitude = event.latitude, let longitude = event.longitude else {
                showUnavailableLocation()
                return
            }
            
            configureLocation(latitude, longitude)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
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
            self.formatAddress(geoLocation: geoLocation)
        }
    }
    
    func formatAddress(geoLocation: ReversedGeoLocation) {
        var fullAddress: String = ""
        if !geoLocation.city.isEmpty {
            fullAddress += geoLocation.city + ","
        }
        if !geoLocation.state.isEmpty {
            fullAddress += " \(geoLocation.state)" + ","
        }
        if !geoLocation.country.isEmpty {
            fullAddress += " \(geoLocation.country)" + ","
        }
        
        if !fullAddress.isEmpty {
            self.labelLocation.textColor = R.color.cardRegularText()
            self.labelLocation.text = String(fullAddress.dropLast())
        } else {
            self.showUnavailableLocation()
        }
    }
    
    func showUnavailableLocation() {
        self.labelLocation.textColor = R.color.errorText()
        self.labelLocation.text = "localização indisponível"
    }
    
    @IBAction func buttonCheckinTapped(_ sender: Any) {
        self.delegate?.tapCheckin()
    }
    
    @IBAction func buttonShareTapped(_ sender: UIButton) {
        self.delegate?.tapShare()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
