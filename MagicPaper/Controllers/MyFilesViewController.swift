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
import SwipeCellKit
import ChameleonFramework

class MyFilesViewController: UITableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let blueColor = "#1D9BF6"
    
    let realm = try! Realm()
    
    var myBooks: Results<Book>?
    var myBooksForFilter: Results<Book>?
    
    override func viewDidLoad() {
           super.viewDidLoad()
        tableView.rowHeight = 70.0
        tableView.separatorStyle = .none
//        print(realm.configuration.fileURL)
        
        searchBar.delegate = self
        tableView.allowsSelection = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMyBooks()
        
        myBooksForFilter = realm.objects(Book.self)
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
        }
        if let navBarColour = UIColor(hexString: blueColor) {
            navBar.backgroundColor = navBarColour
            navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
            searchBar.barTintColor = navBarColour
        }
    }
    
    
    // MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBooks?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFilesItemCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = myBooks?[indexPath.row].bookTitle ?? "No books added yet"
        cell.detailTextLabel?.text = myBooks?[indexPath.row].bookDescription ?? ""
        
        if let colour = UIColor(hexString: blueColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(myBooks!.count)) {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
        }
        
        cell.delegate = self
        
        return cell
    }
    
    
     //MARK: - Data Manipulation Methods
    func loadMyBooks(){
        myBooks = realm.objects(Book.self)
        
        tableView.reloadData()
    }
    
}

//MARK: - Searchbar delegate methods

extension MyFilesViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0{
            myBooks = myBooks?.filter("bookTitle CONTAINS[cd] %@ OR bookDescription CONTAINS[cd] %@", searchBar.text!, searchBar.text!)
            tableView.reloadData()
        }else{
            loadMyBooks()
        }
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text ?? "0")
        if searchBar.text?.count == 0{
            loadMyBooks()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        
        }else{
            myBooks = myBooksForFilter?.filter("bookTitle CONTAINS[cd] %@ OR bookDescription CONTAINS[cd] %@", searchBar.text!, searchBar.text!)
            print(myBooks as Any)
            tableView.reloadData()
        }
    }
    
}


//MARK: - Swipe cell delegate methods
extension MyFilesViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            if let myBookForDelition = self.myBooks?[indexPath.row]{
                
                let imageURLForDelition = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(myBookForDelition.imageName)
                let videoURLForDelition = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(myBookForDelition.videoName)
                
                do{
                    try FileManager.default.removeItem(at: imageURLForDelition)
                    try FileManager.default.removeItem(at: videoURLForDelition)
                    print("Files removed")
                }catch{
                    print("Error deleting media from documents")
                }
                
                var myBookForDelitionName = myBookForDelition.imageName
                var components = myBookForDelitionName.components(separatedBy: ".")
                if components.count > 1 { // If there is a file extension
                  components.removeLast()
                  myBookForDelitionName = components.joined()
                }
                
                _ = anARReferenceImages.anARRefImg.contains { (ARReferenceImage) -> Bool in
                    if ARReferenceImage.name == myBookForDelitionName{
                        anARReferenceImages.anARRefImg.remove(ARReferenceImage)
                        print("Удаление...")
                        return true
                    }else{
                        return false
                    }
                }
               
                
                do{
                    try self.realm.write {
                        self.realm.delete(myBookForDelition)
                    }
                }catch{
                    print("Error deliting my book \(error)")
                }
                
            }
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
