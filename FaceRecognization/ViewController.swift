//
//  ViewController.swift
//  FaceRecognization
//
//  Created by Abhishek Kumar on 15/08/20.
//  Copyright © 2020 Abhishek. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    
    @IBOutlet var arView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arView.delegate = self
        guard ARFaceTrackingConfiguration.isSupported else {
            print("Not supported")
            return
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupARView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        arView.session.pause()
    }

    func setupARView() {
        let scence = SCNScene()
        arView.scene = scence
        
        let config = ARFaceTrackingConfiguration()
        arView.session.run(config)
        self.view = arView
    }
    
}

extension ViewController : ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let _ = anchor as? ARFaceAnchor, let device = arView.device else { return nil }
        let faceGeometory = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometory)
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometory = node.geometry as? ARSCNFaceGeometry else {
            return
        }
        faceGeometory.update(from: faceAnchor.geometry)
    }
    
}
