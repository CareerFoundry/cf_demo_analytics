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
            let links = UserDefaults.standard.object(forKey: userDefaultsKey) as? Array<String>
            
            if let links = links {
                return links
            }
            
            return []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
        }
    }
    
    @IBAction func tappedAddButton(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "New Link", message: "Add link to save for later.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let link = alertController.textFields?.first?.text {
                self.links.append(link)
                self.tableView.reloadData()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Link"
            textField.keyboardType = .URL
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func tappedDeleteButton(_ sender: AnyObject) {
        links.removeAll()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
        cell.textLabel?.text = links[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openURL(links[(indexPath as NSIndexPath).row])
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func hasValidURLPrefix(_ urlString: String) -> Bool {
        if urlString.lowercased().hasPrefix("http://") || urlString.lowercased().hasPrefix("https://") {
            return true
        }
        
        return false
    }
    
    func prepareURL(_ urlString: String) -> URL? {
        if hasValidURLPrefix(urlString) {
            return URL(string: urlString)
        } else {
            let urlStringWithPrefix = addURLPrefix(urlString)
            return URL(string: urlStringWithPrefix)
        }
    }
    
    func addURLPrefix(_ urlString: String) -> String {
        return "http://\(urlString)"
    }
    
    func openURL(_ urlString: String) {
        if let url = prepareURL(urlString) {
            
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.delegate = self
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    
}

