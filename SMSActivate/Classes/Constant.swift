//
//  Constant.swift
//  abseil
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation
import SwiftyUserDefaults

public class Constant {
    
    public static var authID = ""
    public static var rentURL = ""
    public static var apiKey = ""
    public static var fcm = ""
    public static var userBalance = 0
    public static var userRentBalance = 0
    public static var isRentActive = false
    
    
}

extension Notification.Name {
    public static let initFailed = Notification.Name("initFailed")
    public static let initSuccess = Notification.Name("initSuccess")
    public static let rentNumberFetched = Notification.Name("rentNumberFetched")
    public static let numberFetched = Notification.Name("numberFetched")
    public static let timeout = Notification.Name("timeout")
    public static let updatedBalance = Notification.Name("updatedBalance")
    public static let updatedRentBalance = Notification.Name("updatedRentBalance")
}

extension DefaultsKeys {
    var token: DefaultsKey<String> { .init("token", defaultValue: "") }
}
