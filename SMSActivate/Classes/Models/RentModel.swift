//
//  RentModel.swift
//  abseil
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation

public class RentModel {
    var serviceKey: String?
    var code: String?
    var time: Double?
    var number: String?
    var status: String?
    var countryKey: String?
    
    init(data: [String:Any]) {
        if let serviceKey = data["serviceKey"] as? String {
            self.serviceKey = serviceKey
        }
        
        if let code = data["code"] as? String {
            self.code = code
        }
        
        if let time = data["time"] as? Double {
            self.time = time
        }
        
        if let number = data["number"] as? String {
            self.number = number
        }
        
        if let status = data["status"] as? String {
            self.status = status
        }
        
        if let countryKey = data["countryKey"] as? String {
            self.countryKey = countryKey
        }
    }
    
    public func getNumberStatusText() -> String? {
        if let status = self.status {
            switch status {
            case "waiting":
                return "Waiting SMS Code"
            case "cancelled":
                return "You Cancelled"
            case "completed":
                if let serviceTitle = serviceKey, let code = code {
                   return "Your \(serviceTitle) activation code is: \(code)"
                }
                return nil
            default:
                return nil
            }
        }
        return nil
    }
}
