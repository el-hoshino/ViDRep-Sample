//
//  SavedImageListScene.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/24.
//

import SwiftUI

enum SavedImageListSceneRoute {
    case didSelectImage(image: CatImage)
}

protocol SavedImageListSceneRouterDelegate: AnyObject {
    func viewNeedsRoute(to route: SavedImageListSceneRoute)
}

enum SavedImageListSceneAction {
    case loadImageData(id: CatImage.ID)
    case removeImageData(id: CatImage.ID)
}

protocol SavedImageListSceneDispatcherObject: AnyObject {
    func runAction(_ action: SavedImageListSceneAction)
}

struct SavedImageListSceneState {
    var list: SavedImageList
}

protocol SavedImageListSceneRepository: ObservableObject {
    func state() -> SavedImageListSceneState
}

struct SavedImageListScene<RouterDelegate: SavedImageListSceneRouterDelegate,
                           Dispatcher: SavedImageListSceneDispatcherObject,
                           Repository: SavedImageListSceneRepository>: View {
    
    weak var routerDelegate: RouterDelegate?
    var dispatcher: Dispatcher
    @ObservedObject var repository: Repository
    
    @State private var dataSaveLoadError: SaveLoadErrorContent?
    
    private var columns: [GridItem] {
        [.init(.adaptive(minimum: 100, maximum: 150))]
    }
    
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(repository.state().list.ids, id: \.self) { id in
                    if let image = repository.state().list.images[id] {
                        makeGrid(id: id, image: image)
                    }
                }
            }
        }
        .alert(item: $dataSaveLoadError, content: makeAlert(from:))
        .onChange(of: repository.state().list, perform: handleListResult(_:))
        
    }
    
}

extension SavedImageListScene {
    
    @ViewBuilder
    private func makeGrid(id: CatImage.ID, image: AsyncState<ImageData, DataSaveLoadError>) -> some View {
        
        ImageFillGrid(image: image)
            .aspectRatio(1, contentMode: .fill)
            .border(Color.red)
            .onTapGesture {
                if let image = image.retrieved {
                    routerDelegate?.viewNeedsRoute(to: .didSelectImage(image: .init(id: id, image: image)))
                }
            }
            .onAppear {
                if image.retrieved == nil {
                    dispatcher.runAction(.loadImageData(id: id))
                }
            }
        
    }
    
    private func makeAlert(from content: SaveLoadErrorContent) -> Alert {
        
        .init(title: Text(content.error.description),
              dismissButton: .destructive(Text("Remove"), action: {
                dispatcher.runAction(.removeImageData(id: content.id))
              }))
        
    }
    
    private func handleListResult(_ result: SavedImageList) {
        
        for imageTuple in result.images {
            switch imageTuple.value.data {
            case .none, .fetching, .retrieved:
                break
                
            case .failed(let error):
                dataSaveLoadError = .init(id: imageTuple.key, error: error)
            }
        }
        
    }
    
}

private struct SaveLoadErrorContent: Identifiable {
    
    var id: CatImage.ID
    var error: DataSaveLoadError
    
}

private extension AsyncState where Value == ImageData {
    
    @ViewBuilder
    var previewView: some View {
        
        switch data {
        case .none:
            Color.white
            
        case .fetching:
            ProgressView()
            
        case .failed:
            Color.gray
            
        case .retrieved(let image):
            #if canImport(UIKit)
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            #elseif canImport(AppKit)
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            #endif
        }
        
    }
    
}

struct SavedImageListScene_Previews: PreviewProvider {
    
    private final class Mock: SavedImageListSceneRouterDelegate,
                              SavedImageListSceneDispatcherObject,
                              SavedImageListSceneRepository {
        func viewNeedsRoute(to route: SavedImageListSceneRoute) {
            // do nothing
        }
        func runAction(_ action: SavedImageListSceneAction) {
            // do nothing
        }
        func state() -> SavedImageListSceneState {
            .init(list: .init(imageStates: [
                ("123", .none),
                ("456", .fetching),
                ("789", .failed(.noDataSaved)),
            ]))
        }
    }
    private static let mock = Mock()
    
    static var previews: some View {
        
        SavedImageListScene(routerDelegate: mock,
                            dispatcher: mock,
                            repository: mock)
        
    }
    
}
