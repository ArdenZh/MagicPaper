//
//  storeTableViewController.swift
//  MagicPaper
//
//  Created by Arden  on 26.04.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import ChameleonFramework

class StoreTableViewController: UITableViewController, UISearchBarDelegate {

    var storeBookArray = [Book]()
    let storeBookInfo = StoreBooksInfo()
    let blueColor = "#1D9BF6"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70.0
        tableView.separatorStyle = .none
         
        let storeBook1 = Book()
        storeBook1.bookTitle = storeBookInfo.storeBookTitle1
        storeBook1.bookDescription = storeBookInfo.storeBookDescription1
        storeBookArray.append(storeBook1)
        
        let storeBook2 = Book()
        storeBook2.bookTitle = storeBookInfo.storeBookTitle2
        storeBook2.bookDescription = storeBookInfo.storeBookDescription2
        storeBookArray.append(storeBook2)
        
        let storeBook3 = Book()
        storeBook3.bookTitle = storeBookInfo.storeBookTitle3
        storeBook3.bookDescription = storeBookInfo.storeBookDescription3
        storeBookArray.append(storeBook3)
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        if let navBarColour = UIColor(hexString: blueColor) {
            navBar.backgroundColor = navBarColour
            navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        }

    }

    
    // MARK: - TableView Datasourse methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeBookArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreItemCell", for: indexPath)
        
        cell.textLabel?.text = storeBookArray[indexPath.row].bookTitle
        cell.detailTextLabel?.text = storeBookArray[indexPath.row].bookDescription
        
        if let colour = UIColor(hexString: blueColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(storeBookArray.count)) {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "BookDescriptoinSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! BookDescriptionViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.bookNumber = indexPath.row
        }
    }
    
}
