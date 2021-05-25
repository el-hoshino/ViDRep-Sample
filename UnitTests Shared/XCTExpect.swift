//
//  XCTExpect.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import XCTest
@testable import ViDRep_Sample

func XCTExpect<Value: Equatable, Error: Equatable>(_ lhs: AsyncState<Value, Error>, as rhs: AsyncState<Value, Error>, file: StaticString = #file, line: UInt = #line) {
    
    switch (lhs.data, rhs.data) {
    case (.none, .none),
         (.fetching, .fetching):
        break
        
    case (.retrieved(let lhs), .retrieved(let rhs)):
        XCTAssertEqual(lhs, rhs, file: file, line: line)
        
    case (.failed(let lhs), .failed(let rhs)):
        XCTAssertEqual(lhs, rhs, file: file, line: line)
        
    case _:
        XCTFail("\(lhs) is expected to be as \(rhs)", file: file, line: line)
    }
    
}
