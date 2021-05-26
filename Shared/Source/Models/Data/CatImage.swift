//
//  CatImage.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import Foundation

struct CatImage: Identifiable {
    
    let id: String
    let image: ImageData
    
}

extension CatImage: Equatable {
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
}
