//
//  AppResolver.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/25.
//

import SwiftUI
import Combine

final class AppResolver: ObservableObject {
    
    private lazy var repository = AppRepository()
    
    private lazy var userDefaultDatabase = UserDefaultsDatabase()
    private lazy var apiClient = CataasAPIClient()
    
    private lazy var catImageSearchTextReducer = CatImageSearchTextReducer(maxCharacterCount: 10)
    
    private lazy var imageSearchingDispatcher = ImageSearchingDispatcher(reducer: catImageSearchTextReducer,
                                                                         apiClient: apiClient,
                                                                         repository: repository)
    private lazy var imageSavingDispatcher = ImageSavingDispatcher(userDatabase: userDefaultDatabase,
                                                                   repository: repository)
    
    private lazy var appRouter = AppRouter(resolverDelegate: self)
        
    var objectWillChange: ObservableObjectPublisher {
        repository.objectWillChange
    }
    
}

extension AppResolver {
    
    @ViewBuilder
    func makeView() -> some View {
        appRouter.makeAppView()
    }
    
}

extension AppResolver: AppRouterResolverDelegate {
    
    @ViewBuilder
    func appRouterNeedsView(for viewID: ViewID) -> some View {
        switch viewID {
        case .searchScene:
            SearchScene(routerDelegate: appRouter, dispatcher: imageSearchingDispatcher, repository: repository)
            
        case .savedImageListScene:
            SavedImageListScene(routerDelegate: appRouter, dispatcher: imageSavingDispatcher, repository: repository)
            
        case .imagePreviewScene(image: let image):
            ImagePreviewScene(dispatcher: imageSavingDispatcher, repository: repository, image: image)
        }
    }
    
}
