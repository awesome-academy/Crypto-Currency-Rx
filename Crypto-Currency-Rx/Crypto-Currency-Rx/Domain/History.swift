//
//  History.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 27/08/2021.
//

import Foundation
import ObjectMapper

struct PriceHistory: Mappable {
    var change: String?
    var history: [History]?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        change  <- map["change"]
        history <- map["history"]
    }
}

struct History {
    var price: String
    var timestamp: Double
}

extension History {
    init() {
        self.init(price: "",
                  timestamp: 0.0)
    }
}

extension History: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        price     <- map["price"]
        timestamp <- map["timestamp"]
    }
}
