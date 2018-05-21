//
//  CollectorsViewController.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 07..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit

class CollectorsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
