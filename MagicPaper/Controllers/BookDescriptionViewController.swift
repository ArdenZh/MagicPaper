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
    
    @IBOutlet weak var bookTitle: UILabel!
    
    @IBOutlet weak var bookDescription: UILabel!
    
    
    @IBOutlet weak var bookDetail: UILabel!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(bookNumber)
        
        loadData()
    }
    
    func loadData(){
        switch bookNumber {
        case 0:
            bookTitle.text = storeBookInfo.storeBookTitle1
            bookDescription.text = storeBookInfo.storeBookDescription1
            bookDetail.text = storeBookInfo.storeBookDetail1

        case 1:
            bookTitle.text = storeBookInfo.storeBookTitle2
            bookDescription.text = storeBookInfo.storeBookDescription2
            bookDetail.text = storeBookInfo.storeBookDetail2
        case 2:
            bookTitle.text = storeBookInfo.storeBookTitle3
            bookDescription.text = storeBookInfo.storeBookDescription3
            bookDetail.text = storeBookInfo.storeBookDetail3

        default:
            bookTitle.text = "Название"
            bookDescription.text = "Подзаголовок"
            bookDetail.text = "Описание"
        }
    }
    
}
