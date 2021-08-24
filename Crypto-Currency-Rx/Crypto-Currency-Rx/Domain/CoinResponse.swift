//
//  CoinResponse.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation
import ObjectMapper

struct CoinResponse<T: Mappable>: Mappable {
    var status: String?
    var data: T?

    init?(map: Map) { }

    mutating func mapping(map: Map) {
        status <- map["status"]
        data   <- map["data"]
    }
}
