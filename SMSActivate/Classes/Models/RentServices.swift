//
//  RentServices.swift
//  SMSActivate
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation

class RentServices: Codable {
    var error: Bool?
    var status: Int?
    var response: String?
    var data: [RentService]?
}

class RentService: Codable {
    var service: String?
    var serviceKey: String?
    var supportedCountry: [RentCountries]?
}

class RentCountries: Codable {
    var countryKey: String?
    var country: String?
    var prefix: String?
}
