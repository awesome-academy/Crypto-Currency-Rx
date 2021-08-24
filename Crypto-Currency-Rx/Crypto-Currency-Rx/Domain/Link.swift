//
//  Link.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation
import ObjectMapper

struct Link {
    var name: String
    var url: String
    var type: String
}

extension Link {
    init() {
        self.init(
            name: "",
            url: "",
            type: ""
        )
    }
}

extension Link: Mappable {
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        url  <- map["url"]
        type <- map["type"]
    }
}
