//
//  AnyCancellableTests.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/26.
//

import XCTest
import Combine
@testable import ViDRep_Sample

class AnyCancellableTests: XCTestCase {
    
    func test_storeByReplacing() {
        
        var onCancelWritingTarget = ""
        var cancellable: AnyCancellable? = AnyCancellable({ onCancelWritingTarget = "cancelled" })
        
        let anotherCancellable = AnyCancellable({ /* do nothing */ })
        XCTAssertEqual(onCancelWritingTarget, "")
        XCTAssertNotIdentical(cancellable, anotherCancellable)
        
        anotherCancellable.store(byReplacing: &cancellable)
        XCTAssertEqual(onCancelWritingTarget, "cancelled")
        XCTAssertIdentical(cancellable, anotherCancellable)
        
    }
    
}
