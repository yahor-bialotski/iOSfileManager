//
//  KeyChainService.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 20.06.22.
//

import UIKit
import KeychainSwift

class KeyChainService {
    
    static let shared = KeyChainService()
    
    let keyChain = KeychainSwift()
    private var savedPasswordKey = "password"     // key "password" - 1
    
    private init() { }
    
    func setPassword(value: String) {
        keyChain.set(value, forKey: savedPasswordKey)
    }
    
    func getPassword() -> String? {
        keyChain.get(savedPasswordKey)
    }
}
