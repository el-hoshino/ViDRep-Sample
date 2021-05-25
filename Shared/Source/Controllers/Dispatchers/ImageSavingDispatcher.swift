//
//  ImageSavingDispatcher.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/25.
//

import Foundation
import Combine

protocol ImageSavingDispatcherUserDatabaseObject: AnyObject {
    func saveImageIDs(_ ids: [CatImage.ID])
    func loadImageIDs() -> [CatImage.ID]?
    func saveImageData(_ data: Data?, with id: CatImage.ID)
    func loadImageData(with id: CatImage.ID) -> Data?
}

protocol ImageSavingDispatcherRepositoryObject: AnyObject {
    var savedImages: SavedImageList { get set }
}

final class ImageSavingDispatcher<UserDatabase: ImageSavingDispatcherUserDatabaseObject,
                                  Repository: ImageSavingDispatcherRepositoryObject> {
    
    let userDatabase: UserDatabase
    let repository: Repository
    
    private let savedImageModifyingSemaphore = DispatchSemaphore(value: 1)
    
    init(userDatabase: UserDatabase, repository: Repository) {
        self.userDatabase = userDatabase
        self.repository = repository
        initializeSavedData()
    }
    
    private func initializeSavedData() {
        if repository.savedImages.isEmpty {
            let ids = userDatabase.loadImageIDs() ?? []
            let savedImages = ids.map { ($0, AsyncState<ImageData, DataSaveLoadError>.none) }
            repository.savedImages = .init(imageStates: savedImages)
        }
    }
    
}

extension ImageSavingDispatcher {
    
    func saveImage(_ image: CatImage) {
        
        savedImageModifyingSemaphore.wait()
        defer { savedImageModifyingSemaphore.signal() }
        
        repository.savedImages.saveImage(image)
        
        do {
            let newSavedImageIDs = repository.savedImages.ids
            userDatabase.saveImageIDs(newSavedImageIDs)
            guard let data = image.image.extracted() else {
                throw DataSaveLoadError.failedToExtractDataToSave(image.image)
            }
            userDatabase.saveImageData(data, with: image.id)
            
        } catch let error as DataSaveLoadError {
            repository.savedImages.modifyImage(.failed(error), with: image.id)
            
        } catch {
            assertionFailure("\(error)")
        }
        
    }
    
    func removeImage(with id: CatImage.ID) {
        
        savedImageModifyingSemaphore.wait()
        defer { savedImageModifyingSemaphore.signal() }
        
        repository.savedImages.removeImage(with: id)
        
        do {
            let newSavedImageIDs = repository.savedImages.ids
            userDatabase.saveImageIDs(newSavedImageIDs)
            userDatabase.saveImageData(nil, with: id)
        }
        
    }
    
    func loadImage(with id: CatImage.ID) {
        
        savedImageModifyingSemaphore.wait()
        defer { savedImageModifyingSemaphore.signal() }
        
        do {
            guard let imageData = userDatabase.loadImageData(with: id) else {
                throw DataSaveLoadError.noDataSaved
            }
            guard let image = ImageData(data: imageData) else {
                throw DataSaveLoadError.failedToConvertDataToTargetType(imageData)
            }
            repository.savedImages.modifyImage(.retrieved(image), with: id)
            
        } catch let error as DataSaveLoadError {
            repository.savedImages.modifyImage(.failed(error), with: id)
            
        } catch {
            assertionFailure("\(error)")
        }
        
    }
    
}
