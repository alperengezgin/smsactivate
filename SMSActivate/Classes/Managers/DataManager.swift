//
//  DataManager.swift
//  abseil
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    private var services = [PurchaseModel]()
    private var countries = [PurchaseModel]()
    
    private var isServiceSelected = false
    private var isCountrySelected = false
    
    private var selectedCountry: PurchaseModel?
    private var selectedService: PurchaseModel?
    
    private init() {
        fetchServices()
        fetchCountries()
    }
    
    func startActivation(completion: @escaping (Bool, String) -> ()) {
        guard let serviceCode = getSelectedService()?.code, let countryKey = getSelectedCountry()?.key, let serviceImage = getSelectedService()?.key else {
            completion(false, "Sorry. Something Wrong. Please try agin")
            return
        }
        
        ActivationNetworkManager.shared.buyNumber(service: serviceCode, country: countryKey) { response in
            if let response = response {
                let parsedResponse = response.components(separatedBy: ":")
                
                guard let result = parsedResponse[0] as? String else {
                    completion(false, "Sorry. Something Wrong. Please try agin")
                    return
                }
                
                if result == "ACCESS_NUMBER" {
                    guard let id = parsedResponse[1] as? String, let number = parsedResponse[2] as? String else {
                        completion(false, "Sorry. Something Wrong. Please try agin")
                        return
                    }
                    
                    let service = self.getSelectedService()!.title!
                    let country = self.getSelectedCountry()!.code!
                    let activationNumber = ActivationModel(number: "+"+number, order_id: id, status: "1", verifyCode: "", service: serviceCode, serviceTitle: service, serviceImage: serviceImage, country: country, date: self.getCurrentDateString())
                    AuthManager.shared.updateUserBalance(isPurchased: false, isSpent: true)
                    self.unselectService()
                    self.unselectCountry()
                    AuthManager.shared.initNumberPurchase(dic: activationNumber.createDic())
                    AuthManager.shared.startPurchase(currentActivation: activationNumber)
                    
                    
                } else if result == "NO_NUMBERS" {
                    completion(false, "We can not provide a number now for this service and this country. Please try again later")
                    return
                } else {
                    completion(false, "Sorry. Something Wrong. Please try agin")
                    return
                }
                
            } else {
                completion(false, "Sorry. Something Wrong. Please try agin")
                return
            }
        }
        
    }
    
    
    private func fetchCountries() {
        let path = ResourceManager.shared.getJsonFilePath(name: "Countries")
        guard let jsonPath = path, let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return
        }
        
        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)) as? Array<Any> {
            for jsonObject in jsonObjects {
                guard let countryObj = jsonObject as? Dictionary<String, Any> else {
                    continue
                }
                guard let name = countryObj["name"] as? String,
                      let code = countryObj["code"] as? String,
                      let phoneCode = countryObj["dial_code"] as? String,
                      let key = countryObj["key"] as? String else {
                          continue
                      }
                let country = PurchaseModel(title: name, caption: "Buy number with prefix \(phoneCode)", key: key, code: code, prefix: phoneCode, type: .country)
                countries.append(country)
            }
        }
    }
    
    private func fetchServices() {
        let path = ResourceManager.shared.getJsonFilePath(name: "Services")
        guard let jsonPath = path, let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return
        }
        
        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)) as? Array<Any> {
            for jsonObject in jsonObjects {
                guard let countryObj = jsonObject as? Dictionary<String, Any> else {
                    continue
                }
                guard let name = countryObj["name"] as? String,
                      let key = countryObj["key"] as? String,
                      let code = countryObj["code"] as? String else {
                          continue
                      }
                
                if key == "whatsapp" {
//                    if Defaults.isServicesActive {
//                        let service = PurchaseModel(title: name, caption: "Buy SMS for activate \(name)", key: key, code: code, type: .service)
//                        services.append(service)
//                    }
                } else {
                    let service = PurchaseModel(title: name, caption: "Buy SMS for activate \(name)", key: key, code: code, type: .service)
                    services.append(service)
                }
                
                
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
        
        let filteredArr = countries.filter({$0.title.lowercased().contains(searchedKey.lowercased())})
        
        return searchedKey == "" ? countries : filteredArr
    }
    
    func getCurrentDateString() -> String {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        return timestamp
    }
    
}
