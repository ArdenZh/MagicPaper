//
//  ViewController.swift
//  MagicPaper
//
//  Created by Arden  on 19.02.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import RealmSwift


class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private var isTouch: Bool = false
    
    private var videoNode = SKVideoNode()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        downloadImagesFromRealmToARReferenceImages()

//        Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        configuration.trackingImages = anARReferenceImages.anARRefImg
        
        configuration.maximumNumberOfTrackedImages = 1
        
        print("New group\(anARReferenceImages.anARRefImg)")
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            if var videoName = imageAnchor.referenceImage.name{
                
                if videoName.starts(with: "user"){
                    
                    let realm = try! Realm()
                    
                    let predicate = NSPredicate(format: "videoName CONTAINS '\(videoName)'")
                    let videoObject = realm.objects(Book.self).filter(predicate)
                    
                    let videoURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(videoObject[0].videoName)
                    
                    videoNode = SKVideoNode(url: videoURL)
                    
                }else{
                    videoName += ".mp4"
                    videoNode = SKVideoNode(fileNamed: videoName)
                }
                
                
                videoNode.pause()
                isTouch = false
                
                let videoScene = SKScene(size: CGSize(width: 480, height: 360))
                
                videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
                
                videoNode.yScale = -1.0
                
                videoScene.addChild(videoNode)
                
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                plane.firstMaterial?.diffuse.contents = videoScene
                
                let planeNode = SCNNode(geometry: plane)
                
                planeNode.eulerAngles.x = -.pi/2
                
                node.addChildNode(planeNode)
            
            }
            
        }
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let imageAnchor = anchor as? ARImageAnchor, imageAnchor.isTracked == false {
            sceneView.session.remove(anchor: anchor)
            videoNode.pause()
            isTouch = false
        }
    }
    
    
    func downloadImagesFromRealmToARReferenceImages() {
        let realm = try! Realm()
        
        for imageObject in realm.objects(Book.self){
            
            let anARWidth = CGFloat(imageObject.imageWidth)
            
            let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageObject.imageName)
            
            if let image = UIImage(contentsOfFile: imageURL.path){
                if let cgImage = image.cgImage{
                    let newARImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: anARWidth)
                    
                    var imageObjectName = imageObject.imageName
                    var components = imageObjectName.components(separatedBy: ".")
                    if components.count > 1 { // If there is a file extension
                      components.removeLast()
                      imageObjectName = components.joined()
                    }
                    
                    newARImage.name = imageObjectName
                    anARReferenceImages.anARRefImg.insert(newARImage)
                }
            }
        }
           
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouch == false{
            videoNode.play()
            isTouch = true
        }
        else {
            videoNode.pause()
            isTouch = false
        }
    }
    
}
