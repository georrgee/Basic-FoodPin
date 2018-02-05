//
//  AboutTableViewController.swift (Class)
//  FoodPin
//
//  Created by George Garcia on 1/23/18.
//  Copyright © 2018 Gee Team. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    var sectionTitles = ["Leave Feedback","Follow Us"]
    var sectionContent = [ ["Rate us on the App Store", "Tell us your feedback"], ["Twitter", "Facebook", "Pinterest"] ]
    var links = ["https://twitter.com/Georr_Gee", "https://facebook.com/GeorrGee20", "https://www.pinterest.com/appcoda/"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int { // returning the amount of sections created. Therefore since there are two elements in the array. 2 sections will be created
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0: // Leave us feedback section since its position is in element [0]
            if indexPath.row == 0 { // if it were to choose for example the first row of the section, then it will pick row [0] of section [0]
                if let url = URL(string: "http://www.apple.com/itunes/charts/paid-apps/"){
                    UIApplication.shared.open(url) // safari app
                }
            } else if indexPath.row == 1 {
                performSegue(withIdentifier: "showWebView", sender: self) // another view controller and display web content
            }
        case 1: // follow us section
            if let url = URL(string: links[indexPath.row]){
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: false)
     }
}
