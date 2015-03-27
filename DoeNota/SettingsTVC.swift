//
//  SettingsTVC.swift
//  DoeNota
//
//  Created by Isa Sophia on 2/16/15.
//  Copyright (c) 2015 Isadora Sophia. All rights reserved.
//

import UIKit

let changedSettings = "changedSettings"

struct Institution {
    var name: String
    var value: Int
}

class SettingsTVC: UITableViewController, UIPickerViewDelegate {
    required init(coder aDecoder: NSCoder) {
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        pickerInst = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenSize.size.width, height: screenSize.size.height/2))
        pickerInst.transform = CGAffineTransformMakeTranslation(0, screenSize.size.height)
        
        margin = UIView(frame: CGRect(x: 0, y: -0.5, width: screenSize.size.width, height: 100))
        margin.transform = CGAffineTransformMakeTranslation(0, screenSize.size.height)
        
        institutions = [Institution(name: "Centro Infantil Boldrini - Campinas", value: 1),
            Institution(name: "Recanto dos Velhinhos de Valinhos", value: 2),
            Institution(name: "SOBRAPAR - Campinas", value: 3)]
        
        pickerViewRow = 0
        count = 0
        
        super.init(coder: aDecoder)
    }
    
    override init() {
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        pickerInst = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenSize.size.width, height: screenSize.size.height/2))
        pickerInst.transform = CGAffineTransformMakeTranslation(0, screenSize.size.height)
        
        margin = UIView(frame: CGRect(x: 0, y: -0.5, width: screenSize.size.width, height: 100))
        margin.transform = CGAffineTransformMakeTranslation(0, screenSize.size.height)
        
        institutions = [Institution(name: "Centro Infantil Boldrini - Campinas", value: 1),
            Institution(name: "Recanto dos Velhinhos de Valinhos", value: 2),
            Institution(name: "SOBRAPAR - Campinas", value: 3)]
        
        pickerViewRow = 0
        count = 0
        
        super.init()
    }
    
    @IBOutlet weak var wifiButton: UISwitch!
    
    var pickerInst : UIPickerView
    var margin : UIView
    var pickerViewRow : Int
    var institutions : [Institution]
    var count : Int
    
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
        
        // Instead of 2, is the database previous selected
        let selected = institutions.find { $0.value == 2 }
        
        if (selected != nil) {
            pickerInst.selectRow(selected!, inComponent: 0, animated: true)
        }
        
        margin.backgroundColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1)
        
        self.view.addSubview(margin)
        self.view.addSubview(pickerInst)
        
        pickerInst.hidden = true
        pickerInst.alpha = 0
        margin.alpha = 0
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Regarding 3G functionality
    func set3GOptions (sender: UISwitch!) {
        if (sender.on) {
            DatabaseManager.sharedInstance.set3G(true)
            
            NSNotificationCenter.defaultCenter().postNotificationName(changedSettings, object: nil)
        } else {
            DatabaseManager.sharedInstance.set3G(false)
        }
    }
    
    // MARK: Regarding picker view delegate
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DatabaseManager.sharedInstance.setInstitution(institutions[row].value)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return institutions.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    } 
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return institutions[row].name
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        let selectionWidth : CGFloat = screenSize.size.width
        
        return selectionWidth
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        var pickerLabel : UILabel
        
        let frame = CGRectMake(0, 0, screenSize.width, screenSize.height/(2 * 5))
        pickerLabel = UILabel(frame: frame)
        pickerLabel.text = institutions[row].name
        
        var fontSize : CGFloat
        
        if (countElements(pickerLabel.text!) >= 40 ) {
            fontSize = 15
        } else if (countElements(pickerLabel.text!) >= 25) {
            fontSize = 17
        }
        else {
            fontSize = 20
        }
        
        pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: fontSize)
        pickerLabel.textAlignment = NSTextAlignment.Center
        
        return pickerLabel
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
        return 4
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == pickerViewRow) {
            pickerInst.hidden = false
            
            animationPickerViewAppear()
        } else {
            animationPickerViewGone()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.row == tableView.numberOfRowsInSection(0) - 1) {
            return true
        }
        
        return false
    }
    
    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject) -> Bool {
        if (indexPath.row == tableView.numberOfRowsInSection(0) - 1) {
            return (action == Selector("copy:"))
        }
        
        return false
    }
    
    override func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) {
        if (action == Selector("copy:") && indexPath.row == tableView.numberOfRowsInSection(0) - 1) {
            var pasteboard : UIPasteboard = UIPasteboard.generalPasteboard()
            pasteboard.string = "doenotafiscal@gmail.com"
        }
    }
    
    func animationPickerViewAppear () {
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        var transform : CGAffineTransform = CGAffineTransformMakeTranslation(0, screenSize.size.height - 63 - pickerInst.frame.height)
        
        pickerInst.selectRow(DatabaseManager.sharedInstance.getInstitution() - 1, inComponent: 0, animated: false)
        
        UIView.animateWithDuration(0.6, animations: { self.pickerInst.transform = transform; self.margin.transform = transform; self.margin.alpha = 1; self.pickerInst.alpha = 1 } , completion: nil)
    }
    
    func animationPickerViewGone () {
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        var transform : CGAffineTransform = CGAffineTransformMakeTranslation(0, screenSize.size.height)
        
        UIView.animateWithDuration(0.6, animations: { self.pickerInst.transform = transform; self.margin.transform = transform; self.margin.alpha = 0; self.pickerInst.alpha = 0 } , completion: { finished in self.pickerInst.hidden = false })
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

extension Array {
    func find(includedElement: T -> Bool) -> Int? {
        for (idx, element) in enumerate(self) {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
}
