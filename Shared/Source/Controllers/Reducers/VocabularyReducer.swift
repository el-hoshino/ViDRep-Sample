//
//  VocabularyReducer.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/02/20.
//

import Foundation

final class VocabularyReducer {
    
}

extension VocabularyReducer: VocabularyReducerObject {
    
    func appending(_ vocabulary: String, to array: [String]) -> [String] {
        return array + [vocabulary]
    }
    
    func initial() -> [String] {
        return []
    }
    
}
