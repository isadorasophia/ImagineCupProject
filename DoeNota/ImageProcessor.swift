//
//  ImageProcessor.swift
//  DoeNota
//
//  Created by Isa Sophia on 2/12/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

class ImageProcessor: NSObject {
    class var sharedInstance: ImageProcessor {
        struct Static {
            static var instance: ImageProcessor?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ImageProcessor()
        }
        
        return Static.instance!
    }
    
    class func processImage (image: UIImage) -> UIImage {
        var actualHeight = image.size.height;
        var actualWidth = image.size.width;
        var imgRatio = actualWidth/actualHeight;
        var maxRatio : CGFloat = 640.0/960.0;
        
        if (imgRatio != maxRatio) {
            if (imgRatio < maxRatio) {
                imgRatio = 960.0 / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = 960.0;
            }
            else {
                imgRatio = 640.0 / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = 640.0;
            }
        }
        
        var rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        
        UIGraphicsBeginImageContext(rect.size);
        image.drawInRect(rect)
        let finalImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return finalImg
    }
}

// Coloring images
extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        color1.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}