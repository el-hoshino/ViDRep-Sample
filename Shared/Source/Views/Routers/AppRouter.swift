//
//  AppRouter.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/25.
//

import SwiftUI
import Combine

protocol AppRouterResolverDelegate: AnyObject {
    associatedtype ResolvedView: View
    @ViewBuilder func appRouterNeedsView(for viewID: ViewID) -> ResolvedView
}

final class AppRouter<ResolverDelegate: AppRouterResolverDelegate> {
    
    weak var resolverDelegate: ResolverDelegate?
    
    @Published var searchSceneRoute: SearchSceneRoute?
    @Published var savedImageListSceneRoute: SavedImageListSceneRoute?
    
    init(resolverDelegate: ResolverDelegate) {
        self.resolverDelegate = resolverDelegate
    }
    
}

extension AppRouter {
    
    @ViewBuilder
    func searchScene() -> some View {
        if let resolver = resolverDelegate {
            resolver.appRouterNeedsView(for: .searchScene)
                .injectRouter(self, with: .searchScene)
        }
    }
    
    @ViewBuilder
    func savedImageListScene() -> some View {
        if let resolver = resolverDelegate {
            resolver.appRouterNeedsView(for: .savedImageListScene)
                .injectRouter(self, with: .savedImageListScene)
        }
    }
    
    @ViewBuilder
    func imagePreviewScene(image: CatImage) -> some View {
        if let resolver = resolverDelegate {
            resolver.appRouterNeedsView(for: .imagePreviewScene(image: image))
                .injectRouter(self, with: .imagePreviewScene(image: image))
        }
    }
    
}

extension AppRouter {
    
    @ViewBuilder
    func nextNavigationView(accordingTo route: SearchSceneRoute?) -> some View {
        if let route = route {
            switch route {
            case .didFinishSearch(let image):
                imagePreviewScene(image: image)
            }
        }
    }
    
    @ViewBuilder
    func nextNavigationView(accordingTo route: SavedImageListSceneRoute?) -> some View {
        if let route = route {
            switch route {
            case .didSelectImage(let image):
                imagePreviewScene(image: image)
            }
        }
    }
    
}

extension AppRouter {
    
    func makeAppView() -> some View {
        
        TabView {
            
            NavigationView {
                searchScene()
                    .uiNavigationBarHidden(true)
            }
            .tabItem { Text("Search") }
            
            NavigationView {
                savedImageListScene()
                    .uiNavigationBarHidden(true)
            }
            .tabItem { Text("Favorite") }
            
        }
        
    }
    
}

extension AppRouter: RouterObject {
    
    func navigationBinding(for viewID: ViewID) -> Binding<Bool> {
        switch viewID {
        case .searchScene:
            return .init(get: { [unowned self] in return self.searchSceneRoute != nil },
                         set: { [unowned self] in assert($0 == false); self.searchSceneRoute = nil })
            
        case .savedImageListScene:
            return .init(get: { [unowned self] in return self.savedImageListSceneRoute != nil },
                         set: { [unowned self] in assert($0 == false); self.savedImageListSceneRoute = nil })
            
        case .imagePreviewScene:
            return .constant(false)
        }
    }
    
    @ViewBuilder
    func nextNavigationView(for viewID: ViewID) -> some View {
        switch viewID {
        case .searchScene:
            nextNavigationView(accordingTo: searchSceneRoute)
            
        case .savedImageListScene:
            nextNavigationView(accordingTo: savedImageListSceneRoute)
            
        case .imagePreviewScene:
            EmptyView()
        }
    }
    
    func presentationBinding(for viewID: ViewID) -> Binding<Bool> {
        return .constant(false)
    }
    
    @ViewBuilder
    func nextPresentationView(for viewID: ViewID) -> some View {
        EmptyView()
    }
}

extension AppRouter: SearchSceneRouterDelegate {
    
    func viewNeedsRoute(to route: SearchSceneRoute) {
        searchSceneRoute = route
    }
    
}

extension AppRouter: SavedImageListSceneRouterDelegate {
    
    func viewNeedsRoute(to route: SavedImageListSceneRoute) {
        savedImageListSceneRoute = route
    }
    
}

private extension View {
    @ViewBuilder
    func uiNavigationBarHidden(_ hidden: Bool) -> some View {
        #if canImport(UIKit)
        navigationBarHidden(hidden)
        #elseif canImport(AppKit)
        self
        #endif
    }
}
