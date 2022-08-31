//
//  PurchaseModel.swift
//  abseil
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation

public class PurchaseModel {
    var title: String!
    var caption: String!
    var key: String!
    var code: String!
    var prefix: String!
    var type: PurchaseModelType
    
    public init(title:String, caption:String, key:String, code:String = "nil", prefix:String = "nil", type:PurchaseModelType) {
        self.title = title
        self.caption = caption
        self.key = key
        self.code = code
        self.prefix = prefix
        self.type = type
    }
}

public enum PurchaseModelType {
    case service
    case country
}

