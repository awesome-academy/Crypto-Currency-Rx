//
//  SimpleCoin.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation
import ObjectMapper
import Then

struct DataSimpleCoin: Mappable {
    var coins: [SimpleCoin]?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        coins <- map["coins"]
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

extension SimpleCoin: Then { }
