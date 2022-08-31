//
//  RentServices.swift
//  SMSActivate
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation

public class RentServices: Codable {
    public var error: Bool?
    public var status: Int?
    public var response: String?
    public var data: [RentService]?
}

public class RentService: Codable {
    public var service: String?
    public var serviceKey: String?
    public var supportedCountry: [RentCountries]?
}

public class RentCountries: Codable {
    public var countryKey: String?
    public var country: String?
    public var prefix: String?
}
