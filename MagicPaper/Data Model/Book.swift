//
//  StoreBook.swift
//  MagicPaper
//
//  Created by Arden  on 04.05.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import Foundation
import RealmSwift


class Book: Object {
    @objc dynamic var bookTitle: String = ""
    @objc dynamic var bookDescription: String? = ""
    
    @objc dynamic var imageName: String = ""
    @objc dynamic var videoName: String = ""
    
    @objc dynamic var imageWidth: Float = 0
    
//    let referenceImagesAndVideos = List<ReferenceImageAndVideo>()
    
}

