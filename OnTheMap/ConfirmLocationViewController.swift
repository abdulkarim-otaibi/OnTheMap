//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Abdulkrum Alatubu on 24/11/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var studentLocation :StudentInformation?
    
    @IBAction func finish(_ sender: Any) {
        addLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    func addLocation(){
        
        if let lat = studentLocation?.latitude , let long = studentLocation?.longitude , let mediaURL = studentLocation?.mediaURL , let mapString = studentLocation?.mapString{
            API.postStudentLocations(mapString: "\(mapString)", mediaURL: "\(mediaURL)", latitude: "\(lat)", longitude: "\(long)", completion: { (error) in
                if let error = error {
                    self.showAlert(title: "Error", message: "\(error)")
                }else{
                    self.dismiss(animated: true, completion: nil)   
                }
            })
        }else{
            self.showAlert(title: "Error", message: "no location or mediaURL found")
        }
        
    }

    func setup(){
        guard let location = studentLocation else {
            return
        }
        
        let latitude = CLLocationDegrees(location.latitude!)
        let longitude = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        
        map.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        map.setRegion(region, animated: true)
   
    }

}

extension ConfirmLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
