//
//  MapViewController.swift
//  FoodPin
//
//  Created by George Garcia on 12/5/17.
//  Copyright © 2017 Gee Team. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(restaurant.location!) { (placemarks, error) in
            
            if error != nil {
                print (error as Any)
                return
            }
            
            if let placemarks = placemarks{
                
                let placemark = placemarks[0]
                
                //add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location{
                    
                    annotation.coordinate = location.coordinate
                    
                    //display annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                    
                }
            }
        }
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        // if yes, return nil and the map view will keep displaying the location using a blue dot
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        }
        // for performance reasons, it is preferred to reuse an existing annotation view instead of creating a new one
        
        //Reuse annotation if possible
        
        //seeing if any unused views are available then downcast it to MKPINANNOTATIONVIEW
        var annotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil{
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView?.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        
        leftIconView.image = UIImage(data: restaurant.image as! Data)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        return annotationView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
