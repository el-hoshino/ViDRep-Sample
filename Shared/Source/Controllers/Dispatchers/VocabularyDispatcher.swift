//
//  VocabularyDispatcher.swift
//  ViDRep-Sample (iOS)
//
//  Created by 史 翔新 on 2021/02/20.
//

import Foundation

protocol VocabularyReducerObject: AnyObject {
    func appending(_ vocabulary: String, to array: [String]) -> [String]
    func initial() -> [String]
}

protocol VocabularyRepositoryObject: AnyObject {
    typealias VocabularyEditing = (_ vocabularies: inout [String]) -> Void
    func editVocabularies(_ edit: VocabularyEditing)
}

final class VocabularyDispatcher<Reducer: VocabularyReducerObject, Repository: VocabularyRepositoryObject> {
    
    let reducer: Reducer
    let repository: Repository
    
    init(reducer: Reducer, repository: Repository) {
        self.reducer = reducer
        self.repository = repository
    }
    
    func addVocabulary(_ vocabulary: String) {
        repository.editVocabularies {
            $0 = reducer.appending(vocabulary, to: $0)
        }
    }
    
    func resetVocabulary() {
        repository.editVocabularies {
            $0 = reducer.initial()
        }
    }
    
}

extension VocabularyDispatcher: HomeDispatcherObject {
    
    func runAction(_ action: HomeDispatcherObjectAction) {
        switch action {
        case .add(vocabulary: let vocabulary):
            addVocabulary(vocabulary)
            
        case .reset:
            resetVocabulary()
        }
    }
    
}
