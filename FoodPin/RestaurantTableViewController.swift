//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by George Garcia on 10/23/17.
//  Copyright © 2017 Gee Team. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
        var resterName = ["Cafe Deadend", "Homei", "Teakha", "Cafe Loisl", "Petite Oyster", "For Kee Restaurant", "Po's Atelier", "Chipotle", "Bdubs", "Panda Express", "Upstate", "Traif", "Grahama Avenue Meats and Deli", "Waffle Wolf", "Five Leaves", "Cafe Lore", "Confessional", "Barrafina", "Donostia", "Royal Oak", "CASK Pub and Kitchen"]
    
        var restImages = ["barrafina.jpg", "bourkestreetbakery.jpg", "cafedeadend.jpg", "cafeloisl.jpg", "cafelore.jpg", "caskpubkitchen.jpg", "confessional.jpg", "donostia.jpg", "fiveleaves.jpg", "forkeerestaurant.jpg", "grahamavenuemeats.jpg", "haighschocolate.jpg", "homei.jpg", "palominoespresso.jpg", "petiteoyster.jpg", "posatelier.jpg", "restaurant.jpg", "royaloak.jpg", "teakha.jpg", "traif.jpg", "upstate.jpg", "wafflewolf.jpg"]
    
        var restLocation = ["Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Hong Kong", "Sydney", "Sydney", "Sydney", "New York", "New York", "New York", "New York", "New York", "New York", "New York", "London", "London", "London", "London"]
    
        var restType = ["Coffee & Tea Shop", "Cafe", "Tea House", "Austraian/Causal Drink", "French", "Bakery", "Bakery", "Chocolate", "Cafe", "American/Seafood", "American", "American", "Breakfast & Brunch", "Coffee & Tea", "Coffee & Tea" ,"Latin American", "Spanish", "Spanish", "Spanish", "British", "Thai"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resterName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellID = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! RestaurantTableViewCell
        
        cell.nameLabel.text = resterName[indexPath.row]
        cell.thumbnailImageView.image = UIImage(named: restImages[indexPath.row])
        cell.locationLabel.text = restLocation[indexPath.row]
        cell.typeLabel.text = restType[indexPath.row]
        
        // circular image
//        cell.thumbnailImageView.layer.cornerRadius = 30.0
//        cell.thumbnailImageView.clipsToBounds = true
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
