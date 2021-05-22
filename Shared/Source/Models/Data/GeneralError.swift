//
//  GeneralError.swift
//  ViDRep-Sample (iOS)
//
//  Created by 史 翔新 on 2021/05/22.
//

import Foundation

enum GeneralError: Error {
    case urlError(URLError)
    case decodingError(DecodingError)
    case unknownError(Error)
}

extension GeneralError {
    
    var message: String {
        switch self {
        case .urlError(let error):
            return "Failed with URL error: \(error)"
            
        case .decodingError(let error):
            return "Failed with decoding error: \(error)"
            
        case .unknownError(let error):
            assertionFailure("Unknown error: \(error)")
            return "Unknown error: \(error)"
        }
    }
    
}

extension GeneralError: Identifiable {
    
    var id: String {
        return message
    }
    
}
