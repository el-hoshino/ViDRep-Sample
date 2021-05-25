//
//  CataasJSONResponse.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import Foundation

struct CataasJSONResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case path = "url"
    }
    
    var id: String
//    var createdAt: Date // Contained in the response, but currently no plan to use it.
//    var tags: [String] // Contained in the response, but currently no plan to use it.
    var path: String
    
}
