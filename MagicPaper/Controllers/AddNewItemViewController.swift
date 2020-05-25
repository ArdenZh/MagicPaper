//
//  ViewController.swift
//  Pickers
//
//  Created by Tibor Bödecs on 2019. 08. 28..
//  Copyright © 2019. Tibor Bödecs. All rights reserved.
//

import UIKit
import ARKit
import RealmSwift

class AddNewItemViewController: UIViewController {
    
    let realm = try! Realm()
    
    var imagePicker: ImagePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imagePickerButton: UIButton!
    
    var videoPicker: VideoPicker!
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var videoPickerButton: UIButton!
    
    @IBOutlet weak var newPapersName: UITextField!
    
    @IBOutlet weak var newPapersDescription: UITextField!
    
    @IBOutlet weak var newPapersWidth: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    var didImageSelect: Bool = false
    var didVideoSelect: Bool = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.videoView.contentMode = .scaleAspectFit
        self.videoView.player?.isMuted = true
        self.videoView.repeat = .loop
        
        newPapersWidth.keyboardType = .numbersAndPunctuation
        
        imagePickerButton.layer.cornerRadius = 5
        videoPickerButton.layer.cornerRadius = 5
        createButton.layer.cornerRadius = 5
        
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 1
        
        videoView.layer.borderColor = UIColor.systemBlue.cgColor
        videoView.layer.borderWidth = 1
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //hide keyboard by clicking on any view area (suitable only if there is no scroll!!)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil{
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }

    @IBAction func imagePickerButtonTouched(_ sender: UIButton) {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func videoPickerButtonTouched(_ sender: UIButton) {
        self.videoPicker = VideoPicker(presentationController: self, delegate: self)
        self.videoPicker.present(from: sender)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        print(paths[0])
        return paths[0]
    }
    
    @IBAction func createNewPaper(_ sender: UIButton) {
        if newPapersName != nil &&
            newPapersWidth != nil &&
            didImageSelect == true /*&&
            didVideoSelect == true*/ {
            
            let newBook = Book()
                
            let image = imageView.image!
            
                let videoURL = getDocumentsDirectory().appendingPathComponent("addedVideo.mp4")
                
                
                let userNewPapersName = "user" + newPapersName.text!
            
                let newVideoURL = videoURL.deletingLastPathComponent().appendingPathComponent(userNewPapersName).appendingPathExtension("mp4")
                do{
                    try FileManager.default.moveItem(at: videoURL, to: newVideoURL)
                }catch{
                    print("ERROR WITH VIDEO COPYING \(error)")
                } 
                
                print("Video URL: \(newVideoURL)")
                
                let stringNewVideoURL = newVideoURL.absoluteString
                
                print(stringNewVideoURL)
            
            if let data = image.jpegData(compressionQuality: 1) {

                let whritePath = getDocumentsDirectory().appendingPathComponent(userNewPapersName).appendingPathExtension("jpg")
                
                try? data.write(to: whritePath)
                print("data: \(data)")
                
                let stringImagePath = whritePath.absoluteString
                print("stringImagePath: \(stringImagePath)")
                
            
                
                newBook.bookDescription = newPapersDescription.text!
                newBook.bookTitle = newPapersName.text!
                newBook.imagePath = stringImagePath
                newBook.videoPath = stringNewVideoURL
                
                print("newBook.videoPath: \(newBook.videoPath)")
            }
            
                do{
                    try realm.write{
                        realm.add(newBook)
                    }
                }catch{
                    print("Error writing primary data to Realm \(error)")
                }
                
                let width = CGFloat(Float(newPapersWidth.text!)!)/100
                
            
                
            if let cgImage = image.cgImage{
                let newARImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: width)
                newARImage.name = userNewPapersName
                anARReferenceImages.anARRefImg.insert(newARImage)
                print(anARReferenceImages.anARRefImg)
            }
            
        }
    }
    
}

extension AddNewItemViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?){
        guard let image = image else {
            return
        }
        self.imageView.image = image
        didImageSelect = true
        
    }
}


extension AddNewItemViewController: VideoPickerDelegate {

    func didSelect(url: URL?) {
        guard let url = url else {
            return
        }
        self.videoView.url = url
        self.videoView.player?.play()
        
        didVideoSelect = true
    }
}

