//
//  DataSaveLoadError.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/24.
//

import Foundation

enum DataSaveLoadError: Error {
    case failedToExtractDataToSave(Any)
    case failedToConvertDataToTargetType(Data)
    case noDataSaved
}

extension DataSaveLoadError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .failedToExtractDataToSave:
            return "Failed to extract data to save"
            
        case .failedToConvertDataToTargetType:
            return "Failed to convert data to target type"
            
        case .noDataSaved:
            return "No data saved found"
        }
    }
    
}
