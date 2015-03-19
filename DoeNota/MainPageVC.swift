//
//  MainPageVC.swift
//  DoeNota
//
//  Created by Isa Sophia on 2/12/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

class MainPageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var Settings: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the databse set
        DatabaseManager.sharedInstance.getSet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Ajuda", style: .Plain, target: nil, action: nil)
        
        // Adds the camera button
        let cameraImg = UIImage(named: "Camera")
        let cameraFrame = CGRectMake(screenSize.width * 0.5 - 27.5, screenSize.height - 118, 55, 55)
        var cameraButton = UIButton(frame: cameraFrame)
        cameraButton.setImage(cameraImg, forState: UIControlState.Normal)
        cameraButton.setImage(cameraImg, forState: UIControlState.Highlighted)
        cameraButton.addTarget(self, action: "canTakePhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(cameraButton)
        
        // Adds the gallery button
        let galleryImg = UIImage(named: "Gallery")?.imageWithColor(UIColor(red: 197/255, green: 171/255, blue: 202/255, alpha: 1))
        let galleryFrame = CGRectMake(screenSize.width * 0.5 + 37, screenSize.height - 97, 22, 22)
        var galleryButton = UIButton(frame: galleryFrame)
        galleryButton.setImage(galleryImg, forState: UIControlState.Normal)
        galleryButton.setImage(galleryImg, forState: UIControlState.Highlighted)
        galleryButton.addTarget(self, action: "selectPhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(galleryButton)
        
        // Adds the help button
        let helpImg = UIImage(named: "Question")?.imageWithColor(UIColor(red: 154/255, green: 126/255, blue: 158/255, alpha: 1))
        let helpFrame = CGRectMake(0, 0, 22, 22)
        var helpButton = UIBarButtonItem(image: helpImg, style: .Plain, target: self, action: "ButtonClicked:")
        self.navigationItem.rightBarButtonItem = helpButton
        
        // Sets the title
        var titleImg = UIImageView(image: UIImage(named: "DoeNota"))
        titleImg.frame = CGRectMake(0, 0, 122, 30)
        titleImg.contentMode = UIViewContentMode.ScaleAspectFit
        titleImg.image = UIImage(named: "DoeNota")
        
        var titleView = UIView(frame: CGRectMake(0, 0, 122, 30))
        titleView.addSubview(titleImg)
        titleView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.navigationItem.titleView = titleView
        
        // Loads buttons actions
        Settings.action = "ButtonClicked:"
        
        // Testing database...
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ButtonClicked (sender: UIButton!) {
        if (sender == Settings) {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Preferências", style: .Plain, target: nil, action: nil)
            
            performSegueWithIdentifier("ToSettings", sender: nil)
        } else {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Dicas", style: .Plain, target: nil, action: nil)
            
            performSegueWithIdentifier("ToHelp", sender: nil)
        }
    }
    
    // Regards photo actions
    func canTakePhoto(sender: UIButton!) {
        if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let alertCamera = UIAlertView(title: "Ops! Ocorreu um erro...", message: "Não foi possível detectar uma câmera em seu dispositivo.", delegate: nil, cancelButtonTitle: "OK")
            
            alertCamera.show()
            
            return
        }
        
        takePhoto()
    }
    
    func takePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func selectPhoto(sender: UIButton!) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    // Image delegate, picks the image in order to process it and send to server
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        let finalImg = ImageProcessor.processImage(image)
        let convertedImage : NSData = UIImageJPEGRepresentation(finalImg, 0.75)
        
        ServerConnection.sendToServer(convertedImage, user: "1", institution: "2")
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
