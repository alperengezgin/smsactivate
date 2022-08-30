//
//  RentManager.swift
//  abseil
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation

class RentManager {
    
    typealias PurchaseModels = [PurchaseModel]
    
    static let shared = RentManager()
    private var services = [PurchaseModel]()
    public var countries = [PurchaseModel]()
    private var countriesForServices = [String:PurchaseModels]()
    
    private var isServiceSelected = false
    private var isCountrySelected = false
    
    private var selectedCountry: PurchaseModel?
    private var selectedService: PurchaseModel?
    
    var userHavePremium = [false, false, false, false]
    
    private init() {
        
    }
    
    func publicInit() {
        fetchServices()
        fetchUserBalance()
    }
    
    public func getUserBalanceWithString() -> String {
        if Constant.userRentBalance == 0 || Constant.userRentBalance == 1 {
            return "\(Constant.userRentBalance) Rent"
        } else {
            return "\(Constant.userRentBalance) Rents"
        }
    }
    
    public func fetchUserBalance() {
        RentNetworkManager.shared.getBalance { error, data in
            if error {
                return
            }
            
            guard let data = data else {
                return
            }

            if let balance = data.balance {
                Constant.userRentBalance = balance
                NotificationCenter.default.post(name: .updatedRentBalance, object: nil, userInfo: nil)
            }
        }
    }

    
    private func fetchServices() {
        
        RentNetworkManager.shared.getServices { error, data in
            if error {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let services = data.data else {
                return
            }
            
            for service in services {
                let currentService = PurchaseModel(title: service.service!, caption: "Buy SMS for activate \(service.service!)", key: service.serviceKey!, code: service.serviceKey!, type: .service)
                self.services.append(currentService)
                
                self.countries.removeAll()
                if let currentCountries = service.supportedCountry {
                    for country in currentCountries {
                        let currentCountry = PurchaseModel(title: country.country!, caption: "Buy number with prefix \(country.prefix!)", key: country.countryKey!, code: country.countryKey!, prefix: country.prefix!, type: .country)
                        self.countries.append(currentCountry)
                    }
                }
                
                self.countriesForServices[service.service!] = self.countries
            }
        }

        
        
    }
    
    public func selectService(with service: PurchaseModel) {
        selectedService = service
        isServiceSelected = true
    }
    
    public func selectCountry(with country: PurchaseModel) {
        selectedCountry = country
        isCountrySelected = true
    }
    
    public func unselectService() {
        if isServiceSelected {
            selectedService = nil
            isServiceSelected = false
        }
    }
    
    public func unselectCountry() {
        if isCountrySelected {
            selectedCountry = nil
            isCountrySelected = false
        }
    }
    
    public func getSelectedService() -> PurchaseModel? {
        return selectedService
    }
    
    public func getSelectedCountry() -> PurchaseModel? {
        return selectedCountry
    }
    
    public func getData(with searchedKey: String) -> [PurchaseModel] {
        if isServiceSelected {
            return getCountries(with: searchedKey)
        }
        
        return getServices(with: searchedKey)
    }
    
    public func getServices(with searchedKey: String) -> [PurchaseModel] {
        
        let filteredArr = services.filter({$0.title.lowercased().contains(searchedKey.lowercased())})
        
        return searchedKey == "" ? services : filteredArr
    }
    
    public func getCountries(with searchedKey: String) -> [PurchaseModel] {
        
        countries.removeAll()
        countries.append(contentsOf: countriesForServices[self.selectedService!.title]!)
        
        let filteredArr = countries.filter({$0.title.lowercased().contains(searchedKey.lowercased())})
        
        return searchedKey == "" ? countries : filteredArr
    }
    
    public func rentNumber(completion: @escaping (Bool) -> ()) {
        guard let service = getSelectedService(), let country = getSelectedCountry() else {
            completion(false)
            return
        }
        
        RentNetworkManager.shared.rent(serviceKey: service.key, countryKey: country.key) { response, messsage in
            if response {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    public func cancelRent(for rentModel: RentModel, completion: @escaping (Bool) -> ()) {
        
        guard let serviceKey = rentModel.serviceKey, let number = rentModel.number else {
            completion(false)
            return
        }
        
        RentNetworkManager.shared.cancel(serviceKey: serviceKey, number: number) { response, messsage in
            if response {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    public func savePurchase(transactionID:String, productID: String, quantity: Int,completion: @escaping (Bool)->()) {
        
        RentNetworkManager.shared.savePurchase(transactionID: transactionID, productID: productID, quantity: quantity) { response, messsage in
            if response {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
