//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by George Garcia on 11/15/17.
//  Copyright © 2017 Gee Team. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapView: MKMapView!
    
    var restaurant: RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantImageView.image = UIImage(data: restaurant.image as! Data)
        tableView.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.2)
        //tableView.tableFooterView = UIView(frame: CGRect.zero) // removing seperators
        tableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
        
        title = restaurant.name
        
        navigationController?.hidesBarsOnSwipe = false
        
        // SELF SIZING
        tableView.estimatedRowHeight = 36.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Table Footer For Map
        // remove tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //Using UITapGestureRecognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        // Geocoder and adding PIN ANNOTATIONS
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!) { (placemarks, error) in
            
            if error != nil{
                print(error as Any)
                return
            }
            
            if let placemarks = placemarks{
                // getting the first placemark
                let placemark = placemarks[0]
                
                // adding annotation
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location{
                    // display annotation
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    // setting the zoom level
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    
                    self.mapView.setRegion(region, animated: false)
                    
                }
                
            }
            
        }
        
    }
    
    @objc func showMap(){
        
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    @IBAction func close(segue: UIStoryboardSegue){
    }
    
    @IBAction func ratingButtonTapped(segue: UIStoryboardSegue){
        
        if let rating = segue.identifier {
            
            restaurant.isVisited = true // so when any button that has been touched, this will change the isVisited to true
            
            switch rating {
                case "amazing" : restaurant.rating = "It is really amazing! Must try!"
                case "decent" : restaurant.rating = "Meh, it is not too bad"
                case "nope" : restaurant.rating = "Not feeling it at all. Did not like it"
                            
                default: break
            }
        }
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){ // update restaurant record
            
            appDelegate.saveContext()
        }
        
        tableView.reloadData() // refresh table
    }
    
    override func viewWillAppear (_ animated: Bool){
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
            
        } else if segue.identifier == "showMap"{
            
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
        }
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantDetailTableViewCell
        
        switch indexPath.row{
            case 0:
                cell.fieldLabel.text = "Name"
                cell.valueLabel.text = restaurant.name
            case 1:
                cell.fieldLabel.text = "Type"
                cell.valueLabel.text = restaurant.type
            case 2:
                cell.fieldLabel.text = "Location"
                cell.valueLabel.text = restaurant.location
            case 3:
                cell.fieldLabel.text = "Phone Number"
                cell.valueLabel.text = restaurant.phoneNumber
            case 4:
                cell.fieldLabel.text = "Been Here"
                cell.valueLabel.text = (restaurant.isVisited) ? "Yes, I have been here. \(String(describing: restaurant.rating))" : "No, I have not"
            default:
                cell.fieldLabel.text = ""
                cell.valueLabel.text = ""
        }
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
