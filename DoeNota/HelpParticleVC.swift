//
//  HelpParticleVC.swift
//  DoeNota
//
//  Created by Isadora Sophia on 3/19/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

class HelpParticleVC: UIViewController {
    
    var imageFile : String!
    var currentText : String!
    
    var pageIndex : Int?
    
    var myImageView: UIImageView!
    var myTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        var initialImg = UIImage(named: self.imageFile)!
        
        self.myImageView.image = initialImg
        
        self.myTextView.text = self.currentText
        self.myTextView.alpha = 0.1
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            self.myTextView.alpha = 1.0
        })
        
        self.view.addSubview(myImageView)
        self.view.addSubview(myTextView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}