//
//  ImagePreviewScene.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/24.
//

import SwiftUI

enum ImagePreviewSceneAction {
    case markAsFavorite(CatImage)
    case removeMarkAsFavorite(CatImage)
}

protocol ImagePreviewSceneDispatcherObject: AnyObject {
    func runAction(_ action: ImagePreviewSceneAction)
}

struct ImagePreviewSceneState {
    var isFavorite: Bool
}

protocol ImagePreviewSceneRepositoryObject: ObservableObject {
    func state(image: CatImage) -> ImagePreviewSceneState
}

struct ImagePreviewScene<Dispatcher: ImagePreviewSceneDispatcherObject,
                         Repository: ImagePreviewSceneRepositoryObject>: View {
    
    var dispatcher: Dispatcher
    @ObservedObject var repository: Repository
    
    var image: CatImage
    
    private var isFavorite: Bool {
        repository.state(image: image).isFavorite
    }
    
    private var favoriteButtonImageName: String {
        isFavorite ? "heart.fill" : "heart"
    }
    
    @ViewBuilder
    private var favoriteButton: some View {
        
        Button {
            isFavorite
                ? dispatcher.runAction(.removeMarkAsFavorite(image))
                : dispatcher.runAction(.markAsFavorite(image))
        } label: {
            Image(systemName: favoriteButtonImageName)
                .font(.largeTitle)
                .fixedSize()
                .foregroundColor(.red)
        }
        
    }
    
    var body: some View {
        
        image.imageView
            .resizable(resizingMode: .stretch)
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(favoriteButton, alignment: .bottomTrailing)
        
    }
    
}

private extension CatImage {
    
    @ViewBuilder
    var imageView: Image {
        
        #if canImport(UIKit)
        Image(uiImage: image)
        #elseif canImport(AppKit)
        Image(nsImage: image)
        #endif
        
    }
    
}


import CoreImage.CIFilterBuiltins

struct ImagePreviewScene_Previews: PreviewProvider {
    
    private final class Mock: ImagePreviewSceneDispatcherObject,
                              ImagePreviewSceneRepositoryObject {
        @Published var isFavorite = false
        func runAction(_ action: ImagePreviewSceneAction) {
            switch action {
            case .markAsFavorite:
                isFavorite = true
            case .removeMarkAsFavorite:
                isFavorite = false
            }
        }
        func state(image: CatImage) -> ImagePreviewSceneState {
            return .init(isFavorite: isFavorite)
        }
    }
    
    private static let dummyImage: ImageData = {
        let context = CIContext()
        let ciGenerator = CIFilter.qrCodeGenerator()
        ciGenerator.correctionLevel = "H"
        ciGenerator.message = "This is ViDRep-Preview".data(using: .utf8)!
        let qrCode = ciGenerator.outputImage!
        let output = context.createCGImage(qrCode, from: qrCode.extent)!
        #if canImport(UIKit)
        let image = ImageData(cgImage: output)
        #elseif canImport(AppKit)
        let image = ImageData(cgImage: output, size: .zero)
        #endif
        return image
    }()
    
    private static let mock = Mock()
    
    static var previews: some View {
        
        ImagePreviewScene(dispatcher: mock,
                          repository: mock,
                          image: .init(id: "", image: dummyImage))
        
    }
    
}
