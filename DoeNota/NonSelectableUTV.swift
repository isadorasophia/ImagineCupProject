//
//  NonSelectableUTV.swift
//  DoeNota
//
//  Created by Isadora Sophia on 3/24/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

class NonSelectableUTV: UITextView {

    override func caretRectForPosition(_position: UITextPosition!) -> CGRect  {
        return CGRectZero
    }
    
    override func selectionRectsForRange(range: UITextRange) -> [AnyObject] {
        return NSArray()
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if (action == Selector("copy:") || action == Selector("selectAll:") || action == Selector("paste:") || action == Selector("define:")) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        return false
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return false
    }
    
    override func scrollRectToVisible(rect: CGRect, animated: Bool) {
        //
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
