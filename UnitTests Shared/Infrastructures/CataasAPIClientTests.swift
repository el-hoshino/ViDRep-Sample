//
//  CataasAPIClientTests.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import XCTest
@testable import ViDRep_Sample

class CataasAPIClientTests: XCTestCase {
    
    func test_makeURLRequest() {
        
        let client = CataasAPIClient()
        let request = client.makeURLRequest(percentEncodedText: "LGTM")
        XCTAssertEqual(request.url?.absoluteString, "https://cataas.com/cat/says/LGTM?json=true")
        
    }
    
}
