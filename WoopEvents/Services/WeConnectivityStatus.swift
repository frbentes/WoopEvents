//
//  WeConnectivityStatus.swift
//  WoopEvents
//
//  Created by Fredyson Costa Marques Bentes on 14/04/20.
//  Copyright © 2020 home. All rights reserved.
//

import Foundation
import Reachability

public class WeConnectivityStatus {
    
    public class var online: Bool {
        return current == .cellular || current == .wifi
    }
    
    public class var offline: Bool {
        return current == .unavailable
    }
    
    public class var wifiAvailable: Bool {
        return current == .wifi
    }
    
    class var current: Reachability.Connection {
        do {
            return try Reachability().connection
        } catch {
            return .unavailable
        }
    }
    
}
