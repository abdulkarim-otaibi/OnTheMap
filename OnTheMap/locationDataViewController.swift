//
//  locationDataViewController.swift
//  OnTheMap
//
//  Created by Abdulkrum Alatubu on 22/11/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import UIKit

class locationDataViewController: UIViewController {

    var locationsData: LocationsData?

    override func viewDidLoad() {
        super.viewDidLoad()
        // add three buttons for logout , refresh and add on userInterface
        setup()
        // load the locations from API
        loadLocations()
    }
    
    func setup() {
          let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addLocation(_:)))
          let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshLocations(_:)))
          let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logout(_:)))
          
          navigationItem.rightBarButtonItems = [plusButton, refreshButton]
          navigationItem.leftBarButtonItem = logoutButton
     }
     @objc private func addLocation(_ sender: Any) {
         let LocationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Location") as! UINavigationController
         
         present(LocationController, animated: true, completion: nil)
     }
     
     @objc private func refreshLocations(_ sender: Any) {
         loadLocations()
     }
     
     @objc private func logout(_ sender: Any) {
         logout()
     }
    
    func logout(){
        
        let load = self.startAnActivityIndicator()

        API.DeleteSession { (error) in
            load.stopAnimating()
            if let error = error {
                self.showAlert(title: "Error", message: "\(error)")
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func loadLocations(){
         
          let load = self.startAnActivityIndicator()
          API.getStudentLocations { (LocationsData, error) in
            load.stopAnimating()
            guard let data = LocationsData else {
                self.showAlert(title: "Error", message: "No internet connection")
                return
            }
            guard data.results.count > 0 else {
                self.showAlert(title: "Error", message: "No Locations found")
                return
            }
            self.locationsData = data
          }
      }
}
