//
//  Publisher+.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/23.
//

import Combine

extension Publisher {
    
    func assign <Holder: AnyObject> (to stateKeyPath: ReferenceWritableKeyPath<Holder, AsyncState<Output, Failure>>, on holder: Holder) -> AnyCancellable {
        
        sink { completion in
            switch completion {
            case .finished:
                break
                
            case .failure(let error):
                holder[keyPath: stateKeyPath] = .failed(error)
            }
        } receiveValue: { output in
            holder[keyPath: stateKeyPath] = .retrieved(output)
        }

        
    }
    
}
