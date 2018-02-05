//  WalkthoughContentViewController.swift
//  FoodPin
//  This class will support multiple walkthrough screens

//  Created by George Garcia on 1/15/18.
//  Copyright © 2018 Gee Team. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var fowardButton: UIButton!
    
    var index = 0 // store the current page index (i.e first screen will have the index value of 0)
    
    var heading = "", imageFile = "", content = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel.text = heading
        contentLabel.text = content
        contentImageView.image = UIImage(named: imageFile)
        pageControl.currentPage = index
        
        switch index{
            case 0...1: fowardButton.setTitle("NEXT", for: .normal)
            case 2: fowardButton.setTitle("DONE", for: .normal)
        default : break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    @IBAction func nextButtonTapped(sender: UIButton){
        switch index{
        case 0...1: // Next button
            let pageViewController = parent as! WalkthroughPageViewController
            pageViewController.forward(index: index)
        case 2: // Done button
            UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
            dismiss(animated: true, completion: nil)
        default : break
        }
    }
  
}
