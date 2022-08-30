//
//  RentResponse.swift
//  SMSActivate
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation

class RentResponse: Codable {
    var error: Bool?
    var status: Int?
    var response: String?
    var data: RentUser?
}

class RentUser: Codable {
    var fcmToken: String?
    var deviceID: String?
    var authID: String?
    var balance: Int?
    var state: Bool?
    var userToken: String?
    var country: String?
    var operation: String?
}
