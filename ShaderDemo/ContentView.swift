//
//  ContentView.swift
//  MaterialsDemo
//
//  Created by Nien Lam on 11/1/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//

import SwiftUI
import RealityKit

// MARK: - UI Layer.
struct ContentView : View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            // AR View.
            ARViewContainer(viewModel: viewModel)
            
            // Lock / release button & filter button.
            VStack(alignment: .leading, spacing: 20) {
                filterButton()
                lockButton()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding()

            // Enable / disable entities.
            VStack(alignment: .trailing) {
                lightButton()
                spheresButton()
                boardButton()
                chairButton()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding()
            
        }
        .edgesIgnoringSafeArea(.all)
        .statusBar(hidden: true)
    }
    
    func lockButton() -> some View {
        Button {
            viewModel.positionIsLocked.toggle()
        } label: {
            Label("Lock Position", systemImage: "target")
                .font(.system(.title))
                .foregroundColor(viewModel.positionIsLocked ? .yellow : .white)
                .labelStyle(IconOnlyLabelStyle())
                .frame(width: 44, height: 44)
        }
    }

    func lightButton() -> some View {
        Button {
            viewModel.directionalLightEnabled.toggle()
        } label: {
            Label("Light", systemImage: "light.overhead.left.fill")
                .font(.system(.title))
                .foregroundColor(viewModel.directionalLightEnabled ? .yellow : .white)
                .labelStyle(IconOnlyLabelStyle())
                .frame(width: 44, height: 44)
        }
    }

    func spheresButton() -> some View {
        Button {
            viewModel.sphereEnabled.toggle()
        } label: {
            Label("Spheres", systemImage: "rotate.3d.fill")
                .font(.system(.title))
                .foregroundColor(viewModel.sphereEnabled ? .yellow : .white)
                .labelStyle(IconOnlyLabelStyle())
                .frame(width: 44, height: 44)
        }
    }

    func boardButton() -> some View {
        Button {
            viewModel.boardEnabled.toggle()
        } label: {
            Label("Checkerboard", systemImage: "rectangle.checkered")
                .font(.system(.title))
                .foregroundColor(viewModel.boardEnabled ? .yellow : .white)
                .labelStyle(IconOnlyLabelStyle())
                .frame(width: 44, height: 44)
        }
    }

    func chairButton() -> some View {
        Button {
            viewModel.chairEnabled.toggle()
        } label: {
            Label("Chair", systemImage: "chair")
                .font(.system(.title))
                .foregroundColor(viewModel.chairEnabled ? .yellow : .white)
                .labelStyle(IconOnlyLabelStyle())
                .frame(width: 44, height: 44)
        }
    }
    
    func filterButton() -> some View {
        Button {
            viewModel.filtersIdx = (viewModel.filtersIdx + 1) % 6
        } label: {
            Label("Filters", systemImage: "camera.filters")
                .font(.system(.title))
                .foregroundColor(viewModel.filtersIdx > 0 ? .yellow : .white)
                .labelStyle(IconOnlyLabelStyle())
                .frame(width: 44, height: 44)
        }
    }
}
