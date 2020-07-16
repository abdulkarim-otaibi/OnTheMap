//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Abdulkrum Alatubu on 23/11/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var mediaLink: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancel(_:)))

        location.delegate = self
        mediaLink.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
           subscribeToKeyboardNotifications()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
           unsubscribeFromKeyboardNotifications()
        }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
       
    
    
   
    @IBAction func findLocation(_ sender: Any) {
        guard let location = location.text,
            let mediaLink = mediaLink.text,
            location != "", mediaLink != "" else {
                self.showAlert(title: "Missing information", message: "Please fill both fields and try again")
                return
        }
        
        let studentLocation = StudentInformation(mapString: location, mediaURL: mediaLink)
        geocodeCoordinates(studentLocation)
    }
    
  
    private func geocodeCoordinates(_ studentLocation: StudentInformation) {
           
        let load = self.startAnActivityIndicator()
        
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (Placemark, error) in
            load.stopAnimating()
            
            guard let firstLocation = Placemark?.first?.location else {
                self.showAlert(title: "Error", message: error as! String)
                return
            }
            
            var location = studentLocation
            location.longitude = firstLocation.coordinate.longitude
            location.latitude = firstLocation.coordinate.latitude
            self.performSegue(withIdentifier: "map", sender: location)
        }
   
       }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "map", let viewController = segue.destination as? ConfirmLocationViewController {
              viewController.studentLocation = sender as? StudentInformation
          }
      }
    
  
   
   
    
    @objc private func cancel(_ sender: Any) {
           self.dismiss(animated: true, completion: nil)
       }
    
    
}

extension UIViewController {
      func startAnActivityIndicator() -> UIActivityIndicatorView {
          let ai = UIActivityIndicatorView(style: .medium)
          self.view.addSubview(ai)
          self.view.bringSubviewToFront(ai)
          ai.center = self.view.center
          ai.hidesWhenStopped = true
          ai.startAnimating()
          return ai
      }
  }
