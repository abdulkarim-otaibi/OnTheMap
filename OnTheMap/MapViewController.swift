//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Abdulkrum Alatubu on 21/11/1441 AH.
//  Copyright © 1441 AbdulkarimAlotaibi. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: locationDataViewController ,MKMapViewDelegate{

    @IBOutlet weak var map: MKMapView!
   
    override var locationsData: LocationsData? {
        didSet{
            updatePins()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    
    func updatePins() {
        guard let locations = locationsData?.results else { return }
        
        var annotations = [MKPointAnnotation]()
        
        for location in locations {
    
            let latitude = location.latitude
            let longitude = location.longitude
            
            let lat = CLLocationDegrees(latitude!)
            let long = CLLocationDegrees(longitude!)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first ?? "") \(last ?? "")"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        map.removeAnnotations(map.annotations)
        map.addAnnotations(annotations)
    }


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
