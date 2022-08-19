//
//  UserDefaultService.swift
//  iOS File Manager
//
//  Created by Егор Белоцкий on 17.06.22.
//

import Foundation
import UIKit

class UserDefaultService {
    static let shared = UserDefaultService()
    
    private init() { }
    
    func saveDisplayMode(mode: DisplayViewMode, key: String) {
        UserDefaults.standard.set(mode.rawValue, forKey: key)
    }
    
    func getDisplayMode(key: String) -> String? {
        UserDefaults.standard.string(forKey: key)
    }
}
