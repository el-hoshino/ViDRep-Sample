//
//  PublisherTests.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/26.
//

import XCTest
import Combine
@testable import ViDRep_Sample

class PublisherTests: XCTestCase {
    
    func test_assign() {
        
        typealias State = AsyncState<String, LocalError>
        
        enum LocalError: Error, Equatable {
            case myError
        }
        
        final class Test {
            var state: State = .none
        }
        
        let test = Test()
        XCTAssertEqual(test.state.data, State.none.data)
        
        _ = Just("Test").setFailureType(to: LocalError.self).assign(to: \.state, on: test)
        XCTAssertEqual(test.state.data, State.retrieved("Test").data)
        
        _ = Fail(error: LocalError.myError).assign(to: \.state, on: test)
        XCTAssertEqual(test.state.data, State.failed(.myError).data )
        
    }
    
}
