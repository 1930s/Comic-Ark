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
    case collection = "/collection"
    case rate = "/rate"
    case loggedInState = "/isLoggedIn"
    case logut = "/logout"
    case editProfile = "/editProfile"
    case deleteProfile = "/deleteProfile"
    case publicProfiles = "/publicProfiles"
}

class NetworkManager {
    private static let baseUrl = "http://138.197.187.213/comicArk"
    
    static var sessionId = String() {
        didSet {
            UserDefaults.standard.setValue(sessionId, forKey: "sessionId")
        }
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
    
    static func checkLoggedInState(completion: @escaping(_ data: [String: Bool]?, _ error: Error?) -> Void) {
        
        let urlString = baseUrl + NetworkManagerRequest.loggedInState.rawValue
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString,
                       "sessionId": NetworkManager.sessionId]
        
        sendRequest(to: urlString, method: .get, parameters: nil, headers: headers, completion: completion)
    }
    
    static func logout(completion: @escaping(_ data: [String: Bool]?, _ error: Error?) -> Void) {
        
        let urlString = baseUrl + NetworkManagerRequest.logut.rawValue
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString,
                       "sessionId": NetworkManager.sessionId]
        
        sendRequest(to: urlString, method: .post, parameters: nil, headers: headers, completion: completion)
    }
    
    static func login(email: String, password:  String, completion: @escaping (_ data: AuthentificationResponse?, _ error: Error?) -> Void) {
        
        let urlString = baseUrl + NetworkManagerRequest.login.rawValue
        let parameters = ["email": email, "password": password]
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString,
                       "os": "iOS",
                       "osVersion": UIDevice.current.systemVersion]
        
        sendRequest(to: urlString, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    static func register(email: String, password: String, repassword: String, username: String, completion: @escaping (_ data: AuthentificationResponse?, _ error: Error?) -> Void) {
        
        let urlString = baseUrl + NetworkManagerRequest.register.rawValue
        let parameters = ["email": email, "password": password, "repassword": repassword, "name": username]
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString,
                       "os": "iOS",
                       "osVersion": UIDevice.current.systemVersion]
        
        sendRequest(to: urlString, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    static func editProfile(name: String, isPublic: Bool, completion: @escaping(_ data: [String: Bool]?, _ error: Error?) -> Void) {
        
        let urlString = baseUrl + NetworkManagerRequest.editProfile.rawValue
        let parameters = ["name": name, "isPublic": isPublic] as [String : Any]
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString,
                       "sessionId": NetworkManager.sessionId]
        
        sendRequest(to: urlString, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    static func deleteProfile(completion: @escaping(_ data: [String: Bool]?, _ error: Error?) -> Void) {
        
        let urlString = baseUrl + NetworkManagerRequest.deleteProfile.rawValue
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString,
                       "sessionId": NetworkManager.sessionId]
        
        sendRequest(to: urlString, method: .delete, parameters: nil, headers: headers, completion: completion)
    }
    
    static func downloadPrivateCollection(completion: @escaping(_ data: [Comic]?, _ error: Error?) -> Void) {
        
        let urlString = baseUrl + NetworkManagerRequest.collection.rawValue + "/my"
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString,
                       "sessionId": NetworkManager.sessionId]
        
        sendRequest(to: urlString, method: .get, parameters: nil, headers: headers, completion: completion)
    }
    
    static func upload(book: Comic, completion: @escaping(_ data: UploadConfirmation?, _ error: Error?) -> Void) {
        
        let urlString = baseUrl + NetworkManagerRequest.book.rawValue
        let parameters = ["book": ["title": book.title, "isbn": book.isbn, "authors": [book.authors], "publisher": book.publisher ?? "", "coverUrl": book.coverUrl ?? ""]]
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString, "sessionId": NetworkManager.sessionId]

        sendRequest(to: urlString, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    static func rate(book: Comic, completion: @escaping(_ data: [String: Bool]?, _ error: Error?) -> Void) {

        let urlString = baseUrl + NetworkManagerRequest.book.rawValue + NetworkManagerRequest.rate.rawValue
        let parameters = ["bookId": book.id, "rating": book.rating]
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString, "sessionId": NetworkManager.sessionId]

        sendRequest(to: urlString, method: .post, parameters: parameters, headers: headers, completion: completion)
    }
    
    static func delete(book: Comic, completion: @escaping(_ data: [String: Bool]?, _ error: Error?) -> Void) {
        
        let urlString = baseUrl + NetworkManagerRequest.book.rawValue + "/\(book.id)"
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString, "sessionId": NetworkManager.sessionId]
        
        sendRequest(to: urlString, method: .delete, parameters: nil, headers: headers, completion: completion)
    }
    
    static func downloadProfiles(completion: @escaping(_ data: [PublicProfile]?, _ error: Error?) -> Void) {
        
        let urlString = baseUrl + NetworkManagerRequest.publicProfiles.rawValue
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString, "sessionId": NetworkManager.sessionId]
        
        sendRequest(to: urlString, method: .get, parameters: nil, headers: headers, completion: completion)
    }
    
    static func downloadPublicCollection(ofUserWithId id: Int, completion: @escaping(_ data: [Comic]?, _ error: Error?) -> Void) {
        
        let urlString = baseUrl + NetworkManagerRequest.collection.rawValue + "/\(id)"
        let headers = ["hardwareId": UIDevice.current.identifierForVendor!.uuidString,
                       "sessionId": NetworkManager.sessionId]
        
        sendRequest(to: urlString, method: .get, parameters: nil, headers: headers, completion: completion)
    }
    
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
