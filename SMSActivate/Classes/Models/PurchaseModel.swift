//
//  PurchaseModel.swift
//  abseil
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation

public class PurchaseModel {
    public var title: String!
    public var caption: String!
    public var key: String!
    public var code: String!
    public var prefix: String!
    public var type: PurchaseModelType
    
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

