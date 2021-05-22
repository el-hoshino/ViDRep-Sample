//
//  UserInputData.swift
//  ViDRep-Sample (iOS)
//
//  Created by 史 翔新 on 2021/05/22.
//

import Foundation

protocol InvalidReason {
    var message: String { get }
}

struct UserInputData<Value, Invalid: InvalidReason> {
    
    enum LocalValidation {
        case none
        case invalid([Invalid])
        case valid
    }
    
    var value: Value
    var localValidation: LocalValidation
    
}

extension UserInputData {
    
    init(_ value: Value) {
        self.value = value
        self.localValidation = .none
    }
    
}

extension UserInputData.LocalValidation {
    
    var invalidMessages: [String] {
        
        switch self {
        case .none, .valid:
            return []
            
        case .invalid(let invalids):
            return invalids.map({ $0.message })
        }
        
    }
    
}

extension UserInputData.LocalValidation where Invalid == SearchTextInvalidReason {
    
    var hasError: Bool {
        switch self {
        case .none, .valid:
            return false
            
        case .invalid(let reasons):
            return reasons.contains(where: { $0.isError })
        }
    }
    
}
