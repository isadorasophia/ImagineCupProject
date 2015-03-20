//
//  HelpParticleVC.swift
//  DoeNota
//
//  Created by Isadora Sophia on 3/19/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

class HelpParticleVC: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextView: UITextView!
    
    var imageFile : NSString = ""
    var currentText : NSString = ""
    
    var pageIndex : NSInteger = 0
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myImageView.image = UIImage (named: self.imageFile)
        self.myTextView.text = self.currentText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}