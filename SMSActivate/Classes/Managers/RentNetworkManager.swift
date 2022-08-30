//
//  RentNetworkManager.swift
//  SMSActivate
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation
import Alamofire
import SwiftyUserDefaults

class RentNetworkManager {
    public static let shared = RentNetworkManager()
    
    let BASE_URL = Constant.rentURL
    
    private init() {
        
    }
    
    public func login(completion: @escaping (_ response: Bool, _ message: String)->()) {
        let url = BASE_URL + "/login"
        let parameters = [
            "authID": Constant.authID,
            "deviceID": UIDevice.current.identifierForVendor!.uuidString,
            "fcmToken": Constant.fcm,
            "operation": "iOS",
            "country": Locale.current.regionCode
        ]
        
        let request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
        request.responseDecodable(of: RentResponse.self) { (response) in
            guard let user = response.value else {
                completion(false,"Something Wrong")
                return
            }
            
            if (user.error ?? true) {
                completion(false,user.response ?? "Something Wrong")
                return
            }
            
            if let rentUser = user.data, let token = rentUser.userToken {
                Defaults.token = token
                print("Token: ",token)
            }
            
            completion(true,user.response ?? "")
          }
    }
    
    public func savePurchase(transactionID:String, productID: String, quantity: Int,completion: @escaping (_ response: Bool, _ messsage: String)->()) {
        let url = BASE_URL + "/savePurchase"
        let parameters = [
            "purchaseID": transactionID,
            "recieptID": productID,
            "deviceID": UIDevice.current.identifierForVendor!.uuidString,
            "numberValue": quantity
        ] as? [String:Any]
        
        let header: HTTPHeaders = [
                "Content-Type" : "application/json",
                "Accept" : "application/json",
                "authorization" : "Bearer \(Defaults.token)"
        ]
        
        let request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
        request.responseDecodable(of: RentResponse.self) { (response) in
            guard let res = response.value else {
                completion(false,"Something Wrong")
                return
            }
            
            if (res.error ?? true) {
                completion(false,res.response ?? "Something Wrong")
                return
            }
            
            RentManager.shared.fetchUserBalance()
            completion(true,res.response ?? "Something Wrong")
          }
    }
    
    public func rent(serviceKey:String, countryKey: String, completion: @escaping (_ response: Bool, _ messsage: String)->()) {
        let url = BASE_URL + "/rent"
        let parameters = [
            "serviceKey": serviceKey,
            "countryKey": countryKey
        ]
        
        let header: HTTPHeaders = [
                "Content-Type" : "application/json",
                "Accept" : "application/json",
                "authorization" : "Bearer \(Defaults.token)"
        ]
        
        let request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
        request.responseDecodable(of: RentResponse.self) { (response) in
            guard let res = response.value else {
                completion(false,"Something Wrong")
                return
            }
            
            if (res.error ?? true) {
                completion(false,res.response ?? "Something Wrong")
                return
            }
            
            RentManager.shared.fetchUserBalance()
            completion(true,res.response ?? "Something Wrong")
          }
    }
    
    public func cancel(serviceKey:String, number: String, completion: @escaping (_ response: Bool, _ messsage: String)->()) {
        let url = BASE_URL + "/cancel"
        let parameters = [
            "serviceKey": serviceKey,
            "number": number
        ]
        
        let header: HTTPHeaders = [
                "Content-Type" : "application/json",
                "Accept" : "application/json",
                "authorization" : "Bearer \(Defaults.token)"
        ]
        
        let request = AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header)
        request.responseDecodable(of: RentResponse.self) { (response) in
            guard let res = response.value else {
                completion(false,"Something Wrong")
                return
            }
            
            if (res.error ?? true) {
                completion(false,res.response ?? "Something Wrong")
                return
            }
            
            RentManager.shared.fetchUserBalance()
            completion(true,res.response ?? "Something Wrong")
          }
    }
    
    
    public func getServices(completion: @escaping (_ error: Bool, _ data: RentServices?) -> ()) {
        let url = BASE_URL + "/services"
        
        let header: HTTPHeaders = [
                "Content-Type" : "application/json",
                "Accept" : "application/json",
                "authorization" : "Bearer \(Defaults.token)"
        ]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        request.responseDecodable(of: RentServices.self) { (response) in
            guard let res = response.value else {
                completion(true,nil)
                return
            }
            
            if (res.error ?? true) {
                completion(true,nil)
                return
            }
            
           completion(false,res)
          }
    }
    
    public func getBalance(completion: @escaping (_ error: Bool, _ data: RentBalance?) -> ()) {
        let url = BASE_URL + "/balance"
        
        let header: HTTPHeaders = [
                "Content-Type" : "application/json",
                "Accept" : "application/json",
                "authorization" : "Bearer \(Defaults.token)"
        ]
        
        let request = AF.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
        request.responseDecodable(of: RentBalance.self) { (response) in
            guard let res = response.value else {
                completion(true,nil)
                return
            }
            
            if (res.error ?? true) {
                completion(true,nil)
                return
            }
            
           completion(false,res)
          }
    }
    
}
