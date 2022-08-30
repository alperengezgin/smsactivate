//
//  NetworkManager.swift
//  abseil
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation
import Alamofire

class ActivationNetworkManager {
    
    static let shared = ActivationNetworkManager()
    
    var baseURL: String!
    
    
    private init() {
        baseURL = "https://api.sms-activate.org/stubs/handler_api.php?api_key=\(Constant.apiKey)&action="
    }

    
    public func buyNumber(service: String, country: String, completion: @escaping (_ response: String?) -> ()) {
        
        
        let url = baseURL + "getNumber&service=" + service + "&country=" + country
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default)
        request.responseString { data in
            guard let response = data.value else {
                completion(nil)
                return
            }
            
            completion(response)
        }
    }
    
    public func getStatus(id: String, completion: @escaping (_ response: String?) -> ()) {
        
        
        let url = baseURL + "getStatus&id=" + id
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default)
        request.responseString { data in
            guard let response = data.value else {
                completion(nil)
                return
            }
            
            completion(response)
        }
    }
    
    public func setStatus(id: String, status: Status, completion: @escaping (_ response: String?) -> ()) {
        
        
        let url = baseURL + "setStatus&status=" + status.rawValue + "&id=" + id
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default)
        request.responseString { data in
            guard let response = data.value else {
                completion(nil)
                return
            }
            
            completion(response)
        }
    }
    
}

enum Status: String {
    case cancel = "8"
    case finish = "6"
}
