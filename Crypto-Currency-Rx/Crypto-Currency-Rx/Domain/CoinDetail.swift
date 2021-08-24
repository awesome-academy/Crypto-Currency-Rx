//
//  CoinDetail.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation
import ObjectMapper

struct DataDetailCoin: Mappable {
    var coin: CoinDetail?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        coin <- map["coin"]
    }
}

struct CoinDetail {
    var uuid: String
    var symbol: String
    var name: String
    var iconUrl: String
    var description: String
    var links: [Link]
    var total: String
    var circulating: String
    var volume: String
    var marketCap: String
    var price: String
    var btcPrice: String
    var change: String
    var rank: Int
}

extension CoinDetail {
    init() {
        self.init(
            uuid: "",
            symbol: "",
            name: "",
            iconUrl: "",
            description: "",
            links: [Link](),
            total: "",
            circulating: "",
            volume: "",
            marketCap: "",
            price: "",
            btcPrice: "",
            change: "",
            rank: 0
        )
    }
}

extension CoinDetail: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        uuid        <- map["uuid"]
        symbol      <- map["symbol"]
        name        <- map["name"]
        iconUrl     <- map["iconUrl"]
        description <- map["description"]
        links       <- map["links"]
        total       <- map["supply.total"]
        circulating <- map["supply.circulating"]
        volume      <- map["24hVolume"]
        marketCap   <- map["marketCap"]
        price       <- map["price"]
        btcPrice    <- map["btcPrice"]
        change      <- map["change"]
        rank        <- map["rank"]
    }
}

