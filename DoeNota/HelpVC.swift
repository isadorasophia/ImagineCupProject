//
//  HelpVC.swift
//  DoeNota
//
//  Created by Isadora Sophia on 3/19/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

class HelpVC: UIViewController, UIPageViewControllerDataSource {
    
    let pageTitles = ["a", "b", "c", "d"]
    var pageImages = ["1st.jpg", "2nd.jpg", "3rd.jpg", "4rd.jpg"]
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
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, windowHeight)
        
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
        
        // Create the apropriate View Controller
        let helpParticleVC = self.storyboard?.instantiateViewControllerWithIdentifier("HelpParticle") as HelpParticleVC
        
        helpParticleVC.myImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, windowHeight - windowHeight/4))
        helpParticleVC.myTextView = UITextView(frame: CGRectMake(0, windowHeight - windowHeight/4, self.view.frame.width, 60))
        
        helpParticleVC.myTextView.font = UIFont(name: "Roboto-Light", size: 30)
        
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
