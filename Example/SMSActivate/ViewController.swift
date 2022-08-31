//
//  ViewController.swift
//  SMSActivate
//
//  Created by Alperen Polat GEZGIN on 08/29/2022.
//  Copyright (c) 2022 Alperen Polat GEZGIN. All rights reserved.
//

import UIKit
import SMSActivate
import SwiftyUserDefaults

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handler), name: .initSuccess, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let a = SMSActivate(authID: "alp", rentURL: "alp", apiKey: "alp")
        a.getData(searchedKey: "")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handler() {
        let vc = UIAlertController(title: "Success", message: "ok", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        vc.addAction(cancel)
        self.present(vc, animated: true, completion: nil)
    }

}

