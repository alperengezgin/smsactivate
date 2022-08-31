//
//  ResourceManager.swift
//  SMSActivate
//
//  Created by Alperen Polat Gezgin on 30.08.2022.
//

import Foundation
import FlagKit
import UIKit

public class ResourceManager {
    
    public static let shared = ResourceManager()
    
    private init() {
        
    }
    
    public func getServiceImage(for service: String) -> UIImage {
        if let image = UIImage(named: service, in: SMSActivate.assetBundle, with: .none) {
            return image
        }
        
        return UIImage()
    }
    
    public func getCountryImage(for country: String, isCircle: Bool = false) -> UIImage {
        if let flag = Flag(countryCode: country) {
            return isCircle ? flag.image(style: .circle) : flag.originalImage
        }
        
        return UIImage()
    }
    
    public func getJsonFilePath(name: String) -> String? {
        if let bundlePath = SMSActivate.assetBundle.path(forResource: "SMSActivate", ofType: "bundle") {
            if let bundleUrl = URL(string: bundlePath) {
                if let jsonUrl = Bundle.url(forResource: name, withExtension: "json", subdirectory: nil, in: bundleUrl) {
                    return jsonUrl.path
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
        
    }
}
