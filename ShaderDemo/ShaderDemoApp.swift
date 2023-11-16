//
//  ShaderDemoApp.swift
//  ShaderDemo
//
//  Created by Nien Lam on 11/1/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//

import UIKit
import SwiftUI

@main
struct ShaderDemoApp: App {
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)
        }
    }
}

