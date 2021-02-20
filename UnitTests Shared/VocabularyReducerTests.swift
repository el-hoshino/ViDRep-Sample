//
//  VocabularyReducerTests.swift
//  Tests iOS
//
//  Created by 史 翔新 on 2021/02/20.
//

import XCTest
@testable import ViDRep_Sample

class VocabularyReducerTests: XCTestCase {
    
    func test_appending() {
        
        let reducer = VocabularyReducer()
        
        typealias SUT = (appending: String, base: [String], expected: [String])
        let suts: [SUT] = [
            ("1", [], ["1"]),
            ("2", ["1"], ["1", "2"]),
            ("a", ["a"], ["a", "a"]),
        ]
        
        for sut in suts {
            XCTAssertEqual(reducer.appending(sut.appending, to: sut.base), sut.expected)
        }
        
    }
    
}
