//
//  Network.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation

struct Network {

    static let shared = Network()
    
    private init() { }
    
    private let baseUrl = "https://api.coinranking.com/v2"
    
    func getCoinsURL(path: Path) -> String {
        return "\(baseUrl)\(path.rawValue)"
    }
    
    func getRankingURL() -> String {
        return "\(baseUrl)/coins?limit=30"
    }
    
    func getOffsetURL(offset: String) -> String {
        return "\(baseUrl)/coins?limit=10&offset=\(offset)"
    }
    
    func getHistoryURL(time: String) -> String {
        return "\(baseUrl)/coin/Qwsogvtv82FCd/history?timePeriod=\(time)"
    }
    
    func getDetailURL(uuid: String) -> String {
        return "\(baseUrl)/coin/\(uuid)"
    }
    
    func getSearchURL(name: String) -> String {
        return "\(baseUrl)/search-suggestions?query=\(name)"
    }
    
    func getExchangeRates(base: String, target: String) -> String {
        return "\(baseUrl)/coin/\(base)/price?referenceCurrencyUuid=\(target)"
    }
}
