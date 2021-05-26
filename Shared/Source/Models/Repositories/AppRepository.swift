//
//  AppRepository.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import Foundation
import Combine

final class AppRepository: ObservableObject {
    
    @Published var _searchText: SearchTextInput = .init("")
    @Published var _downloadedImage: AsyncState<CatImage, GeneralError> = .none
    @Published var _savedImages: SavedImageList = .init(images: [])
    
    private let savedImagesSemaphore = DispatchSemaphore(value: 1)
    
}

extension AppRepository: ImageSearchingDispatcherRepositoryObject {
    
    var searchText: SearchTextInput {
        get {
            return _searchText
        }
        set {
            DispatchQueue.main.async {
                self._searchText = newValue
            }
        }
    }
    
    var downloadedImage: AsyncState<CatImage, GeneralError> {
        get {
            return _downloadedImage
        }
        set {
            DispatchQueue.main.async {
                self._downloadedImage = newValue
            }
        }
    }
    
}

extension AppRepository: ImageSavingDispatcherRepositoryObject {
    
    var savedImages: SavedImageList {
        get {
            savedImagesSemaphore.wait()
            defer { savedImagesSemaphore.signal() }
            return _savedImages
        }
        set {
            savedImagesSemaphore.wait()
            DispatchQueue.main.async {
                defer { self.savedImagesSemaphore.signal() }
                self._savedImages = newValue
            }
        }
    }
    
}

extension AppRepository: SearchSceneRepositoryObject {
    
    func state() -> SearchSceneState {
        .init(inputText: _searchText,
              searchResult: _downloadedImage)
    }
    
}

extension AppRepository: SavedImageListSceneRepository {
    
    func state() -> SavedImageListSceneState {
        .init(list: _savedImages)
    }
    
}

extension AppRepository: ImagePreviewSceneRepositoryObject {
    
    func state(image: CatImage) -> ImagePreviewSceneState {
        .init(isFavorite: _savedImages.ids.contains(image.id))
    }
    
}
