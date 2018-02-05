//
//  AddRestaurantController.swift AKA ADDTABLEVIEWCONTROLLER
//  FoodPin
//
//  Created by George Garcia on 12/11/17.
//  Copyright © 2017 Gee Team. All rights reserved.
//

import UIKit
import CloudKit

class AddRestaurantController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    @IBOutlet var photoImageView: UIImageView!
    
    var isVisited = true
    
    var restaurant : RestaurantMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                present(imagePicker, animated: true, completion: nil)
                
                imagePicker.delegate = self
            }
        }
    }
    
    // get the selected photo from the method's parameter
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // creating a variable where it will equal to the image chosen
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            photoImageView.image = selectedImage // let the outlet object equal to selectedImage
            photoImageView.contentMode = .scaleAspectFill // scale it to the appropiate size
            photoImageView.clipsToBounds = true // clips to bounds
        }
        
        // Auto Layout Programatically
        let leadingConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: photoImageView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: photoImageView.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        
        bottomConstraint.isActive = true
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveDetails(_ sender: AnyObject) {
        
        if nameTextField.text == "" || typeTextField.text == "" || locationTextField.text == "" || phoneTextField.text == ""{
            
            let alert = UIAlertController(title: "Missing info", message: "Looks like we are missing some info from either the name, type, or location. Please complete the form in order to proceed.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                //self.dismiss(animated: true, completion: nil)
                // having this will go back to the restaurant page which it shouldnt. There fore remove this dismiss call
            }))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        print("Name: " + (nameTextField.text!))
        print("Type: " + (typeTextField.text!))
        print("Location: " + (locationTextField.text!))
        print("Phone Number: " + (phoneTextField.text!))
        print("Have you been here?: \(isVisited)")
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){ //persistentContainer varible is declared in AppDelegate.swift . Access var, we get ref AppDelegate
            
            restaurant = RestaurantMO(context: appDelegate.persistentContainer.viewContext)
            restaurant.name = nameTextField.text
            restaurant.type = typeTextField.text
            restaurant.location = locationTextField.text
            restaurant.phoneNumber = phoneTextField.text
            restaurant.isVisited = isVisited
            
            if let restaurantImage = photoImageView.image {
                if let imageData = UIImagePNGRepresentation(restaurantImage) {
                    
                    restaurant.image = NSData(data: imageData) as Data
                }
            }
            print("Saving data to context......")
            appDelegate.saveContext() // saving info to database
        }
        saveRecordToCloud(restuarnt: restaurant)
       dismiss(animated: true, completion: nil)
    }
    // end of saveDetails Function
    
    @IBAction func beenHereButton(sender: UIButton){
        
        if sender == yesButton{
            isVisited = true
            yesButton.backgroundColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
            noButton.backgroundColor = UIColor(red: 218.0/255.0, green: 223.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        } else if sender == noButton{
            isVisited = false
            yesButton.backgroundColor = UIColor(red: 218.0/255.0, green: 223.0/255.0, blue: 225.0/255.0, alpha: 1.0)
            noButton.backgroundColor = UIColor(red: 218.0/255.0, green: 100.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        }
    }
    
    func saveRecordToCloud(restuarnt: RestaurantMO!) -> Void { // takes in a Restaurant Object which is the object to save
        
        // prepare the record to save
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.name, forKey: "name")
        record.setValue(restaurant.type, forKey: "type")
        record.setValue(restaurant.location, forKey: "location")
        record.setValue(restaurant.phoneNumber, forKey: "phone") // All this is to transform the restaurant object to CK Record
        
        let imageData = restaurant.image as! Data
        
        //Resize Image (scaling down the image; we dont want to upload a super-high resolution photo)
        let originalImage = UIImage(data: imageData)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: imageData, scale: scalingFactor)
        
        // Write the image to Local File for temporary use
        let imageFilePath = NSTemporaryDirectory() + restaurant.name! // get the path of the temporary directory; by combining both name and path, temporary file path created
        let imageFileUrl = URL(fileURLWithPath: imageFilePath)
        try? UIImageJPEGRepresentation(scaledImage!, 0.8)?.write(to: imageFileUrl) // save the compressed image data as a file by using the write function
        
        //create image asset for upload
        let imageAsset = CKAsset(fileURL: imageFileUrl)
        record.setValue(imageAsset, forKey: "image")
        
        // Get the public iCloud Database
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        // Save the record to iCloud
        publicDatabase.save(record) { (record,error ) in
            //remove file (temporarily clean up the temp directory)
            try? FileManager.default.removeItem(at: imageFileUrl)
        }
    }
}
