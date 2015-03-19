//
//  HelpVC.swift
//  DoeNota
//
//  Created by Isadora Sophia on 3/19/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {

    required init(coder aDecoder: NSCoder) {
        imageFile = "Camera.png"
        currentText = "olar"
        
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var currentImageView: UIImageView!
    @IBOutlet weak var textHelp: UITextView!
    
    var imageFile : NSString
    var currentText : NSString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentImageView.image = UIImage (named: self.imageFile)
        self.textHelp.text = self.currentText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
