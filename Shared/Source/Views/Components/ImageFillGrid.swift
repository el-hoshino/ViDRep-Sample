//
//  ImageFillGrid.swift
//  ViDRep-Sample (iOS)
//
//  Created by 史 翔新 on 2021/05/26.
//

import SwiftUI

struct ImageFillGrid<Error: Swift.Error>: View {
    
    var image: AsyncState<ImageData, Error>
    
    var body: some View {
        
        GeometryReader { proxy in
            Container(image: image)
                .aspectRatio(contentMode: .fill)
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .clipped()
        
    }
    
}

private struct Container<Error: Swift.Error>: View {
    
    var image: AsyncState<ImageData, Error>
    
    var body: some View {
        
        switch image.data {
        case .none:
            Color.white
            
        case .fetching:
            ProgressView()
            
        case .failed:
            Color.gray
            
        case .retrieved(let image):
            Image(image: image)
        }
        
    }
    
}

private struct Image: View {
    
    var image: ImageData
    
    var body: some View {
        
        #if canImport(UIKit)
        SwiftUI.Image(uiImage: image)
            .resizable()
        #elseif canImport(AppKit)
        SwiftUI.Image(nsImage: image)
            .resizable()
        #endif
        
    }
    
}

struct ImageFillGrid_Previews: PreviewProvider {
    
    private static let context = CIContext()
    
    private static func makeDummyImage(text: String) -> ImageData {
        let ciGenerator = CIFilter.qrCodeGenerator()
        ciGenerator.correctionLevel = "H"
        ciGenerator.message = text.data(using: .utf8)!
        let qrCode = ciGenerator.outputImage!
        let output = context.createCGImage(qrCode, from: qrCode.extent)!
        #if canImport(UIKit)
        let image = ImageData(cgImage: output)
        #elseif canImport(AppKit)
        let image = ImageData(cgImage: output, size: .zero)
        #endif
        return image
    }
    
    private static let images: [ImageData] = {
        [
            "abc",
            "def",
            "ghi",
            "jkl",
        ]
        .map(makeDummyImage(text:))
    }()
    
    static var previews: some View {
        
        LazyVGrid(columns: .init(repeating: GridItem(.fixed(100)),
                                                      count: 3)) {
            ForEach(images, id: \.self) {
                ImageFillGrid<Never>(image: .retrieved($0))
                    .aspectRatio(1, contentMode: .fill)
            }
        }
        
    }
    
}
