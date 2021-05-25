//
//  UserDefaultsDatabase.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/24.
//

import Foundation

final class UserDefaultsDatabase {
    
    private enum Key: String {
        case imageIDList
        case imageData
    }
    
    private let defaults = UserDefaults.standard
    
}
