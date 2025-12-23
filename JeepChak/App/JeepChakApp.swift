//
//  JeepChakApp.swift
//  JeepChak
//
//  Created by 김은찬 on 10/18/25.
//

import SwiftUI
import NMapsMap

@main
struct JeepChakApp: App {
    init() {
            NMFAuthManager.shared().ncpKeyId = "5senpkgczx"
        }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
