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
        
        newPapersWidth.keyboardType = .numberPad
        
        imagePickerButton.layer.cornerRadius = 5
        videoPickerButton.layer.cornerRadius = 5
        createButton.layer.cornerRadius = 5
        
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 1
        
        videoView.layer.borderColor = UIColor.systemBlue.cgColor
        videoView.layer.borderWidth = 1
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createButton.isUserInteractionEnabled = false
        createButton.backgroundColor = .systemGray
    }
    
    //hide keyboard by clicking on any view area (suitable only if there is no scroll!!)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil{
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
        didAllFieldsFill()
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
        return paths[0]
    }
    
    @IBAction func createNewPaper(_ sender: UIButton) {
            
            saveMedia()
            navigationController?.popViewController(animated: true)
    }
    
    
    
    func saveMedia() {
        
        let userNewPapersName = "user" + newPapersName.text!
        
        //save video to Documents folder and rename
        let videoURL = getDocumentsDirectory().appendingPathComponent("addedVideo.mp4")

        let newVideoURL = videoURL
            .deletingLastPathComponent()
            .appendingPathComponent(userNewPapersName)
            .appendingPathExtension("mp4")
        
        do{
            try FileManager.default.moveItem(at: videoURL, to: newVideoURL)
        }catch{
            print("Error with saving video to Documents folder \(error)")
        }
        
        
        //save photo to Documents folder and rename
        let image = imageView.image!
        let width = (Float(newPapersWidth.text!)!)/100.0
        
        if let data = image.jpegData(compressionQuality: 1) {

            let whritePath = getDocumentsDirectory()
                .appendingPathComponent(userNewPapersName)
                .appendingPathExtension("jpg")
            
            do{
                try data.write(to: whritePath)
            }catch{
                print("Error with saving photo to Documents folder \(error)")
            }
            
            saveMediaToRealm(bookDescription: newPapersDescription.text!,
                             bookTitle: newPapersName.text!,
                             fullImagePath: whritePath,
                             fullVideoPath: newVideoURL,
                             imageWidth: width)
        }
        
        //save image to AR Reference group
        let anARWidth = CGFloat(width)
        
        if let cgImage = image.cgImage{
            let newARImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: anARWidth)
            newARImage.name = userNewPapersName
            anARReferenceImages.anARRefImg.insert(newARImage)
            print(anARReferenceImages.anARRefImg)
        }
    }
    
    
    func saveMediaToRealm(bookDescription: String, bookTitle: String, fullImagePath: URL, fullVideoPath: URL, imageWidth: Float) {
        
        let newBook = Book()
        
        newBook.bookDescription = bookDescription
        newBook.bookTitle = bookTitle
        newBook.imageName = fullImagePath.lastPathComponent
        newBook.videoName = fullVideoPath.lastPathComponent
        newBook.imageWidth = imageWidth
        
        do{
            try realm.write{
                realm.add(newBook)
            }
        }catch{
            print("Error writing primary data to Realm \(error)")
        }
        
    }
    
    func didAllFieldsFill() {
        if didImageSelect == true &&
            didVideoSelect == true &&
            newPapersName.text != "" &&
            newPapersWidth.text != ""{
            
            if let newPapersWidthInt = Int(newPapersWidth.text!){
            
                if newPapersWidthInt == 0{
                    let alert = UIAlertController(title: "Ширина изображения не может быть 0", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "ОК", style: .default) { (action) in
                        
                        self.newPapersWidth.layer.borderColor = UIColor.systemRed.cgColor
                        self.newPapersWidth.text = ""
                        
                    }
                    
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                    
                    createButton.isUserInteractionEnabled = false
                    createButton.backgroundColor = .systemGray
                }else{
                    createButton.isUserInteractionEnabled = true
                    createButton.backgroundColor = .systemGreen
                }
            }
        }else{
            createButton.isUserInteractionEnabled = false
            createButton.backgroundColor = .systemGray
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
        didAllFieldsFill()
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
        didAllFieldsFill()
    }
}

