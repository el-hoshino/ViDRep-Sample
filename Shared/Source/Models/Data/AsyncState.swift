//
//  AsyncState.swift
//  ViDRep-Sample (iOS)
//
//  Created by 史 翔新 on 2021/05/22.
//

import Foundation

struct AsyncState<Value, Error: Swift.Error> {
    
    enum Data {
        case none
        case fetching
        case retrieved(Value)
        case failed(Error)
    }
    
    let id = UUID()
    let data: Data
    
    init(_ data: Data) {
        self.data = data
    }
    
}

extension AsyncState {
    
    static var none: Self {
        return .init(.none)
    }
    
    static var fetching: Self {
        return .init(.fetching)
    }
    
    static func retrieved(_ value: Value) -> Self {
        return .init(.retrieved(value))
    }
    
    static func failed(_ error: Error) -> Self {
        return .init(.failed(error))
    }
    
}

extension AsyncState {
    
    var isFetching: Bool {
        switch data {
        case .fetching:
            return true
            
        case .none, .retrieved, .failed:
            return false
        }
    }
    
    var retrieved: Value? {
        switch data {
        case .retrieved(let value):
            return value
            
        case .none, .fetching, .failed:
            return nil
        }
    }
    
}

extension AsyncState: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}

extension AsyncState: ExpressibleByNilLiteral {
    
    init(nilLiteral: ()) {
        self.data = .none
    }
    
}

extension AsyncState.Data: Equatable where Value: Equatable, Error: Equatable {}
