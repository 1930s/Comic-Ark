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
    
    struct Books: Decodable {
        let items: [Volume]
    }
    
    struct Volume: Decodable {
        let volumeInfo: VolumeInfo?
    }

    struct VolumeInfo: Decodable {
        let title: String?
        let authors: [String]?
    }
    
  
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBookInfo()
        
        tableView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellReuseIdentifier: "CollectionCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        barcodeScannerViewController.codeDelegate = self
        barcodeScannerViewController.errorDelegate = self
        barcodeScannerViewController.dismissalDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewItemToCollectionPressed(_ sender: UIBarButtonItem) {
        
        present(barcodeScannerViewController, animated: true, completion: nil)
    }
    
    func getBookInfo() {
        let jsonUrlString = "https://www.googleapis.com/books/v1/volumes?q=isbn:1603091467&key=AIzaSyBCGhzSNu1qzUAW4VbF_h1bET_wPfyZzqM"
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let books = try decoder.decode(Books.self, from: data)
                
                for book in books.items {
                    print("book Data is \(book)")
                }
                
            } catch let error {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
}

extension PrivateCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let privateCollectionCell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath)
        
        return privateCollectionCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}

extension PrivateCollectionViewController: BarcodeScannerCodeDelegate,  BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print(code)
        controller.reset(animated: true)
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.reset(animated: true)
        controller.dismiss(animated: true, completion: nil)
    }
    
}
