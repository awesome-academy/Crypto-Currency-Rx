//
//  Price.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 30/08/2021.
//

import Foundation
import ObjectMapper

struct Price {
    var price: String
}

extension Price {
    init() {
        self.init(price: "")
    }
}

extension Price: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        price <- map["price"]
    }
}
