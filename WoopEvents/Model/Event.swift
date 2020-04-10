//
//  Event.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 10/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation

struct Event: Codable {
    
    let id: Int
    let title: String
    let description: String
    let date: TimeInterval
    let price: Float
    let imageUrl: String?
    let latitude: Float?
    let longitude: Float?
    let coupons: [Coupon]?
    let people: [Person]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case date
        case price
        case imageUrl = "image"
        case latitude
        case longitude
        case coupons = "cupons"
        case people
    }
    
}
