//
//  ARView.swift
//  ShaderDemo
//
//  Created by Nien Lam on 11/1/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

// Metal library.
let library = MTLCreateSystemDefaultDevice()!.makeDefaultLibrary()!


// MARK: - AR View.
struct ARViewContainer: UIViewRepresentable {
    let viewModel: ViewModel
    
    func makeUIView(context: Context) -> ARView {
        SimpleARView(frame: .zero, viewModel: viewModel)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

class SimpleARView: ARView {
    var viewModel: ViewModel
    var arView: ARView { return self }
    var originAnchor: AnchorEntity!
    var subscriptions = Set<AnyCancellable>()

    let rotationGestureSpeed: Float = 0.005

    // Place holder anchor.
    var simulatedAnchor: Entity!
    
    var exampleUSDZModel: ModelEntity!
    
    // Load a geometry modifier function named.
    let geometryModifier = CustomMaterial.GeometryModifier(named: "wrapGeometry",
                                                           in: library)

    // Load a surface shader function.
    let surfaceShader = CustomMaterial.SurfaceShader(named: "passthroughSurfaceShader",
                                                     in: library)
//    let surfaceShader = CustomMaterial.SurfaceShader(named: "pulsingSurfaceShader",
//                                                     in: library)

    init(frame: CGRect, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        setupScene()
        
        setupEntities()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let deltaX = touch.location(in: self).x - touch.previousLocation(in: self).x
        simulatedAnchor.orientation *= simd_quatf(angle: Float(deltaX) * rotationGestureSpeed, axis: [0,1,0])
    }

    func setupScene() {
        arView.renderOptions = [.disableDepthOfField, .disableMotionBlur]

        // Process UI signals.
        viewModel.uiSignal.sink { [weak self] in
            self?.processUISignal($0)
        }.store(in: &subscriptions)
    }

    // Process UI signals.
    func processUISignal(_ signal: ViewModel.UISignal) {
        switch signal {
        case .reset:
            print("👇 Did press reset button")
            simulatedAnchor.orientation = simd_quatf(angle: 0, axis: [0,1,0])
        }
    }

    // Setup method.
    func setupEntities() {
        // Create an anchor at scene origin.
        originAnchor = AnchorEntity(world: .zero)
        arView.scene.addAnchor(originAnchor)

        // Offset set plane origin in front and below simulator camera.
        simulatedAnchor = Entity()
        simulatedAnchor.position = [0, -0.125, 1.5]
        originAnchor.addChild(simulatedAnchor)
        
        // Add directional light.
        let directionalLight = DirectionalLight()
        directionalLight.light.intensity = 750
        directionalLight.look(at: [0,0,0], from: [1, 1.1, 1.3], relativeTo: originAnchor)
        directionalLight.shadow = DirectionalLightComponent.Shadow(maximumDistance: 0.5, depthBias: 2)
        simulatedAnchor.addChild(directionalLight)
        

        // Add checkerboard plane.
        var checkerBoardMaterial = PhysicallyBasedMaterial()
        checkerBoardMaterial.baseColor.texture = .init(try! .load(named: "checker.png"))
        let checkerBoardPlane = ModelEntity(mesh: .generatePlane(width: 0.5, depth: 0.5), materials: [checkerBoardMaterial])
        simulatedAnchor.addChild(checkerBoardPlane)
         
        // Add example usdz model.
        exampleUSDZModel = try! Entity.loadModel(named: "box-a")
        // exampleUSDZModel = try! Entity.loadModel(named: "box-b")
        exampleUSDZModel.position.y = 0.05
        simulatedAnchor.addChild(exampleUSDZModel!)

        
        var checkerBoardMaterialTinted = PhysicallyBasedMaterial()
        checkerBoardMaterialTinted.baseColor.texture = .init(try! .load(named: "checker.png"))
        checkerBoardMaterialTinted.baseColor.tint = .yellow
        
        let customMaterial = try! CustomMaterial(from: checkerBoardMaterialTinted,
                                                 surfaceShader: surfaceShader,
                                                 geometryModifier: geometryModifier)
        exampleUSDZModel.model?.materials = [customMaterial]
    }
}
