//
//  ViewController.swift
//  UnitTestsDemo
//
//  Created by Hesham Abd-Elmegid on 7/31/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit
import SafariServices

class LinksViewController: UITableViewController, SFSafariViewControllerDelegate {
    let userDefaultsKey = "LinksUserDefaultsKey"
    
    var links: Array<String> {
        get {
            let links = NSUserDefaults.standardUserDefaults().objectForKey(userDefaultsKey) as? Array<String>
            
            if let links = links {
                return links
            }
            
            return []
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: userDefaultsKey)
        }
    }
    
    @IBAction func tappedAddButton(sender: AnyObject) {
        let alertController = UIAlertController(title: "New Link", message: "Add link to save for later.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .Default) { (action) in
            if let link = alertController.textFields?.first?.text {
                self.links.append(link)
                self.tableView.reloadData()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Link"
            textField.keyboardType = .URL
        }
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func tappedDeleteButton(sender: AnyObject) {
        links.removeAll()
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LinkCell", forIndexPath: indexPath)
        cell.textLabel?.text = links[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        openURL(links[indexPath.row])
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func hasValidURLPrefix(urlString: String) -> Bool {
        if urlString.lowercaseString.hasPrefix("http://") || urlString.lowercaseString.hasPrefix("https://") {
            return true
        }
        
        return false
    }
    
    func prepareURL(urlString: String) -> NSURL? {
        if hasValidURLPrefix(urlString) {
            return NSURL(string: urlString)
        } else {
            let urlStringWithPrefix = addURLPrefix(urlString)
            return NSURL(string: urlStringWithPrefix)
        }
    }
    
    func addURLPrefix(urlString: String) -> String {
        return "http://\(urlString)"
    }
    
    func openURL(urlString: String) {
        if let url = prepareURL(urlString) {
            
            let safariViewController = SFSafariViewController(URL: url)
            safariViewController.delegate = self
            self.presentViewController(safariViewController, animated: true, completion: nil)
        }
    }
    
}

