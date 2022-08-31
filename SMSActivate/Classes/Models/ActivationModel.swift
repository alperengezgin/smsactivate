//
//  ActivationItem.swift
//  abseil
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation

public class ActivationModel: Codable {
    public var number: String?
    public var order_id: String?
    public var status: String?
    public var verifyCode: String?
    public var service: String?
    public var serviceTitle: String?
    public var serviceImage: String?
    public var country: String?
    public var date: String?

    
    public init(data:[String:Any]) {
        if let number = data["number"] as? String {
            self.number = number
        }
        
        if let order_id = data["order_id"] as? String {
            self.order_id = order_id
        }
        
        if let status = data["status"] as? String {
            self.status = status
        }
        
        if let verifyCode = data["verifyCode"] as? String {
            self.verifyCode = verifyCode
        }
        
        if let service = data["service"] as? String {
            self.service = service
        }
        
        if let serviceTitle = data["serviceTitle"] as? String {
            self.serviceTitle = serviceTitle
        }
        
        if let serviceImage = data["serviceImage"] as? String {
            self.serviceImage = serviceImage
        }
        
        if let country = data["country"] as? String {
            self.country = country
        }
        
        if let date = data["date"] as? String {
            self.date = date
        }
    }
    
    public init(number: String, order_id: String, status:String, verifyCode:String, service:String, serviceTitle:String, serviceImage: String, country:String, date:String) {
        self.number = number
        self.order_id = order_id
        self.status = status
        self.verifyCode = verifyCode
        self.service = service
        self.serviceTitle = serviceTitle
        self.serviceImage = serviceImage
        self.country = country
        self.date = date
    }
    
    public func getOrderID() -> String {
       return order_id!
    }
    
    public func createDic() -> [String:Any] {
        
        let dic = ["number":number,
                   "order_id":order_id,
                   "status":status,
                   "verifyCode":verifyCode,
                   "service":service,
                   "serviceTitle":serviceTitle,
                   "serviceImage":serviceImage,
                   "country":country,
                   "date":date] as! [String:Any]
        return dic

    }
    
    public func getDicForCancel() -> [String:Any] {
        let dic = ["status":"8", "order_id": order_id!] as! [String:Any]
        return dic
    }
    
    
    public func getDicForFinish(for code:String) -> [String:Any] {
        let dic = ["status":"6", "verifyCode":code, "order_id": order_id!] as! [String:Any]
        return dic
    }
    
  
    
    public func getNumberStatusText() -> String? {
        if let status = self.status {
            switch status {
            case "1":
                return "Waiting SMS Code"
            case "8":
                return "You Cancelled"
            case "6":
                if let serviceTitle = serviceTitle, let code = verifyCode {
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
