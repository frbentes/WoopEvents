//
//  ReversedGeoLocation.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 10/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import CoreLocation

struct ReversedGeoLocation {
    
    let city: String
    let state: String
    let country: String
    
    init(with placemark: CLPlacemark) {
        self.city = placemark.locality ?? ""
        self.state = placemark.administrativeArea ?? ""
        self.country = placemark.country ?? ""
    }
    
}
