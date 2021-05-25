//
//  ImageSearchingDispatcher.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import Foundation
import Combine

protocol SearchTextReducerObject: AnyObject {
    func makeSearchTextInput(from text: String) -> SearchTextInput
}

protocol ImageSearchingAPIClientObject: AnyObject {
    func searchImage(with line: String) -> AnyPublisher<CatImage, GeneralError>
}

protocol ImageSearchingDispatcherRepositoryObject: AnyObject {
    var searchText: SearchTextInput { get set }
    var downloadedImage: AsyncState<CatImage, GeneralError> { get set }
}

final class ImageSearchingDispatcher<Reducer: SearchTextReducerObject,
                                     APIClient: ImageSearchingAPIClientObject,
                                     Repository: ImageSearchingDispatcherRepositoryObject> {
    
    let reducer: Reducer
    let apiClient: APIClient
    let repository: Repository
    
    private var searchingTask: AnyCancellable?
    
    init(reducer: Reducer, apiClient: APIClient, repository: Repository) {
        self.reducer = reducer
        self.apiClient = apiClient
        self.repository = repository
    }
    
}

extension ImageSearchingDispatcher {
    
    func setSearchText(_ text: String) {
        
        repository.searchText = reducer.makeSearchTextInput(from: text)
        
    }
    
    func removedDownloadedImage() {
        
        repository.downloadedImage = nil
        
    }
    
    func searchImage(with line: String) {
        
        repository.downloadedImage = .fetching
        apiClient.searchImage(with: line)
            .assign(to: \.downloadedImage, on: repository)
            .store(byReplacing: &searchingTask)
        
    }
    
}
