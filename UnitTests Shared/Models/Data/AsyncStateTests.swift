//
//  AsyncStateTests.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/26.
//

import XCTest
@testable import ViDRep_Sample

class AsyncStateTests: XCTestCase {
    
    enum LocalError: Error, Equatable {
        case myError
    }
    
    typealias State = AsyncState<String, LocalError>
    
    func test_staticVars() {
        
        typealias SUT = (state: State, expected: State.Data)
        let suts: [SUT] = [
            (.none, .none),
            (.fetching, .fetching),
            (.retrieved("yes"), .retrieved("yes")),
            (.failed(.myError), .failed(.myError)),
        ]
        
        for sut in suts {
            XCTAssertEqual(sut.state.data, sut.expected)
        }
        
    }
    
    func test_isFetching() {
        
        typealias SUT = (state: State, expected: Bool)
        let suts: [SUT] = [
            (.none, false),
            (.fetching, true),
            (.retrieved(""), false),
            (.failed(.myError), false),
        ]
        
        for sut in suts {
            XCTAssertEqual(sut.state.isFetching, sut.expected)
        }
        
    }
    
    func test_retrieved() {
        
        typealias SUT = (state: State, expected: String?)
        let suts: [SUT] = [
            (.none, nil),
            (.fetching, nil),
            (.retrieved(""), ""),
            (.retrieved("abc"), "abc"),
            (.failed(.myError), nil),
        ]
        
        for sut in suts {
            XCTAssertEqual(sut.state.retrieved, sut.expected)
        }
        
    }
    
    func test_equatable() {
        
        typealias SUT = (State, State)
        let suts: [SUT] = [
            (.none, .none),
            (.fetching, .fetching),
            (.retrieved(""), .retrieved("")),
            (.failed(.myError), .failed(.myError)),
            (.none, .fetching),
            (.none, .retrieved("")),
            (.none, .failed(.myError)),
            (.fetching, .retrieved("")),
            (.fetching, .failed(.myError)),
            (.retrieved(""), .failed(.myError)),
        ]
        
        for sut in suts {
            // Different AsyncState instances should always be different since they should have different ids.
            XCTAssertNotEqual(sut.0, sut.1)
            
            // On the other hand copied AsyncState instances should be the same since they should have the same id.
            let copied0 = sut.0
            let copied1 = sut.1
            XCTAssertEqual(sut.0, copied0)
            XCTAssertEqual(sut.1, copied1)
        }
        
    }
    
    func test_expressibleByNilLiteral() {
        
        let none: State = nil
        XCTAssertEqual(none.data, State.Data.none)
        
    }
    
    func test_map() {
        
        let map: (String) -> Int = { Int($0)! }
        typealias SUT = (original: State, expected: AsyncState<Int, LocalError>.Data)
        let suts: [SUT] = [
            (.none, .none),
            (.fetching, .fetching),
            (.retrieved("123"), .retrieved(123)),
            (.failed(.myError), .failed(.myError)),
        ]
        
        for sut in suts {
            XCTAssertEqual(sut.original.map(map).data, sut.expected)
        }
        
    }
    
    func test_mapError() {
        
        enum AnotherError: Error {
            case anotherError
        }
        let mapError: (LocalError) -> AnotherError = { _ in .anotherError }
        typealias SUT = (original: State, expected: AsyncState<String, AnotherError>.Data)
        let suts: [SUT] = [
            (.none, .none),
            (.fetching, .fetching),
            (.retrieved(""), .retrieved("")),
            (.failed(.myError), .failed(.anotherError)),
        ]
        
        for sut in suts {
            XCTAssertEqual(sut.original.mapError(mapError).data, sut.expected)
        }
        
    }
    
}
