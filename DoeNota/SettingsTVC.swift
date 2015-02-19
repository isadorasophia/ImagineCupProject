//
//  SettingsTVC.swift
//  DoeNota
//
//  Created by Isa Sophia on 2/16/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController, UIPickerViewDelegate {

    required init(coder aDecoder: NSCoder) {
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        pickerInst = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenSize.size.width, height: screenSize.size.height/2))
        pickerInst.transform = CGAffineTransformMakeTranslation(0, screenSize.size.height)
        
        pickerViewRow = 0
        
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var wifiButton: UISwitch!
    
    var pickerInst : UIPickerView
    var pickerViewRow : Int
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize : CGRect = UIScreen.mainScreen().bounds

        // Set switch button
        wifiButton.setOn(DatabaseManager.sharedInstance.getHability3G(), animated: true)
        wifiButton.addTarget(self, action: "set3GOptions:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Set picker view
        pickerInst.delegate = self
        pickerInst.showsSelectionIndicator = true
        
        pickerInst.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(pickerInst)
        
        pickerInst.hidden = true
        pickerInst.alpha = 0
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Regarding 3G functionality
    func set3GOptions (sender: UISwitch!) {
        if (sender.on) {
            DatabaseManager.sharedInstance.set3G(true)
        } else {
            DatabaseManager.sharedInstance.set3G(false)
        }
    }
    
    // MARK: Regarding picker view delegate
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Handle selection
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let text = "oi" as String
        
        return text
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let selectionWidth : CGFloat = 300
        
        return selectionWidth
    }

    // Regarding VC
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == pickerViewRow) {
            pickerInst.hidden = false
            
            animationPickerViewAppear()
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == pickerViewRow) {
            animationPickerViewGone()
        }
    }
    
    func animationPickerViewAppear () {
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        var transform : CGAffineTransform = CGAffineTransformMakeTranslation(0, screenSize.size.height - 55 - pickerInst.frame.height)
        
        UIView.animateWithDuration(0.6, animations: { self.pickerInst.transform = transform; self.pickerInst.alpha = 1 } , completion: nil)
    }
    
    func animationPickerViewGone () {
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        var transform : CGAffineTransform = CGAffineTransformMakeTranslation(0, screenSize.size.height)
        
        UIView.animateWithDuration(0.6, animations: { self.pickerInst.transform = transform; self.pickerInst.alpha = 0 } , completion: { finished in self.pickerInst.hidden = false })
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
