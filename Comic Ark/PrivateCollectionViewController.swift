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
    
    var decodedJSON: DecodedJSONResponse?
    
    let barcodeScannerViewController = BarcodeScannerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellReuseIdentifier: "CollectionCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        barcodeScannerViewController.isOneTimeSearch = true
        
        barcodeScannerViewController.codeDelegate = self
        barcodeScannerViewController.errorDelegate = self
        barcodeScannerViewController.dismissalDelegate = self
    }

    
    @IBAction func addNewItemToCollectionPressed(_ sender: UIBarButtonItem) {
        
        present(barcodeScannerViewController, animated: true, completion: nil)
    }
    
    // Method that sends a request to Google Books containing an ISBN number and returns book data:
    
    func fetchJSON(for isbn: String, finished: @escaping () -> Void) {
        
        let jsonUrlString = "https://www.googleapis.com/books/v1/volumes?q=isbn" + isbn + "&key=AIzaSyBCGhzSNu1qzUAW4VbF_h1bET_wPfyZzqM"
        
        guard let url = URL(string: jsonUrlString) else {
            print("Invalid URL string.")
            return }
        
        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            let jsonForPrinting = try! JSONSerialization.jsonObject(with: data, options: [])
            print(jsonForPrinting)
            
            do {

                let decoder = JSONDecoder()
                self.decodedJSON = try decoder.decode(DecodedJSONResponse.self, from: data)
                
            } catch let error {
                print("Failed to decode JSON:", error)
                self.decodedJSON = nil
            }
            
            finished()

        }.resume()
    }
    
    // Method that takes as input a DecodedJSONResponse object and outputs a Comic object:
    
    func moldJSONResponseIntoComicModel(jsonResponse: DecodedJSONResponse, isbn: String) -> Comic {
        
        let decodedComic = jsonResponse.items[0]
        
        let newComic = Comic(title: decodedComic.volumeInfo?.title,
                             isbn: isbn,
                             authors: decodedComic.volumeInfo?.authors,
                             publisher: decodedComic.volumeInfo?.publisher,
                             coverURL: URL(string: (decodedComic.volumeInfo?.imageLinks?.thumbnail)!))
        
        return newComic
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
    
}

// MARK: - BarcodeScanner delegate methods:

extension PrivateCollectionViewController: BarcodeScannerCodeDelegate,  BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        print(code)
        
        fetchJSON(for: code) {
            if self.decodedJSON != nil {
                let newComic = self.moldJSONResponseIntoComicModel(jsonResponse: self.decodedJSON!, isbn: code)
                
                let alertController = UIAlertController(title: "Product found!", message: "Do you want to add \(newComic.title!) to your collection?", preferredStyle: .actionSheet)
                let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
                    User.sharedInstance.addToCollection(comic: newComic)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    controller.dismiss(animated: true) {
                        controller.reset(animated: false)
                        self.decodedJSON = nil
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
