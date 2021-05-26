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

extension UserDefaultsDatabase: ImageSavingDispatcherUserDatabaseObject {
    
    func saveImageIDs(_ ids: [CatImage.ID]) {
        
        defaults.setValue(ids, forKey: Key.imageIDList.rawValue)
        
    }
    
    func loadImageIDs() -> [CatImage.ID]? {
        
        defaults.array(forKey: Key.imageIDList.rawValue) as? [CatImage.ID]
        
    }
    
    func saveImageData(_ data: Data?, with id: CatImage.ID) {
        
        defaults.setValue(data, forKey: Key.imageData.rawValue + id)
        
    }
    
    func loadImageData(with id: CatImage.ID) -> Data? {
        
        defaults.data(forKey: Key.imageData.rawValue + id)
        
    }
    
}
