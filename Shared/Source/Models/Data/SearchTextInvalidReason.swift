//
//  SearchTextInvalidReason.swift
//  ViDRep-Sample (iOS)
//
//  Created by 史 翔新 on 2021/05/22.
//

import Foundation

enum SearchTextInvalidReason: Equatable {
    case textTooLong
    case textContainsDog
}

extension SearchTextInvalidReason {
    
    var isError: Bool {
        switch self {
        case .textTooLong:
            return true
            
        case .textContainsDog:
            return false
        }
    }
    
}

extension SearchTextInvalidReason: InvalidReason {
    
    var message: String {
        switch self {
        case .textTooLong:
            return "Text too long. Make it shorter."
            
        case .textContainsDog:
            return #"The searching text seems containing "Dog". This is for searching cats, not dogs!"#
        }
    }
    
}
