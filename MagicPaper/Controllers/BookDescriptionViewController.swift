//
//  BookDescriptionViewController.swift
//  MagicPaper
//
//  Created by Arden  on 28.04.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import Foundation
import UIKit

class BookDescriptionViewController: UIViewController {

    
    var bookNumber: Int = 0
    
    let storeBookInfo = StoreBooksInfo()
    
    @IBOutlet weak var bookTitle: UITextView!
    
    @IBOutlet weak var bookDescription: UITextView!
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBOutlet weak var bookDetails: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bookTitle.isEditable = false
        bookDescription.isEditable = false
        bookDetails.isEditable = false
        
//        bookTitle.adjustsFontSizeToFitWidth = true
//        bookTitle.lineBreakMode = .byWordWrapping
//        bookTitle.numberOfLines = 0
//
//
//        bookDescription.adjustsFontSizeToFitWidth = true
//        bookDescription.lineBreakMode = .byWordWrapping
//        bookDescription.numberOfLines = 0
        
//        bookDescription.sizeToFit()
        
//        bookDetail.adjustsFontSizeToFitWidth = true
//        bookDetail.lineBreakMode = .byWordWrapping
//        bookDetail.numberOfLines = 0
        
        loadData()
    }
    
    func loadData(){
        switch bookNumber {
        case 0:
            bookTitle.text = storeBookInfo.storeBookTitle1
            bookDescription.text = storeBookInfo.storeBookDescription1
            bookDetails.text = storeBookInfo.storeBookDetail1
            bookImage.image = UIImage(named: storeBookInfo.storeBookImageName1)
        case 1:
            bookTitle.text = storeBookInfo.storeBookTitle2
            bookDescription.text = storeBookInfo.storeBookDescription2
            bookDetails.text = storeBookInfo.storeBookDetail2
            bookImage.image = UIImage(named: storeBookInfo.storeBookImageName2)
        case 2:
            bookTitle.text = storeBookInfo.storeBookTitle3
            bookDescription.text = storeBookInfo.storeBookDescription3
            bookDetails.text = storeBookInfo.storeBookDetail3
            bookImage.image = UIImage(named: storeBookInfo.storeBookImageName3)
            
        case 3:
            bookTitle.text = storeBookInfo.storeBookTitle4
            bookDescription.text = storeBookInfo.storeBookDescription4
            bookDetails.text = storeBookInfo.storeBookDetail4
            bookImage.image = UIImage(named: storeBookInfo.storeBookImageName4)
            
        case 4:
            bookTitle.text = storeBookInfo.storeBookTitle5
            bookDescription.text = storeBookInfo.storeBookDescription5
            bookDetails.text = storeBookInfo.storeBookDetail5
            bookImage.image = UIImage(named: storeBookInfo.storeBookImageName5)
            
        case 5:
            bookTitle.text = storeBookInfo.storeBookTitle6
            bookDescription.text = storeBookInfo.storeBookDescription6
            bookDetails.text = storeBookInfo.storeBookDetail6
            bookImage.image = UIImage(named: storeBookInfo.storeBookImageName6)
            
        case 6:
            bookTitle.text = storeBookInfo.storeBookTitle7
            bookDescription.text = storeBookInfo.storeBookDescription7
            bookDetails.text = storeBookInfo.storeBookDetail7
            bookImage.image = UIImage(named: storeBookInfo.storeBookImageName7)
            
        case 7:
            bookTitle.text = storeBookInfo.storeBookTitle8
            bookDescription.text = storeBookInfo.storeBookDescription8
            bookDetails.text = storeBookInfo.storeBookDetail8
            bookImage.image = UIImage(named: storeBookInfo.storeBookImageName8)
            
        case 8:
            bookTitle.text = storeBookInfo.storeBookTitle9
            bookDescription.text = storeBookInfo.storeBookDescription9
            bookDetails.text = storeBookInfo.storeBookDetail9
            bookImage.image = UIImage(named: storeBookInfo.storeBookImageName9)
            
        default:
            bookTitle.text = "Название"
            bookDescription.text = "Подзаголовок"
            bookDetails.text = "Описание"
        }
    }
    
}
