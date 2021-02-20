//
//  Repository.swift
//  ViDRep-Sample (iOS)
//
//  Created by 史 翔新 on 2021/02/20.
//

import Foundation

final class Repository: ObservableObject {
    
    @Published var vocabularies: [String] = []
    
}

extension Repository: VocabularyRepositoryObject {
    
    func editVocabularies(_ edit: VocabularyEditing) {
        edit(&vocabularies)
    }
    
}

extension Repository: HomeRepositoryObject {
    
}
