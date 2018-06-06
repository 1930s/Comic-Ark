//
//  NetworkManager.swift
//  Comic Ark
//
//  Created by Levente Dimény on 2018. 05. 24..
//  Copyright © 2018. Levente Dimény. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


enum NetworkManagerRequest: String {
    
    case login = "/login"
    case register = "/register"
    case book = "/book"
}

class NetworkManager {
    private static let baseUrl = "http://138.197.187.213/comicArk"
    
    static func login(email: String, password:  String, completion: @escaping (_ data: AuthentificationResponse?, _ error: Error?) -> Void) {
        let urlString = baseUrl + NetworkManagerRequest.login.rawValue
        let parameters = ["email": email, "password": password]
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString,
                       "os": "iOS",
                       "osVersion": UIDevice.current.systemVersion]
        
        sendRequest(to: urlString, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    static func register(email: String, password: String, repassword: String, completion: @escaping (_ data: AuthentificationResponse?, _ error: Error?) -> Void) {
        let urlString = baseUrl + NetworkManagerRequest.register.rawValue
        let parameters = ["email": email, "password": password, "repassword": repassword]
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString,
                       "os": "iOS",
                       "osVersion": UIDevice.current.systemVersion]
        
        sendRequest(to: urlString, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    static func downloadBooks(completion: @escaping(_ data: [Comic]?, _ error: Error?) -> Void) {
        let urlString = baseUrl + NetworkManagerRequest.book.rawValue
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString, "sessionId": User.sharedInstance.sessionId]
        
        sendRequest(to: urlString, method: .get, parameters: nil, headers: headers, completion: completion)
    }
    
    static func upload(book: Comic, completion: @escaping(_ data: [String: Bool]?, _ error: Error?) -> Void) {
        let urlString = baseUrl + NetworkManagerRequest.book.rawValue
        
        let parameters = ["book": ["title": book.title, "isbn": book.isbn, "authors": [book.authors], "publisher": book.publisher ?? " ", "coverUrl": book.coverUrl ?? " ", "rating": book.rating]]
        
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString, "sessionId": User.sharedInstance.sessionId]

        sendRequest(to: urlString, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    
    private static func sendRequest<T: Codable>(
        to urlString : String,
        method : HTTPMethod,
        parameters : [String: Any]?,
        headers : [String: String]?,
        completion : @escaping (_ data : T?, _ error : Error?) -> Void) {

        Alamofire.request(urlString, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { (response) in
            let statusCode = response.response?.statusCode

            if statusCode == 200 {
                print("200")
                
                let decoder = JSONDecoder()
                
                do {
                    if let decodedJSON = try decoder.decode(T?.self, from: response.data!) {
                        completion(decodedJSON, nil)
                    }
                }
                
                catch {
                    print("Failed to decode JSON.")
                    completion(nil, nil)
                }
            } else {
                completion(nil, response.error)
            }
        }
    }
    

    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Method that sends a request to Google Books containing an ISBN number and returns book data:
    
    static func getJSONData(for isbn: String, finished: @escaping (GoogleBooksResponse?) -> Void) {
        
        var decodedJSON: GoogleBooksResponse?
        
        let jsonUrlString = "https://www.googleapis.com/books/v1/volumes?q=isbn" + isbn + "&key=AIzaSyBCGhzSNu1qzUAW4VbF_h1bET_wPfyZzqM"
        
        guard let url = URL(string: jsonUrlString) else {
            print("Invalid URL string.")
            return }
        
        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                
                let decoder = JSONDecoder()
                decodedJSON = try decoder.decode(GoogleBooksResponse.self, from: data)
                
            } catch let error {
                print("Failed to decode JSON:", error)
                decodedJSON = nil
            }
            
            finished(decodedJSON)
            
            }.resume()
    }
    
    
}
