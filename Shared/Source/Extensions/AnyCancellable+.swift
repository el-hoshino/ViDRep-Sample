//
//  AnyCancellable+.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import Combine

extension AnyCancellable {
    
    func store(byReplacing source: inout AnyCancellable?) {
        source?.cancel()
        source = self
    }
    
}
