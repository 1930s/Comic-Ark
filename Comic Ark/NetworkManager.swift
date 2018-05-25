//
//  NetworkManager.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 24..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation

class NetworkManager {
    
    // Method that sends a request to Google Books containing an ISBN number and returns book data:
    
    static func getJSONData(for isbn: String, finished: @escaping (DecodedJSONResponse?) -> Void) {
        
        var decodedJSON: DecodedJSONResponse?
        
        let jsonUrlString = "https://www.googleapis.com/books/v1/volumes?q=isbn" + isbn + "&key=AIzaSyBCGhzSNu1qzUAW4VbF_h1bET_wPfyZzqM"
        
        guard let url = URL(string: jsonUrlString) else {
            print("Invalid URL string.")
            return }
        
        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                
                let decoder = JSONDecoder()
                decodedJSON = try decoder.decode(DecodedJSONResponse.self, from: data)
                
            } catch let error {
                print("Failed to decode JSON:", error)
                decodedJSON = nil
            }
            
            finished(decodedJSON)
            
            }.resume()
    }
    
}
