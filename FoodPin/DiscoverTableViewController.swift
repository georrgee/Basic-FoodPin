//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by George Garcia on 1/29/18.
//  Copyright © 2018 Gee Team. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController{
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    var imageCache = NSCache<CKRecordID, NSURL>()
    
    
    var restaurants: [CKRecord] = [] // stores an array of CKRecord Objects (Initially the array is empty)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecordsFromCloud()
        
        // displaying loading indicator on app
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        tableView.addSubview(spinner)
        spinner.startAnimating()
        
        //pull to refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControlEvents.valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.object(forKey: "name") as? String
        
        cell.imageView?.image = UIImage(named: "photoalbum")
        
        if let imageFileUrl = imageCache.object(forKey: restaurant.recordID){
            
            print("Get image from cache...")
            if let imageData = try? Data.init(contentsOf: imageFileUrl as URL){
                
                cell.imageView?.image = UIImage(data: imageData)
            }
            
        } else {
            // fetch image from cloud in background
            let publicDatabase = CKContainer.default().publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .veryHigh
            
            fetchRecordsImageOperation.perRecordCompletionBlock = { (record, recordID, error) -> Void in
                
                if let error = error{
                    print("Failed to get restaurant image: \(error.localizedDescription)")
                    return
                }
                if let restaurantRecord = record {
                    
                    OperationQueue.main.addOperation {
                        if let image = restaurantRecord.object(forKey: "image"){
                            
                            let imageAsset = image as! CKAsset
                            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL){
                                cell.imageView?.image = UIImage(data: imageData)
                            }
                            self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: restaurant.recordID) // add the image URL to the cache
                        }
                    }
                }
            }
            publicDatabase.add(fetchRecordsImageOperation)
        }
        return cell
        //        if let image = restaurant.object(forKey: "image"){
        //
        //            let imageAsset = image as! CKAsset
        //            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL){
        //                cell.imageView?.image = UIImage(data: imageData)
        //            }
        //        }
    }
    
    @objc func fetchRecordsFromCloud(){
        
        //remove existing records before refreshing
        restaurants.removeAll()
        tableView.reloadData()
        
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Create the query operation with the query
        let queryOperation = CKQueryOperation(query: query)
        //queryOperation.desiredKeys = ["name","image"]
        queryOperation.desiredKeys = ["name"] // lazy loading
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = {(record) -> Void in
            self.restaurants.append(record)
        }
        
        queryOperation.queryCompletionBlock = {(cursor, error) -> Void in
            
            if let error = error {
                print("Failed to get data from iCloud... \(error.localizedDescription)")
                return
            }
            
            print("Successfully retrieve the data from iCloud")
            OperationQueue.main.addOperation {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                
                if let refreshControl = self.refreshControl{
                    
                    if refreshControl.isRefreshing{
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
        publicDatabase.add(queryOperation) // execute query operation
    }
}


//  func fetchRecordsFromCloud(){
//        // fetch data using convenience API
//        let cloudContainer = CKContainer.default()
//        let publicDatabase = cloudContainer.publicCloudDatabase
//        let predicate = NSPredicate(value: true)
//        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
//        publicDatabase.perform(query, inZoneWith: nil) { (results, error ) in
//
//            if error != nil{
//                print(error!)
//                return
//            }
//
//            if let results = results{
//
//                print("Download of Resturant Data Completed...")
//                self.restaurants = results
//                OperationQueue.main.addOperation {
//                    self.tableView.reloadData()
//                }
//            }
//        }
