//
//  ImageSearchingDispatcherTests.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import XCTest
import Combine
@testable import ViDRep_Sample

final class ImageSearchingDispatcherTests: XCTestCase {
    
    private final class Mock: SearchTextReducerObject,
                              ImageSearchingAPIClientObject,
                              ImageSearchingDispatcherRepositoryObject {
        
        var searchText: SearchTextInput = .init("")
        var downloadedImage: AsyncState<CatImage, GeneralError> = nil
        
        func makeSearchTextInput(from text: String) -> SearchTextInput {
            if text == "invalid" {
                return .init(value: text, localValidation: .invalid([.textTooLong, .textContainsDog]))
            } else {
                return .init(value: text, localValidation: .valid)
            }
        }
        
        func searchImage(with line: String) -> AnyPublisher<CatImage, GeneralError> {
            if line == "error" {
                return Fail(error: .urlError(URLError(.badURL))).eraseToAnyPublisher()
            } else {
                return Just(.init(id: "xyz", image: .init())).setFailureType(to: GeneralError.self).eraseToAnyPublisher()
            }
        }
        
    }
    
    func testSetSearchText() {
        
        let mock = Mock()
        let dispatcher = ImageSearchingDispatcher(reducer: mock, apiClient: mock, repository: mock)
        
        XCTAssertEqual(mock.searchText, .init(""))
        
        typealias SUT = (line: UInt, input: String, expected: SearchTextInput.LocalValidation)
        let suts: [SUT] = [
            (#line, "abc", .valid),
            (#line, "invalid", .invalid([.textTooLong, .textContainsDog])),
        ]
        
        for sut in suts {
            dispatcher.setSearchText(sut.input)
            XCTAssertEqual(mock.searchText, .init(value: sut.input, localValidation: sut.expected), line: sut.line)
        }
        
    }
    
    func testRemoveDownloadedImage() {
        
        let mock = Mock()
        let dispatcher = ImageSearchingDispatcher(reducer: mock, apiClient: mock, repository: mock)
        
        XCTAssertEqual(mock.downloadedImage.data, .none)
        
        mock.downloadedImage = .fetching
        XCTAssertEqual(mock.downloadedImage.data, .fetching)
        
        dispatcher.removedDownloadedImage()
        XCTAssertEqual(mock.downloadedImage.data, .none)
        
    }
    
    func testSearchImage() {
        
        let mock = Mock()
        let dispatcher = ImageSearchingDispatcher(reducer: mock, apiClient: mock, repository: mock)
        
        typealias SUT = (line: UInt, input: String, expected: AsyncState<CatImage, GeneralError>)
        let suts: [SUT] = [
            (#line, "any", .init(.retrieved(.init(id: "xyz", image: .init())))),
            (#line, "error", .init(.failed(.urlError(.init(.badURL))))),
        ]
        
        for sut in suts {
            dispatcher.searchImage(with: sut.input)
            XCTExpect(mock.downloadedImage, as: sut.expected, line: sut.line)
        }
        
    }
    
    func testRunSearchSceneAction() {
        
        let mock = Mock()
        let dispatcher = ImageSearchingDispatcher(reducer: mock, apiClient: mock, repository: mock)
        
        XCTAssertEqual(mock.searchText, .init(value: "", localValidation: .none))
        XCTAssertEqual(mock.downloadedImage.data, .none)
        
        dispatcher.runAction(.inputText("search text"))
        XCTAssertEqual(mock.searchText, .init(value: "search text", localValidation: .valid))
        XCTAssertEqual(mock.downloadedImage.data, .none)
        
        dispatcher.runAction(.searchImage)
        XCTAssertEqual(mock.searchText, .init(value: "search text", localValidation: .valid))
        XCTAssertEqual(mock.downloadedImage.data, .retrieved(.init(id: "xyz", image: .init())))
        
    }
    
}
