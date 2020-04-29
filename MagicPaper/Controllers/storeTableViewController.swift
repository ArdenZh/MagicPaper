//
//  storeTableViewController.swift
//  MagicPaper
//
//  Created by Arden  on 26.04.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import Foundation
import UIKit

class StoreTableViewController: UITableViewController {
    
    let itemArray : [String : String] = ["Физика 8 класс" : "Автор: Демидович. Издательство мектеп 2018г.", "Химия 9 класс" : "Автор: Борисенко. Издательство Светоч, 2017г.", "Биология 8 класс" : "Автор: Солнышкин. Издательство мектеп, 2018г."]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK - TableView Datasourse methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray.keys.sorted()[indexPath.row]
        cell.detailTextLabel?.text = itemArray.values.sorted()[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "BookDescriptoinSegue", sender: indexPath)
        
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "BookDescriptoinSegue" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                let destinationVC = segue.destination as! BookDescription
//                destinationVC.name = self.array[(indexPath as NSIndexPath).row]
//            }
//        }
//    }
    
}
