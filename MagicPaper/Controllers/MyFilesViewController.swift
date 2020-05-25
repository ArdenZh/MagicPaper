//
//  MyFilesViewController.swift
//  MagicPaper
//
//  Created by Arden  on 25.05.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MyFilesViewController: UITableViewController{
    
    let realm = try! Realm()
    
    var myBooks: Results<Book>?
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
        loadMyBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMyBooks()
    }
    
    
    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBooks?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFilesItemCell", for: indexPath)
        cell.textLabel?.text = myBooks?[indexPath.row].bookTitle ?? "No books added yet"
        cell.detailTextLabel?.text = myBooks?[indexPath.row].bookDescription ?? ""
        
        return cell
    }
    
    
     //MARK: - Data Manipulation Methods
    func loadMyBooks(){
        myBooks = realm.objects(Book.self)
        tableView.reloadData()
    }
    
}
