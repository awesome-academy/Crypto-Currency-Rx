//
//  SimpleCoin.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation
import ObjectMapper

struct DataSimpleCoin: Mappable {
    var coin: [SimpleCoin]?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        coin <- map["coin"]
    }
}

struct SimpleCoin {
    var uuid: String
    var symbol: String
    var name: String
    var iconUrl: String
}

extension SimpleCoin {
    init() {
        self.init(
            uuid: "",
            symbol: "",
            name: "",
            iconUrl: ""
        )
    }
}

extension SimpleCoin: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        uuid    <- map["uuid"]
        symbol  <- map["symbol"]
        name    <- map["name"]
        iconUrl <- map["iconUrl"]
    }
}
