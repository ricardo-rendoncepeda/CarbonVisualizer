/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import SceneKit

class ViewController: UIViewController {
  // UI
  @IBOutlet weak var geometryLabel: UILabel!
  @IBOutlet weak var sceneView: SCNView!
  
  // Geometry
  var geometryNode: SCNNode = SCNNode()
  
  // Gestures
  var currentAngle: Float = 0.0
  
  // MARK: Lifecycle
  override func viewDidLoad() {
      super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    sceneSetup()
    geometryLabel.text = "Atoms\n"
    geometryNode = Atoms.allAtoms()
    sceneView.scene!.rootNode.addChildNode(geometryNode)
  }
  
  // MARK: Scene
  func sceneSetup() {
    let scene = SCNScene()
    
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light!.type = SCNLightTypeAmbient
    ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
    scene.rootNode.addChildNode(ambientLightNode)
    
    let omniLightNode = SCNNode()
    omniLightNode.light = SCNLight()
    omniLightNode.light!.type = SCNLightTypeOmni
    omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
    omniLightNode.position = SCNVector3Make(0, 50, 50)
    scene.rootNode.addChildNode(omniLightNode)
    
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3Make(0, 0, 25)
    scene.rootNode.addChildNode(cameraNode)
    
    let panRecognizer = UIPanGestureRecognizer(target: self, action: "panGesture:")
    sceneView.addGestureRecognizer(panRecognizer)
    
    sceneView.scene = scene
  }
  
  func panGesture(sender: UIPanGestureRecognizer) {
    let translation = sender.translationInView(sender.view!)
    var newAngle = (Float)(translation.x)*(Float)(M_PI)/180.0
    newAngle += currentAngle
    
    geometryNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0)
    
    if(sender.state == UIGestureRecognizerState.Ended) {
      currentAngle = newAngle
    }
  }
  
  // MARK: IBActions
  @IBAction func segmentValueChanged(sender: UISegmentedControl) {
    geometryNode.removeFromParentNode()
    currentAngle = 0.0
    
    switch sender.selectedSegmentIndex {
    case 0:
      geometryLabel.text = "Atoms\n"
      geometryNode = Atoms.allAtoms()
    case 1:
      geometryLabel.text = "Methane\n(Natural Gas)"
      geometryNode = Molecules.methaneMolecule()
    case 2:
      geometryLabel.text = "Ethanol\n(Alcohol)"
      geometryNode = Molecules.ethanolMolecule()
    case 3:
      geometryLabel.text = "Polytetrafluoroethylene\n(Teflon)"
      geometryNode = Molecules.ptfeMolecule()
    default:
      break
    }
    
    sceneView.scene!.rootNode.addChildNode(geometryNode)
  }
  
  // MARK: Style
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  
  // MARK: Transition
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    sceneView.stop(nil)
    sceneView.play(nil)
  }
}
