//
//  HelpVC.swift
//  DoeNota
//
//  Created by Isadora Sophia on 3/19/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

class HelpVC: UIViewController, UIPageViewControllerDataSource {
    
    var pageTitles = [NSString] ()
    var pageImages = [NSString] ()
    var pageViewController : UIPageViewController = UIPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Now do it right
        self.pageTitles = ["a", "b", "c", "d"]
        self.pageImages = ["a", "b", "c", "d"]
        
        self.pageViewController = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as UIPageViewController
        self.pageViewController.dataSource = self
        
        var startingView = self.viewControllerAtIndex(0)!
        var viewControllers = [startingView]
        self.pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Reverse, animated: false, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
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
        let helpParticleVC = self.storyboard!.instantiateViewControllerWithIdentifier("HelpParticle") as HelpParticleVC
        helpParticleVC.imageFile = self.pageImages[index]
        helpParticleVC.currentText = self.pageTitles[index]
        helpParticleVC.pageIndex = index
        
        return helpParticleVC
    }
    
    // UIPageViewControllerDataSource    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as HelpParticleVC).pageIndex
        
        if ((index == 0) || (index == NSNotFound)) {
            return nil;
        }
        
        index--;
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as HelpParticleVC).pageIndex
        
        if (index == NSNotFound) {
            return nil;
        }
        
        index++;
        if (index == self.pageTitles.count) {
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
