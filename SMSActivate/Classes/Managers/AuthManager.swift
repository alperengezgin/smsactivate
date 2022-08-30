//
//  AuthManager.swift
//  abseil
//
//  Created by Alperen Polat Gezgin on 29.08.2022.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore


class AuthManager {
    static let shared = AuthManager()
    
    private var firestore: Firestore!
    private var realtimedb: DatabaseReference!
    private var authID: String!
    
    var timer: Timer?
    var duration = 600
    var isTimerRunning = false
    
    public var userNumbers = [ActivationModel]()
    public var userRentNumbers = [RentModel]()
    
    var currentActivation: ActivationModel?
    
    private init() {
        firestore = Firestore.firestore()
        realtimedb = Database.database().reference()
        authID = Constant.authID
    }
    
    
    
}



/* Rent */

extension AuthManager {
    
    func fetchUserRent() {
        var ref = realtimedb.child("/users/").child(authID).child("/codes/")
        ref.keepSynced(true)
        ref.observe(DataEventType.value, with: { (snapshot) in
            self.userRentNumbers.removeAll()
            if let response = snapshot.children.allObjects as? [DataSnapshot]{
                for item in response {
                    let rent = RentModel(data: item.value as! [String:Any])
                    self.userRentNumbers.append(rent)
                }
                self.userRentNumbers.sort(by: {$0.time! > $1.time!})
                NotificationCenter.default.post(name: .rentNumberFetched, object: nil)
            }else{
            
            }

        })
    }
    
    
}

/* Activation */

extension AuthManager {
    
    func startPurchase(currentActivation: ActivationModel) {
        self.currentActivation = currentActivation
        isTimerRunning = true
        startTimer()
    }
    
    func startTimer() {
        
        guard let currentActivation = currentActivation else { return }
        
        duration = 600
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
                if self.duration > 0 {
                    self.duration -= 1
                    print(self.duration)
                    self.checkNumber()
                } else {
                    self.cancelOrder()
                }
            }
        }
    }
    
    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
            isTimerRunning = false
            currentActivation = nil
        }
    }
    
    func checkNumber() {
        
        guard let currentActivation = currentActivation else { return }
        
        
        ActivationNetworkManager.shared.getStatus(id: currentActivation.getOrderID()) { response in
            guard let response = response else {
                return
            }
            
            let responses = response.components(separatedBy: ":")
            
            guard let status = responses.first else { return }
            
            if status == "STATUS_OK" {
                self.finishOrder(code: responses[1].replacingOccurrences(of: " ", with: ""))
            }
        }
    }
    
    
    func finishOrder(code: String) {
        
        guard let currentActivation = currentActivation else { return }

        ActivationNetworkManager.shared.setStatus(id: currentActivation.getOrderID(), status: .finish) { response in
            guard let response = response else {
                return
            }
            
            if response == "ACCESS_ACTIVATION" {
                self.updateNumberPurchase(dic: currentActivation.getDicForFinish(for: code))
                self.stopTimer()
            }
        }
    }
    
    func cancelOrder() {
        
        guard let currentActivation = currentActivation else { return }
        
        ActivationNetworkManager.shared.setStatus(id: currentActivation.getOrderID(), status: .cancel) { response in
            guard let response = response else {
                return
            }
            
            if response == "ACCESS_CANCEL" {
                self.updateNumberPurchase(dic: currentActivation.getDicForCancel())
                self.updateUserBalance(isPurchased: true, isSpent: false, amount: 1)
                NotificationCenter.default.post(name: .timeout, object: nil, userInfo: nil)
                self.stopTimer()
            }
        }
    }
    
    func cancelOrderByUser(completion: @escaping (Bool) -> ()) {
        
        guard let currentActivation = currentActivation else { return }
        
        ActivationNetworkManager.shared.setStatus(id: currentActivation.getOrderID(), status: .cancel) { response in
            guard let response = response else {
                completion(false)
                return
            }
            
            if response == "ACCESS_CANCEL" {
                self.updateNumberPurchase(dic: currentActivation.getDicForCancel())
                self.updateUserBalance(isPurchased: true, isSpent: false, amount: 1)
                self.stopTimer()
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    public func fetchNumberPurchases() {
        
        firestore.collection("users").document(authID).collection("purchases").getDocuments { snapshots, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            if let snaps = snapshots {
                
                if snaps.isEmpty {
                    return
                }
                
                self.userNumbers.removeAll()
                for snap in snaps.documents {
                    let number = ActivationModel.init(data: snap.data())
                    self.userNumbers.append(number)
                }
                self.userNumbers.sort(by: {Int($0.order_id!)! > Int($1.order_id!)!})
                NotificationCenter.default.post(name: .numberFetched, object: nil)
            }
        }
    }
    
    public func updateUserBalance(isPurchased: Bool, isSpent: Bool, amount: Int = 0) {
        if isSpent == isPurchased {
            return
        }
        
        let updatedBalance = isSpent ? Constant.userBalance - 1 : Constant.userBalance + amount
        let dic = ["userBalance":updatedBalance] as! [String:Any]
        
        firestore.collection("users").document(authID).updateData(dic) { err in
            if let err = err {
                return
            }
            
            self.fetchUserBalance()
        }
        
    }
    
    public func updateFCMToken(token: String) {
        
        let dic = ["fcmToken":token] as! [String:Any]
        
        firestore.collection("users").document(authID).updateData(dic)
        
    }
    
    public func initNumberPurchase(dic: [String:Any]) {
        
        firestore.collection("users").document(authID).collection("purchases").document(dic["order_id"] as! String).setData(dic) { err in
            if let err = err {
                return
            }
            
            self.fetchNumberPurchases()
        }
    }
    
    public func updateNumberPurchase(dic: [String:Any]) {
        
        firestore.collection("users").document(authID).collection("purchases").document(dic["order_id"] as! String).updateData(dic) { err in
            if let err = err {
                return
            }
            
            self.fetchNumberPurchases()
        }
        
    }
    
    public func fetchUserBalance() {
        
        firestore.collection("users").document(authID).getDocument { snapshot, err in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            
            if let doc = snapshot?.data() {
                Constant.userBalance = doc["userBalance"] as! Int
                NotificationCenter.default.post(name: .updatedBalance, object: nil)
            }
        }
    }
    
    public func initUser() {
        
        let dic = ["userBalance":0,
                   "userDeviceID":UIDevice.current.identifierForVendor!.uuidString,
                   "fcmToken":""] as! [String:Any]
        firestore.collection("users").document(authID).setData(dic)
    }
    
    
    public func getUserBalance() -> Int {
        return Constant.userBalance
    }
    
    
    public func getUserBalanceWithString() -> String {
        if Constant.userBalance == 0 || Constant.userBalance == 1 {
            return "\(Constant.userBalance) Activation"
        } else {
            return "\(Constant.userBalance) Activations"
        }
    }
    
    
}
