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
    
    var aboutNotas : NonSelectableUTV? = nil
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the databse set
        DatabaseManager.sharedInstance.getSet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseManager.sharedInstance.getSet()
        
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Ajuda", style: .Plain, target: nil, action: nil)
        
        // Adds the camera button
        let cameraImg = UIImage(named: "Camera")
        var cameraFrame : CGRect
        
        cameraFrame = CGRectMake(screenSize.width * 0.5 - 27.5, screenSize.height - 118 - UIApplication.sharedApplication().statusBarFrame.height + 20, 55, 55)
        
        var cameraButton = UIButton(frame: cameraFrame)
        cameraButton.setImage(cameraImg, forState: UIControlState.Normal)
        cameraButton.setImage(cameraImg, forState: UIControlState.Highlighted)
        cameraButton.addTarget(self, action: "canTakePhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(cameraButton)
        
        // Adds the gallery button
        let galleryImg = UIImage(named: "Gallery")?.imageWithColor(UIColor(red: 197/255, green: 171/255, blue: 202/255, alpha: 1))
        let galleryFrame = CGRectMake(screenSize.width * 0.5 + 37, screenSize.height - 97 - UIApplication.sharedApplication().statusBarFrame.height + 20, 22, 22)
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
        
        // Let user know about the status
        aboutNotas = NonSelectableUTV(frame: CGRectMake(0, UIApplication.sharedApplication().statusBarFrame.origin.y + UIApplication.sharedApplication().statusBarFrame.height - 22, screenSize.size.width, screenSize.size.height/20 * 0.9))
        
        aboutNotas!.backgroundColor = UIColor(red: 197/255, green: 171/255, blue: 202/255, alpha: 0.35)
        aboutNotas!.textColor = UIColor(red: 128/255, green: 104/255, blue: 131/255, alpha: 1)
        aboutNotas!.textAlignment = NSTextAlignment.Center
        aboutNotas!.font = UIFont(name: "Roboto-Thin", size: screenSize.size.height/20 * 0.9 * 0.45)
        
        aboutNotas!.editable = false
        aboutNotas!.userInteractionEnabled = false
        
        self.updateNotas()
        self.view.addSubview(aboutNotas!)
        
        // Loads buttons actions
        Settings.action = "ButtonClicked:"
        
        // Add observer for internet
        let reachability = Reachability.reachabilityForInternetConnection()
        
        self.reachabilityChanged(nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
        reachability.startNotifier()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateNotas:", name: NotaSent, object: ServerConnection())
    }
    
    func reachabilityChanged(note: NSNotification?) {
        let reachability = Reachability.reachabilityForInternetConnection()
        
        let notasDB = DatabaseManager.sharedInstance.totalPhotos()
        var counter : Int
        
        if (notasDB > 0 && reachability.isReachable()) {
            counter = notasDB
            
            if ((reachability.isReachableViaWWAN() && DatabaseManager.sharedInstance.getHability3G()) || reachability.isReachableViaWiFi()) {
                while (((reachability.isReachableViaWWAN() && DatabaseManager.sharedInstance.getHability3G()) || reachability.isReachableViaWiFi())
                    && counter-- > 0) {
                    let image = DatabaseManager.sharedInstance.getImage(DatabaseManager.sharedInstance.getNext())
                    let id = DatabaseManager.sharedInstance.getId(DatabaseManager.sharedInstance.getNext())
                    let institution = DatabaseManager.sharedInstance.getInstitution(DatabaseManager.sharedInstance.getNext())
                    
                    ServerConnection.sendToServer(image, user: "1", institution: institution, id: id)
                }
            }
        }
        
        self.updateNotas()
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
        let convertedImage : NSData = UIImageJPEGRepresentation(finalImg, 0.70)
        
        let reachability = Reachability.reachabilityForInternetConnection()
        let institution = DatabaseManager.sharedInstance.getInstitution()
        let id = "IOS " + DatabaseManager.sharedInstance.userID()
        
        if (!reachability.isReachable()) {
            DatabaseManager.sharedInstance.savePhoto(convertedImage, institution: institution, user: "1", id: id)
            
            self.updateNotas()
        } else if ((reachability.isReachableViaWWAN() && DatabaseManager.sharedInstance.getHability3G()) || reachability.isReachableViaWiFi()) {
            ServerConnection.sendToServer(convertedImage, user: "1", institution: institution, id: id)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateNotas () {
        if (DatabaseManager.sharedInstance.totalPhotos() > 0) {
            aboutNotas!.text = "Ainda falta enviar \(DatabaseManager.sharedInstance.totalPhotos()) nota(s)!"
        } else {
            aboutNotas!.text = "Não há notas para serem enviadas."
        }
    }
}
