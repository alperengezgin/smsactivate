
import Foundation
import UIKit

public class SMSActivate {
    
    public static var assetBundle: Bundle {
        get {
            return Bundle(for: SMSActivate.self)
        }
    }
    
    public init(authID: String, rentURL: String, apiKey: String, fcm: String = "", isRentActive: Bool = false) {
        Constant.authID = authID
        Constant.rentURL = rentURL
        Constant.apiKey = apiKey
        Constant.fcm = fcm
        Constant.isRentActive = isRentActive
        checkInit()
    }
    
    private func checkInit() {
       
        if (Constant.authID == "") || (Constant.rentURL == "") || (Constant.apiKey == "") {
            NotificationCenter.default.post(name: .initFailed, object: nil, userInfo: nil)
            return
        }
        
        publicInit()

    }
    
    
    private func publicInit() {
        
        AuthManager.shared.fetchUserBalance()
        AuthManager.shared.fetchNumberPurchases()
        
        if !Constant.isRentActive {
            NotificationCenter.default.post(name: .initSuccess, object: nil, userInfo: nil)
            return
        }
        
        RentNetworkManager.shared.login { response, message in
            if response {
                AuthManager.shared.fetchUserRent()
                RentManager.shared.publicInit()
                NotificationCenter.default.post(name: .initSuccess, object: nil, userInfo: nil)
            } else {
                NotificationCenter.default.post(name: .initFailed, object: nil, userInfo: nil)
            }
        }
    }
    
}

extension SMSActivate {
    
    public func getFlagImage(country: String, isCircle: Bool = false) -> UIImage {
        return ResourceManager.shared.getCountryImage(for: country, isCircle: isCircle)
    }
    
    public func getServiceImage(service: String) -> UIImage {
        return ResourceManager.shared.getServiceImage(for: service)
    }
    
}



extension SMSActivate {
    
    public func getRents() -> [RentModel] {
        return AuthManager.shared.userRentNumbers
    }
    
    public func getRentBalance() -> Int {
        return Constant.userRentBalance
    }
    
    public func getRentBalanceAsString() -> String {
        return RentManager.shared.getUserBalanceWithString()
    }
    
    public func selectRentService(service: PurchaseModel) {
        RentManager.shared.selectService(with: service)
    }
    
    public func selectRentCountry(country: PurchaseModel) {
        RentManager.shared.selectCountry(with: country)
    }
    
    public func unselectRentService() {
        RentManager.shared.unselectService()
    }
    
    public func unselectRentCountry() {
        RentManager.shared.unselectCountry()
    }
    
    public func getSelectedRentService() -> PurchaseModel? {
        return RentManager.shared.getSelectedService()
    }
    
    public func getSelectedRentCountry() -> PurchaseModel? {
        return RentManager.shared.getSelectedCountry()
    }
    
    public func getRentData(searchedKey: String) -> [PurchaseModel] {
        return RentManager.shared.getData(with: searchedKey)
    }
    
    public func rentNumber(completion: @escaping (Bool) -> ()) {
        RentManager.shared.rentNumber { response in
            completion(response)
        }
    }
    
    public func cancelRent(rentModel: RentModel, completion: @escaping (Bool) -> ()) {
        RentManager.shared.cancelRent(for: rentModel) { response in
            completion(response)
        }
    }
    
    public func savePurchase(transactionID:String, productID: String, quantity: Int,completion: @escaping (Bool)->()) {
        
        RentManager.shared.savePurchase(transactionID: transactionID, productID: productID, quantity: quantity) { response in
            completion(response)
        }
    }
    
}

extension SMSActivate {
    
    public func initUser() {
        AuthManager.shared.initUser()
    }
    
    public func getActivations() -> [ActivationModel] {
        return AuthManager.shared.userNumbers
    }
    
    public func getBalance() -> Int {
        return Constant.userBalance
    }
    
    public func getBalanceAsString() -> String {
        return AuthManager.shared.getUserBalanceWithString()
    }
    
    public func selectService(service: PurchaseModel) {
        DataManager.shared.selectService(with: service)
    }
    
    public func selectCountry(country: PurchaseModel) {
        DataManager.shared.selectCountry(with: country)
    }
    
    public func unselectService() {
        DataManager.shared.unselectService()
    }
    
    public func unselectCountry() {
        DataManager.shared.unselectCountry()
    }
    
    public func getSelectedService() -> PurchaseModel? {
        return DataManager.shared.getSelectedService()
    }
    
    public func getSelectedCountry() -> PurchaseModel? {
        return DataManager.shared.getSelectedCountry()
    }
    
    public func getData(searchedKey: String) -> [PurchaseModel] {
        return DataManager.shared.getData(with: searchedKey)
    }
    
    public func updateFCM(token: String) {
        AuthManager.shared.updateFCMToken(token: token)
    }
    
    public func startActivation(completion: @escaping (Bool, String) -> ()) {
        DataManager.shared.startActivation { response, result in
            completion(response,result)
        }
    }
    
    public func cancelActivation(completion: @escaping (Bool) -> ()) {
        AuthManager.shared.cancelOrderByUser { respone in
            completion(respone)
        }
    }
    
    public func getCurrentActivation(completion: @escaping (Bool,ActivationModel?) -> ()) {
        if let currentActivation = AuthManager.shared.getCurrentActivation() {
            completion(true,currentActivation)
        } else {
            completion(false,nil)
        }
    }
    
    public func addBalance(amount: Int) {
        AuthManager.shared.updateUserBalance(isPurchased: true, isSpent: false, amount: amount)
    }
}

