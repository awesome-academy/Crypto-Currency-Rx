//
//  APIService.swift
//  Crypto-Currency-Rx
//
//  Created by namtrinh on 23/08/2021.
//

import Foundation
import RxSwift
import Alamofire
import ObjectMapper

struct APIService {
    
    static let shared = APIService()
    
    private var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
            fatalError("Couldn't find file 'Keys.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'Keys.plist'.")
        }
        return value
    }
    
    func request<T: Mappable>(url: String, expecting: T.Type) -> Observable<T> {
        let headers: HTTPHeaders = [
            "x-access-token": apiKey
        ]
        
        return Observable.create { observable in
            AF.request(url, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200 ..< 300)
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let data):
                        guard let object = Mapper<T>().map(JSONObject: data) else { return }
                        observable.onNext(object)
                        observable.onCompleted()
                    case .failure(let error):
                        observable.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
}

