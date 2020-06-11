//
//  ViewController.swift
//  ARShots
//
//  Created by Armando Carrillo on 03/06/20.
//  Copyright © 2020 Armando Carrillo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/hoop.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .vertical
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
  
    

    func createWall(planeAnchor : ARPlaneAnchor) -> SCNNode{
        let node = SCNNode()
        let geometry = SCNPlane(width: 0.5, height: 1)
        node.geometry = geometry
        
        node.eulerAngles.x = -Float.pi/2
        node.opacity = 0.5
        return node
        }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        print("A new plane has been discovered.")
        let wall = createWall(planeAnchor: planeAnchor)
        node.addChildNode(wall)
        
        
        
    }
    
   func addHoop(result: ARHitTestResult){
        // Retrieve the scene file and locate the Hoop node
        
        let hoopScene = SCNScene(named: "art.scnassets/hoop.scn")
        
        guard let hoopNode = hoopScene?.rootNode.childNode(withName: "Hoop", recursively: false) else {
            return
            }
        // Place the node in the correct position
        let planePosition = result.worldTransform.columns.3
        hoopNode.position = SCNVector3(planePosition.x, planePosition.y, planePosition.z)
        // Add the node to the scene
      
        sceneView.scene.rootNode.addChildNode(hoopNode)
    }
    
   
    func createBasketball(){
        guard let currentFrame = sceneView.session.currentFrame else
        { return }
        
        let ball = SCNNode(geometry: SCNSphere(radius: 0.25))
        ball.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        let cameraTransform = SCNMatrix4(currentFrame.camera.transform)
        ball.transform = cameraTransform
        print("se creo una pelota")
        sceneView.scene.rootNode.addChildNode(ball)
        
        
        
    }
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    var hoopAdded = false
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer){
        if !hoopAdded {
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, types: [.existingPlane])
        
        print("tapped")
        
        if let result = hitTestResult.first{
            addHoop(result: result)
            hoopAdded = true
    }
        }else {
            createBasketball()
        }
}
}
