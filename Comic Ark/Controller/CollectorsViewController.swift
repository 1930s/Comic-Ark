//
//  CollectorsViewController.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 07..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class CollectorsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CollectorCell", bundle: nil), forCellReuseIdentifier: "collectorCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchController.isActive = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToPublicCollectionVC" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! PublicCollectionViewController
                
                if isFiltering() {
                    controller.selectedUser = Users.sharedInstance.filteredPublicUsers[indexPath.row].name
                } else {
                    controller.selectedUser = Users.sharedInstance.publicUsers[indexPath.row].name
                }
            }
        }
    }
    
    func isSearchBarEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        
        return searchController.isActive && !isSearchBarEmpty()
    }
    
}

extension CollectorsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let collectorCell = tableView.dequeueReusableCell(withIdentifier: "collectorCell", for: indexPath) as! CollectorCell
        
        if isFiltering() {
            collectorCell.publicProfile = Users.sharedInstance.filteredPublicUsers[indexPath.row]
        } else {
            collectorCell.publicProfile = Users.sharedInstance.publicUsers[indexPath.row]
            
        }
        return collectorCell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() == true ? Users.sharedInstance.filteredPublicUsers.count : Users.sharedInstance.publicUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NetworkManager.downloadPublicCollection(ofUserWithId: isFiltering() == true ? Users.sharedInstance.filteredPublicUsers[indexPath.row].id : Users.sharedInstance.publicUsers[indexPath.row].id) { (comics, error) in
            
            if let loadedComics = comics {
                for comic in loadedComics {
                    comic.downloadImage()
                    Users.sharedInstance.selectedUserCollection.append(comic)
                }
                
                self.performSegue(withIdentifier: "goToPublicCollectionVC", sender: self)
                self.tableView.deselectRow(at: indexPath, animated: true)
            } else {
                print("Failed to download comics.")
            }
        }
    }
}

extension CollectorsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        Users.sharedInstance.filterContent(for: searchController.searchBar.text!)
        tableView.reloadData()
    }
}
