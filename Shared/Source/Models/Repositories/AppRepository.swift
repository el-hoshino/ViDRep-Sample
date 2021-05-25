//
//  AppRepository.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import Foundation
import Combine

final class AppRepository: ObservableObject {
    
    @Published var _searchSceneRoute: SearchSceneRoute?
    @Published var _savedImageListSceneRoute: SavedImageListSceneRoute?
    
    @Published var _searchText: SearchTextInput = .init("")
    @Published var _downloadedImage: AsyncState<CatImage, GeneralError> = .none
    @Published var _savedImages: SavedImageList = .init(images: [])
    
    private let savedImagesSemaphore = DispatchSemaphore(value: 1)
    
}
