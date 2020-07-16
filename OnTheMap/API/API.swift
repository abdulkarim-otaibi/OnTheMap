//
//  API.swift
//  OnTheMap
//
//  Created by Abdulkrum Alatubu on 20/11/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import Foundation


class API {
    
    private static var userInfo = UserInformation()
    private static var sessionId: String?
    
    static func postStudentLocations(mapString: String,mediaURL: String, latitude: String, longitude: String, completion: @escaping (String?)->Void){
        //John Doe
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(userInfo.key!)\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 {
                    //Response is ok
                    print("\(String(describing: data))")
                } else {
                    errString = "\(String(describing: error))"
                }
            } else { //Request failed to sent
                errString = "Check your internet connection"
            }
          print(String(data: data!, encoding: .utf8)!)
          DispatchQueue.main.async {
            completion(errString)
          }
        }
        task.resume()
    }
    static func DeleteSession(completion: @escaping (String?)->Void){
            
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/session") else {
                   completion("Supplied url is invalid")
                   return
               }
        var request = URLRequest(url: url)

        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        var errString: String?

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            if statusCode >= 200 && statusCode < 300 {
                let newData = data?.subdata(in: 5..<data!.count)/* subset response data! */
                print(String(data: newData!, encoding: .utf8)!)//Response is ok
                
            } else {
                errString = "\(String(describing: error))"
                }
              } else { //Request failed to sent
                errString = "Check your internet connection"
            }
    
            DispatchQueue.main.async {
                completion(errString)
            }
        }
        task.resume()
    
    }
    static func postSession(username: String, password: String, completion: @escaping (String?)->Void) {
        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/session") else {
            completion("Supplied url is invalid")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 {
                    //Response is ok
                    
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dict = json as? [String:Any],
                        let sessionDict = dict["session"] as? [String: Any],
                        let accountDict = dict["account"] as? [String: Any]  {
                        print("\( accountDict)")
                        self.sessionId = sessionDict["id"] as? String
                        self.userInfo.key = accountDict["key"] as? String
   
                    } else {
                        errString = "Couldn't parse response"
                    }
                } else {
                    errString = "Invalid username or password"
                }
            } else { //Request failed to sent
                errString = "Check your internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
            
        }
        task.resume()
    }

    
    
    static func getStudentLocations(completion: @escaping (LocationsData?, String?)->Void) {

        guard let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&order=-updatedAt") else {
            completion(nil ,"Supplied url is invalid")
            return
        }
        var errString: String?
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var locationsData: LocationsData?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    do {
                        locationsData = try JSONDecoder().decode(LocationsData.self, from: data!)
                    } catch {
                         errString = "there is some error on read data"
                    }
                }else{
                    errString = "\(String(describing: error))"
                    
                }
                
            }else{
                errString = "Check your internet connection"
            }
            
            DispatchQueue.main.async {
                completion(locationsData, errString)
            }
            
        }
        task.resume()
    }
       
      
   
}
