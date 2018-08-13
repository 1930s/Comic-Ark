//
//  PublicCollectionViewController.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 07. 08..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class PublicCollectionViewController: UIViewController {
    var selectedUser = String()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.title = "\(selectedUser)'s collection"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Users.sharedInstance.selectedUserCollection.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellReuseIdentifier: "CollectionCell")
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.2901960784, green: 0.7254901961, blue: 0.6392156863, alpha: 1)
    }
}

// MARK: - UISearchController delegate methods:

extension PublicCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let publicCollectionCell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        let comic = Users.sharedInstance.selectedUserCollection[indexPath.row]
        publicCollectionCell.ratingButtons.forEach { button in
            button.isUserInteractionEnabled = false
        }
        publicCollectionCell.comic = comic
        return publicCollectionCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Users.sharedInstance.selectedUserCollection.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
