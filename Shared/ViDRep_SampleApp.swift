//
//  ViDRep_SampleApp.swift
//  Shared
//
//  Created by 史 翔新 on 2021/02/20.
//

import SwiftUI

let repository = Repository()
let reducer = VocabularyReducer()
let dispatcher = VocabularyDispatcher(reducer: reducer, repository: repository)

@main
struct ViDRep_SampleApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(repository: repository, dispatcher: dispatcher)
        }
    }
}
