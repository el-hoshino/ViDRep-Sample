//
//  VocabularyDispatcherTests.swift
//  Tests iOS
//
//  Created by 史 翔新 on 2021/02/20.
//

import XCTest
@testable import ViDRep_Sample

// TIPS: Using mocking libraries like Cuckoo or MockingBird could make the test easier to read & write.

class VocabularyDispatcherTests: XCTestCase {
    
    func test_addVocabulary() {
        
        let expected: [String] = ["appending test"]
        let reducer = MockReducer(appendingAction: { return expected })
        
        let expect1 = expectation(description: "addVocabulary")
        let repository1 = MockRepository(expect: expect1, expected: expected)
        let dispatcher1 = VocabularyDispatcher(reducer: reducer,
                                               repository: repository1)
        dispatcher1.addVocabulary("test")
        
        let expect2 = expectation(description: "runAction")
        let repository2 = MockRepository(expect: expect2, expected: expected)
        let dispatcher2 = VocabularyDispatcher(reducer: reducer,
                                               repository: repository2)
        dispatcher2.runAction(.add(vocabulary: "test"))
        
        wait(for: [expect1, expect2], timeout: 1)
        
        XCTAssertEqual(repository1.vocabularies, expected)
        XCTAssertEqual(repository2.vocabularies, expected)
        
    }
    
    func test_resetVocabulary() {
        
        let expected: [String] = ["reset test"]
        let reducer = MockReducer(initialAction: { return expected })
        
        let expect1 = expectation(description: "resetVocabulary")
        let repository1 = MockRepository(expect: expect1, expected: expected)
        let dispatcher1 = VocabularyDispatcher(reducer: reducer,
                                              repository: repository1)
        dispatcher1.resetVocabulary()
        
        let expect2 = expectation(description: "runAction")
        let repository2 = MockRepository(expect: expect2, expected: expected)
        let dispatcher2 = VocabularyDispatcher(reducer: reducer,
                                               repository: repository2)
        dispatcher2.runAction(.reset)
        
        wait(for: [expect1, expect2], timeout: 1)
        
        XCTAssertEqual(repository1.vocabularies, expected)
        XCTAssertEqual(repository2.vocabularies, expected)
        
    }
    
}

private final class MockRepository: VocabularyRepositoryObject {
    
    var vocabularies: [String] = []
    
    let expect: XCTestExpectation
    let expected: [String]
    
    init(expect: XCTestExpectation, expected: [String]) {
        self.expect = expect
        self.expected = expected
    }
    
    func editVocabularies(_ edit: (inout [String]) -> Void) {
        defer { expect.fulfill() }
        edit(&vocabularies)
        XCTAssertEqual(vocabularies, expected)
    }
    
}

private final class MockReducer: VocabularyReducerObject {
    
    typealias Action = () -> [String]
    let appendingAction: () -> [String]
    let initialAction: () -> [String]
    
    init(
        appendingAction: @escaping Action = {
            XCTFail()
            return []
        },
        initialAction: @escaping Action = {
            XCTFail()
            return []
        }
    ) {
        self.appendingAction = appendingAction
        self.initialAction = initialAction
    }
    
    func appending(_ vocabulary: String, to array: [String]) -> [String] {
        return appendingAction()
    }
    
    func initial() -> [String] {
        return initialAction()
    }
    
}
