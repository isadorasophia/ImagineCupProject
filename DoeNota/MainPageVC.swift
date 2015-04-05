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
    let serverConnection : ServerConnection = ServerConnection.sharedInstance
    
    var helpView : UIImageView? = nil
    var helpText : NonSelectableUTV? = nil
    var settingsView : UIImageView? = nil
    var settingsText : NonSelectableUTV? = nil
    var notinhaView : UIImageView? = nil
    var notinhaText : NonSelectableUTV? = nil
    
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
        let helpNavImg = UIImage(named: "Question")?.imageWithColor(UIColor(red: 154/255, green: 126/255, blue: 158/255, alpha: 1))
        let helpFrame = CGRectMake(0, 0, 22, 22)
        var helpButton = UIBarButtonItem(image: helpNavImg, style: .Plain, target: self, action: "ButtonClicked:")
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
        aboutNotas = NonSelectableUTV(frame: CGRectMake(0, 0, screenSize.size.width, screenSize.size.height/20 * 0.9))
        
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
        
        self.loadMainScreen()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
        reachability.startNotifier()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ChangedSettings, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notaJustSent:", name: Success, object: nil)
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
                    
                    serverConnection.sendToServer(image, user: "1", institution: institution, id: id, alreadyStored: true)
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
        let finalImg = ImageProcessor.sharedInstance.processImage(image)
        let convertedImage : NSData = UIImageJPEGRepresentation(finalImg, 0.70)
        
        let reachability = Reachability.reachabilityForInternetConnection()
        let institution = DatabaseManager.sharedInstance.getInstitution()
        let id = "IOS " + DatabaseManager.sharedInstance.userID()
        
        DatabaseManager.sharedInstance.savePhoto(convertedImage, institution: institution, user: "1", id: id)
        
        self.updateNotas()
        
        if (reachability.isReachable() && ((reachability.isReachableViaWWAN() && DatabaseManager.sharedInstance.getHability3G()) || reachability.isReachableViaWiFi())) {
            serverConnection.sendToServer(convertedImage, user: "1", institution: institution, id: id, alreadyStored: true)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        //performSegueWithIdentifier("ToSuccess", sender: nil)
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
    
    func notaJustSent (note: NSNotification?) {
        let screenSize : CGRect = UIScreen.mainScreen().bounds

        let sent = NonSelectableUTV(frame: CGRectMake(0, screenSize.size.height/2 - screenSize.size.height/10, screenSize.size.width, screenSize.size.height/20))
        sent.textAlignment = NSTextAlignment.Center
        sent.font = UIFont(name: "Roboto-Thin", size: screenSize.size.height/20 * 0.9 * 0.6)
        sent.textColor = UIColor(red: 128/255, green: 104/255, blue: 131/255, alpha: 1)
        sent.text = "Enviado!"
        sent.alpha = 0
        
        self.view.addSubview(sent)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations:  { () -> Void in
            sent.alpha = 1.0
            }, completion:  { (finished: Bool) -> Void in
                // Fade out
                UIView.animateWithDuration(0.5, delay: 2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    sent.alpha = 0
                    }, completion: nil)
        })
        
        self.updateNotas()
    }
    
    func loadMainScreen () {
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        // Adds the help section
        let helpImg = UIImage(named: "Question")?.imageWithColor(UIColor(red: 154/255, green: 126/255, blue: 158/255, alpha: 1))
        let helpFrame = CGRectMake(screenSize.width/20, aboutNotas!.frame.height + screenSize.width/20, screenSize.width/15, screenSize.width/15)
    
        helpView = UIImageView(frame: helpFrame)
        helpView!.image = helpImg
        helpView!.alpha = 0
        
        helpText = NonSelectableUTV(frame: CGRectMake(screenSize.width/20 + screenSize.width/15, helpView!.frame.origin.y - helpView!.frame.height/2, screenSize.size.width - (screenSize.width/20 + (screenSize.width/15)), 2.5 * helpView!.frame.height))
        helpText!.textAlignment = NSTextAlignment.Left
        helpText!.font = UIFont(name: "Roboto-Thin", size: screenSize.size.height/20 * 0.9 * 0.6)
        helpText!.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        helpText!.text = "Aperte para instruções de como tirar a foto de sua nota fiscal."
        helpText!.alpha = 0
        
        self.view.addSubview(helpView!)
        self.view.addSubview(helpText!)
        
        // Adds the settings section
        let settingsImg = UIImage(named: "Config")?.imageWithColor(UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1))
        let settingsFrame = CGRectMake(screenSize.width - screenSize.width/20 - screenSize.width/15, helpView!.frame.origin.y + screenSize.height/5 * 0.6, screenSize.width/15, screenSize.width/15)
        
        settingsView = UIImageView(frame: settingsFrame)
        settingsView!.image = settingsImg
        settingsView!.alpha = 0
        
        settingsText = NonSelectableUTV(frame: CGRectMake(screenSize.width/20 - screenSize.width/15, settingsView!.frame.origin.y - settingsView!.frame.height/2, screenSize.size.width - (screenSize.width/20 + (screenSize.width/15)), 2 * 2.5 * settingsView!.frame.height))
        settingsText!.textAlignment = NSTextAlignment.Right
        settingsText!.font = UIFont(name: "Roboto-Thin", size: screenSize.size.height/20 * 0.9 * 0.6)
        settingsText!.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        settingsText!.text = "Aperte para alterar a instituição a qual deseja realizar a doação e outras preferências."
        settingsText!.alpha = 0
        
        self.view.addSubview(settingsText!)
        self.view.addSubview(settingsView!)
        
        // Adds the camera pointer
        let notinhaImg = UIImage(named: "NotaCharacter2")?
        let barHeight = UIApplication.sharedApplication().statusBarFrame.height + 118
        let notinhaX : CGFloat = screenSize.width * 0.5
        let notinhaY : CGFloat = screenSize.height - barHeight + 20 - screenSize.height * 0.075 - (screenSize.width * 0.175)
        let notinhaFrame = CGRectMake(notinhaX, notinhaY, screenSize.width * 0.35, screenSize.width * 0.35)
        
        notinhaView = UIImageView(frame: notinhaFrame)
        notinhaView!.contentMode = UIViewContentMode.ScaleAspectFit
        notinhaView!.image = notinhaImg
        notinhaView!.alpha = 0
        
        notinhaText = NonSelectableUTV(frame: CGRectMake(screenSize.width/20, notinhaView!.frame.origin.y - screenSize.height * 0.05, screenSize.width - screenSize.width/10, 2.5 * settingsView!.frame.height))
        notinhaText!.textAlignment = NSTextAlignment.Center
        notinhaText!.font = UIFont(name: "Roboto-Thin", size: screenSize.size.height/20 * 0.9 * 0.6)
        notinhaText!.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        notinhaText!.text = "Clique aqui para tirar a foto ou selecionar da galeria a sua nota fiscal!"
        notinhaText!.alpha = 0
        
        self.view.addSubview(notinhaText!)
        self.view.addSubview(notinhaView!)
        
        beginMainFadeIn()
    }
    
    func beginMainFadeIn () {
        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations:  { () -> Void in
            self.helpView!.alpha = 1.0
            self.helpText!.alpha = 1.0
            self.settingsText!.alpha = 1.0
            self.settingsView!.alpha = 1.0
            }, completion:  { (finished: Bool) -> Void in
                // Fade out
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.notinhaText!.alpha = 1.0
                    self.notinhaView!.alpha = 1.0
                    }, completion: nil)
        })
    }
}
