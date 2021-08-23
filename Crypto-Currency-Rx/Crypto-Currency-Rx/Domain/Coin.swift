//
//  CoinResponse.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation
import ObjectMapper

struct DataCoin: Mappable {
    var coins: [Coin]?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        coins <- map["coins"]
    }
}

struct Coin {
    var uuid: String
    var symbol: String
    var name: String
    var iconUrl: String
    var price: String
    var change: String
    var rank: Int
}

extension Coin {
    init() {
        self.init(
            uuid: "",
            symbol: "",
            name: "",
            iconUrl: "",
            price: "",
            change: "",
            rank: 0
        )
    }
}

extension Coin: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        uuid    <- map["uuid"]
        symbol  <- map["symbol"]
        name    <- map["name"]
        iconUrl <- map["iconUrl"]
        price   <- map["price"]
        change  <- map["change"]
        rank    <- map["rank"]
    }
}

