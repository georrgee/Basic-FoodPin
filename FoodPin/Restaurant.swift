// Restaurant Class

import Foundation

class Restaurant {
    
    //5 properties
    @objc var name = ""
    @objc var type = ""
    @objc var location = ""
    @objc var phone = ""
    @objc var image = ""
    @objc var isVisited = false
    @objc var rating = ""
    
    init(name: String, type: String, location: String, phone: String, image: String, isVisited: Bool) { // constructor
        
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.image = image
        self.isVisited = isVisited
    }
    
}
