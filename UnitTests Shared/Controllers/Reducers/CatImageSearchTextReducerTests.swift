//
//  CatImageSearchTextReducerTests.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import XCTest
@testable import ViDRep_Sample

class CatImageSearchTextReducerTests: XCTestCase {
    
    func test_validate() {
        
        let reducer = CatImageSearchTextReducer(maxCharacterCount: 5)
        
        typealias SUT = (line: UInt, input: String, expected: SearchTextInput.LocalValidation)
        let suts: [SUT] = [
            (#line, "abcde", .valid),
            (#line, "abcdef", .invalid([.textTooLong])),
            (#line, "dog", .invalid([.textContainsDog])),
            (#line, "doge", .valid),
            (#line, "find me a dog", .invalid([.textTooLong, .textContainsDog])),
        ]
        
        for sut in suts {
            let output = reducer.validate(sut.input)
            XCTAssertEqual(output, sut.expected, line: sut.line)
        }
        
    }
    
}
