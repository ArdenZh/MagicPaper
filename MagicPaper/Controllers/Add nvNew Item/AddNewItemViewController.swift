//
//  AddNewItemViewController.swift
//  MagicPaper
//
//  Created by Arden  on 13.05.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import UIKit
import ARKit

class AddNewItemViewController: UIViewController{

   var imagePicker: ImagePicker!
        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet weak var imagePickerButton: UIButton!
        
        var videoPicker: VideoPicker!
        @IBOutlet weak var videoView: VideoView!
        @IBOutlet weak var videoPickerButton: UIButton!
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
                    
            self.videoView.contentMode = .scaleAspectFill
            self.videoView.player?.isMuted = true
            self.videoView.repeat = .loop
            
        }

        @IBAction func imagePickerButtonTouched(_ sender: UIButton) {
            self.imagePicker = ImagePicker(presentationController: self, delegate: self)
            self.imagePicker.present(from: sender)
        }
        
        @IBAction func videoPickerButtonTouched(_ sender: UIButton) {
            self.videoPicker = VideoPicker(presentationController: self, delegate: self)
            self.videoPicker.present(from: sender)
        }
    }

    extension AddNewItemViewController: ImagePickerDelegate {

        func didSelect(image: UIImage?) {
            guard let image = image else {
                return
            }
            self.imageView.image = image
            
            let configuration = ARImageTrackingConfiguration()
            if var resources = ARReferenceImage.referenceImages(inGroupNamed: "NewsPaperImages", bundle: Bundle.main){
                configuration.trackingImages = resources
                
                configuration.maximumNumberOfTrackedImages = 1
                if let arimage = image.cgImage{
                    let arrrimage = ARReferenceImage(arimage, orientation: .up, physicalWidth: 0.34)
                    resources.insert(arrrimage)
                    print(resources)
                }
            }
            
            
            
        }
    }


    extension AddNewItemViewController: VideoPickerDelegate {

        func didSelect(url: URL?) {
            guard let url = url else {
                return
            }
            self.videoView.url = url
            self.videoView.player?.play()
        }
    
}

