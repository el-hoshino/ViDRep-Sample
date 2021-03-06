//
//  ViDRep_SampleApp.swift
//  Shared
//
//  Created by 史 翔新 on 2021/02/20.
//

import SwiftUI

@main
struct ViDRep_SampleApp: App {
    
    @StateObject var appResolver = AppResolver()
    
    var body: some Scene {
        WindowGroup {
            appResolver.makeView()
        }
    }
}
