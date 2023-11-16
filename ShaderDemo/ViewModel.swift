//
//  ViewModel.swift
//  ShaderDemo
//
//  Created by Nien Lam on 11/1/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//

import Foundation
import Combine

// MARK: - View model for handling communication between the UI and ARView.

@MainActor
class ViewModel: ObservableObject {
    let uiSignal = PassthroughSubject<UISignal, Never>()
    
    enum UISignal {
        case reset
    }
}
