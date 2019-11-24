//
//  RestCall.swift
//  emailLogin
//
//  Created by user158383 on 10/2/19.
//  Copyright © 2019 user158383. All rights reserved.
//

import Foundation

class RestCall {
    //make my networking class a singleton, so it can be accessed from anywhere
    static let shared = RestCall()
    private init() {}

    //let jsonDict: [String: Any] =
    //       ["email": "m@m.at",
    //         "password": "madmad",
    //        "returnSecureToken": true]

    let urlSession = URLSession(configuration: .default)
    var loggedInUser: User?

        
    func login(email:String, pw:String, completionHandler: @escaping (User?, NetworkingError?) -> Void) {
        let url = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCTryhlVmmRHYE7iQT3k0eeNRHIKsTMpRw")
        var request = URLRequest(url: url!) //force because i know its defined
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonDict: [String: Any] = ["email": email,
                                       "password": pw,
                                       "returnSecureToken": true]
        
        do {
            let sendbody = try JSONSerialization.data(withJSONObject: jsonDict)
            request.httpBody = sendbody
        } catch {
            DispatchQueue.main.async {
                completionHandler(nil, .serializingError)
            }
        }

        let dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            //print("data \(data!), response \(response), error \(error)")
            //data 1322 bytes, response Optional
            var myUser: User?
            var myError: NetworkingError?
            if let error = error as NSError? {
                //print(error.localizedDescription)
                if error.code == -1009 { // NSURLErrorNotConnectedToInternet
                    myError = .networkOfflineError
                } else {
                    myError = .unexpectedError
                }
            }
            if let response = response as! HTTPURLResponse? {
                //print(response)
                if response.statusCode >= 200 && response.statusCode < 400 {
                    // ok
                } else {
                    myError = .nonSuccessfulResponseError
                }
            }
            if let data = data {
                let jsonDecoder = JSONDecoder()
                if let userFromResponse = try? jsonDecoder.decode(User.self, from: data) {
                    //print(userFromResponse)
                    myUser = userFromResponse
                    self.loggedInUser = userFromResponse
                } else {
                    if let errorFromResponse = try? jsonDecoder.decode(ResponseError.self, from: data) {
                        print(errorFromResponse)
                        if (errorFromResponse.error.message == "INVALID_EMAIL") {
                            myError = .notValidEmailError
                        }
                        if (errorFromResponse.error.message == "EMAIL_NOT_FOUND") {
                            myError = .wrongEmailError
                        }
                        if (errorFromResponse.error.message == "MISSING_PASSWORD") {
                            myError = .noPasswordError
                        }
                        if (errorFromResponse.error.message == "INVALID_PASSWORD") {
                            myError = .wrongPasswordError
                        }
                        
                    }
                }
           }
            DispatchQueue.main.async {
                completionHandler(myUser, myError)
            }
        }
        dataTask.resume()
        
    }
    
    //download the country from the api
    func getCountries(completionhandler: @escaping (DocumentsContainer?) -> Void){
        
        var countries: DocumentsContainer?

        guard let loggedInUser = loggedInUser else {
            print("loggedin nil")
            return
        }
        let url = URL(string: "https://firestore.googleapis.com/v1/projects/mad-course-3ceb1/databases/(default)/documents/countries?pageSize=1000&orderBy=name")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(loggedInUser.idToken)", forHTTPHeaderField: "Authorization")
        //print(request.allHTTPHeaderFields)
        let datatask = urlSession.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("error datatask1")
                return
            }
            
            guard let unwarrapedData = data else { print("error unwarrpingdata1")
                return
                
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let country = try decoder.decode(DocumentsContainer.self, from: unwarrapedData)
                
                countries = country
                
            }
            catch { print(error) }
            
            DispatchQueue.main.async {
                // pass the countries to CountryViewController
                completionhandler(countries)
            }
            
        }
        datatask.resume()
    }
    
}

