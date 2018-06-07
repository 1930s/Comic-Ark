//
//  ViewController.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 07..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import UIKit
import BarcodeScanner

class PrivateCollectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let barcodeScannerViewController = BarcodeScannerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        barcodeScannerViewController.isOneTimeSearch = true
        
        barcodeScannerViewController.codeDelegate = self
        barcodeScannerViewController.errorDelegate = self
        barcodeScannerViewController.dismissalDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellReuseIdentifier: "CollectionCell")
        
        tableView.reloadData()
    }

    
    @IBAction func addNewItemToCollectionPressed(_ sender: UIBarButtonItem) {
        
        present(barcodeScannerViewController, animated: true, completion: nil)
    }
    
   
    
    
    
}

// MARK: - UITableView delegate methods:

extension PrivateCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let privateCollectionCell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        
        let comic = User.sharedInstance.collection[indexPath.row]
        privateCollectionCell.comic = comic
        
        return privateCollectionCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.sharedInstance.collection.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            User.sharedInstance.collection.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}

// MARK: - BarcodeScanner delegate methods:

extension PrivateCollectionViewController: BarcodeScannerCodeDelegate,  BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        print(code)
        
        NetworkManager.getJSONData(for: code) { (decodedJSON) in
            if decodedJSON != nil {
                let newComic = Comic.init(jsonResponse: decodedJSON!, isbn: code)
                
                let alertController = UIAlertController(title: "Product found!", message: "Do you want to add \(newComic.title) to your collection?", preferredStyle: .actionSheet)
                let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
                    User.sharedInstance.addToCollection(comic: newComic)
                    
                    NetworkManager.upload(book: newComic, completion: { (confirmation, error) in
                        
                        if error == nil {
                            print(confirmation!["success"]!)
                            
                        } else {
                            print("Failed to upload book.")
                        }
                    })
                    
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    controller.dismiss(animated: true) {
                        controller.reset(animated: false)
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                    controller.reset(animated: true)
                }
                
                alertController.addAction(addAction)
                alertController.addAction(cancelAction)
                
                self.barcodeScannerViewController.present(alertController, animated: true, completion: {
                    self.barcodeScannerViewController.messageViewController.textLabel.text?.removeAll()
                })
            } else {
                DispatchQueue.main.async {
                    self.barcodeScannerViewController.resetWithError()
                }
            }
        }
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true) {
            controller.reset(animated: true)
        }
    }
    
}
