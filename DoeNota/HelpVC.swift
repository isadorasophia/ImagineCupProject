//
//  HelpVC.swift
//  DoeNota
//
//  Created by Isadora Sophia on 3/19/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

class HelpVC: UIViewController, UIPageViewControllerDataSource {
    
    let pageTitles = ["1) Tente seguir os seguintes parâmetros enquanto tirar a sua foto.", "2) Caso sua nota fiscal seja muito grande, tente dobrá-la desta forma.", "3) Evite tirar a foto de sua nota se ela foi emitida a mais de um mês, ou se possui CPF registrado.", "4) Evite também tirar fotos muito tortas ou que escondam informações essenciais."]
    var pageImages = ["1st.png", "2nd.png", "3rd.png", "4rd.png"]
    var count = 0
    
    var windowHeight : CGFloat = 0
    
    var pageViewController : UIPageViewController!
    
    @IBAction func swiped(sender: AnyObject) {
        
        self.pageViewController.view .removeFromSuperview()
        self.pageViewController.removeFromParentViewController()
        reset()
    }
    
    func reset() {
        /* Getting the page View controller */
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as UIPageViewController
        self.pageViewController.dataSource = self
        
        let pageContentViewController = self.viewControllerAtIndex(0)
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, windowHeight + 40)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    @IBAction func start(sender: AnyObject) {
        let pageContentViewController = self.viewControllerAtIndex(0)
        
        self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.windowHeight = self.view.frame.height
        reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex (index: NSInteger) -> HelpParticleVC? {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return nil;
        }
        
        // Create the appropriate View Controller
        let helpParticleVC = self.storyboard?.instantiateViewControllerWithIdentifier("HelpParticle") as HelpParticleVC
        
        helpParticleVC.myImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, windowHeight - (windowHeight/3 * 0.85) + 60 - 60))
        
        helpParticleVC.myTextView = UITextView(frame: CGRectMake(0, windowHeight - (windowHeight/3 * 0.85), self.view.frame.width, (windowHeight/3 * 0.85)))
        
        helpParticleVC.myTextView.font = UIFont(name: "Roboto-Thin", size: windowHeight/32)
        helpParticleVC.myTextView.textColor = UIColor(red: 154/255, green: 126/255, blue: 158/255, alpha: 1)
        helpParticleVC.myTextView.editable = false
        helpParticleVC.myTextView.backgroundColor = UIColor(red: 251/255, green: 251/255, blue: 251/255, alpha: 1)
        
        helpParticleVC.imageFile = self.pageImages[index]
        helpParticleVC.currentText = self.pageTitles[index]
        helpParticleVC.pageIndex = index
        
        return helpParticleVC
    }
    
    // UIPageViewControllerDataSource    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as HelpParticleVC).pageIndex!
        
        if ((index <= 0) || (index == NSNotFound)) {
            return nil;
        }
        
        index--
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as HelpParticleVC).pageIndex!
        
        if (index == NSNotFound) {
            return nil;
        }
        
        index++;
        
        if (index >= self.pageTitles.count) {
            return nil;
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count;
    }
    
    // First page is default
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
