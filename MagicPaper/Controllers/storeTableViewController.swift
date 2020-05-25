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

class StoreTableViewController: UITableViewController, UISearchBarDelegate {

    var storeBookArray = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
         
        let storeBook1 = Book()
        storeBook1.bookTitle = "Физика 8 класс"
        storeBook1.bookDescription = "Автор: Демидович. Издательство мектеп 2018г."
        storeBookArray.append(storeBook1)
        
        let storeBook2 = Book()
        storeBook2.bookTitle = "Химия 9 класс"
        storeBook2.bookDescription = "Автор: Борисенко. Издательство Светоч, 2017г."
        storeBookArray.append(storeBook2)
        
        let storeBook3 = Book()
        storeBook3.bookTitle = "Биология 8 класс"
        storeBook3.bookDescription = "Автор: Солнышкин. Издательство мектеп, 2018г."
        storeBookArray.append(storeBook3)

    }
    
    // MARK: - TableView Datasourse methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeBookArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreItemCell", for: indexPath)
        
        cell.textLabel?.text = storeBookArray[indexPath.row].bookTitle
        cell.detailTextLabel?.text = storeBookArray[indexPath.row].bookDescription

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "BookDescriptoinSegue", sender: self)
        
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! BookDescriptionViewController
//        
        
//        if segue.identifier == "BookDescriptoinSegue" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let destinationVC = segue.destination as! BookDescription
//                destinationVC.name = self.array[(indexPath as NSIndexPath).row]
//            }
//        }
//    }
    
}
