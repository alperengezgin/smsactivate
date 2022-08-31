//
//  RentResponse.swift
//  SMSActivate
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation

public class RentResponse: Codable {
    public var error: Bool?
    public var status: Int?
    public var response: String?
    public var data: RentUser?
}

public class RentUser: Codable {
    public var fcmToken: String?
    public var deviceID: String?
    public var authID: String?
    public var balance: Int?
    public var state: Bool?
    public var userToken: String?
    public var country: String?
    public var operation: String?
}
