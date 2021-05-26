//
//  CatImageSearchTextReducer.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import Foundation

final class CatImageSearchTextReducer {
    
    let maxCharacterCount: Int
    
    init(maxCharacterCount: Int) {
        self.maxCharacterCount = maxCharacterCount
    }
    
    func validate(_ text: String) -> SearchTextInput.LocalValidation {
        
        var invalids: [SearchTextInvalidReason] = []
        
        if text.count > maxCharacterCount {
            invalids.append(.textTooLong)
        }
        
        let lowercasedComponents = text.lowercased().components(separatedBy: .whitespaces)
        if lowercasedComponents.contains("dog") {
            invalids.append(.textContainsDog)
        }
        
        if invalids.isEmpty {
            return .valid
            
        } else {
            return .invalid(invalids)
        }
        
    }
    
}

extension CatImageSearchTextReducer: SearchTextReducerObject {
    
    func makeSearchTextInput(from text: String) -> SearchTextInput {
        return .init(value: text, localValidation: validate(text))
    }
    
}
