//
//  ViewController.swift
//  TextTransfer
//
//  Created by Rohaine Hsu on 9/12/15.
//  Copyright © 2015 Rohaine Hsu. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var filenames: Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filename.delegate = self;
        self.filetext.delegate = self;
        self.fileextension.delegate = self;
        
        self.modify.delegate = self
        
        self.modifycontent.delegate = self;
        self.modifycontent.editable = true
        self.modifycontent.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        self.modifycontent.layer.borderWidth = 1.0
        self.modifycontent.layer.cornerRadius = 5
            
        self.filenames = []
        // Verify user is logged into Dropbox
        if let client = Dropbox.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)")
                } else {
                    print(error!)
                }
            }
            
            // List folder
            client.files.listFolder(path: "").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                        self.filenames!.append(entry.name)
                    }

                } else {
                    print(error!)
                }
                print(self.filenames)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   @IBAction func linkButtonPressed(sender: AnyObject) {
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
            //Dropbox.unlinkClient()
        }
    }
    
    @IBAction func viewFileContent(sender: AnyObject) {
        filecontent("test.txt")
    }
    
    /*func filecontent(filepath: String) {
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("\(filepath)")
        do {
            let contentsOfFile = try NSString(contentsOfFile: fileDestinationUrl.path!, encoding: NSUTF8StringEncoding)
            print("Content of file = \(contentsOfFile)")
        } catch let error as NSError {
            print(error)
            print("No file found")
        }
    }*/
    
    func filecontent(filepath: String) {
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        let fileDestinationUrl = directoryURL.URLByAppendingPathComponent("\(filepath)")
        do {
            let contentsOfFile = try NSString(contentsOfFile: fileDestinationUrl.path!, encoding: NSUTF8StringEncoding)
            print("Content of file = \(contentsOfFile)")
        } catch let error as NSError {
            print(error)
            print("No file found")
        }
    }
    
    /*func downloadfile(filename: String){
        if let client = Dropbox.authorizedClient {
            
            let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
                (temporaryURL, response) in
                
                if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                    let path = directoryURL.URLByAppendingPathComponent("\(filename)")
                    return path
                }
                return temporaryURL
            }
            client.files.download(path: filename, destination: destination).response { response, error in

                    if let (metadata, data) = response {
                        print("*** Download file ***")
                        print("Downloaded file name: \(metadata.name)")
                        //print("Downloaded file data: \(data)")
                    } else {
                        print(error!)
                    }
            }
        
        }
    }*/
    
    func downloadfile(filename: String){
        if let client = Dropbox.authorizedClient {
            
            let destination : (NSURL, NSHTTPURLResponse) -> NSURL = { temporaryURL, response in
                let fileManager = NSFileManager.defaultManager()
                let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
                // generate a unique name for this file in case we've seen it before
                //let UUID = NSUUID().UUIDString
//                let pathComponent = "\(UUID)-\(response.suggestedFilename!)"
                

                let newfilename = String(filename.characters.dropFirst())
                
                if self.checkexisting(newfilename) {
                    let index = newfilename.startIndex
                    let index2 = newfilename.endIndex.advancedBy(-4)
                    let other = newfilename[Range(start: index, end: index2)]
                    print(other)
                    let character = other.characters.last!
                    print(character)
                    
                    let char = String(character)
                    
                    if char >= "0" && char <= "8" {
                        let number = Int(char)
                        let newvalue = number! + 1
                        let newchar = String(newvalue)
                        
                        let index3 = other.endIndex.advancedBy(-2)
                        let other2 = newfilename[Range(start: other.startIndex, end: index3)]
                        print(other2)
                        let name = other2 + newchar + ".txt"
                        
                        return directoryURL.URLByAppendingPathComponent(name)
                    }
                        
                    if char == "9" {
                        let index3 = other.endIndex.advancedBy(-2)
                        let char = other[index3]
                        let charString = String(char)
                        
                        if charString >= "1" && charString <= "8" {
                            let number = Int(charString)
                            let newvalue = number! + 1
                            let newchar = String(newvalue)
                            
                            let other2 = newfilename[Range(start: other.startIndex, end: index3)]
                            print(other2)
                            let name = other2 + newchar + "0.txt"
                            
                            if charString == "9" {
                                let other2 = newfilename[Range(start: other.startIndex, end: index3)]
                                print(other2)
                                let name = other2 + newchar + "100.txt"
                                
                                return directoryURL.URLByAppendingPathComponent(name)
                            }
                            
                            return directoryURL.URLByAppendingPathComponent(name)

                        }
                            
                        else {
                            let index3 = other.endIndex.advancedBy(-2)
                            let other2 = newfilename[Range(start: other.startIndex, end: index3)]
                            print(other2)
                            let name = other2  + "10.txt"
                            
                            return directoryURL.URLByAppendingPathComponent(name)
                        }

                    }
                    
                    else if char == ")" {
                        let index3 = other.endIndex.advancedBy(-2)
                        let char = other[index3]
                        let charString = String(char)
                            if charString >= "0" && charString <= "9" {
                                let number = Int(charString)
                                let newvalue = number! + 1
                                let newchar = String(newvalue)
                                
                                let other2 = newfilename[Range(start: other.startIndex, end: index3)]
                                print(other2)
                                let name = other2 + newchar + ").txt"
                                
                                if self.checkexisting(name) {
                                    let index = name.startIndex
                                    let index2 = name.endIndex.advancedBy(-4)
                                    let other = newfilename[Range(start: index, end: index2)]
                                    print(other)
                                    let newname = other + ".1.txt"
                                    print(newname)
                                    return directoryURL.URLByAppendingPathComponent(newname)
                                    
                                }
                                
                                return directoryURL.URLByAppendingPathComponent(name)
                                
                        }
                        //return directoryURL.URLByAppendingPathComponent(name)
                    }
                        
                    else {
                        let name = other + "1.txt"
                        
                        return directoryURL.URLByAppendingPathComponent(name)
                    }
                }
                    
                else {
                    return directoryURL.URLByAppendingPathComponent(newfilename)

                }
                
//                let newurl = directoryURL.URLByAppendingPathComponent("\(newfilename)")
//                print(newurl)
                //return directoryURL.URLByAppendingPathComponent(newfilename)
//                return directoryURL.URLByAppendingPathComponent(pathComponent)

                return directoryURL.URLByAppendingPathComponent(newfilename)

            }

    
            client.files.download(path: filename, destination: destination).response { response, error in
                if let (metadata, url) = response {
                    //
                    print(url)
                    print("*** Download file ***")
                    let data = NSData(contentsOfURL: url)
                    print("Downloaded file name: \(metadata.name)")
                    print("Downloaded file url: \(url)")
                    print("Downloaded file data: \(data)")
                } else {
                    print(error!)
                }
            }
            
        }

    }
    
    func checkexisting(filepath: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        let fileDestinationUrl = directoryURL.URLByAppendingPathComponent("\(filepath)")
        let filemgr = NSFileManager.defaultManager()
        if (filemgr.fileExistsAtPath(fileDestinationUrl.path!)) {
            print("file found")
            return true
        }
        else {
            print("none")
            return false
        }
    }
    
    @IBOutlet var modifycontent: UITextView!
    
    @IBOutlet var filename: UITextField!
    
    @IBOutlet var filetext: UITextField!
    
    @IBOutlet var fileextension: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
        
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func upload(sender: AnyObject) {
        //createfile("text", filename: "/Sample.txt")
        self.createfile("\(self.filetext.text!)", filename: ("/\(self.filename.text!).\(self.fileextension.text!)"))
    }
    
    func createfile(text: String, filename: String) {
        if let client = Dropbox.authorizedClient {
            // Upload a file

            let fileData = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            print(fileData)
                
            //client.filesUpload(path:filename, body: fileData!).response { response, error in
            client.files.upload(path:filename, autorename: true, body: fileData!).response { response, error in
    
                
                if let metadata = response {
                    print("*** Upload file ****")
                    print("Uploaded file name: \(metadata.name)")
                    print("Uploaded file revision: \(metadata.rev)")
                    
                    // Get file (or folder) metadata
                    //client.filesGetMetadata(path: "/test.txt").response { response, error in
                    client.files.getMetadata(path: "/test.txt").response { response, error in
    
                        print("*** Get file metadata ***")
                        if let metadata = response {
                            //print("Name: \(metadata.name)")
                            if let file = metadata as? Files.FileMetadata {
                                //print("This is a file.")
                                print("This is a file with path: \(file.pathLower)")
                                print("File size: \(file.size)")
                            } else if let folder = metadata as? Files.FolderMetadata {
                                //print("This is a folder.")
                                print("This is a folder with path: \(folder.pathLower)")
                            }
                        } else {
                            print(error!)
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func Check(sender: AnyObject) {
        files()
        check("test.txt")
    }
    
    
    /*func files() {
        let documentsURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)

        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsURL.absoluteURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryContents)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }*/

    
    func files() {
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        do {
            let directoryContents = try fileManager.contentsOfDirectoryAtURL(directoryURL.absoluteURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryContents)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    /*func check(filepath: String) {
        
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("\(filepath)")
        let filemgr = NSFileManager.defaultManager()
        if (filemgr.fileExistsAtPath(fileDestinationUrl.path!)) {
            print("file found")
        }
        else {
            print("none")
        }
    }*/
    
    func check(filepath: String) {
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        let fileDestinationUrl = directoryURL.URLByAppendingPathComponent("\(filepath)")
        let filemgr = NSFileManager.defaultManager()
        if (filemgr.fileExistsAtPath(fileDestinationUrl.path!)) {
            print("file found")
        }
        else {
            print("none")
        }
    }
    
    @IBAction func Modify(sender: AnyObject) {
        print(self.modifycontent.text)
        //print(self.modify.text)
    }
    
    @IBOutlet var modify: UITextField!
    
    func write(filepath: String) {
        /*if (self.modifycontent.text == nil) {
            print("nil")*/
        
            //let text = "\(self.modifycontent.text)"
        
        

        let text = "\(self.modify.text!)"
        print(filepath)
        
        //let text = "text"
        
        let fileManager = NSFileManager.defaultManager()
        let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileDestinationUrl = directoryURL.URLByAppendingPathComponent("\(filepath)")
        print(fileDestinationUrl)
        
            do {
                try text.writeToURL(fileDestinationUrl, atomically: true, encoding: NSUTF8StringEncoding)

                let contentsOfFile = try! NSString(contentsOfURL: fileDestinationUrl, encoding: NSUTF8StringEncoding)
                print("Content of file = \(contentsOfFile)")
                createfile("\(contentsOfFile)", filename: "/\(filepath)")
                
            } catch let error as NSError {
                print(error)
                print("No file found")
            }
    }
    
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var DestViewController = (segue.destinationViewController as! UINavigationController).topViewController as! TableViewController
        DestViewController.data = self.filenames
    }
}
