//
//  StringTests.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/26.
//

import XCTest
@testable import ViDRep_Sample

class StringTests: XCTestCase {
    
    func test_id() {
        
        let suts = ["abc", "123", ""]
        for sut in suts {
            XCTAssertEqual(sut.id, sut)
        }
        
    }
    
}
