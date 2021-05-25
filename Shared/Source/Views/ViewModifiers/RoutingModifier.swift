//
//  RoutingModifier.swift
//  ViDRep-Sample
//
//  Created by 史 翔新 on 2021/05/25.
//

import SwiftUI

protocol RouterObject: ObservableObject {
    
    associatedtype NextNavigationView: View
    func navigationBinding(for viewID: ViewID) -> Binding<Bool>
    @ViewBuilder func nextNavigationView(for viewID: ViewID) -> NextNavigationView
    
    associatedtype NextPresentationView: View
    func presentationBinding(for viewID: ViewID) -> Binding<Bool>
    @ViewBuilder func nextPresentationView(for viewID: ViewID) -> NextPresentationView
    
}

struct RoutingModifier<Router: RouterObject>: ViewModifier {
    
    @ObservedObject var router: Router
    var currentViewID: ViewID
    
    func body(content: Content) -> some View {
        content
            .background(EmptyNavigationLink(destination: router.nextNavigationView(for: currentViewID), isActive: router.navigationBinding(for: currentViewID)))
            .popover(isPresented: router.presentationBinding(for: currentViewID), content: { router.nextPresentationView(for: currentViewID) })
    }
    
}

private struct EmptyNavigationLink<Destination: View>: View {
    
    var destination: Destination
    var isActive: Binding<Bool>
    
    var body: some View {
        NavigationLink(destination: destination,
                       isActive: isActive,
                       label: { EmptyView() })
            .hidden()
    }
    
}

extension View {
    
    func injectRouter<Router: RouterObject>(_ router: Router, with viewID: ViewID) -> some View {
        modifier(RoutingModifier(router: router, currentViewID: viewID))
    }
    
}
