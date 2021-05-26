//
//  ImageData.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/25.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
typealias ImageData = UIImage
#elseif canImport(AppKit)
typealias ImageData = NSImage
#endif

extension ImageData {
    
    func extracted() -> Data? {
        
        #if canImport(UIKit)
        return pngData()
        
        #elseif canImport(APPKit)
        guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let rep = NSBitmapImageRep(cgImage: cgImage)
        return rep.representation(using: .png, properties: [:])
        
        #endif
        
    }
    
}
