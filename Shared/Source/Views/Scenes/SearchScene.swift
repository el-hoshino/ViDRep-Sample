//
//  SearchScene.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/20.
//

import SwiftUI

enum SearchSceneRoute {
    case didFinishSearch(image: CatImage)
}

protocol SearchSceneRouterDelegate: AnyObject {
    func viewNeedsRoute(to route: SearchSceneRoute)
}

enum SearchSceneAction {
    case inputText(String)
    case searchImage
}

protocol SearchSceneDispatcherObject: AnyObject {
    func runAction(_ action: SearchSceneAction)
}

struct SearchSceneState {
    var inputText: SearchTextInput
    var searchResult: AsyncState<CatImage, GeneralError>
}

protocol SearchSceneRepositoryObject: ObservableObject {
    func state() -> SearchSceneState
}

struct SearchScene<RouterDelegate: SearchSceneRouterDelegate,
                   Dispatcher: SearchSceneDispatcherObject,
                   Repository: SearchSceneRepositoryObject>: View {
    
    weak var routerDelegate: RouterDelegate?
    var dispatcher: Dispatcher
    @ObservedObject var repository: Repository
    
    @State private var generalError: GeneralError?
    
    private var textBinding: Binding<String> {
        .init(get: { repository.state().inputText.value },
              set: { dispatcher.runAction(.inputText($0)) })
    }
    
    private var validationMessages: [String] {
        repository.state().inputText.localValidation.invalidMessages
    }
    
    private var searchButtonDisabled: Bool {
        return textBinding.wrappedValue.isEmpty
            || repository.state().inputText.localValidation.hasError
    }
    
    private var searchResult: AsyncState<CatImage, GeneralError> {
        repository.state().searchResult
    }
    
    var body: some View {
        
        VStack {
            
            TextField("Search cat pics with text!", text: textBinding)
            
            VStack {
                ForEach(validationMessages) {
                    Text($0)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                }
            }
            .frame(minHeight: 40)
            
            HStack {
                
                Button {
                    dispatcher.runAction(.searchImage)
                } label: {
                    Text("Search")
                }
                .disabled(searchButtonDisabled)
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .isLoading(repository.state().searchResult.isFetching)
        .alert(item: $generalError, content: makeAlert(from:))
        .onChange(of: searchResult, perform: handleSearchResult(_:))
        
    }
    
}

extension SearchScene {
    
    private func makeAlert(from generalError: GeneralError) -> Alert {
        
        return .init(title: Text(generalError.message))
        
    }
    
    private func handleSearchResult(_ result: AsyncState<CatImage, GeneralError>) {
        
        switch result.data {
        case .none, .fetching:
             break
            
        case .retrieved(let image):
            routerDelegate?.viewNeedsRoute(to: .didFinishSearch(image: image))
            
        case .failed(let error):
            generalError = error
            
        }
        
    }
    
}

struct SearchScene_Previews: PreviewProvider {
    
    private final class Mock: SearchSceneRouterDelegate,
                              SearchSceneDispatcherObject,
                              SearchSceneRepositoryObject {
        
        @Published private var text: SearchTextInput = .init("")
        private let checkInput: Bool
        
        init(validation: SearchTextInput.LocalValidation? = nil) {
            if let validation = validation {
                self.text = .init(value: "", localValidation: validation)
                self.checkInput = false
            } else {
                self.text = .init("")
                self.checkInput = true
            }
        }
        
        private func inputText(_ input: String) {
            func validate(_ input: String) -> SearchTextInput.LocalValidation {
                if input.count > 5 {
                    return .invalid([.textTooLong])
                } else {
                    return .valid
                }
            }
            if checkInput {
                text = .init(value: input, localValidation: validate(input))
            } else {
                text = .init(input)
            }
        }
        
        func viewNeedsRoute(to route: SearchSceneRoute) {
            // do nothing
        }
        
        func runAction(_ action: SearchSceneAction) {
            switch action {
            case .inputText(let input):
                inputText(input)
            case .searchImage:
                // do nothing
                break
            }
        }
        
        func state() -> SearchSceneState {
            .init(inputText: text, searchResult: .none)
        }
        
    }
    
    private static let mock = Mock()
    
    static var previews: some View {
        
        SearchScene(routerDelegate: mock,
                    dispatcher: mock,
                    repository: mock)
        
    }
    
}
