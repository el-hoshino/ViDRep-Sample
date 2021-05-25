//
//  SavedImageList.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/25.
//

import Foundation

struct SavedImageList: Equatable {
    private(set) var ids: [CatImage.ID]
    private(set) var images: [CatImage.ID: AsyncState<ImageData, DataSaveLoadError>]
}

extension SavedImageList {
    
    init(images: [CatImage]) {
        self.ids = images.map(\.id)
        self.images = images.reduce(into: [:], { $0[$1.id] = .retrieved($1.image) })
    }
    
    init(imageStates: [(id: CatImage.ID, state: AsyncState<ImageData, DataSaveLoadError>)]) {
        self.ids = imageStates.map(\.id)
        self.images = imageStates.reduce(into: [:], { $0[$1.id] = $1.state })
    }
    
}

extension SavedImageList {
    
    var isEmpty: Bool {
        ids.isEmpty
    }
    
}

extension SavedImageList {
    
    mutating func saveImage(_ image: CatImage) {
        
        guard !ids.contains(image.id) else {
            return
        }
        
        ids.append(image.id)
        images[image.id] = .retrieved(image.image)
        
    }
    
}

extension SavedImageList {
    
    mutating func removeImage(with id: CatImage.ID) {
        
        guard ids.contains(id) else {
            assertionFailure()
            return
        }
        
        ids.removeAll(where: { $0 == id })
        images.removeValue(forKey: id)
        
    }
    
}

extension SavedImageList {
    
    mutating func modifyImage(_ imageState: AsyncState<ImageData, DataSaveLoadError>, with id: CatImage.ID) {
        
        guard ids.contains(id) else {
            assertionFailure()
            return
        }
        
        images[id] = imageState
        
    }
    
}
