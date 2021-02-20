//
//  HomeView.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/02/20.
//

import SwiftUI

enum HomeDispatcherObjectAction {
    case add(vocabulary: String)
    case reset
}

protocol HomeDispatcherObject: AnyObject {
    func runAction(_ action: HomeDispatcherObjectAction)
}

protocol HomeRepositoryObject: ObservableObject {
    var vocabularies: [String] { get }
}

struct HomeView<Repository: HomeRepositoryObject, Dispatcher: HomeDispatcherObject>: View {
    
    @State private var input: String = ""
    
    @StateObject var repository: Repository
    
    let dispatcher: Dispatcher
    
    var body: some View {
        
        VStack {
            
            HStack {
                TextField("Vocabulary Input", text: $input)
                Button("Add") {
                    dispatcher.runAction(.add(vocabulary: input))
                    input = ""
                }
                .disabled(input.isEmpty)
            }
            
            ForEach(repository.vocabularies) {
                Text($0)
            }
            .onLongPressGesture {
                dispatcher.runAction(.reset)
            }
            
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    
    private final class Repository: HomeRepositoryObject {
        var vocabularies: [String] {
            return "This Is A Sample Project".components(separatedBy: " ")
        }
    }
    
    private final class Dispatcher: HomeDispatcherObject {
        func runAction(_ action: HomeDispatcherObjectAction) {
            
        }
    }
    
    private static let repository = Repository()
    private static let dispatcher = Dispatcher()
    
    static var previews: some View {
        HomeView(repository: repository, dispatcher: dispatcher)
    }
}
